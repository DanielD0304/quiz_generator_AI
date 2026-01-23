import asyncio
import json
import os
from typing import List
from fastapi import FastAPI, HTTPException
from dotenv import load_dotenv
from mock_questions import MOCK_QUESTIONS

load_dotenv()

app = FastAPI(title="QuizAI Backend")

# Umgebungsvariable um Mock-Modus zu steuern (Standard: True für Entwicklung)
USE_MOCK = os.getenv("USE_MOCK", "true").lower() == "true"

if not USE_MOCK:
    import google.generativeai as genai
    # Altes, stabiles SDK konfigurieren
    genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))
    # Free Tier Modell - 2.5-flash-lite hat 10 RPM
    model = genai.GenerativeModel('models/gemini-2.5-flash-lite')
else:
    print("🎭 MOCK-MODUS aktiviert - keine API-Calls")
    genai = None
    model = None

SYSTEM_INSTRUCTION = """
Du bist ein Redakteur für das Brettspiel "Bezzerwizzer". 
Erstelle für die angegebene Kategorie eine anspruchsvolle Wissensfrage.
Die Antwort muss kurz und präzise sein (1-3 Wörter).

Antworte NUR mit einem validen JSON-Array. Schema:
[{"category": "...", "question": "...", "answer": "..."}]
"""

async def fetch_batch(categories: List[str], retry_count=0):
    full_prompt = f"{SYSTEM_INSTRUCTION}\n\nKategorien: {', '.join(categories)}"
    
    try:
        loop = asyncio.get_event_loop()
        response = await loop.run_in_executor(
            None, 
            lambda: model.generate_content(
                full_prompt,
                generation_config=genai.types.GenerationConfig(
                    response_mime_type="application/json",
                    temperature=0.7
                )
            )
        )
        
        # DEBUG: Zeige uns, was die KI wirklich sagt
        if not response.text:
            print(f"WARNUNG: Keine Antwort für {categories}. Grund: {response.prompt_feedback}")
            return []

        clean_text = response.text.strip()
        # Manuelle Säuberung für den Fall, dass Markdown-Tags mitkommen
        if clean_text.startswith("```"):
            clean_text = clean_text.split("```")[1]
            if clean_text.startswith("json"):
                clean_text = clean_text[4:]
        
        return json.loads(clean_text)

    except json.JSONDecodeError as e:
        print(f"JSON FEHLER bei {categories}: {e}. Roh-Text: {response.text[:100]}")
        return []
    except Exception as e:
        # Bei Rate-Limit: retry nach Wartezeit
        if "429" in str(e) and retry_count < 3:
            wait_time = 35 * (retry_count + 1)  # 35, 70, 105 Sekunden
            print(f"Rate limit für {categories}, warte {wait_time}s...")
            await asyncio.sleep(wait_time)
            return await fetch_batch(categories, retry_count + 1)
        print(f"ALLGEMEINER FEHLER bei {categories}: {e}")
        return []

@app.get("/prepare-round")
async def prepare_round():
    all_categories = [
        "Geschichte", "Geographie", "Naturwissenschaft", "Sport", 
        "Film & Fernsehen", "Musik", "Literatur", "Politik", 
        "Technik", "Kunst", "Essen & Trinken", "Mensch", 
        "Religion", "Architektur", "Wirtschaft", "Mode"
    ]
    
    # Mock-Modus: Schnelle Antwort für Entwicklung
    if USE_MOCK:
        print("🎭 MOCK-MODUS: Verwende vordefinierte Fragen (spart API-Calls)")
        return {"status": "ready", "questions": MOCK_QUESTIONS}
    
    # Echter API-Modus: Rufe Google Gemini auf
    print("🔴 ECHTER API-MODUS: Generiere Fragen mit Google Gemini")
    
    # Sequentiell statt parallel - schont das Quota
    all_questions = []
    chunks = [all_categories[i:i + 4] for i in range(0, len(all_categories), 4)]
    
    for chunk in chunks:
        questions = await fetch_batch(chunk)
        all_questions.extend(questions)
        # Kurze Pause zwischen Requests
        await asyncio.sleep(2)
    
    if not all_questions:
        raise HTTPException(status_code=500, detail="KI-Fehler beim Generieren")
        
    return {"status": "ready", "questions": all_questions}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)