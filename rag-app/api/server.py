from fastapi import FastAPI
from pydantic import BaseModel
from app.chain import build_chain

app = FastAPI(title="Grounded QA")
qa = build_chain()

class Ask(BaseModel):
    question: str
    k: int | None = None

@app.post("/ask")
def ask(body: Ask):
    if body.k:
        qa.retriever.search_kwargs["k"] = body.k
    result = qa.invoke({"query": body.question})
    return {
        "answer": result.get("result"),
        "sources": [
            {"metadata": (d.metadata or {}), "text": d.page_content[:500]}
            for d in result.get("source_documents", [])
        ],
    }
