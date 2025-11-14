# watsonx Orchestrate: Enterprise Agent Platform {data-background-color="#1e3a8a"}

::: notes
Comprehensive workshop on building production-grade AI agents with watsonx Orchestrate Agent Developer Kit (ADK).
:::

---

### Tutor

**Ruslan Idelfonso Magana Vsevolodovna**  
*PhD in Physics · AI Engineer*  

📧 [contact@ruslamv.com](mailto:contact@ruslamv.com)

<p style="text-align:right; margin-top:1.5rem;">
  <img
    src="https://raw.githubusercontent.com/ruslanmv/watsonx-workshop/refs/heads/master/themes/assets/tutor.png"
    alt="Tutor: Ruslan Idelfonso Magana Vsevolodovna"
    style="
      border-radius:50%;
      width:130px;
      height:130px;
      object-fit:cover;
      box-shadow:0 12px 30px rgba(0,0,0,0.45);
      border:3px solid rgba(248,250,252,0.9);
    "
  >
</p>

---



## Table of Contents {data-transition="slide"}

<div class="fragment">

1. Environment Setup
2. Introduction to AI Agents
3. Building Your First Agent
4. Creating Python Tools
5. Connections & Integration

</div>

<div class="fragment">

6. Knowledge Bases
7. Flow Builder
8. Multi-Agent Systems
9. Agent Protocols (MCP & A2A)
10. Production Deployment

</div>

::: notes
This comprehensive workshop covers everything from basics to production deployment.
:::

---

## 1. Environment Setup {data-background-color="#064e3b"}

### Prerequisites

<div class="fragment">

- Python 3.9 or higher
- Docker Desktop installed and running
- IBM Cloud account (for production deployment)

</div>

::: notes
Ensure all prerequisites are met before starting the installation.
:::

---

## Install the ADK {data-transition="fade"}

### Installation Command

```bash
pip install ibm-watsonx-orchestrate
```

<div class="fragment">

### Verify Installation

```bash
orchestrate --version
```

</div>

::: notes
The ADK provides command-line tools for managing agents, tools, and connections.
:::

---

## Configure Environment {data-transition="slide"}

### Create Environment File

```bash
# .env file
WATSONX_API_KEY=your_watsonx_api_key
WATSONX_PROJECT_ID=your_project_id
WATSONX_URL=https://us-south.ml.cloud.ibm.com

# Optional: Skip login for Developer Edition
WO_DEVELOPER_EDITION_SKIP_LOGIN=true
```

::: notes
Store credentials securely in an environment file, never hardcode them.
:::

---

## Start Developer Edition {data-transition="fade"}

### Launch watsonx Orchestrate

```bash
orchestrate server start \
  --env-file .env \
  --accept-terms-and-conditions
```

<div class="fragment">

### Available Services

- **API Base URL**: `http://localhost:4321/api/v1`
- **OpenAPI Docs**: `http://localhost:4321/docs`
- **UI**: `http://localhost:3000`

</div>

::: notes
The Developer Edition runs locally in Docker containers.
:::

---

## Configure Environment {data-transition="slide"}

### Activate Local Environment

```bash
orchestrate env activate local
```

<div class="fragment">

### Add Remote Environment (Optional)

```bash
# Add IBM Cloud environment
orchestrate env add \
  -n production \
  -u https://your-instance-url.com

# Activate remote environment
orchestrate env activate production \
  --api-key your-api-key
```

</div>

::: notes
You can work with multiple environments: local for development, remote for production.
:::

---

## 2. Introduction to AI Agents {data-background-color="#7c2d12"}

### What is an AI Agent?

<div class="fragment">

An AI agent is an **autonomous application** that can:

- **Understand** user requests
- **Plan** sequences of actions
- **Execute** tasks using LLMs
- **Interface** with tools, models, and IT systems

</div>

::: notes
Agents go beyond simple question-answering to perform complex, multi-step tasks.
:::

---

## Core Agent Components {data-transition="fade"}

<div class="fragment">

