from fastapi import FastAPI
from pydantic import BaseModel
from rag.pipeline import answer_question
app = FastAPI()
class AskReq(BaseModel): question: str
@app.post('/ask')
def ask(req: AskReq): return {'answer': answer_question(req.question)['answer'], 'citations': []}
