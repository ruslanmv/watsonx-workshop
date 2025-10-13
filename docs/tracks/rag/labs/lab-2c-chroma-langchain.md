# Use watsonx, Chroma, and LangChain to answer questions (RAG) — Notebook

**Track:** RAG → Lab 2  
**Why:** Vendor-agnostic vector store alternative.  
**Converted on:** 2025-10-13

---

![image](https://raw.githubusercontent.com/IBM/watson-machine-learning-samples/master/cloud/notebooks/headers/watsonx-Prompt_Lab-Notebook.png)
# Use watsonx Granite Model Series, Chroma, and LangChain to answer questions (RAG)

#### Disclaimers

- Use only Projects and Spaces that are available in watsonx context.

## Notebook content
This notebook contains the steps and code to demonstrate support of Retrieval Augumented Generation in watsonx.ai. It introduces commands for data retrieval, knowledge base building & querying, and model testing.

Some familiarity with Python is helpful. This notebook uses Python 3.11.

### About Retrieval Augmented Generation
Retrieval Augmented Generation (RAG) is a versatile pattern that can unlock a number of use cases requiring factual recall of information, such as querying a knowledge base in natural language.

In its simplest form, RAG requires 3 steps:

- Index knowledge base passages (once)
- Retrieve relevant passage(s) from knowledge base (for every user query)
- Generate a response by feeding retrieved passage into a large language model (for every user query)

## Contents

This notebook contains the following parts:

- [Setup](#setup)
- [Document data loading](#data)
- [Build up knowledge base](#build_base)
- [Foundation Models on watsonx](#models)
- [Generate a retrieval-augmented response to a question](#predict)
- [Summary and next steps](#summary)


<a id="setup"></a>
##  Set up the environment

Before you use the sample code in this notebook, you must perform the following setup tasks:

-  Create a <a href="https://cloud.ibm.com/catalog/services/watson-machine-learning" target="_blank" rel="noopener no referrer">Watson Machine Learning (WML) Service</a> instance (a free plan is offered and information about how to create the instance can be found <a href="https://dataplatform.cloud.ibm.com/docs/content/wsj/getting-started/wml-plans.html?context=wx&audience=wdp" target="_blank" rel="noopener no referrer">here</a>).


### Install and import the dependecies

```python
!pip install wget | tail -n 1
!pip install -U "langchain>=0.3,<0.4" | tail -n 1
!pip install -U "ibm_watsonx_ai>=1.1.22" | tail -n 1
!pip install -U "langchain_ibm>=0.3,<0.4" | tail -n 1
!pip install -U "langchain_chroma>=0.1,<0.2" | tail -n 1
```

```python
import os, getpass
```

### watsonx API connection
This cell defines the credentials required to work with watsonx API for Foundation
Model inferencing.

**Action:** Provide the IBM Cloud user API key. For details, see <a href="https://cloud.ibm.com/docs/account?topic=account-userapikey&interface=ui" target="_blank" rel="noopener no referrer">documentation</a>.

```python
from ibm_watsonx_ai import Credentials

credentials = Credentials(
    url="https://us-south.ml.cloud.ibm.com",
    api_key=getpass.getpass("Please enter your WML api key (hit enter): "),
)
```

### Defining the project id
The API requires project id that provides the context for the call. We will obtain the id from the project in which this notebook runs. Otherwise, please provide the project id.

**Hint**: You can find the `project_id` as follows. Open the prompt lab in watsonx.ai. At the very top of the UI, there will be `Projects / <project name> /`. Click on the `<project name>` link. Then get the `project_id` from Project's Manage tab (Project -> Manage -> General -> Details).


```python
try:
    project_id = os.environ["PROJECT_ID"]
except KeyError:
    project_id = input("Please enter your project_id (hit enter): ")
```

Create an instance of APIClient with authentication details.

```python
from ibm_watsonx_ai import APIClient

api_client = APIClient(credentials=credentials, project_id=project_id)
```

<a id="data"></a>
## Document data loading

Download the file with State of the Union.

```python
import wget

filename = 'state_of_the_union.txt'
url = 'https://raw.github.com/IBM/watson-machine-learning-samples/master/cloud/data/foundation_models/state_of_the_union.txt'

if not os.path.isfile(filename):
    wget.download(url, out=filename)
```

<a id="build_base"></a>
## Build up knowledge base

The most common approach in RAG is to create dense vector representations of the knowledge base in order to calculate the semantic similarity to a given user query.

In this basic example, we take the State of the Union speech content (filename), split it into chunks, embed it using an open-source embedding model, load it into <a href="https://www.trychroma.com/" target="_blank" rel="noopener no referrer">Chroma</a>, and then query it.

```python
from langchain.document_loaders import TextLoader
from langchain.text_splitter import CharacterTextSplitter
from langchain_chroma import Chroma

loader = TextLoader(filename)
documents = loader.load()
text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=0)
texts = text_splitter.split_documents(documents)
```

The dataset we are using is already split into self-contained passages that can be ingested by Chroma.

### Create an embedding function

Note that you can feed a custom embedding function to be used by chromadb. The performance of Chroma db may differ depending on the embedding model used. In following example we use watsonx.ai Embedding service. We can check available embedding models using `get_embedding_model_specs`

```python
api_client.foundation_models.EmbeddingModels.show()
```

    {'SLATE_125M_ENGLISH_RTRVR': 'ibm/slate-125m-english-rtrvr', 'SLATE_125M_ENGLISH_RTRVR_V2': 'ibm/slate-125m-english-rtrvr-v2', 'SLATE_30M_ENGLISH_RTRVR': 'ibm/slate-30m-english-rtrvr', 'SLATE_30M_ENGLISH_RTRVR_V2': 'ibm/slate-30m-english-rtrvr-v2', 'MULTILINGUAL_E5_LARGE': 'intfloat/multilingual-e5-large', 'ALL_MINILM_L12_V2': 'sentence-transformers/all-minilm-l12-v2', 'ALL_MINILM_L6_V2': 'sentence-transformers/all-minilm-l6-v2'}


```python
from langchain_ibm import WatsonxEmbeddings

embeddings = WatsonxEmbeddings(
    model_id="ibm/slate-30m-english-rtrvr",
    url=credentials["url"],
    apikey=credentials["apikey"],
    project_id=project_id
    )
docsearch = Chroma.from_documents(texts, embeddings)
```

#### Compatibility watsonx.ai Embeddings with LangChain

 LangChain retrievals use `embed_documents` and `embed_query` under the hood to generate embedding vectors for uploaded documents and user query respectively.

```python
help(WatsonxEmbeddings)
```

<a id="models"></a>
## Foundation Models on `watsonx.ai`

IBM watsonx foundation models are among the <a href="https://python.langchain.com/docs/integrations/llms/watsonxllm" target="_blank" rel="noopener no referrer">list of LLM models supported by Langchain</a>. This example shows how to communicate with <a href="https://newsroom.ibm.com/2023-09-28-IBM-Announces-Availability-of-watsonx-Granite-Model-Series,-Client-Protections-for-IBM-watsonx-Models" target="_blank" rel="noopener no referrer">Granite Model Series</a> using <a href="https://python.langchain.com/docs/get_started/introduction" target="_blank" rel="noopener no referrer">Langchain</a>.

### Defining model
You need to specify `model_id` that will be used for inferencing:

```python
from ibm_watsonx_ai.foundation_models.utils.enums import ModelTypes

model_id = ModelTypes.GRANITE_13B_CHAT_V2
```

### Defining the model parameters
We need to provide a set of model parameters that will influence the result:

```python
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams
from ibm_watsonx_ai.foundation_models.utils.enums import DecodingMethods

parameters = {
    GenParams.DECODING_METHOD: DecodingMethods.GREEDY,
    GenParams.MIN_NEW_TOKENS: 1,
    GenParams.MAX_NEW_TOKENS: 100,
    GenParams.STOP_SEQUENCES: ["<|endoftext|>"]
}
```

### LangChain CustomLLM wrapper for watsonx model
Initialize the `WatsonxLLM` class from Langchain with defined parameters and `ibm/granite-13b-chat-v2`. 

```python
from langchain_ibm import WatsonxLLM

watsonx_granite = WatsonxLLM(
    model_id=model_id.value,
    url=credentials.get("url"),
    apikey=credentials.get("apikey"),
    project_id=project_id,
    params=parameters
)
```

<a id="predict"></a>
## Generate a retrieval-augmented response to a question

Build the `RetrievalQA` (question answering chain) to automate the RAG task.

```python
from langchain.chains import RetrievalQA

qa = RetrievalQA.from_chain_type(llm=watsonx_granite, chain_type="stuff", retriever=docsearch.as_retriever())
```

### Select questions

Get questions from the previously loaded test dataset.

```python
query = "What did the president say about Ketanji Brown Jackson"
qa.invoke(query)
```




    {'query': 'What did the president say about Ketanji Brown Jackson',
     'result': ' The president said, "One of our nation’s top legal minds, who will continue Justice Breyer’s legacy of excellence." This statement was made in reference to Ketanji Brown Jackson, who was nominated by the president to serve on the United States Supreme Court.'}



---

<a id="summary"></a>
## Summary and next steps

 You successfully completed this notebook!.
 
 You learned how to answer question using RAG using watsonx and LangChain.
 
Check out our _<a href="https://ibm.github.io/watsonx-ai-python-sdk/samples.html" target="_blank" rel="noopener no referrer">Online Documentation</a>_ for more samples, tutorials, documentation, how-tos, and blog posts. 