### 1. LLM
The language model powering the agent's reasoning

</div>

<div class="fragment">

### 2. Style
Prompting structure:
- **Default**: Standard prompt-response
- **ReAct**: Reason, Act, Observe cycles
- **Plan-Act**: Plan first, then execute

</div>

<div class="fragment">

### 3. Instructions
Natural language guidance for agent behavior

</div>

::: notes
These components define how the agent thinks and behaves.
:::

---

## Core Agent Components (Continued) {data-transition="fade"}

<div class="fragment">

### 4. Tools
Functions the agent can execute

</div>

<div class="fragment">

### 5. Collaborators
Other agents it can work with

</div>

<div class="fragment">

### 6. Knowledge Base
Domain-specific information for RAG

</div>

::: notes
Tools, collaborators, and knowledge bases extend the agent's capabilities.
:::

---

## 3. Building Your First Agent {data-background-color="#1e3a8a"}

### Lab 1: Hello World Agent

**Objective**: Create a simple agent that responds to greetings

::: notes
Let's start with the simplest possible agent.
:::

---

## Create Agent YAML File {data-transition="slide"}

### hello-world-agent.yaml

```yaml
spec_version: v1
kind: native
name: Hello_World_Agent
description: A simple Hello World agent for testing
instructions: |
  You are a test agent created for a tutorial on how to
  get started with watsonx Orchestrate ADK.
  When the user asks 'who are you', respond with:
  "I'm the Hello World Agent. Congratulations on
   completing the Getting Started tutorial!"
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: default
collaborators: []
tools: []
```

::: notes
YAML format makes agents declarative and version-controllable.
:::

---

## Import the Agent {data-transition="fade"}

### Import Command

```bash
orchestrate agents import -f hello-world-agent.yaml
```

<div class="fragment">

### Expected Output

```text
✓ Agent 'Hello_World_Agent' imported successfully
```

</div>

::: notes
The import command validates and registers the agent.
:::

---

## Test the Agent {data-transition="fade"}

### Start Chat Interface

```bash
orchestrate chat start
```

<div class="fragment">

### Test Query

```text
who are you?
```

### Expected Response

```text
I'm the Hello World Agent. Congratulations on
completing the Getting Started tutorial!
```

</div>

::: notes
The chat interface lets you test agents interactively.
:::

---

## Lab 2: Weather Agent with Tools {data-background-color="#581c87"}

**Objective**: Create an agent that provides weather information using an external API

::: notes
Now let's add tools to give the agent real capabilities.
:::

---

## Create Weather Tool {data-transition="slide"}

### weather_tool.py

```python
from ibm_watsonx_orchestrate.agent_builder.tools import tool
import requests

@tool(
    name="get_weather",
    description="Get current weather for a given city"
)
def get_weather(city: str) -> str:
    """
    Retrieves current weather information.

    Args:
        city (str): The name of the city

    Returns:
        str: Weather information as a formatted string
    """
    api_key = "your_openweather_api_key"
    base_url = "http://api.openweathermap.org/data/2.5/weather"
```

::: notes
The @tool decorator makes any Python function available to agents.
:::

---

## Weather Tool Implementation {data-transition="fade"}

```python
    params = {
        "q": city,
        "appid": api_key,
        "units": "metric"
    }

    try:
        response = requests.get(base_url, params=params)
        response.raise_for_status()
        data = response.json()

        temp = data['main']['temp']
        description = data['weather'][0]['description']

        return f"The current weather in {city} is " \
               f"{description} with a temperature of {temp}°C."
    except Exception as e:
        return f"Sorry, I couldn't fetch the weather " \
               f"for {city}. Error: {str(e)}"
```

::: notes
Always include error handling in tools for robustness.
:::

---

## Import the Tool {data-transition="slide"}

### Import Command

```bash
orchestrate tools import -k python -f weather_tool.py
```

::: notes
Tools are imported separately and can be reused across multiple agents.
:::

---

## Create Weather Agent {data-transition="fade"}

### weather-agent.yaml

