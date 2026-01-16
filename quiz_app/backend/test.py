import os
from google.genai import Client
from google.genai import types
from dotenv import load_dotenv

load_dotenv()

# Wir zwingen den Client auf die stabile v1
client = Client(
    api_key=os.getenv("GOOGLE_API_KEY"),
    http_options={'api_version': 'v1'} 
)

# Probiere hier BEIDE Varianten nacheinander:
# Variante A: "gemini-1.5-flash"
# Variante B: "models/gemini-1.5-flash"
try:
    response = client.models.generate_content(
        model="gemini-1.5-flash", 
        contents="Hi"
    )
    print("ERFOLG:", response.text)
except Exception as e:
    print("FEHLER:", e)