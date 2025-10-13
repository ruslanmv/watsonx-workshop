# Use watsonx, and Elasticsearch Python SDK to answer questions (RAG) — Notebook

**Track:** RAG → Lab 2  
**Why:** Low-level control/debug vs. LangChain version.  
**Converted on:** 2025-10-13

---

![image](https://raw.githubusercontent.com/IBM/watson-machine-learning-samples/master/cloud/notebooks/headers/watsonx-Prompt_Lab-Notebook.png)
# Use watsonx, and Elasticsearch Python SDK to answer questions (RAG)

#### Disclaimers

- Use only Projects and Spaces that are available in watsonx context.

## Notebook content

This notebook contains the steps and code to demonstrate support of Retrieval Augumented Generation in watsonx.ai. It introduces commands for data retrieval, knowledge base building & querying, and model testing.

Some familiarity with Python is helpful. This notebook uses Python 3.10.

#### About Retrieval Augmented Generation
Retrieval Augmented Generation (RAG) is a versatile pattern that can unlock a number of use cases requiring factual recall of information, such as querying a knowledge base in natural language.

In its simplest form, RAG requires 3 steps:

- Index knowledge base passages (once)
- Retrieve relevant passage(s) from knowledge base (for every user query)
- Generate a response by feeding retrieved passage into a large language model (for every user query)

## Contents

This notebook contains the following parts:

- [Setup](#setup)
- [Data (test) loading](#data)
- [Foundation Models on watsonx](#models)
- [Basic information how to connect to Elasticsearch (applies to both scenarios)](#elastic_conn)
- **[Retrieval augmented generation using Elasticsearch (Python Client)](#elastic)**
    - [Create index](#mapping)
    - [Index data into Elasticsearch](#index_data)
    - [Run semantic knn search queries](#knn)
    - [Calculate rougeL metric](#elastic_score)
    



<a id="setup"></a>
##  Set up the environment

Before you use the sample code in this notebook, you must perform the following setup tasks:

-  Create a <a href="https://cloud.ibm.com/catalog/services/watson-machine-learning" target="_blank" rel="noopener no referrer">Watson Machine Learning (WML) Service</a> instance (a free plan is offered and information about how to create the instance can be found <a href="https://dataplatform.cloud.ibm.com/docs/content/wsj/admin/create-services.html?context=wx&audience=wdp" target="_blank" rel="noopener no referrer">here</a>).


### Install and import dependecies

```python
!pip install "langchain==0.0.340" | tail -n 1
!pip install elasticsearch | tail -n 1
!pip install sentence_transformers | tail -n 1
!pip install pandas | tail -n 1
!pip install rouge_score | tail -n 1
!pip install nltk | tail -n 1
!pip install wget | tail -n 1
!pip install evaluate | tail -n 1
!pip install "pydantic==1.10.0" | tail -n 1
!pip install "ibm-watsonx-ai>=1.0.312" | tail -n 1
```

```python
import os, getpass
import pandas as pd
```

### watsonx API connection
This cell defines the credentials required to work with watsonx API for Foundation
Model inferencing.

**Action:** Provide the IBM Cloud user API key. For details, see <a href="https://cloud.ibm.com/docs/account?topic=account-userapikey&interface=ui" target="_blank" rel="noopener no referrer">documentation</a>.

```python
credentials = {
    "url": "https://us-south.ml.cloud.ibm.com",
    "apikey": getpass.getpass("Please enter your WML api key (hit enter): ")
}
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

<a id="data"></a>
## Data (test) loading

Download the test dataset. This dataset is used to calculate the metrics score for selected model, defined prompts and parameters.

```python
import wget

questions_test_filename = 'questions_test.csv'
questions_train_filename = 'questions_train.csv'
questions_test_url = 'https://raw.github.com/IBM/watson-machine-learning-samples/master/cloud/data/RAG/questions_test.csv'
questions_train_url = 'https://raw.github.com/IBM/watson-machine-learning-samples/master/cloud/data/RAG/questions_train.csv'


if not os.path.isfile(questions_test_filename): 
    wget.download(questions_test_url, out=questions_test_filename)


if not os.path.isfile(questions_train_filename): 
    wget.download(questions_train_url, out=questions_train_filename)
```

```python
filename_test = './questions_test.csv'
filename_train =  './questions_train.csv'

test_data = pd.read_csv(filename_test)
train_data = pd.read_csv(filename_train)
```

Inspect data sample

```python
train_data.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>qid</th>
      <th>question</th>
      <th>answers</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1961</td>
      <td>where does diffusion occur in the excretory sy...</td>
      <td>diffusion</td>
    </tr>
    <tr>
      <th>1</th>
      <td>7528</td>
      <td>when did the us join world war one</td>
      <td>April 6 , 1917</td>
    </tr>
    <tr>
      <th>2</th>
      <td>8685</td>
      <td>who played wilma in the movie the flintstones</td>
      <td>Elizabeth Perkins</td>
    </tr>
    <tr>
      <th>3</th>
      <td>6716</td>
      <td>when was the office of the vice president created</td>
      <td>1787</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2916</td>
      <td>where does carbon fixation occur in c4 plants</td>
      <td>in the mesophyll cells</td>
    </tr>
  </tbody>
</table>
</div>



### Build up knowledge base

The current state-of-the-art in RAG is to create dense vector representations of the knowledge base in order to calculate the semantic similarity to a given user query.

We can generate dense vector representations using embedding models. In this notebook, we use <a href="https://www.sbert.net/" target="_blank" rel="noopener no referrer">SentenceTransformers</a> <a href="https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2" target="_blank" rel="noopener no referrer">all-MiniLM-L6-v2</a> to embed both the knowledge base passages and user queries. `all-MiniLM-L6-v2` is a performant open-source model that is small enough to run locally.

A vector database is optimized for dense vector indexing and retrieval. This notebook uses <a href="https://python.langchain.com/docs/integrations/vectorstores/elasticsearch#basic-example" target="_blank" rel="noopener no referrer">Elasticsearch</a>, a distributed, RESTful search and analytics engine, capable of performing both vector and lexical search. It is built on top of the Apache Lucene library, which offers good speed and performance with all-MiniLM-L6-v2 embedding model.

The dataset we are using is already split into self-contained passages that can be ingested by Elasticsearch. 

The size of each passage is limited by the embedding model's context window (which is 256 tokens for `all-MiniLM-L6-v2`).

### Load knowledge base documents

Load set of documents used further to build knowledge base. 

```python
knowledge_base_dir = "./knowledge_base"
```

```python
my_path = f"{os.getcwd()}/knowledge_base"
if not os.path.isdir(my_path):
   os.makedirs(my_path)
```

```python
documents_filename = 'knowledge_base/psgs.tsv'
documents_url = 'https://raw.github.com/IBM/watson-machine-learning-samples/master/cloud/data/RAG/psgs.tsv'


if not os.path.isfile(documents_filename): 
    wget.download(documents_url, out=documents_filename)
```

```python
documents = pd.read_csv(f"{knowledge_base_dir}/psgs.tsv", sep='\t', header=0)
documents['indextext'] = documents['title'].astype(str) + "\n" + documents['text']
documents = documents[:1000]
```

### Create an embedding function

Note that you can feed a custom embedding function to be used by Elasticsearch. The performance of Elasticsearch may differ depending on the embedding model used.

```python
from langchain.embeddings import SentenceTransformerEmbeddings

emb_func = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
```

<a id="models"></a>
## Foundation Models on watsonx

### Defining model
You need to specify `model_id` that will be used for inferencing:

```python
from ibm_watsonx_ai.foundation_models.utils.enums import ModelTypes

model_id = ModelTypes.FLAN_UL2
```

### Defining the model parameters
We need to provide a set of model parameters that will influence the result:

```python
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams
from ibm_watsonx_ai.foundation_models.utils.enums import DecodingMethods

parameters = {
    GenParams.DECODING_METHOD: DecodingMethods.GREEDY,
    GenParams.MIN_NEW_TOKENS: 1,
    GenParams.MAX_NEW_TOKENS: 50
}
```

### Initialize the `Model` class.

```python
from ibm_watsonx_ai.foundation_models import Model

model = Model(
    model_id=model_id,
    params=parameters,
    credentials=credentials,
    project_id=project_id
)
```

<a id="elastic_conn"></a>
## Basic information how to connect to Elasticsearch 

**This notebook focuses on self-managed cluster using <a href="https://cloud.ibm.com/docs/databases-for-elasticsearch?topic=databases-for-elasticsearch-getting-started" target="_blank" rel="noopener no referrer">IBM Cloud® Databases for Elasticsearch.</a>**

The following cell retrieves the Elasticsearch users, password, host and port from the environment if available and prompts you otherwise.

```python
try:
    esuser = os.environ["ESUSER"]
except KeyError:
    esuser = input("Please enter your Elasticsearch user name (hit enter): ")
try:
    espassword = os.environ["ESPASSWORD"]
except KeyError:
    espassword = getpass.getpass("Please enter your Elasticsearch password (hit enter): ")
try:
    eshost = os.environ["ESHOST"]
except KeyError:
    eshost = input("Please enter your Elasticsearch hostname (hit enter): ")
try:
    esport = os.environ["ESPORT"]
except KeyError:
    esport = input("Please enter your Elasticsearch port number (hit enter): ")
```

By default Elasticsearch will start with security features like authentication and TLS enabled. To connect to the Elasticsearch cluster you’ll need to configure the Python Elasticsearch client to use HTTPS with the generated CA certificate in order to make requests successfully. Details can be found <a href="https://www.elastic.co/guide/en/elasticsearch/client/python-api/current/connecting.html#connect-self-managed-new" target="_blank" rel="noopener no referrer">here</a>. In this notebook certificate fingerprints will be used for authentication. 

**Verifying HTTPS with certificate fingerprints (Python 3.10 or later)** If you don’t have access to the generated CA file from Elasticsearch you can use the following script to output the root CA fingerprint of the Elasticsearch instance with openssl s_client <a href="https://www.elastic.co/guide/en/elasticsearch/client/python-api/current/connecting.html#_verifying_https_with_certificate_fingerprints_python_3_10_or_later" target="_blank" rel="noopener no referrer"> (docs)</a>:

The following cell retrieves the fingerprint information using a shell command and stores it in variable `ssl_assert_fingerprint`.

```python
es_ssl_fingerprint = !openssl s_client -connect $eshost:$esport  -showcerts </dev/null 2>/dev/null | openssl x509 -fingerprint -sha256 -noout -in /dev/stdin
es_ssl_fingerprint = es_ssl_fingerprint[0].split("=")[1]
es_ssl_fingerprint
```

<a id="elastic"></a>
# Retrieval augmented generation using Elasticsearch (Python SDK)

Connect to Elasticsearch

```python
from elasticsearch import Elasticsearch

elastic_client = Elasticsearch([f"https://{esuser}:{espassword}@{eshost}:{esport}"],
                              basic_auth=(esuser, espassword),
                              request_timeout=None,
                              ssl_assert_fingerprint=es_ssl_fingerprint)
```

In this scenario the same embedding function `all-MiniLM-L6-v2` will be used.

```python
dims = emb_func.client.get_sentence_embedding_dimension()
dims
```




    384



<a id="mapping"></a>
### Create index
To create Elasticsearch index necessary mappings need to be created. This will enable index the data into Elasticsearch.

Field `dense_vector` is a special type that allows to store dense vectors in this case `embedding` in Elasticsearch.

```python
index_name = "elastic_knn_index"
mapping = {
        "properties": {
                "text": {
                        "type": "text"
                    },
                "embedding": {
                        "type": "dense_vector",
                        "dims": dims,
                        "index": True,
                        "similarity": "l2_norm"
                    }
            }
    }
```

```python
if elastic_client.indices.exists(index=index_name):
    elastic_client.indices.delete(index=index_name)
    
elastic_client.indices.create(index=index_name, mappings=mapping)
```




    ObjectApiResponse({'acknowledged': True, 'shards_acknowledged': True, 'index': 'elastic_knn_index'})



<a id="index_data"></a>
### Index data into Elasticsearch

The following function generates the required bulk actions that can be passed to Elasticsearch's Bulk API, so we can index multiple documents efficiently. To perform semantic search, we need to encode queries with the same embedding model used to encode the documents at index time.

```python
texts = documents.indextext.tolist()
embedded_docs = emb_func.embed_documents(texts)
```

```python
from elasticsearch.helpers import bulk

document_list = []
batch_size=500
requests = []
for i, (text, vector) in enumerate(zip(texts, embedded_docs)):
    document = {"_id": i, "embedding": vector, 'text': text}
    document_list.append(document)
    if i % batch_size == batch_size-1:
        success, failed = bulk(elastic_client, document_list, index=index_name)
        document_list = []

elastic_client.indices.refresh(index=index_name)
```




    ObjectApiResponse({'_shards': {'total': 2, 'successful': 2, 'failed': 0}})



### Select questions

Get questions from the previously loaded test dataset.

```python
questions_and_answers = [
            ('names of founding fathers of the united states?', "Thomas Jefferson::James Madison::John Jay::George Washington::John Adams::Benjamin Franklin::Alexander Hamilton"),
            ('who played in the super bowl in 2013?', 'Baltimore Ravens::San Francisco 49ers'),
            ('when did bucharest become the capital of romania?', '1862')
            ]
```

<a id="knn"></a>
## Run semantic search queries

Now it's time to run queries against our Elasticsearch index using our encoded question. We'll be doing a k-nearest neighbors search, using the Elasticsearch kNN query option. Argument k stands for a number of nearest neighbors to return as top hits. Set minimal similarity score to 0.45 

```python
relevant_contexts = []

for question_text, _ in questions_and_answers:
    embedded_question = emb_func.embed_query(question_text)
    relevant_chunks = elastic_client.search(
          index=index_name,
          knn={
            "field": "embedding",
            "query_vector": embedded_question,
            "k": 4,
            "num_candidates": 50,
            },
          _source=[
                    "text"
                  ],
          size=5
                                
    )
    relevant_contexts.append(relevant_chunks)
```

```python
relevant_context = relevant_contexts[0]
hits = relevant_context['hits']['hits']
for hit in hits:
    print("=========")
    print("Paragraph index : ", hit["_id"])
    print("Paragraph : ", hit["_source"]['text'])
    print("Distance : ",  hit["_score"])
            
```

    =========
    Paragraph index :  912
    Paragraph :  Founding Fathers of the United States
    ^ Burstein , Andrew . `` Politics and Personalities : Garry Wills takes a new look at a forgotten founder , slavery and the shaping of America '' , Chicago Tribune ( November 09 , 2003 ) : `` Forgotten founders such as Pickering and Morris made as many waves as those whose faces stare out from our currency . '' ^ Jump up to : Rafael , Ray . The Complete Idiot 's Guide to the Founding Fathers : And the Birth of Our Nation ( Penguin , 2011 ) . Jump up ^ `` Founding Fathers : Virginia '' . FindLaw Constitutional Law Center . 2008 . Retrieved 2008 - 11 - 14 . Jump up ^ Schwartz , Laurens R. Jews and the American Revolution : Haym Solomon and Others , Jefferson , North Carolina : McFarland & Co. , 1987 . Jump up ^ Kendall , Joshua . The Forgotten Founding Father : Noah Webster 's Obsession and the Creation of an American Culture ( Penguin 2011 ) . Jump up ^ Wright , R.E. ( 1996 ) . `` Thomas Willing ( 1731 - 1821 ) : Philadelphia Financier and Forgotten Founding Father '' . Pennsylvania History . 63 ( 4 ) : 525 -- 560 . doi : 10.2307 / 27773931 ( inactive 2017 - 01 - 15 ) . JSTOR 27773931 . Jump up ^ `` A Patriot of Early New England '' , New York Times ( December 20 , 1931 )
    Distance :  0.6436015
    =========
    Paragraph index :  879
    Paragraph :  Founding Fathers of the United States
    Prior to , and during the 19th century , they were referred to as simply the `` Fathers '' . The term has been used to describe the founders and first settlers of the original royal colonies . Contents ( hide ) 1 Background 2 Interesting facts and commonalities 2.1 Education 2.1. 1 Colleges attended 2.1. 2 Advanced degrees and apprenticeships 2.1. 2.1 Doctors of medicine 2.1. 2.2 Theology 2.1. 2.3 Legal apprenticeships 2.1. 3 Self - taught or little formal education 2.2 Demographics 2.3 Political experience 2.4 Occupations and finances 2.5 Religion 2.6 Ownership of slaves and position on slavery 2.7 Attendance at conventions 2.8 Spouses and children 2.9 Charters of freedom and historical documents of the United States 2.10 Post-constitution life 2.11 Youth and longevity 2.12 Founders who were not signatories or delegates 3 Legacy 3.1 Institutions formed by Founders 3.2 Scholarship on the Founders 3.2. 1 Living historians whose focus is the Founding Fathers 3.2. 2 Noted collections of the Founding Fathers 3.3 In stage and film 3.4 Children 's books 4 See also 5 Notes 6 References 7 External links Background ( edit ) The Albany Congress of 1754 was a conference attended by seven colonies , which presaged later efforts at cooperation . The Stamp Act Congress of 1765 included representatives from nine colonies . The First Continental Congress met briefly in Philadelphia , Pennsylvania in 1774 , consisting of fifty - six delegates from twelve of the thirteen colonies ( excluding Georgia ) that
    Distance :  0.6386697
    =========
    Paragraph index :  939
    Paragraph :  Founding Fathers of the United States
    President of Congress Peyton Randolph New Hampshire John Sullivan Nathaniel Folsom Massachusetts Bay Thomas Cushing Samuel Adams John Adams Robert Treat Paine Rhode Island Stephen Hopkins Samuel Ward Connecticut Eliphalet Dyer Roger Sherman Silas Deane New York Isaac Low John Alsop John Jay James Duane Philip Livingston William Floyd Henry Wisner Simon Boerum New Jersey James Kinsey William Livingston Stephen Crane Richard Smith John De Hart Pennsylvania Joseph Galloway John Dickinson Charles Humphreys Thomas Mifflin Edward Biddle John Morton George Ross The Lower Counties Caesar Rodney Thomas McKean George Read Maryland Matthew Tilghman Thomas Johnson , Junr William Paca Samuel Chase Virginia Richard Henry Lee George Washington Patrick Henry , Junr Richard Bland Benjamin Harrison Edmund Pendleton North Carolina William Hooper Joseph Hewes Richard Caswell South Carolina Henry Middleton Thomas Lynch Christopher Gadsden John Rutledge Edward Rutledge See also Virginia Association First Continental Congress Carpenters ' Hall Declaration and Resolves of the First Continental Congress Retrieved from `` https://en.wikipedia.org/w/index.php?title=Founding_Fathers_of_the_United_States&oldid=815247535 '' Categories : Age of Enlightenment American Revolution Articles about multiple people Patriots in the American Revolution Political leaders of the American Revolution National founders Hidden categories : Webarchive template wayback links Pages with DOIs inactive since 2017 Use mdy dates from April 2011 Talk Read Contents About Wikipedia Wikiquote Bân - lâm - gú Башҡортса Bikol Central Български Brezhoneg Català Čeština Cymraeg Deutsch Ελληνικά Español Esperanto فارسی Français 한국어 Հայերեն हिन्दी Ido Bahasa Indonesia Interlingua Íslenska Italiano עברית Latina Lietuvių Magyar Bahasa Melayu Nederlands 日本 語 Norsk Polski Português Română
    Distance :  0.6376214
    =========
    Paragraph index :  877
    Paragraph :  Founding Fathers of the United States
    Founding Fathers of the United States - wikipedia Founding Fathers of the United States Jump to : navigation , search Declaration of Independence , a painting by John Trumbull depicting the Committee of Five presenting their draft to the Congress on June 28 , 1776 Signature page of Treaty of Paris ( 1783 ) ; the treaty was negotiated by John Adams , Benjamin Franklin and John Jay . The Founding Fathers of the United States were those individuals of the Thirteen Colonies in North America who led the American Revolution against the authority of the British Crown in word and deed and contributed to the establishment of the United States of America . Historian Richard B. Morris in 1973 identified the following seven figures as the key Founding Fathers : John Adams , Benjamin Franklin , Alexander Hamilton , John Jay , Thomas Jefferson , James Madison , and George Washington . Adams , Jefferson , and Franklin were members of the Committee of Five that drafted the Declaration of Independence . Hamilton , Madison , and Jay were authors of The Federalist Papers , advocating ratification of the Constitution . The constitutions drafted by Jay and Adams for their respective states of New York ( 1777 ) and Massachusetts ( 1780 ) were heavily relied upon when creating language for the US Constitution Jay , Adams and Franklin negotiated the Treaty of Paris ( 1783 ) that would end the American Revolutionary War . Washington was Commander -
    Distance :  0.6280782


### Feed the context and the questions to `watsonx.ai` model.

```python
def make_prompt(context, question_text):
    return (f"Please answer the following.\n"
          + f"{context}:\n\n"
          + f"{question_text}")
```

```python
prompt_texts = []

for relevant_context, (question_text, _) in zip(relevant_contexts, questions_and_answers):
    hits = [hit for hit in relevant_context["hits"]["hits"]]
    context = "\n\n\n".join([rel_ctx["_source"]['text'] for rel_ctx in hits])
    prompt_text = make_prompt(context, question_text)
    prompt_texts.append(prompt_text)
```

```python
print(prompt_texts[0])
```

    Please answer the following.
    Founding Fathers of the United States
    ^ Burstein , Andrew . `` Politics and Personalities : Garry Wills takes a new look at a forgotten founder , slavery and the shaping of America '' , Chicago Tribune ( November 09 , 2003 ) : `` Forgotten founders such as Pickering and Morris made as many waves as those whose faces stare out from our currency . '' ^ Jump up to : Rafael , Ray . The Complete Idiot 's Guide to the Founding Fathers : And the Birth of Our Nation ( Penguin , 2011 ) . Jump up ^ `` Founding Fathers : Virginia '' . FindLaw Constitutional Law Center . 2008 . Retrieved 2008 - 11 - 14 . Jump up ^ Schwartz , Laurens R. Jews and the American Revolution : Haym Solomon and Others , Jefferson , North Carolina : McFarland & Co. , 1987 . Jump up ^ Kendall , Joshua . The Forgotten Founding Father : Noah Webster 's Obsession and the Creation of an American Culture ( Penguin 2011 ) . Jump up ^ Wright , R.E. ( 1996 ) . `` Thomas Willing ( 1731 - 1821 ) : Philadelphia Financier and Forgotten Founding Father '' . Pennsylvania History . 63 ( 4 ) : 525 -- 560 . doi : 10.2307 / 27773931 ( inactive 2017 - 01 - 15 ) . JSTOR 27773931 . Jump up ^ `` A Patriot of Early New England '' , New York Times ( December 20 , 1931 )
    
    
    Founding Fathers of the United States
    Prior to , and during the 19th century , they were referred to as simply the `` Fathers '' . The term has been used to describe the founders and first settlers of the original royal colonies . Contents ( hide ) 1 Background 2 Interesting facts and commonalities 2.1 Education 2.1. 1 Colleges attended 2.1. 2 Advanced degrees and apprenticeships 2.1. 2.1 Doctors of medicine 2.1. 2.2 Theology 2.1. 2.3 Legal apprenticeships 2.1. 3 Self - taught or little formal education 2.2 Demographics 2.3 Political experience 2.4 Occupations and finances 2.5 Religion 2.6 Ownership of slaves and position on slavery 2.7 Attendance at conventions 2.8 Spouses and children 2.9 Charters of freedom and historical documents of the United States 2.10 Post-constitution life 2.11 Youth and longevity 2.12 Founders who were not signatories or delegates 3 Legacy 3.1 Institutions formed by Founders 3.2 Scholarship on the Founders 3.2. 1 Living historians whose focus is the Founding Fathers 3.2. 2 Noted collections of the Founding Fathers 3.3 In stage and film 3.4 Children 's books 4 See also 5 Notes 6 References 7 External links Background ( edit ) The Albany Congress of 1754 was a conference attended by seven colonies , which presaged later efforts at cooperation . The Stamp Act Congress of 1765 included representatives from nine colonies . The First Continental Congress met briefly in Philadelphia , Pennsylvania in 1774 , consisting of fifty - six delegates from twelve of the thirteen colonies ( excluding Georgia ) that
    
    
    Founding Fathers of the United States
    President of Congress Peyton Randolph New Hampshire John Sullivan Nathaniel Folsom Massachusetts Bay Thomas Cushing Samuel Adams John Adams Robert Treat Paine Rhode Island Stephen Hopkins Samuel Ward Connecticut Eliphalet Dyer Roger Sherman Silas Deane New York Isaac Low John Alsop John Jay James Duane Philip Livingston William Floyd Henry Wisner Simon Boerum New Jersey James Kinsey William Livingston Stephen Crane Richard Smith John De Hart Pennsylvania Joseph Galloway John Dickinson Charles Humphreys Thomas Mifflin Edward Biddle John Morton George Ross The Lower Counties Caesar Rodney Thomas McKean George Read Maryland Matthew Tilghman Thomas Johnson , Junr William Paca Samuel Chase Virginia Richard Henry Lee George Washington Patrick Henry , Junr Richard Bland Benjamin Harrison Edmund Pendleton North Carolina William Hooper Joseph Hewes Richard Caswell South Carolina Henry Middleton Thomas Lynch Christopher Gadsden John Rutledge Edward Rutledge See also Virginia Association First Continental Congress Carpenters ' Hall Declaration and Resolves of the First Continental Congress Retrieved from `` https://en.wikipedia.org/w/index.php?title=Founding_Fathers_of_the_United_States&oldid=815247535 '' Categories : Age of Enlightenment American Revolution Articles about multiple people Patriots in the American Revolution Political leaders of the American Revolution National founders Hidden categories : Webarchive template wayback links Pages with DOIs inactive since 2017 Use mdy dates from April 2011 Talk Read Contents About Wikipedia Wikiquote Bân - lâm - gú Башҡортса Bikol Central Български Brezhoneg Català Čeština Cymraeg Deutsch Ελληνικά Español Esperanto فارسی Français 한국어 Հայերեն हिन्दी Ido Bahasa Indonesia Interlingua Íslenska Italiano עברית Latina Lietuvių Magyar Bahasa Melayu Nederlands 日本 語 Norsk Polski Português Română
    
    
    Founding Fathers of the United States
    Founding Fathers of the United States - wikipedia Founding Fathers of the United States Jump to : navigation , search Declaration of Independence , a painting by John Trumbull depicting the Committee of Five presenting their draft to the Congress on June 28 , 1776 Signature page of Treaty of Paris ( 1783 ) ; the treaty was negotiated by John Adams , Benjamin Franklin and John Jay . The Founding Fathers of the United States were those individuals of the Thirteen Colonies in North America who led the American Revolution against the authority of the British Crown in word and deed and contributed to the establishment of the United States of America . Historian Richard B. Morris in 1973 identified the following seven figures as the key Founding Fathers : John Adams , Benjamin Franklin , Alexander Hamilton , John Jay , Thomas Jefferson , James Madison , and George Washington . Adams , Jefferson , and Franklin were members of the Committee of Five that drafted the Declaration of Independence . Hamilton , Madison , and Jay were authors of The Federalist Papers , advocating ratification of the Constitution . The constitutions drafted by Jay and Adams for their respective states of New York ( 1777 ) and Massachusetts ( 1780 ) were heavily relied upon when creating language for the US Constitution Jay , Adams and Franklin negotiated the Treaty of Paris ( 1783 ) that would end the American Revolutionary War . Washington was Commander -:
    
    what are the names of founding fathers of the united states?


### Generate a retrieval-augmented response with watsonx.ai model

```python
results = []

for prompt_text in prompt_texts:
    results.append(model.generate_text(prompt_text))
```

```python
for idx, result in enumerate(results):
    print("Question = ", questions_and_answers[idx][0])
    print("Answer = ", result)
    print("Expected Answer(s) (may not be appear with exact wording in the dataset) = ",  questions_and_answers[idx][1])
    print("\n")
```

    Question =  names of founding fathers of the united states?
    Answer =  John Adams Benjamin Franklin Alexander Hamilton John Jay Thomas Jefferson James Madison George Washington
    Expected Answer(s) (may not be appear with exact wording in the dataset) =  Thomas Jefferson::James Madison::John Jay::George Washington::John Adams::Benjamin Franklin::Alexander Hamilton
    
    
    Question =  who played in the super bowl in 2013?
    Answer =  Baltimore Ravens
    Expected Answer(s) (may not be appear with exact wording in the dataset) =  Baltimore Ravens::San Francisco 49ers
    
    
    Question =  when did bucharest become the capital of romania?
    Answer =  1862
    Expected Answer(s) (may not be appear with exact wording in the dataset) =  1862
    
    


<a id="score"></a>
## Calculate rougeL metric 
In this sample notebook `evaluate` module from HuggingFace was used for rougeL calculation.

```python
from evaluate import load

rouge = load('rouge')
scores = rouge.compute(predictions=results, references=[answer for _, answer in questions_and_answers])
print(scores)
```

    {'rouge1': 0.8571428571428572, 'rouge2': 0.38974358974358975, 'rougeL': 0.6666666666666666, 'rougeLsum': 0.6666666666666666}


---