```yaml
spec_version: v1
kind: native
name: Weather_Agent
description: Provides current weather information
instructions: |
  You are a helpful weather assistant. When users
  ask about weather in a city:
  1. Use the get_weather tool to fetch conditions
  2. Present info in a friendly manner
  3. If city not found, politely ask for clarification
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: react
tools:
  - get_weather
```

::: notes
The react style enables the agent to reason about when to use tools.
:::

---

## Test Weather Agent {data-transition="fade"}

### Import and Test

```bash
orchestrate agents import -f weather-agent.yaml
orchestrate chat start
```

<div class="fragment">

### Test Query

```text
What's the weather in Paris?
```

</div>

::: notes
The agent will automatically call the weather tool and format the response.
:::

---

## 4. Creating Python Tools {data-background-color="#064e3b"}

### Lab 3: Advanced Python Tool with Connections

**Objective**: Create a tool that uses secure connections to external APIs

::: notes
Learn to integrate tools with external services securely.
:::

---

## Connection Configuration {data-transition="slide"}

### github-connection.yaml

```yaml
spec_version: v1
kind: connection
app_id: github_api
environments:
  draft:
    kind: bearer
    type: bearer_token
  live:
    kind: bearer
    type: bearer_token
```

::: notes
Connections abstract credential management from tool code.
:::

---

## Import Connection {data-transition="fade"}

### Import and Set Credentials

```bash
# Import connection configuration
orchestrate connections import -f github-connection.yaml

# Set credentials
orchestrate connections set-credentials \
  --app-id github_api \
  --env draft \
  --token your_github_personal_access_token
```

::: notes
Credentials are stored securely and never appear in code.
:::

---

## Create GitHub Tool {data-transition="slide"}

### github_tool.py

```python
from ibm_watsonx_orchestrate.agent_builder.tools import tool
from ibm_watsonx_orchestrate.agent_builder.connections import \
    ConnectionType
from ibm_watsonx_orchestrate.run import connections
import requests

@tool(
    name="search_github_repos",
    description="Search for GitHub repositories by keyword",
    expected_credentials=[
        {"app_id": "github_api",
         "type": ConnectionType.BEARER_TOKEN}
    ]
)
def search_github_repos(query: str,
                       max_results: int = 5) -> str:
    """Search GitHub repositories."""
```

::: notes
The expected_credentials parameter declares what connections the tool needs.
:::

---

## GitHub Tool Implementation {data-transition="fade"}

```python
    creds = connections.bearer_token("github_api")

    headers = {
        "Authorization": f"Bearer {creds.token}",
        "Accept": "application/vnd.github.v3+json"
    }

    url = "https://api.github.com/search/repositories"
    params = {
        "q": query,
        "sort": "stars",
        "order": "desc",
        "per_page": max_results
    }

    try:
        response = requests.get(url,
                              headers=headers,
                              params=params)
        response.raise_for_status()
        data = response.json()
```

::: notes
The connections API provides credentials at runtime.
:::

---

## GitHub Tool Response {data-transition="fade"}

```python
        results = []
        for repo in data['items'][:max_results]:
            results.append(
                f"- {repo['full_name']}: "
                f"{repo['description']} "
                f"(⭐ {repo['stargazers_count']})"
            )

        return "\n".join(results)
    except Exception as e:
        return f"Error searching repositories: {str(e)}"
```

::: notes
Format results clearly for the agent to present to users.
:::

---

## Import Tool with Connection {data-transition="fade"}

### Import Command

```bash
orchestrate tools import \
  -k python \
  -f github_tool.py \
  -a github_api
```

::: notes
Link the tool to its required connection during import.
:::

---

## 5. Connections & Integration {data-background-color="#7c2d12"}

### Lab 4: Multiple Connection Types

::: notes
watsonx Orchestrate supports various authentication patterns.
:::

---

## API Key Connection {data-transition="slide"}

### api-key-connection.yaml

```yaml
spec_version: v1
kind: connection
app_id: my_api_service
environments:
  draft:
    kind: api_key
    type: api_key_auth
```

