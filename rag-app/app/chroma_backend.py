import os
from langchain_chroma import Chroma
from langchain_huggingface import HuggingFaceEmbeddings

def build_chroma_retriever():
    persist_dir = os.getenv("CHROMA_DIR", ".chroma")
    embeddings = HuggingFaceEmbeddings(
        model_name=os.getenv("EMBEDDINGS_MODEL", "sentence-transformers/all-MiniLM-L6-v2")
    )
    vectordb = Chroma(collection_name="kb", embedding_function=embeddings, persist_directory=persist_dir)
    return vectordb.as_retriever(search_kwargs={"k": 4})
