# Use watsonx to manage Prompt Templates & create deployment — Notebook

**Track:** Core/Granite → Granite Lab 3  
**Why:** Shows Prompt Template assets and deployments in watsonx.ai.  
**Converted on:** 2025-10-13

---

![image](https://raw.githubusercontent.com/IBM/watson-machine-learning-samples/master/cloud/notebooks/headers/watsonx-Prompt_Lab-Notebook.png)
# Use watsonx.ai python SDK to manage Prompt Template assets and create deployment

#### Disclaimers

- Use only Projects and Spaces that are available in watsonx context.


## Notebook content

This notebook contains the steps and code to demonstrate support for Prompt Template inference and their deployments.

Some familiarity with Python is helpful. This notebook uses Python 3.10.


## Learning goal

The goal of this notebook is to demonstrate how to create a Prompt Template asset and deployment pointing on it. In general, a Prompt Template is a pattern for generating prompts for language models. A template may contain instruction, input/output prefixes, few-shot examples and appropriate context that may vary depending on different tasks.


## Contents

This notebook contains the following parts:

- [Setup](#setup)
- [Prompt Template Inference](#prompt)
- [Prompt Template Deployment](#deployment)
- [Summary](#summary)

<a id="setup"></a>
## Set up the environment

Before you use the sample code in this notebook, you must perform the following setup tasks:

-  Create a <a href="https://cloud.ibm.com/catalog/services/watson-machine-learning" target="_blank" rel="noopener no referrer">Watson Machine Learning (WML) Service</a> instance (a free plan is offered and information about how to create the instance can be found <a href="https://dataplatform.cloud.ibm.com/docs/content/wsj/getting-started/wml-plans.html?context=wx&audience=wdp" target="_blank" rel="noopener no referrer">here</a>).


### Install dependecies

```python
!pip install "ibm-watsonx-ai>=0.1.2" | tail -n 1
```

### Defining the watsonx credentials
This cell defines the watsonx credentials required to work with watsonx Prompt Template inferencing.

**Action:** Provide the IBM Cloud user API key. For details, see <a href="https://cloud.ibm.com/docs/account?topic=account-userapikey&interface=ui" target="_blank" rel="noopener no referrer">documentation</a>.

```python
import getpass

credentials = {
    "url": "https://us-south.ml.cloud.ibm.com",
    "apikey": getpass.getpass("Please enter your WML api key (hit enter): ")
}
```

### Defining the project id
The Prompt Template requires project id that provides the context for the call. We will obtain the id from the project in which this notebook runs. Otherwise, please provide the project id.

```python
import os

try:
    project_id = os.environ["PROJECT_ID"]
except KeyError:
    project_id = input("Please enter your project_id (hit enter): ")
```

<a id="prompt"></a>
## Prompt Template on `watsonx.ai`

```python
from ibm_watsonx_ai.foundation_models.prompts import PromptTemplateManager, PromptTemplate
from ibm_watsonx_ai.foundation_models.utils.enums import ModelTypes, DecodingMethods, PromptTemplateFormats
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams
```

### Instantiate PromptTemplateManager

```python
prompt_mgr = PromptTemplateManager(credentials=credentials,
                                   project_id=project_id)
```

### Create a Prompt Template object and store it in the project


We use a `PromptTemplate` object to store the properties of a newly created prompt template. Prompt text is composed of the instruction, input/output prefixes, few-shot examples and input text. All of the mentioned fields may contain placeholders (`{...}`) with input variables and for the template to be valid, these input variables must be also specified in `input_variables` parameter.

```python
prompt_template = PromptTemplate(name="New prompt",
                                 model_id=ModelTypes.FLAN_T5_XXL,
                                 model_params = {GenParams.DECODING_METHOD: "sample"},
                                 description="My example",
                                 task_ids=["generation"],
                                 input_variables=["object"],
                                 instruction="Answer on the following question",
                                 input_prefix="Human",
                                 output_prefix="Assistant",
                                 input_text="What is {object} and how does it work?",
                                 examples=[["What is a loan and how does it work?", 
                                            "A loan is a debt that is repaid with interest over time."]]
                                )
```

Using `store_prompt(prompt_template_id)` method, one can store newly created prompt template in your ptoject.

```python
stored_prompt_template = prompt_mgr.store_prompt(prompt_template=prompt_template)
```

```python
print(f"Asset id: {stored_prompt_template.prompt_id}")
print(f"Is it a template?: {stored_prompt_template.is_template}")
```

    Asset id: 472dafc1-78dc-442b-abe3-2ad15ce01aa1
    Is it a template?: True


We can also store a template which is a `langchain` Prompt Template object.

```python
!pip install langchain | tail -n 1
```

```python
from langchain.prompts import PromptTemplate as LcPromptTemplate

langchain_prompt_template = LcPromptTemplate(template="What is {object} and how does it work?",
                                             input_variables=["object"])
stored_prompt_template_lc = prompt_mgr.store_prompt(prompt_template=langchain_prompt_template)
print(f"Asset id: {stored_prompt_template_lc.prompt_id}")
```

    Asset id: edd90574-8969-41bd-a19a-37a6a3de7f76


### Manage Prompt Templates

```python
prompt_mgr.list()
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
      <th>ID</th>
      <th>NAME</th>
      <th>CREATED</th>
      <th>LAST MODIFIED</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>edd90574-8969-41bd-a19a-37a6a3de7f76</td>
      <td>My prompt</td>
      <td>2023-12-04T16:04:42Z</td>
      <td>2023-12-04T16:04:44Z</td>
    </tr>
    <tr>
      <th>1</th>
      <td>472dafc1-78dc-442b-abe3-2ad15ce01aa1</td>
      <td>New prompt</td>
      <td>2023-12-04T16:04:37Z</td>
      <td>2023-12-04T16:04:46Z</td>
    </tr>
  </tbody>
</table>
</div>



To retrive Prompt Template asset from project and return string that contains Prompt Template input we use `load_prompt(prompt_template_id, astype=...)`. Returned input string is composed of the fields: `instruction`, `input_prefix`, `output_prefix`, `examples` and `input_text`. After substituting prompt variables, one can evaluate a language model on the obtained string.

```python
prompt_text = prompt_mgr.load_prompt(prompt_id=stored_prompt_template.prompt_id, astype=PromptTemplateFormats.STRING)
print(prompt_text)
```

    Answer on the following question
    
    Human What is a loan and how does it work?
    Assistant A loan is a debt that is repaid with interest over time.
    
    Human What is {object} and how does it work?
    Assistant 


To update Prompt Template data use `prompt_mgr.update_prompt` method.

```python
prompt_with_new_instruction = PromptTemplate(instruction="Answer on the following question in a concise way.")
prompt_mgr.update_prompt(prompt_id=stored_prompt_template.prompt_id, 
                         prompt_template=prompt_with_new_instruction)
prompt_text = prompt_mgr.load_prompt(prompt_id=stored_prompt_template.prompt_id, astype=PromptTemplateFormats.STRING)
print(prompt_text)
```

    Answer on the following question in a concise way.
    
    Human What is a loan and how does it work?
    Assistant A loan is a debt that is repaid with interest over time.
    
    Human What is {object} and how does it work?
    Assistant 


Furthermore, to get information about locked state of Prompt Template run following method

```python
prompt_mgr.get_lock(prompt_id=stored_prompt_template.prompt_id)
```




    {'locked': True, 'locked_by': 'IBMid-6950001R2N', 'lock_type': 'edit'}



Using `lock` or `unlock` method, one can change locked state of Prompt Template asset.

```python
prompt_mgr.unlock(prompt_id=stored_prompt_template_lc.prompt_id)
```




    {'locked': False}



Once the prompt template is unlocked it can be deleted. You can also use the `list` method to check the available prompt templates (passing `limit=2` parameter will return only 2 recently created templates).

```python
print(f"Id of the Prompt Template asset that will be deleted: {stored_prompt_template_lc.prompt_id}")
prompt_mgr.delete_prompt(prompt_id=stored_prompt_template_lc.prompt_id)
prompt_mgr.list(limit=2)
```

    Id of the Prompt Template asset that will be deleted: edd90574-8969-41bd-a19a-37a6a3de7f76





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
      <th>ID</th>
      <th>NAME</th>
      <th>CREATED</th>
      <th>LAST MODIFIED</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>472dafc1-78dc-442b-abe3-2ad15ce01aa1</td>
      <td>New prompt</td>
      <td>2023-12-04T16:04:37Z</td>
      <td>2023-12-04T16:05:18Z</td>
    </tr>
  </tbody>
</table>
</div>



<a id="deployment"></a>
## Deployment pointing to Prompt Template

To create deployment pointing to a Prompt template asset we have to initialized `APIClient` object.

```python
from ibm_watsonx_ai import APIClient

client = APIClient(wml_credentials=credentials)
client.set.default_project(project_id)
```




    'SUCCESS'



In the deployment exmaple we will use the prompt with the following input

```python
prompt_input_text = prompt_mgr.load_prompt(prompt_id=stored_prompt_template.prompt_id, 
                                           astype=PromptTemplateFormats.STRING)
print(prompt_input_text)
```

    Answer on the following question in a concise way.
    
    Human What is a loan and how does it work?
    Assistant A loan is a debt that is repaid with interest over time.
    
    Human What is {object} and how does it work?
    Assistant 


Now, we create deployment providing the id of Prompt Template asset and meta props. 

```python
meta_props = {
    client.deployments.ConfigurationMetaNames.NAME: "SAMPLE DEPLOYMENT PROMPT TEMPLATE",
    client.deployments.ConfigurationMetaNames.ONLINE: {},
    client.deployments.ConfigurationMetaNames.BASE_MODEL_ID: "ibm/granite-13b-chat-v2"}

deployment_details = client.deployments.create(artifact_uid=stored_prompt_template.prompt_id, meta_props=meta_props)
```

    
    
    #######################################################################################
    
    Synchronous deployment creation for uid: '472dafc1-78dc-442b-abe3-2ad15ce01aa1' started
    
    #######################################################################################
    
    
    initializing
    Note: online_url and serving_urls are deprecated and will be removed in a future release. Use inference instead.
    
    ready
    
    
    ------------------------------------------------------------------------------------------------
    Successfully finished deployment creation, deployment_uid='bfbd5e2f-2000-4973-9275-11c84788d036'
    ------------------------------------------------------------------------------------------------
    
    


```python
client.deployments.list()
```

    ------------------------------------  ---------------------------------  -----  ------------------------  ---------------  ----------  ----------------
    GUID                                  NAME                               STATE  CREATED                   ARTIFACT_TYPE    SPEC_STATE  SPEC_REPLACEMENT
    bfbd5e2f-2000-4973-9275-11c84788d036  SAMPLE DEPLOYMENT PROMPT TEMPLATE  ready  2023-12-04T16:07:06.249Z  prompt_template
    ------------------------------------  ---------------------------------  -----  ------------------------  ---------------  ----------  ----------------





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
      <th>GUID</th>
      <th>NAME</th>
      <th>STATE</th>
      <th>CREATED</th>
      <th>ARTIFACT_TYPE</th>
      <th>SPEC_STATE</th>
      <th>SPEC_REPLACEMENT</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>bfbd5e2f-2000-4973-9275-11c84788d036</td>
      <td>SAMPLE DEPLOYMENT PROMPT TEMPLATE</td>
      <td>ready</td>
      <td>2023-12-04T16:07:06.249Z</td>
      <td>prompt_template</td>
      <td></td>
      <td></td>
    </tr>
  </tbody>
</table>
</div>



Substitute prompt variables and generate text

```python
deployment_id = deployment_details.get("metadata", {}).get("id")
```

```python
client.deployments.generate_text(deployment_id, params={"prompt_variables": {"object": "a mortgage"},
                                                        GenParams.DECODING_METHOD: DecodingMethods.GREEDY,
                                                        GenParams.STOP_SEQUENCES: ['\n\n'],
                                                        GenParams.MAX_NEW_TOKENS: 50})
```




    '\nA mortgage is a type of loan that is used to purchase a property, such as a house or a condo.\n\n'



### Generate text using ModelInference

You can also generate text based on your Prompt Template deployment using `ModelInference` class.

```python
from ibm_watsonx_ai.foundation_models import ModelInference
```

```python
model_inference = ModelInference(deployment_id=deployment_id, 
                                 credentials=credentials, 
                                 project_id=project_id)
```

```python
model_inference.generate_text(params={"prompt_variables": {"object": "a mortgage"},
                                      GenParams.DECODING_METHOD: DecodingMethods.GREEDY,
                                      GenParams.STOP_SEQUENCES: ['\n\n'],
                                      GenParams.MAX_NEW_TOKENS: 50})
```




    '\nA mortgage is a type of loan that is used to purchase a property, such as a house or a condo.\n\n'



<a id="summary"></a>
## Summary and next steps

 You successfully completed this notebook!.
 
 You learned how to create valid Prompt Template and store it in watsonx.ai project. Furthermore, you also learned how to create deployment pointing to a Prompt Template asset and generate text using base model.
 
 Check out our _<a href="https://ibm.github.io/watsonx-ai-python-sdk/samples.html" target="_blank" rel="noopener no referrer">Online Documentation</a>_ for more samples, tutorials, documentation, how-tos, and blog posts. 