<div class="fragment">

### Set Credentials

```bash
orchestrate connections set-credentials \
  --app-id my_api_service \
  --env draft \
  --api-key your_api_key \
  --url https://api.example.com
```

</div>

::: notes
API key auth is the simplest connection type.
:::

---

## OAuth Connection {data-transition="fade"}

### oauth-connection.yaml

```yaml
spec_version: v1
kind: connection
app_id: salesforce
environments:
  draft:
    kind: oauth_auth_code_flow
    type: oauth_auth_code_flow
    oauth_config:
      client_id: your_client_id
      client_secret: your_client_secret
      authorization_url: https://login.salesforce.com/
        services/oauth2/authorize
      token_url: https://login.salesforce.com/
        services/oauth2/token
      scope: api refresh_token
```

::: notes
OAuth enables secure integration with enterprise services.
:::

---

## Key-Value Connection {data-transition="fade"}

### kv-connection.yaml

```yaml
spec_version: v1
kind: connection
app_id: custom_service
environments:
  draft:
    kind: key_value
    type: key_value
```

<div class="fragment">

### Set Multiple Credentials

```bash
orchestrate connections set-credentials \
  --app-id custom_service \
  --env draft \
  --key api_key --value your_key \
  --key api_secret --value your_secret \
  --key base_url --value https://api.example.com
```

</div>

::: notes
Key-value connections support multiple credential fields.
:::

---

## 6. Knowledge Bases {data-background-color="#1e3a8a"}

### Lab 5: Create Knowledge Base with RAG

**Objective**: Build an agent that answers questions from uploaded documents

::: notes
Knowledge bases enable RAG within watsonx Orchestrate.
:::

---

## Create Knowledge Base YAML {data-transition="slide"}

### company_kb.yaml

```yaml
spec_version: v1
kind: knowledge_base
name: company_policies
description: Company policies and procedures documentation
documents:
  - ./docs/employee_handbook.pdf
  - ./docs/it_policies.pdf
  - ./docs/hr_guidelines.pdf
conversational_search_tool:
  generation:
    prompt_instruction: "Provide accurate answers based
      on company policies. If unsure, say so."
    max_docs_passed_to_llm: 5
    generated_response_length: Moderate
    idk_message: "I don't have information about
      that in the company policies."
```

::: notes
Knowledge bases can include multiple document types.
:::

---

## Knowledge Base Configuration {data-transition="fade"}

```yaml
  confidence_thresholds:
    retrieval_confidence_threshold: Low
    response_confidence_threshold: Low
  query_rewrite:
    enabled: true
  citations:
    citations_shown: 3
```

::: notes
Configure thresholds and citation behavior for RAG responses.
:::

---

## Import Knowledge Base {data-transition="slide"}

### Import Command

```bash
orchestrate knowledge-bases import -f company_kb.yaml
```

::: notes
Documents are processed, chunked, embedded, and indexed automatically.
:::

---

## Create Agent with Knowledge Base {data-transition="fade"}

### hr-agent.yaml

```yaml
spec_version: v1
kind: native
name: HR_Assistant
description: HR assistant for company policies
instructions: |
  You are an HR assistant. Use the company_policies
  knowledge base to answer questions about:
  - Employee benefits
  - Leave policies
  - IT guidelines
  - Company procedures

  Always cite your sources and be accurate.
  If you're unsure, say so.
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: default
knowledge_base: company_policies
```

::: notes
Agents automatically get a conversational search tool from the knowledge base.
:::

---

## Test HR Agent {data-transition="fade"}

### Import and Test

```bash
orchestrate agents import -f hr-agent.yaml
orchestrate chat start
```

<div class="fragment">

### Test Query

```text
What is the company's vacation policy?
```

</div>

::: notes
The agent will retrieve relevant policy documents and answer based on them.
:::

---

## 7. Flow Builder {data-background-color="#581c87"}

### Lab 6: Company Information Flow

**Objective**: Create a flow that validates company names and returns information

