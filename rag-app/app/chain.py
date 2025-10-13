import os
from langchain.chains import RetrievalQA
from langchain_ibm import WatsonxLLM
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams
from ibm_watsonx_ai.foundation_models.utils.enums import DecodingMethods

from app.settings import settings
from app.elastic_backend import build_elastic_retriever
from app.chroma_backend import build_chroma_retriever

def _build_llm():
    params = {
        GenParams.DECODING_METHOD: DecodingMethods.GREEDY,
        GenParams.MAX_NEW_TOKENS: settings.LLM_MAX_NEW_TOKENS,
        GenParams.TEMPERATURE: settings.LLM_TEMPERATURE,
    }
    return WatsonxLLM(
        model_id=settings.LLM_MODEL_ID,
        url=settings.WATSONX_URL,
        apikey=settings.WATSONX_APIKEY,
        project_id=settings.WATSONX_PROJECT_ID,
        params=params,
    )

def build_chain():
    retriever = build_elastic_retriever() if settings.RAG_BACKEND.lower() == "elastic" else build_chroma_retriever()
    llm = _build_llm()
    chain = RetrievalQA.from_chain_type(llm=llm, chain_type="stuff", retriever=retriever, return_source_documents=True)
    return chain
