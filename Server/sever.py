from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from controller import AI

app = FastAPI(
    title="FastAPI Example",
    description="A simple FastAPI application with CORS enabled",
    version="1.0.0",
    contact={
        "name": "Mohan S",
        "email": "mohansgopi@gmail.comsudo apt install"
    }
)

Ai_resolver = AI()

# CORS configuration
origins = [
    
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/Quetry/{query}")
async def read_root(query:str):
    print(query)
    try:
        answer = await Ai_resolver.Online(query)
    except:
        answer = "No answer found for the query"

    return {"answer": answer}