::: notes
The planner style enables multi-step workflows.
:::

---

## Create Validation Tools {data-transition="slide"}

### company_validator.py

```python
from ibm_watsonx_orchestrate.agent_builder.tools import tool

@tool(
    name="validate_company",
    description="Check if a company exists in our database"
)
def validate_company(company_name: str) -> dict:
    """
    Validate if a company exists.

    Args:
        company_name (str): Name of the company

    Returns:
        dict: Validation result with company info
    """
    companies = {
        "IBM": {
            "exists": True,
            "founded": 1911,
            "industry": "Technology",
            "headquarters": "Armonk, NY"
        },
```

::: notes
Create tools that work together in a workflow.
:::

---

## Validation Tool Implementation {data-transition="fade"}

```python
        "Microsoft": {
            "exists": True,
            "founded": 1975,
            "industry": "Technology",
            "headquarters": "Redmond, WA"
        }
    }

    company_info = companies.get(company_name,
                                 {"exists": False})

    return {
        "company_name": company_name,
        **company_info
    }
```

::: notes
Return structured data that agents can use in decision-making.
:::

---

## Create Fact Tool {data-transition="slide"}

```python
@tool(
    name="get_company_fact",
    description="Get an interesting fact about a company"
)
def get_company_fact(company_name: str) -> str:
    """
    Get an interesting fact about a company.

    Args:
        company_name (str): Name of the company

    Returns:
        str: Interesting fact
    """
    facts = {
        "IBM": "IBM holds more patents than any other "
               "U.S. technology company.",
        "Microsoft": "Microsoft's original name was "
                    "'Micro-Soft' (with a hyphen)."
    }

    return facts.get(company_name,
                    f"No facts available for {company_name}")
```

::: notes
Multiple specialized tools enable complex workflows.
:::

---

## Import Tools {data-transition="fade"}

### Import Command

```bash
orchestrate tools import -k python -f company_validator.py
```

::: notes
Both tools are defined in the same file for convenience.
:::

---

## Create Flow-Based Agent {data-transition="slide"}

### company-info-agent.yaml

```yaml
spec_version: v1
kind: native
name: Company_Info_Agent
description: Provides information about companies
instructions: |
  When a user asks about a company:
  1. First, validate the company exists using
     validate_company tool
  2. If the company exists, provide the basic information
  3. Then use get_company_fact to share an
     interesting fact
  4. If the company doesn't exist, politely inform
     the user

  Always be helpful and informative.
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: planner
tools:
  - validate_company
  - get_company_fact
```

::: notes
The planner style executes the numbered steps as a plan.
:::

---

## Test Company Info Agent {data-transition="fade"}

### Import and Test

```bash
orchestrate agents import -f company-info-agent.yaml
orchestrate chat start
```

<div class="fragment">

### Test Query

```text
Tell me about IBM
```

</div>

::: notes
The agent will execute the plan: validate → provide info → share fact.
:::

---

## 8. Multi-Agent Systems {data-background-color="#064e3b"}

### Lab 7: Customer Service Multi-Agent System

**Objective**: Create a supervisor agent that delegates to specialized agents

::: notes
Multi-agent systems enable specialization and scalability.
:::

---

## Create Specialized Agents {data-transition="slide"}

### Billing Agent

```yaml
spec_version: v1
kind: native
name: Billing_Agent
description: Handles billing inquiries, invoices,
  and payment issues
instructions: |
  You are a billing specialist. Help customers with:
  - Invoice questions
  - Payment issues
  - Billing disputes
  - Account balance inquiries

  Be professional and empathetic.
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: default
```

::: notes
Each specialist agent has a narrow, well-defined responsibility.
:::

---

## Create Technical Support Agent {data-transition="fade"}

### Technical Support Agent

```yaml
spec_version: v1
kind: native
name: Tech_Support_Agent
description: Provides technical support and
  troubleshooting assistance
instructions: |
  You are a technical support specialist.
  Help customers with:
  - Product setup and configuration
  - Troubleshooting technical issues
  - Software updates
  - Technical documentation

  Provide clear, step-by-step guidance.
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: default
```

