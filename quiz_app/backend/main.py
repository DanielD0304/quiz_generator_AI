import asyncio
import json
import os
from typing import List
from fastapi import FastAPI, HTTPException
from dotenv import load_dotenv
import google.generativeai as genai

load_dotenv()

app = FastAPI(title="QuizAI Backend")

# Konfiguration
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))
model = genai.GenerativeModel('gemini-1.5-flash')

SYSTEM_INSTRUCTION = """
Du bist ein Quiz-Redakteur. Erstelle für jede übergebene Kategorie GENAU EINE anspruchsvolle Quizfrage.
Antworte NUR mit einem validen JSON-Array, das Objekte mit diesem Schema enthält:
{
  "category": "Name der Kategorie",
  "question": "Die Frage",
  "answer": "Korrekte Antwort",
  "distractors": ["Falsch1", "Falsch2", "Falsch3"],
  "fact": "Zusatzinfo"
}
"""

async def fetch_batch(categories: List[str]):
    """Holt Fragen für eine Liste von Kategorien in einem API-Call."""
    prompt = f"Erstelle Fragen für folgende Kategorien: {', '.join(categories)}"
    
    try:
        response = await model.generate_content_async(
            contents=[SYSTEM_INSTRUCTION, prompt],
            generation_config={"response_mime_type": "application/json"}
        )
        return json.loads(response.text)
    except Exception as e:
        print(f"Fehler beim Batch {categories}: {e}")
        return []

@app.get("/prepare-round")
async def prepare_round():
    # Alle 20 Kategorien
    all_categories = [
        "Geschichte", "Geographie", "Naturwissenschaft", "Sport", 
        "Film & Fernsehen", "Musik", "Literatur", "Politik", 
        "Technik", "Kunst", "Essen & Trinken", "Mensch", 
        "Religion", "Architektur", "Wirtschaft", "Mode"
    ]
    
    chunks = [all_categories[i:i + 4] for i in range(0, len(all_categories), 4)]
    
    # Führe alle Requests PARALLEL aus
    tasks = [fetch_batch(chunk) for chunk in chunks]
    results = await asyncio.gather(*tasks)
    
    flat_questions = [item for sublist in results for item in sublist]
    
    if not flat_questions:
        raise HTTPException(status_code=500, detail="KI konnte keine Fragen generieren")
        
    return {"status": "ready", "questions": flat_questions}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)