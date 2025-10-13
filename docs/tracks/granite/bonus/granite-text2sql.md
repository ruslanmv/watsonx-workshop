# Inferencing with Granite Text-to-SQL Models — Notebook

**Track:** Granite (Bonus module)  
**Why:** NLQ→SQL pipeline (schema linking + SQL generation).  
**Converted on:** 2025-10-13

---

```python
import os
import json
import requests
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
```

# Inferencing with Granite Text-to-SQL Models 

This notebook demonstrates how to use the two Text2SQL pipeline components, the Schema Linking model (SL) and SQL Generation model (SQL Gen). The inputs of Text2SQL pipeline include a natural language question (NLQ), a database schema in the JSON format, and optionally an evidence (or hint) for models to generate a better SQL query. Inference calls to two models are done via watsonx.ai REST API Endpoints as shown in the sample code in the steps below. This notebook also shows the input prompt and output of each component in the pipeline.

## Table of Contents

1. [Setup](#setup)
1. [Create a prompt for the Schema Linking Model](#schemaprompt)
1. [Perform an inference on the Schema Linking model using the watsonx.ai endpoint](#schemainference)
1. [Post the process of the Schema Linking model output](#schemapost)
1. [Create a prompt for the SQL Generation model](#sqlprompt)
1. [Perform an inference on the SQL Generation model using the watsonx.ai endpoint](#sqlinference)

## Setup
<a id="setup"></a>

You need to provide an API key, see [here](https://dataplatform.cloud.ibm.com/docs/content/wsj/manage-data/task-credentials.html?context=wx&locale=en&audience=wdp) for more details. You can either enter it in the code samples below or set them as environment variable: `WATSONX_APIKEY`.

```python
CLOUD_HOSTNAME = "https://us-south.ml.cloud.ibm.com" # TODO: change this to your cloud hostname if using other cluster
```

```python
from dotenv import find_dotenv, load_dotenv
from getpass import getpass

load_dotenv(find_dotenv())

try:
    IBM_CLOUD_API_KEY = getpass("Please enter your watsonx.ai API key (hit enter): ")

except:
    IBM_CLOUD_API_KEY = os.getenv("WATSONX_APIKEY", None)

```

```python
assert IBM_CLOUD_API_KEY, "WATSONX_APIKEY must be set"
```

### Setup access token

Using the above API key, we generate an access token. If the token expires (each token lasts an hour), we need to request a new one. 

```python
# Get a IAM Bearer token 
token_url = "https://iam.cloud.ibm.com/identity/token"
token_headers = {"Content-Type": "application/x-www-form-urlencoded"}
token_data =  {"grant_type": "urn:ibm:params:oauth:grant-type:apikey", "apikey": IBM_CLOUD_API_KEY}

response = requests.post(token_url, headers=token_headers, data=token_data)

if response.status_code != 200:
	raise Exception("Non-200 response: " + str(response.text))

ACCESS_TOKEN = response.json()["access_token"]
```

```python
ACCESS_TOKEN
```

### Deploy models

We follow the instructions [here](https://dataplatform.cloud.ibm.com/docs/content/wsj/analyze-data/deploy-on-demand-rest-api.html?context=wx&locale=en&audience=wdp) to deploy the 2 models:
- [granite-20b-code-base-schema-linking](https://dataplatform.cloud.ibm.com/docs/content/wsj/analyze-data/fm-models-details.html?context=wx&locale=en&audience=wdp#granite-code-models)
- [granite-20b-code-base-sql-gen](https://dataplatform.cloud.ibm.com/docs/content/wsj/analyze-data/fm-models-details.html?context=wx&locale=en&audience=wdp#granite-code-models)

#### Working with spaces

You need to create a space that will be used for your work. If you do not have a space, you can use [Deployment Spaces Dashboard](https://dataplatform.cloud.ibm.com/ml-runtime/spaces?context=wx) to create one.

- Click **New Deployment Space**
- Create an empty space
- Select Cloud Object Storage
- Select watsonx.ai Runtime instance and press **Create**
- Go to **Manage** tab
- Copy `Space GUID` and paste it below

```python
try:
    SPACE_ID = input('Enter watsonx.ai space id: ')
except:
    SPACE_ID = os.getenv("WATSONX_SPACE_ID", None)

```

```python
SPACE_ID
```

```python
assert SPACE_ID, "SPACE_ID must be set"
```

#### Creating model asset

This step can be done once, if you already have a model asset, just provide the asset id for `sl_asset_id` and `sql_gen_asset_id`.

```python
def create_model_asset(model_id, space_id, access_token, asset_name=None):
    asset_url = f"{CLOUD_HOSTNAME}/ml/v4/models?version=2024-01-29"
    asset_headers = {"Content-Type": "application/json",
                  "Authorization": f"Bearer {access_token}"}

    asset_payload =  {"type": "curated_foundation_model_1.0",
                       "version": "1.0",
                       "name": model_id.split("/")[-1] if asset_name is None else asset_name,
                       "space_id": space_id,
                       "foundation_model": {"model_id": model_id}
                      }
    
    asset_response = requests.post(asset_url, headers=asset_headers, json=asset_payload)
    return asset_response.json()
```

```python
sl_asset_response = create_model_asset(model_id="ibm/granite-20b-code-base-schema-linking-curated",
                                       space_id=SPACE_ID,
                                       access_token=ACCESS_TOKEN)
sql_gen_asset_response = create_model_asset(model_id="ibm/granite-20b-code-base-sql-gen-curated",
                                            space_id=SPACE_ID,
                                            access_token=ACCESS_TOKEN)
```

```python
sl_asset_id = sl_asset_response["metadata"]["id"] # TODO: override if asset had already been created
sql_gen_asset_id = sql_gen_asset_response["metadata"]["id"] # TODO: override if asset had already been created
sl_asset_id, sql_gen_asset_id
```




    ('deee5205-9cf0-41f8-9826-7cdb5d2d5393',
     'f6af013a-4645-42c4-b9d6-1dcd39fa0f5c')



```python
# sl_deploy_response # uncomment to see detailed response
```

```python
# sql_gen_deploy_response # uncomment to see detailed response
```

#### Model deployment and endpoints setup

Once the models are deployed, fill in required information below.

```python
# watsonx.ai deployment information
SL_MODEL_ID = "granite20b_schema_linking" # Note: serving name of schema linking model, can only use '-' with numbers/letters, need to be unique
SQL_GEN_MODEL_ID = "granite_20b_sql_gen" # Note: serving name of sql gen model, can only use '-' with numbers/letters, need to be unique
```

```python
def deploy_model(asset_id, serving_name, access_token, deployment_name="", description=""):
    deploy_url = f"{CLOUD_HOSTNAME}/ml/v4/deployments?version=2024-01-29"
    deploy_headers = {"Content-Type": "application/json",
                  "Authorization": f"Bearer {access_token}"}
    deploy_payload =  { "asset": {
                            "id": asset_id
                          },
                          "online": {
                            "parameters": {
                              "serving_name": serving_name
                            }
                          },
                          "description": "",
                          "name": deployment_name,
                          "space_id": SPACE_ID
                        }
    
    response = requests.post(deploy_url, headers=deploy_headers, json=deploy_payload)
    return response.json()

def get_deployment_info(deploy_id, space_id, access_token):
    deploy_url = f"{CLOUD_HOSTNAME}/ml/v4/deployments/{deploy_id}?version=2024-01-29&space_id={space_id}"
    deploy_headers = {"Content-Type": "application/json",
                  "Authorization": f"Bearer {access_token}"}

    
    return requests.get(deploy_url, headers=deploy_headers).json()

def is_deployment_ready(deploy_id, space_id, access_token):
    response = get_deployment_info(deploy_id=deploy_id, space_id=space_id, access_token=access_token)
    try:
        return response["entity"]["status"]["state"] == "ready"
    except:
        return False

def delete_deployment(deploy_id, space_id, access_token):
    deploy_url = f"{CLOUD_HOSTNAME}/ml/v4/deployments/{deploy_id}?version=2024-01-29&space_id={space_id}"
    deploy_headers = {"Authorization": f"Bearer {access_token}"}
    try:
        requests.delete(deploy_url, headers=deploy_headers)
    except:
        pass

```

```python
sl_deploy_response = deploy_model(sl_asset_id,
                                  serving_name=SL_MODEL_ID,
                                  access_token=ACCESS_TOKEN,
                                  deployment_name="schema-linking-deployment",
                                  description="granite20b-schema-linking deployment")

sql_gen_deploy_response = deploy_model(sql_gen_asset_id,
                                       serving_name=SQL_GEN_MODEL_ID,
                                       access_token=ACCESS_TOKEN,
                                       deployment_name="sql-gen-deployment",
                                       description="granite20b-sql-gen deployment")
```

```python
# sl_deploy_response # uncomment to see detailed response
```

```python
# sql_gen_deploy_response # uncomment to see detailed response
```

```python
if "errors" in sl_deploy_response:
    print(sl_deploy_response["errors"])
else:
    SL_DEPLOYMENT_ID = sl_deploy_response["metadata"]["id"]
if "errors" in sql_gen_deploy_response:
    print(sql_gen_deploy_response["errors"])
else:
    SQL_GEN_DEPLOYMENT_ID = sql_gen_deploy_response["metadata"]["id"]
```

```python
SL_DEPLOYMENT_ID, SQL_GEN_DEPLOYMENT_ID
```




    ('f95334ab-25f1-42dd-a506-5e0a7157edbc',
     'a87bf110-2ea6-42ad-971d-d7d28788c358')



```python
# define inference URLs
SL_PROD_URL = f"{CLOUD_HOSTNAME}/ml/v1/deployments/{SL_DEPLOYMENT_ID}/text/generation?version=2024-01-29"
SQL_GEN_PROD_URL = f"{CLOUD_HOSTNAME}/ml/v1/deployments/{SQL_GEN_DEPLOYMENT_ID}/text/generation?version=2024-01-29"

# Headers for REST API request
PROD_HEADERS = {"Content-Type": "application/json", "accept": "application/json", "Authorization": f"Bearer {ACCESS_TOKEN}"}
```

### Provide a natural language question input

```python
nl_question = "Show me production cost of products in orders with quantity greater than 10"
```

Samples tested successfully with this notebook:
- "Show me production cost, unit sale price of order with quantity greater than 10"
- "Show me opening inventory, average cost and closing inventory with shipped quantity less than 5000"
- "Find order quantity and promotion code of products with top five gross margin"
- "Find base product with order unit sale price greater than 200 and inventory average unit cost less than 1000"
- "Find average gross margin of products with product language EN"

### Provide an JSON Database Schema

For this example, we're using a reduced version of the Gosales database with four tables: inventory_levels, products, product_name_lookup, order_details. We're using Gosales because it's an enterprise datase that is encoded in a JSON schema format.

```python
# JSON Database Schema
db_json_schema = json.loads('{"name": "GOSALES", "tables": {"inventory_levels": {"name": "inventory_levels", "columns": [{"name": "inventory_year", "type": "SMALLINT", "primary_key": true, "foreign_key": null, "value_samples": ["2007", "2004", "2005", "2006"]}, {"name": "inventory_month", "type": "SMALLINT", "primary_key": true, "foreign_key": null, "value_samples": ["9", "12", "11"]}, {"name": "warehouse_branch_code", "type": "INTEGER", "primary_key": true, "foreign_key": null, "value_samples": ["40", "28", "30"]}, {"name": "product_number", "type": "INTEGER", "primary_key": true, "foreign_key": ["product", "product_number"], "value_samples": ["125130", "122150", "149110"]}, {"name": "opening_inventory", "type": "INTEGER", "primary_key": false, "foreign_key": null, "value_samples": ["2", "2152", "2148"]}, {"name": "quantity_shipped", "type": "INTEGER", "primary_key": false, "foreign_key": null, "value_samples": ["2", "1999", "1928"]}, {"name": "additions", "type": "INTEGER", "primary_key": false, "foreign_key": null, "value_samples": ["1129", "1787", "1770"]}, {"name": "unit_cost", "type": "DECIMAL(19, 2)", "primary_key": false, "foreign_key": null, "value_samples": ["4.45", "5.03", "5.02"]}, {"name": "closing_inventory", "type": "INTEGER", "primary_key": false, "foreign_key": null, "value_samples": ["2", "2192", "2152"]}, {"name": "average_unit_cost", "type": "DECIMAL(19, 2)", "primary_key": false, "foreign_key": null, "value_samples": ["2.15", "2.75", "2.31"]}]}, "order_details": {"name": "order_details", "columns": [{"name": "order_detail_code", "type": "INTEGER", "primary_key": true, "foreign_key": null, "value_samples": ["1000001", "1000016", "1000015"]}, {"name": "order_number", "type": "INTEGER", "primary_key": false, "foreign_key": null, "value_samples": ["100015", "100073", "100072"]}, {"name": "ship_date", "type": "TIMESTAMP", "primary_key": false, "foreign_key": null, "value_samples": ["2004-03-05 00:00:00", "2004-08-06 00:00:00", "2004-08-04 00:00:00"]}, {"name": "product_number", "type": "INTEGER", "primary_key": false, "foreign_key": ["product", "product_number"], "value_samples": ["125130", "149110", "123130"]}, {"name": "promotion_code", "type": "INTEGER", "primary_key": false, "foreign_key": null, "value_samples": ["10203", "10223", "10213"]}, {"name": "quantity", "type": "INTEGER", "primary_key": false, "foreign_key": null, "value_samples": ["1532", "1777", "1771"]}, {"name": "unit_cost", "type": "DECIMAL(19, 2)", "primary_key": false, "foreign_key": null, "value_samples": ["43.73", "31.24", "73.96"]}, {"name": "unit_price", "type": "DECIMAL(19, 2)", "primary_key": false, "foreign_key": null, "value_samples": ["72.0", "98.0", "34.8"]}, {"name": "unit_sale_price", "type": "DECIMAL(19, 2)", "primary_key": false, "foreign_key": null, "value_samples": ["12.52", "96.44", "94.8"]}]}, "product": {"name": "product", "columns": [{"name": "product_number", "type": "INTEGER", "primary_key": true, "foreign_key": null, "value_samples": ["1110", "6110", "5110"]}, {"name": "base_product_number", "type": "INTEGER", "primary_key": false, "foreign_key": null, "value_samples": ["1", "6", "5"]}, {"name": "introduction_date", "type": "TIMESTAMP", "primary_key": false, "foreign_key": null, "value_samples": ["1999-06-12 00:00:00", "2004-01-15 00:00:00", "2004-01-13 00:00:00"]}, {"name": "discontinued_date", "type": "TIMESTAMP", "primary_key": false, "foreign_key": null, "value_samples": ["2005-02-28 00:00:00", "2006-05-31 00:00:00", "2006-03-31 00:00:00"]}, {"name": "product_type_code", "type": "INTEGER", "primary_key": false, "foreign_key": null, "value_samples": ["970", "956", "971"]}, {"name": "product_color_code", "type": "INTEGER", "primary_key": false, "foreign_key": null, "value_samples": ["900", "924", "921"]}, {"name": "product_size_code", "type": "INTEGER", "primary_key": false, "foreign_key": null, "value_samples": ["801", "812", "810"]}, {"name": "product_brand_code", "type": "INTEGER", "primary_key": false, "foreign_key": null, "value_samples": ["703", "714", "715"]}, {"name": "production_cost", "type": "DECIMAL(19, 2)", "primary_key": false, "foreign_key": null, "value_samples": ["1.0", "11.43", "9.22"]}, {"name": "gross_margin", "type": "DOUBLE", "primary_key": false, "foreign_key": null, "value_samples": ["0.3", "0.7", "0.41"]}, {"name": "product_image", "type": "VARCHAR(60)", "primary_key": false, "foreign_key": null, "value_samples": ["\'P01CE1CG1.jpg\'", "\'P06CE1CG1.jpg\'", "\'P05CE1CG1.jpg\'"]}]}, "product_name_lookup": {"name": "product_name_lookup", "columns": [{"name": "product_number", "type": "INTEGER", "primary_key": true, "foreign_key": ["product", "product_number"], "value_samples": ["1110", "6110", "5110"]}, {"name": "product_language", "type": "VARCHAR(30)", "primary_key": true, "foreign_key": null, "value_samples": ["\'CS\'", "\'ES\'", "\'EN\'"]}, {"name": "product_name", "type": "VARCHAR(150)", "primary_key": false, "foreign_key": null, "value_samples": ["\'\\"\\u0412\\u0435\\u0447\\u043d\\u044b\\u0439 \\u0441\\u0432\\u0435\\u0442\\" - \\u0411\\u0443\\u0442\\u0430\\u043d\\u043e\\u0432\\u044b\\u0439\'", "\'\\"\\u041c\\u0443\\u0445\\u043e-\\u0429\\u0438\\u0442\\" \\u0410\\u044d\\u0440\\u043e\\u0437\\u043e\\u043b\\u044c\'", "\'\\"\\u041c\\u0443\\u0445\\u043e-\\u0429\\u0438\\u0442\\" - \\u0421\\u0443\\u043f\\u0435\\u0440\'"]}, {"name": "product_description", "type": "VARCHAR(765)", "primary_key": false, "foreign_key": null, "value_samples": []}]}}}')
```

A portion of the Gosales JSON schema:

```python
print("\n".join(json.dumps(db_json_schema, indent=2).split("\n")[:30]))
```

    {
      "name": "GOSALES",
      "tables": {
        "inventory_levels": {
          "name": "inventory_levels",
          "columns": [
            {
              "name": "inventory_year",
              "type": "SMALLINT",
              "primary_key": true,
              "foreign_key": null,
              "value_samples": [
                "2007",
                "2004",
                "2005",
                "2006"
              ]
            },
            {
              "name": "inventory_month",
              "type": "SMALLINT",
              "primary_key": true,
              "foreign_key": null,
              "value_samples": [
                "9",
                "12",
                "11"
              ]
            },
            {


**Note:** To run this notebook with a new JSON Database schema, the input JSON Database schema must follow the following format.

To represent the schema, we assume a structure of following format:

```
{
  "name": <schema name>,
  "tables": {
        "1st_table_name": { "name": "table_name",
                            "columns": [
                                        {
                                          "name": "column name",
                                          "type": "column data type",
                                          "primary_key": "bool, true means this column is the primary key",
                                          "foreign_key": "null or [table name, column name], e.g ['customer','cst_id']"
                                        },
                                        ...
                                       ]
                           },
        ...
   }
}
```

## Create a prompt for the Schema Linking Model 
<a id="schemaprompt"></a>

Create a prompt for the Schema Linking model using the input JSON Database schema, the natural language question, and evidence if it exists. This is the first step in the Text2SQL pipeline.

```python
# Helper functions to parse the input JSON DB schema and create prompt for Schema Linking model
from typing import Union, List, Mapping, Dict, Tuple
def generate_table_representation(schema, linked_schema=None):
    col_indent = ' '
    table_dict = {}
    for tbl_name, tbl in schema["tables"].items():
        if linked_schema is not None and tbl_name not in linked_schema:
            continue
        start = 'CREATE TABLE '+ tbl_name + ' (\n'
        col_strs = []
        fk_strs = []
        col_num = 0
        for col in tbl["columns"]:
            if linked_schema is not None and col["name"] not in linked_schema[tbl_name]:
                continue
            col_num += 1
            col_str = f'{col_indent}{col["name"]}'
            col_str += f' {col["type"].upper()}'
            if col["primary_key"]:
                col_str += ' PRIMARY KEY'
            col_str += ','
            desc = ''
            if col.get("description", None):
                desc += col["description"] + '\n'
            if desc:
                desc = re.sub(r'\s*\n\s*', '\n', desc.strip())
                desc = desc.replace('\n', '\n-- ')
                col_str += ' -- ' + desc
            # TODO: other expansion info
            if col["foreign_key"]:
                fk_table, fk_col = col["foreign_key"]
                if linked_schema is None or (fk_table in linked_schema):
                    fk_strs.append(f'{col_indent}FOREIGN KEY({col["name"]}) REFERENCES {fk_table}({fk_col})')
            col_strs.append(col_str)
        assert len(col_strs) > 0
        col_strs.extend(fk_strs)
        tbl_str = start + '\n'.join(col_strs)+'\n);'
        lines = []
        for col in tbl["columns"]:
            if col["value_samples"]:
                lines.append(tbl["name"] + '.' + col["name"] + ': ' + ', '.join(col["value_samples"]))
            else:
                lines.append(tbl["name"] + '.' + col["name"])
        tbl_str += '\n\n' + '\n'.join(lines)
        table_dict[tbl_name] = tbl_str
    schema_str = '\n\n'.join(table_dict.values())
    return schema_str, table_dict

def qualified_column_list2dict(qual_cols: List[str]) -> Dict[str, List[str]]:
    linked_schema = {}
    for qual_col in qual_cols:
        try:
            qual_col = qual_col.strip()  #.lower()
            tbl, col = qual_col.split('.')[-2:]
            if tbl not in linked_schema:
                linked_schema[tbl] = []
            linked_schema[tbl].append(col)
        except:
            print(f"skipped {qual_col}")
    return linked_schema

def create_sl_prompt(question, schema, evidence: Union[List[str],str]=""):
    if isinstance(evidence, str):
        evidence = [evidence]
    evidence_str = '\n\nNote:\n' + '\n'.join(evidence)
    schema_str, _ = generate_table_representation(schema=schema)
    pre_question = evidence_str.strip() + '\n\nConsider:\n' + question + '\n\n'
    schema_link_query = pre_question + \
                        schema_str + \
                         evidence_str + \
                         '\n\nTo answer:\n' + \
                         question + \
                         '\nWe need columns:\n'
    return schema_link_query

```

Create a prompt for the Schema Linking model.

```python
sl_prompt = create_sl_prompt(question=nl_question, schema=db_json_schema)
```

Display the created prompt.

```python
print(sl_prompt)
```

    Note:
    
    Consider:
    Show me production cost of products in orders with quantity greater than 10
    
    CREATE TABLE inventory_levels (
     inventory_year SMALLINT PRIMARY KEY,
     inventory_month SMALLINT PRIMARY KEY,
     warehouse_branch_code INTEGER PRIMARY KEY,
     product_number INTEGER PRIMARY KEY,
     opening_inventory INTEGER,
     quantity_shipped INTEGER,
     additions INTEGER,
     unit_cost DECIMAL(19, 2),
     closing_inventory INTEGER,
     average_unit_cost DECIMAL(19, 2),
     FOREIGN KEY(product_number) REFERENCES product(product_number)
    );
    
    inventory_levels.inventory_year: 2007, 2004, 2005, 2006
    inventory_levels.inventory_month: 9, 12, 11
    inventory_levels.warehouse_branch_code: 40, 28, 30
    inventory_levels.product_number: 125130, 122150, 149110
    inventory_levels.opening_inventory: 2, 2152, 2148
    inventory_levels.quantity_shipped: 2, 1999, 1928
    inventory_levels.additions: 1129, 1787, 1770
    inventory_levels.unit_cost: 4.45, 5.03, 5.02
    inventory_levels.closing_inventory: 2, 2192, 2152
    inventory_levels.average_unit_cost: 2.15, 2.75, 2.31
    
    CREATE TABLE order_details (
     order_detail_code INTEGER PRIMARY KEY,
     order_number INTEGER,
     ship_date TIMESTAMP,
     product_number INTEGER,
     promotion_code INTEGER,
     quantity INTEGER,
     unit_cost DECIMAL(19, 2),
     unit_price DECIMAL(19, 2),
     unit_sale_price DECIMAL(19, 2),
     FOREIGN KEY(product_number) REFERENCES product(product_number)
    );
    
    order_details.order_detail_code: 1000001, 1000016, 1000015
    order_details.order_number: 100015, 100073, 100072
    order_details.ship_date: 2004-03-05 00:00:00, 2004-08-06 00:00:00, 2004-08-04 00:00:00
    order_details.product_number: 125130, 149110, 123130
    order_details.promotion_code: 10203, 10223, 10213
    order_details.quantity: 1532, 1777, 1771
    order_details.unit_cost: 43.73, 31.24, 73.96
    order_details.unit_price: 72.0, 98.0, 34.8
    order_details.unit_sale_price: 12.52, 96.44, 94.8
    
    CREATE TABLE product (
     product_number INTEGER PRIMARY KEY,
     base_product_number INTEGER,
     introduction_date TIMESTAMP,
     discontinued_date TIMESTAMP,
     product_type_code INTEGER,
     product_color_code INTEGER,
     product_size_code INTEGER,
     product_brand_code INTEGER,
     production_cost DECIMAL(19, 2),
     gross_margin DOUBLE,
     product_image VARCHAR(60),
    );
    
    product.product_number: 1110, 6110, 5110
    product.base_product_number: 1, 6, 5
    product.introduction_date: 1999-06-12 00:00:00, 2004-01-15 00:00:00, 2004-01-13 00:00:00
    product.discontinued_date: 2005-02-28 00:00:00, 2006-05-31 00:00:00, 2006-03-31 00:00:00
    product.product_type_code: 970, 956, 971
    product.product_color_code: 900, 924, 921
    product.product_size_code: 801, 812, 810
    product.product_brand_code: 703, 714, 715
    product.production_cost: 1.0, 11.43, 9.22
    product.gross_margin: 0.3, 0.7, 0.41
    product.product_image: 'P01CE1CG1.jpg', 'P06CE1CG1.jpg', 'P05CE1CG1.jpg'
    
    CREATE TABLE product_name_lookup (
     product_number INTEGER PRIMARY KEY,
     product_language VARCHAR(30) PRIMARY KEY,
     product_name VARCHAR(150),
     product_description VARCHAR(765),
     FOREIGN KEY(product_number) REFERENCES product(product_number)
    );
    
    product_name_lookup.product_number: 1110, 6110, 5110
    product_name_lookup.product_language: 'CS', 'ES', 'EN'
    product_name_lookup.product_name: '"Вечный свет" - Бутановый', '"Мухо-Щит" Аэрозоль', '"Мухо-Щит" - Супер'
    product_name_lookup.product_description
    
    Note:
    
    
    To answer:
    Show me production cost of products in orders with quantity greater than 10
    We need columns:
    


## Perform an inference on the Schema Linking model using the watsonx.ai endpoint
<a id="schemainference"></a>

Send a request to the Schema Linking model, generate outputs based on the provided configuration, and return the top-scoring outputs.

### Check SL Model Deployment

```python
# wait till deployment is up, should take a few minutes for each model
while not (is_deployment_ready(deploy_id=SL_DEPLOYMENT_ID, space_id=SPACE_ID, access_token=ACCESS_TOKEN)):
    pass
print("SL model deployment is ready!")
```

    SL model deployment is ready!


### Perform SL inference

```python
# Helper function to perform inference on Schema Linking model
import collections
def wxai_generate(payload, wxai_url, wxai_headers, num_samples=5, allow_duplicates=True, temperature_scaling=1.1, max_num_request=10):
    # generation params
    temperature = payload["parameters"].get('temperature', 1.0)
    all_outputs = []
    sample_strs = collections.Counter()
    num_request = 0
    while len(all_outputs) < num_samples and num_request < max_num_request:
        payload["parameters"]["temperature"] = temperature
        response = requests.post(wxai_url, headers=wxai_headers, json=payload, verify=True)
        if response.status_code != 200:
            raise ValueError(f"watsonx.ai model request failed, got code {response.status_code}, {response.json()}")

        is_added = False
        for res in response.json()['results']:
            if res["generated_text"] not in sample_strs or allow_duplicates:
                logprobs = [y.get("logprob", 0.0) for y in res["generated_tokens"]] # extract logprobs, if there is no logprob, set it to 0
                cumulative_logprob = sum(logprobs)
                score = cumulative_logprob / len(logprobs)
                all_outputs.append({"score": score, "text": res["generated_text"]})
                sample_strs[res["generated_text"]] += 1
                is_added = True

        # apply temperature scaling if we want more diverse output
        if not is_added:
            temperature = temperature*temperature_scaling
        num_request += 1

    all_outputs = sorted(all_outputs, key=lambda x: x["score"], reverse=True)
    return all_outputs      
```

Store the top-scoring outputs.

```python
scored_preds =collections.Counter()

all_valid_columns = []
for tbl_name, tbl in db_json_schema["tables"].items():
    for col in tbl["columns"]:
        all_valid_columns.append(f'{tbl_name}.{col["name"]}')

# sl inference
sl_inference_payload = {
    "input": sl_prompt,
    "parameters": {
        "decoding_method": "sample",
        "max_new_tokens": 300,
        "temperature": 1.0,
        "return_options": {"generated_tokens": True, "token_logprobs": True}
    }
}
all_sl_outputs = wxai_generate(payload=sl_inference_payload, wxai_url=SL_PROD_URL, wxai_headers=PROD_HEADERS, num_samples=5)

```

```python
all_sl_outputs
```




    [{'score': -0.015094118463691152,
      'text': 'order_details.product_number, order_details.quantity, product.product_number, product.production_cost'},
     {'score': -0.015094118463691152,
      'text': 'order_details.product_number, order_details.quantity, product.product_number, product.production_cost'},
     {'score': -0.015094118463691152,
      'text': 'order_details.product_number, order_details.quantity, product.product_number, product.production_cost'},
     {'score': -0.015094118463691152,
      'text': 'order_details.product_number, order_details.quantity, product.product_number, product.production_cost'},
     {'score': -0.22286841453048314,
      'text': 'inventory_levels.product_number, order_details.order_number, order_details.product_number, order_details.quantity, product.product_number, product.production_cost'}]



## Post the process of the Schema Linking model output
<a id="schemapost"></a>

Filter and organize information from the outputs into a set of tables and a dictionary in a formatted JSON format.

```python
from typing import Tuple
def filter_generative_schema_links(
                            schema_linker_output_dict: Dict[str, float]=None,
                            threshold: float = 1.0,
                            schema_top_k_min: int = 3, 
                            schema_top_k_max: int = 30,
                        ) -> Tuple[List, List, List]:
    # Note that this method can change the qualified table list
    schema_linker_output = []  #List[Tuple[str, float]]
    for k, v in schema_linker_output_dict.items():
        schema_linker_output.append((k, v))
        
    schema_linker_output.sort(key=lambda x: x[1], reverse=True)
    # links above threshold or at least top_k_min, but at most top_k_max
    schema_links_filtered = [qc for qc, score in schema_linker_output if score >= threshold]
    score_filtered = [score for qc, score in schema_linker_output if score >= threshold]
    
    # filter column
    if len(schema_links_filtered) < schema_top_k_min:
        schema_links_filtered = [qc for qc, score in schema_linker_output][:schema_top_k_min]
        score_filtered = [score for qc, score in schema_linker_output][:schema_top_k_min]
    elif len(schema_links_filtered) > schema_top_k_max:
        schema_links_filtered = schema_links_filtered[:schema_top_k_max]
        score_filtered = score_filtered[:schema_top_k_max]
    
    # re-create qualified tables
    qualified_tables_set = set() 
    for col in schema_links_filtered:
        table_name = col.split(".")[-2]
        qualified_tables_set.add(table_name)
    
    return schema_links_filtered, score_filtered, sorted(list(qualified_tables_set))

def process_generative_sl_api_outputs(col_predictions, threshold=1, schema_name=None):
    schema_links_filtered, score_filtered, _ = filter_generative_schema_links(
                                                                                schema_linker_output_dict=col_predictions,
                                                                                threshold=threshold
                                                                            )
    return {k:v for k,v in zip(schema_links_filtered, score_filtered)}
```

```python
for sample in all_sl_outputs:
    sample_preds = set([p.strip() for p in sample['text'].split(',')])
    for sp in sample_preds:
        if sp in all_valid_columns:
            scored_preds[sp] += 1
            

col_predictions = {}
for vc in all_valid_columns:
    col_predictions[vc] = scored_preds[vc] if vc in scored_preds else -10

col_predictions_sorted = {k: v for k, v in sorted(col_predictions.items(), key=lambda item: item[1], reverse=True)}
print("\n".join(json.dumps(col_predictions_sorted, indent=2).split("\n")[:30]))
```

    {
      "order_details.product_number": 5,
      "order_details.quantity": 5,
      "product.product_number": 5,
      "product.production_cost": 5,
      "inventory_levels.product_number": 1,
      "order_details.order_number": 1,
      "inventory_levels.inventory_year": -10,
      "inventory_levels.inventory_month": -10,
      "inventory_levels.warehouse_branch_code": -10,
      "inventory_levels.opening_inventory": -10,
      "inventory_levels.quantity_shipped": -10,
      "inventory_levels.additions": -10,
      "inventory_levels.unit_cost": -10,
      "inventory_levels.closing_inventory": -10,
      "inventory_levels.average_unit_cost": -10,
      "order_details.order_detail_code": -10,
      "order_details.ship_date": -10,
      "order_details.promotion_code": -10,
      "order_details.unit_cost": -10,
      "order_details.unit_price": -10,
      "order_details.unit_sale_price": -10,
      "product.base_product_number": -10,
      "product.introduction_date": -10,
      "product.discontinued_date": -10,
      "product.product_type_code": -10,
      "product.product_color_code": -10,
      "product.product_size_code": -10,
      "product.product_brand_code": -10,
      "product.gross_margin": -10,


```python
col_predictions = process_generative_sl_api_outputs(col_predictions=col_predictions)
```

Create a `qualified_columns` list that contains the names of all columns that have been predicted and scored by the schema linker.

```python
qualified_columns = list(col_predictions.keys())
```

## Create a prompt for the SQL Generation model 
<a id="sqlprompt"></a>

Create a prompt for the SQL Generation model using the input JSON Database schema, the natural language question, and evidence if it exists. This is the second step in the Text2SQL pipeline. 

```python
def create_sql_gen_prompt(question, schema, evidence: Union[List[str],str]="", qualified_columns:List[str]=None):
    if isinstance(evidence, str):
        evidence = [evidence]
    evidence_str = 'Note:\n' + '\n'.join(evidence)
    linked_schema = None
    if qualified_columns is not None:
        if not isinstance(qualified_columns, Mapping):
            linked_schema = qualified_column_list2dict(qualified_columns)
    schema_str, _ = generate_table_representation(schema=schema, linked_schema=linked_schema)
    pre_question = evidence_str + question + '\n\n'
    return pre_question + schema_str + '\n\n' + evidence_str + question + '\nGenerate SQL:'
```

```python
sql_gen_prompt = create_sql_gen_prompt(question=nl_question, schema=db_json_schema, qualified_columns=qualified_columns)
```

```python
print(sql_gen_prompt)
```

    Note:
    Show me production cost of products in orders with quantity greater than 10
    
    CREATE TABLE inventory_levels (
     product_number INTEGER PRIMARY KEY,
     FOREIGN KEY(product_number) REFERENCES product(product_number)
    );
    
    inventory_levels.inventory_year: 2007, 2004, 2005, 2006
    inventory_levels.inventory_month: 9, 12, 11
    inventory_levels.warehouse_branch_code: 40, 28, 30
    inventory_levels.product_number: 125130, 122150, 149110
    inventory_levels.opening_inventory: 2, 2152, 2148
    inventory_levels.quantity_shipped: 2, 1999, 1928
    inventory_levels.additions: 1129, 1787, 1770
    inventory_levels.unit_cost: 4.45, 5.03, 5.02
    inventory_levels.closing_inventory: 2, 2192, 2152
    inventory_levels.average_unit_cost: 2.15, 2.75, 2.31
    
    CREATE TABLE order_details (
     order_number INTEGER,
     product_number INTEGER,
     quantity INTEGER,
     FOREIGN KEY(product_number) REFERENCES product(product_number)
    );
    
    order_details.order_detail_code: 1000001, 1000016, 1000015
    order_details.order_number: 100015, 100073, 100072
    order_details.ship_date: 2004-03-05 00:00:00, 2004-08-06 00:00:00, 2004-08-04 00:00:00
    order_details.product_number: 125130, 149110, 123130
    order_details.promotion_code: 10203, 10223, 10213
    order_details.quantity: 1532, 1777, 1771
    order_details.unit_cost: 43.73, 31.24, 73.96
    order_details.unit_price: 72.0, 98.0, 34.8
    order_details.unit_sale_price: 12.52, 96.44, 94.8
    
    CREATE TABLE product (
     product_number INTEGER PRIMARY KEY,
     production_cost DECIMAL(19, 2),
    );
    
    product.product_number: 1110, 6110, 5110
    product.base_product_number: 1, 6, 5
    product.introduction_date: 1999-06-12 00:00:00, 2004-01-15 00:00:00, 2004-01-13 00:00:00
    product.discontinued_date: 2005-02-28 00:00:00, 2006-05-31 00:00:00, 2006-03-31 00:00:00
    product.product_type_code: 970, 956, 971
    product.product_color_code: 900, 924, 921
    product.product_size_code: 801, 812, 810
    product.product_brand_code: 703, 714, 715
    product.production_cost: 1.0, 11.43, 9.22
    product.gross_margin: 0.3, 0.7, 0.41
    product.product_image: 'P01CE1CG1.jpg', 'P06CE1CG1.jpg', 'P05CE1CG1.jpg'
    
    Note:
    Show me production cost of products in orders with quantity greater than 10
    Generate SQL:


### Check SQL Gen Model Deployment

```python
# wait till deployment is up, should take a few minutes for each model
while not (is_deployment_ready(deploy_id=SQL_GEN_DEPLOYMENT_ID, space_id=SPACE_ID, access_token=ACCESS_TOKEN)):
    pass
print("SQL gen model deployment is ready!")
```

    SQL gen model deployment is ready!


## Perform an inference on the SQL Generation model using the watsonx.ai endpoint
<a id="sqlinference"></a>

Generate three unique SQL queries based on the prompt string and store the outputs.

```python
# sql gen inference
sql_gen_inference_payload = {
    "input": sql_gen_prompt,
    "parameters": {
        "decoding_method": "sample",
        "max_new_tokens": 300,
        "temperature": 1.0,
        "return_options": {"generated_tokens": True, "token_logprobs": True}
    }
}

all_sql_gen_outputs = wxai_generate(payload=sql_gen_inference_payload, wxai_url=SQL_GEN_PROD_URL, wxai_headers=PROD_HEADERS, num_samples=3, allow_duplicates=False)
```

```python
all_sql_gen_outputs
```




    [{'score': -0.02310277242189,
      'text': ' SELECT product.production_cost FROM order_details JOIN product ON order_details.product_number = product.product_number WHERE order_details.quantity > 10'},
     {'score': -0.05095982284078461,
      'text': ' SELECT product.production_cost FROM product JOIN order_details ON product.product_number = order_details.product_number WHERE order_details.quantity > 10'},
     {'score': -0.09621994493760405,
      'text': ' SELECT product.production_cost FROM order_details JOIN product ON product.product_number = order_details.product_number WHERE order_details.quantity > 10'}]



# Delete deployment

```python
get_deployment_info(deploy_id=SL_DEPLOYMENT_ID, space_id=SPACE_ID, access_token=ACCESS_TOKEN)
```




    {'entity': {'asset': {'id': 'deee5205-9cf0-41f8-9826-7cdb5d2d5393'},
      'base_model_id': 'ibm/granite-20b-code-base-schema-linking-curated',
      'custom': {},
      'deployed_asset_type': 'curated_foundation_model',
      'hardware_request': {'num_nodes': 1, 'size': 'gpu_s'},
      'name': 'schema-linking-deployment',
      'online': {'parameters': {'serving_name': 'granite20b_schema_linking'}},
      'space_id': '21b7ac7b-fd1f-4a97-9927-65121d937dae',
      'status': {'inference': [{'url': 'https://us-south.ml.cloud.ibm.com/ml/v1/deployments/granite20b_schema_linking/text/generation',
         'uses_serving_name': True},
        {'sse': True,
         'url': 'https://us-south.ml.cloud.ibm.com/ml/v1/deployments/granite20b_schema_linking/text/generation_stream',
         'uses_serving_name': True},
        {'url': 'https://us-south.ml.cloud.ibm.com/ml/v1/deployments/f95334ab-25f1-42dd-a506-5e0a7157edbc/text/generation'},
        {'sse': True,
         'url': 'https://us-south.ml.cloud.ibm.com/ml/v1/deployments/f95334ab-25f1-42dd-a506-5e0a7157edbc/text/generation_stream'}],
       'serving_urls': ['https://us-south.ml.cloud.ibm.com/ml/v1/deployments/f95334ab-25f1-42dd-a506-5e0a7157edbc/text/generation',
        'https://us-south.ml.cloud.ibm.com/ml/v1/deployments/f95334ab-25f1-42dd-a506-5e0a7157edbc/text/generation_stream',
        'https://us-south.ml.cloud.ibm.com/ml/v1/deployments/granite20b_schema_linking/text/generation',
        'https://us-south.ml.cloud.ibm.com/ml/v1/deployments/granite20b_schema_linking/text/generation_stream'],
       'state': 'ready'}},
     'metadata': {'created_at': '2024-12-10T18:34:26.035Z',
      'id': 'f95334ab-25f1-42dd-a506-5e0a7157edbc',
      'modified_at': '2024-12-10T18:34:26.035Z',
      'name': 'schema-linking-deployment',
      'owner': 'IBMid-6630033MST',
      'space_id': '21b7ac7b-fd1f-4a97-9927-65121d937dae'}}



```python
get_deployment_info(deploy_id=SQL_GEN_DEPLOYMENT_ID, space_id=SPACE_ID, access_token=ACCESS_TOKEN)
```




    {'entity': {'asset': {'id': 'f6af013a-4645-42c4-b9d6-1dcd39fa0f5c'},
      'base_model_id': 'ibm/granite-20b-code-base-sql-gen-curated',
      'custom': {},
      'deployed_asset_type': 'curated_foundation_model',
      'hardware_request': {'num_nodes': 1, 'size': 'gpu_s'},
      'name': 'sql-gen-deployment',
      'online': {'parameters': {'serving_name': 'granite_20b_sql_gen'}},
      'space_id': '21b7ac7b-fd1f-4a97-9927-65121d937dae',
      'status': {'inference': [{'url': 'https://us-south.ml.cloud.ibm.com/ml/v1/deployments/granite_20b_sql_gen/text/generation',
         'uses_serving_name': True},
        {'sse': True,
         'url': 'https://us-south.ml.cloud.ibm.com/ml/v1/deployments/granite_20b_sql_gen/text/generation_stream',
         'uses_serving_name': True},
        {'url': 'https://us-south.ml.cloud.ibm.com/ml/v1/deployments/a87bf110-2ea6-42ad-971d-d7d28788c358/text/generation'},
        {'sse': True,
         'url': 'https://us-south.ml.cloud.ibm.com/ml/v1/deployments/a87bf110-2ea6-42ad-971d-d7d28788c358/text/generation_stream'}],
       'serving_urls': ['https://us-south.ml.cloud.ibm.com/ml/v1/deployments/a87bf110-2ea6-42ad-971d-d7d28788c358/text/generation',
        'https://us-south.ml.cloud.ibm.com/ml/v1/deployments/a87bf110-2ea6-42ad-971d-d7d28788c358/text/generation_stream',
        'https://us-south.ml.cloud.ibm.com/ml/v1/deployments/granite_20b_sql_gen/text/generation',
        'https://us-south.ml.cloud.ibm.com/ml/v1/deployments/granite_20b_sql_gen/text/generation_stream'],
       'state': 'ready'}},
     'metadata': {'created_at': '2024-12-10T18:34:27.935Z',
      'id': 'a87bf110-2ea6-42ad-971d-d7d28788c358',
      'modified_at': '2024-12-10T18:34:27.935Z',
      'name': 'sql-gen-deployment',
      'owner': 'IBMid-6630033MST',
      'space_id': '21b7ac7b-fd1f-4a97-9927-65121d937dae'}}



```python
# delete 2 deployments
delete_deployment(deploy_id=SL_DEPLOYMENT_ID, space_id=SPACE_ID, access_token=ACCESS_TOKEN)
delete_deployment(deploy_id=SQL_GEN_DEPLOYMENT_ID, space_id=SPACE_ID, access_token=ACCESS_TOKEN)
```

```python
get_deployment_info(deploy_id=SL_DEPLOYMENT_ID, space_id=SPACE_ID, access_token=ACCESS_TOKEN)
```




    {'trace': 'ca13682a8ef1df103aa8e3fdc5f30147',
     'errors': [{'code': 'deployment_does_not_exist',
       'message': "Deployment with id 'f95334ab-25f1-42dd-a506-5e0a7157edbc' does not exist. Re-try with a valid deployment id."}]}



```python
get_deployment_info(deploy_id=SQL_GEN_DEPLOYMENT_ID, space_id=SPACE_ID, access_token=ACCESS_TOKEN)
```




    {'trace': '98981c3fd5310682aaa10d4ac82cdced',
     'errors': [{'code': 'deployment_does_not_exist',
       'message': "Deployment with id 'a87bf110-2ea6-42ad-971d-d7d28788c358' does not exist. Re-try with a valid deployment id."}]}



## Summary

Congratulations, you completed this notebook! You learned how to work with the two Text2SQL pipeline components, the Schema Linking model (SL) and SQL Generation model (SQL Gen).

## Authors

- **Long Vu** lhvu@us.ibm.com
- **Nhan Pham** nhp@ibm.com
- **Michael Glass** mrglass@us.ibm.com
- **Shankar Subramanian** dharmash@us.ibm.com

IBM TJ Watson Research Center, New York, United States of America

Copyright © 2024 IBM. This notebook and its source code are released under the terms of the MIT License.