::: notes
Technical issues require different expertise than billing.
:::

---

## Create Account Management Agent {data-transition="fade"}

### Account Agent

```yaml
spec_version: v1
kind: native
name: Account_Agent
description: Manages account settings, profile updates,
  and subscriptions
instructions: |
  You are an account management specialist.
  Help customers with:
  - Profile updates
  - Subscription changes
  - Account settings
  - Security settings

  Ensure customer data privacy and security.
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: default
```

::: notes
Account management focuses on user profile and subscription tasks.
:::

---

## Import Specialized Agents {data-transition="slide"}

### Import Commands

```bash
orchestrate agents import -f billing-agent.yaml
orchestrate agents import -f tech-support-agent.yaml
orchestrate agents import -f account-agent.yaml
```

::: notes
Import all specialist agents before creating the supervisor.
:::

---

## Create Supervisor Agent {data-transition="fade"}

### customer-service-supervisor.yaml

```yaml
spec_version: v1
kind: native
name: Customer_Service_Supervisor
description: Main customer service agent that
  routes requests
instructions: |
  You are a customer service supervisor. Analyze
  customer requests and route to the appropriate
  specialist:

  - Billing_Agent: For billing, invoices, payments
  - Tech_Support_Agent: For technical issues, setup
  - Account_Agent: For account settings, profile

  If a request involves multiple areas, handle them
  sequentially. Always greet customers warmly and
  summarize the resolution.
```

::: notes
The supervisor analyzes requests and delegates to the right specialist.
:::

---

## Supervisor Configuration {data-transition="fade"}

```yaml
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: planner
collaborators:
  - Billing_Agent
  - Tech_Support_Agent
  - Account_Agent
tools: []
```

::: notes
Collaborators list defines which agents the supervisor can delegate to.
:::

---

## Test Multi-Agent System {data-transition="slide"}

### Import and Test

```bash
orchestrate agents import -f customer-service-supervisor.yaml
orchestrate chat start
```

<div class="fragment">

### Test Query

```text
I have a question about my last invoice and
need help setting up my account
```

</div>

::: notes
The supervisor will delegate to both Billing_Agent and Account_Agent.
:::

---

## 9. Agent Protocols {data-background-color="#7c2d12"}

### MCP & A2A Integration

::: notes
Modern agent systems support standard protocols for interoperability.
:::

---

## Lab 8: MCP Server Integration {data-transition="slide"}

**Objective**: Connect to an MCP server for additional tools

<div class="fragment">

### What is MCP?

**Model Context Protocol**: Standard for connecting LLMs to external data sources and tools

</div>

::: notes
MCP enables agents to use tools from any MCP-compatible server.
:::

---

## Install MCP Toolkit {data-transition="fade"}

### Import from npm

```bash
orchestrate toolkits import \
  --kind mcp \
  --name filesystem \
  --source npm \
  --package @modelcontextprotocol/server-filesystem \
  --args '{"rootPath": "/tmp/workspace"}'
```

::: notes
MCP servers can provide multiple related tools as a toolkit.
:::

---

## Create Agent Using MCP Tools {data-transition="slide"}

### file-manager-agent.yaml

```yaml
spec_version: v1
kind: native
name: File_Manager_Agent
description: Agent that can read and manage files using MCP
instructions: |
  You are a file management assistant. You can:
  - List files in directories
  - Read file contents
  - Search for files

  Use the MCP filesystem tools to help users
  manage their files.
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: react
tools:
  - filesystem:list_directory
  - filesystem:read_file
  - filesystem:search_files
```

::: notes
MCP tools are referenced using the toolkit_name:tool_name format.
:::

---

## Lab 9: External Agent Integration (A2A) {data-transition="fade"}

**Objective**: Connect an external agent from another platform

<div class="fragment">

### What is A2A?

**Agent-to-Agent**: Protocol for agents to collaborate across platforms

</div>

::: notes
A2A enables watsonx Orchestrate agents to work with agents from other systems.
:::

---

## Create External Agent Configuration {data-transition="slide"}

### external-news-agent.yaml

```yaml
spec_version: v1
kind: external
name: News_Agent
title: News Agent
description: External agent that searches and
  summarizes news articles
api_url: https://your-external-agent-url.com/api/chat
auth_scheme: API_KEY
auth_config:
  token: your_external_agent_api_key
chat_params:
  stream: true
config:
  hidden: false
  enable_cot: true
tags:
  - news
  - external
```

::: notes
External agents are integrated via their API endpoints.
:::

---

## Import External Agent {data-transition="fade"}

### Import Command

```bash
orchestrate agents import -f external-news-agent.yaml
```

::: notes
External agents can be used as collaborators by native agents.
:::

---

## Create Supervisor with External Collaborator {data-transition="slide"}

### news-supervisor.yaml

```yaml
spec_version: v1
kind: native
name: News_Supervisor
description: Supervisor that can delegate to
  external news agent
instructions: |
  You coordinate news-related requests. When users
  ask about current events or news:
  1. Delegate to the News_Agent collaborator
  2. Summarize the results for the user
  3. Offer to search for related topics
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: default
collaborators:
  - News_Agent
```

::: notes
Mix native and external agents in collaborative workflows.
:::

---

## 10. Production Deployment {data-background-color="#1e3a8a"}

### Lab 10: Deploy to Production

::: notes
Move from local development to production IBM Cloud deployment.
:::

---

## Add Production Environment {data-transition="slide"}

### Configure Production

```bash
orchestrate env add \
  -n production \
  -u https://your-production-instance.cloud.ibm.com

orchestrate env activate production \
  --api-key your-production-api-key
```

::: notes
Manage multiple environments: local, staging, production.
:::

---

## Export Agent from Local {data-transition="fade"}

### Export Process

```bash
# Switch to local environment
orchestrate env activate local

# Export agent
orchestrate agents export \
  -n Weather_Agent \
  -o weather-agent-export.yaml
```

::: notes
Export creates a portable YAML file with all agent configuration.
:::

---

## Import to Production {data-transition="slide"}

### Import Process

```bash
# Switch to production
orchestrate env activate production

# Import agent
orchestrate agents import -f weather-agent-export.yaml
```

::: notes
Same agent definition works across all environments.
:::

---

## Deploy Agent {data-transition="fade"}

### Deployment Command

```bash
orchestrate agents deploy --name Weather_Agent
```

<div class="fragment">

### Verify Deployment

```bash
orchestrate agents list
```

</div>

::: notes
Deployed agents are available via API and UI.
:::

---

## Workshop Exercises {data-background-color="#581c87"}

::: notes
Additional exercises to reinforce learning.
:::

---

## Exercise 1: Restaurant Recommendation Agent {data-transition="slide"}

### Requirements

<div class="fragment">

- Create a tool that searches restaurants by cuisine type
- Create a tool that gets restaurant reviews
- Build an agent that recommends restaurants based on
  user preferences
- Use the ReAct style for iterative reasoning

</div>

::: notes
This exercise combines tool creation with agent reasoning.
:::

---

## Exercise 2: Document Processing Pipeline {data-transition="fade"}

### Requirements

<div class="fragment">

- Create a knowledge base from company documents
- Build an agent that can answer questions from the documents
- Implement confidence thresholds
- Add citation support

</div>

::: notes
Practice building production-ready RAG agents.
:::

---

## Exercise 3: Multi-Agent Workflow {data-transition="slide"}

### Requirements

<div class="fragment">

- Create 3 specialized agents (your choice of domains)
- Build a supervisor agent that routes requests
- Test with complex multi-step queries
- Implement error handling

</div>

::: notes
Design and implement a complete multi-agent system.
:::

---

## Best Practices {data-background-color="#064e3b"}

::: notes
Essential guidelines for building production agents.
:::

---

## Agent Design Best Practices {data-transition="slide"}

<div class="fragment">

### Single Responsibility
Each agent should have a clear, focused purpose

</div>

<div class="fragment">

### Clear Instructions
Write detailed, unambiguous instructions

</div>

<div class="fragment">

### Tool Selection
Only include tools the agent actually needs

</div>

<div class="fragment">

### Testing
Test agents thoroughly before deployment

</div>

::: notes
Good design practices lead to reliable, maintainable agents.
:::

---

## Tool Development Best Practices {data-transition="fade"}

<div class="fragment">

### Error Handling
Always include try-except blocks

</div>

<div class="fragment">

### Type Hints
Use Python type hints for better LLM understanding

</div>

<div class="fragment">

### Documentation
Write clear docstrings

</div>

<div class="fragment">

### Validation
Validate inputs before processing

</div>

::: notes
Robust tools prevent agent failures.
:::

---

## Security Best Practices {data-transition="slide"}

<div class="fragment">

### Credentials
Never hardcode credentials

</div>

<div class="fragment">

### Connections
Use the connection framework for all external APIs

</div>

<div class="fragment">

### Validation
Validate all user inputs

</div>

<div class="fragment">

### Least Privilege
Grant minimum necessary permissions

</div>

::: notes
Security is critical for production deployments.
:::

---

## Performance Best Practices {data-transition="fade"}

<div class="fragment">

### Caching
Cache frequently accessed data

</div>

<div class="fragment">

### Timeouts
Set appropriate timeouts for external calls

</div>

<div class="fragment">

### Batch Processing
Process multiple items together when possible

</div>

<div class="fragment">

### Monitoring
Use observability tools to track performance

</div>

::: notes
Optimize for production workloads.
:::

---

## Troubleshooting {data-background-color="#7c2d12"}

::: notes
Common issues and how to resolve them.
:::

---

## Agent Not Responding {data-transition="slide"}

### Diagnostic Commands

```bash
# Check agent status
orchestrate agents list

# View agent details
orchestrate agents get -n Your_Agent_Name

# Check logs
docker logs docker-api-1
```

::: notes
Start with basic diagnostics to identify the issue.
:::

---

## Tool Import Fails {data-transition="fade"}

### Diagnostic Commands

```bash
# Verify tool syntax
python your_tool.py

# Check dependencies
pip install -r requirements.txt

# Import with verbose output
orchestrate tools import \
  -k python \
  -f your_tool.py \
  --verbose
```

::: notes
Most tool issues are syntax or dependency problems.
:::

---

## Connection Issues {data-transition="slide"}

### Diagnostic Commands

```bash
# List connections
orchestrate connections list

# Verify credentials
orchestrate connections get --app-id your_app_id

# Reset credentials
orchestrate connections set-credentials \
  --app-id your_app_id \
  --env draft
```

::: notes
Connection issues often involve expired or incorrect credentials.
:::

---

## Additional Resources {data-background-color="#1e3a8a"}

::: notes
Resources for continued learning.
:::

---

## Documentation {data-transition="slide"}

<div class="fragment">

### Official Resources

- watsonx Orchestrate ADK Documentation
- Agent Builder Guide
- Tool Development Guide

</div>

::: notes
Comprehensive documentation available online.
:::

---

## Community Resources {data-transition="fade"}

<div class="fragment">

### GitHub & Examples

- GitHub: `ibm-watsonx-orchestrate-adk`
- Examples: ADK examples repository

</div>

::: notes
Learn from community examples and contribute back.
:::

---

## Summary {data-background-color="#581c87"}

<div class="fragment">

### What We Covered

1. Environment setup and configuration
2. Building agents with various capabilities
3. Creating and integrating Python tools
4. Working with connections and knowledge bases
5. Multi-agent systems and collaboration
6. Production deployment

</div>

<div class="fragment">

### Next Steps

- Experiment with your own use cases
- Build production agents
- Join the community

</div>

::: notes
You now have the foundation to build enterprise-grade AI agents with watsonx Orchestrate.
:::