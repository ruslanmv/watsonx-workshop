# 3.x watsonx Orchestrate – Labs & Reference

**Workshop Focus:** Building AI Agents with watsonx Orchestrate  
**Target Audience:** Technical professionals, developers, and architects  

---

## Table of Contents

1. [Environment Setup](#1-environment-setup)
2. [Introduction to AI Agents](#2-introduction-to-ai-agents)
3. [Building Your First Agent](#3-building-your-first-agent)
4. [Creating Python Tools](#4-creating-python-tools)
5. [Connections & Integration](#5-connections--integration)
6. [Knowledge Bases](#6-knowledge-bases)
7. [Flow Builder / Planner Style](#7-flow-builder--planner-style)
8. [Multi-Agent Systems](#8-multi-agent-systems)
9. [Agent Protocols (MCP & A2A)](#9-agent-protocols-mcp--a2a)
10. [Production Deployment](#10-production-deployment)  

---

## 1. Environment Setup

### Prerequisites

- Python 3.9 or higher  
- Docker Desktop installed and running  
- IBM Cloud account (for production deployment)

### Install the ADK

```bash
pip install ibm-watsonx-orchestrate
```

### Configure Environment File

Create a `.env` file with your credentials:

```bash
# .env file
WATSONX_API_KEY=your_watsonx_api_key
WATSONX_PROJECT_ID=your_project_id
WATSONX_URL=https://us-south.ml.cloud.ibm.com

# Optional: Skip login for Developer Edition
WO_DEVELOPER_EDITION_SKIP_LOGIN=true
```

### Start watsonx Orchestrate Developer Edition

```bash
orchestrate server start --env-file .env --accept-terms-and-conditions
```

**Available Services:**

- API Base URL: `http://localhost:4321/api/v1`  
- OpenAPI Docs: `http://localhost:4321/docs`  
- UI: `http://localhost:3000`

### Configure Local Environment

```bash
# Activate local environment
orchestrate env activate local
```

### Add Remote Environment (Optional)

```bash
# Add IBM Cloud environment
orchestrate env add -n production -u https://your-instance-url.com

# Activate remote environment
orchestrate env activate production --api-key your-api-key
```

---

## 2. Introduction to AI Agents

### What Is an AI Agent?

An AI agent is an autonomous application that can understand, plan, and execute tasks using LLMs to reason and interface with tools, models, and IT systems.

### Core Agent Components

1. **LLM** – the language model powering the agent.  
2. **Style** – prompting structure (Default, ReAct, Plan–Act).  
3. **Instructions** – natural language guidance.  
4. **Tools** – functions the agent can execute.  
5. **Collaborators** – other agents it can work with.  
6. **Knowledge Base** – domain-specific information.

---

## 3. Building Your First Agent

### Lab 1: Hello World Agent

**Objective:** Create a simple agent that responds to greetings.

#### Step 1: Create Agent YAML File

Create `hello-world-agent.yaml`:

```yaml
spec_version: v1
kind: native
name: Hello_World_Agent
description: A simple Hello World agent for testing
instructions: |
  You are a test agent created for a tutorial on how to get started with watsonx Orchestrate ADK.
  When the user asks 'who are you', respond with: 
  "I'm the Hello World Agent. Congratulations on completing the Getting Started with watsonx Orchestrate ADK tutorial!"
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: default
collaborators: []
tools: []
```

#### Step 2: Import the Agent

```bash
orchestrate agents import -f hello-world-agent.yaml
```

Expected output:

```text
✓ Agent 'Hello_World_Agent' imported successfully
```

#### Step 3: Test the Agent

```bash
orchestrate chat start
```

In the chat interface, type:

```text
who are you?
```

You should see your “Hello World Agent” answer.

---

### Lab 2: Weather Agent with Tools

**Objective:** Create an agent that provides weather information using an external API.

#### Step 1: Create Weather Tool (Python)

Create `weather_tool.py`:

```python
from ibm_watsonx_orchestrate.agent_builder.tools import tool
import requests

@tool(
    name="get_weather",
    description="Get current weather for a given city"
)
def get_weather(city: str) -> str:
    """
    Retrieves current weather information for a specified city.

    Args:
        city (str): The name of the city

    Returns:
        str: Weather information as a formatted string
    """
    # Using a free weather API (replace with your API key)
    api_key = "your_openweather_api_key"
    base_url = "http://api.openweathermap.org/data/2.5/weather"

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

        return f"The current weather in {city} is {description} with a temperature of {temp}°C."
    except Exception as e:
        return f"Sorry, I couldn't fetch the weather for {city}. Error: {str(e)}"
```

#### Step 2: Import the Tool

```bash
orchestrate tools import -k python -f weather_tool.py
```

#### Step 3: Create Weather Agent

Create `weather-agent.yaml`:

```yaml
spec_version: v1
kind: native
name: Weather_Agent
description: An agent that provides current weather information for cities
instructions: |
  You are a helpful weather assistant. When users ask about weather in a city:
  1. Use the get_weather tool to fetch current conditions
  2. Present the information in a friendly, conversational manner
  3. If the city is not found, politely ask for clarification
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: react
collaborators: []
tools:
  - get_weather
```

#### Step 4: Import and Test

```bash
orchestrate agents import -f weather-agent.yaml
orchestrate chat start
```

Test with:

```text
What's the weather in Paris?
```

---

## 4. Creating Python Tools

### Lab 3: Advanced Python Tool with Connections

**Objective:** Create a tool that uses secure connections to external APIs.

#### Step 1: Create Connection Configuration

Create `github-connection.yaml`:

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

#### Step 2: Import Connection

```bash
orchestrate connections import -f github-connection.yaml
```

#### Step 3: Set Credentials

```bash
orchestrate connections set-credentials   --app-id github_api   --env draft   --token your_github_personal_access_token
```

#### Step 4: Create GitHub Tool

Create `github_tool.py`:

```python
from ibm_watsonx_orchestrate.agent_builder.tools import tool
from ibm_watsonx_orchestrate.agent_builder.connections import ConnectionType
from ibm_watsonx_orchestrate.run import connections
import requests

@tool(
    name="search_github_repos",
    description="Search for GitHub repositories by keyword",
    expected_credentials=[
        {"app_id": "github_api", "type": ConnectionType.BEARER_TOKEN}
    ]
)
def search_github_repos(query: str, max_results: int = 5) -> str:
    """
    Search GitHub repositories.

    Args:
        query (str): Search query
        max_results (int): Maximum number of results to return

    Returns:
        str: Formatted list of repositories
    """
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
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()
        data = response.json()

        results = []
        for repo in data['items'][:max_results]:
            results.append(
                f"- {repo['full_name']}: {repo['description']} "
                f"(⭐ {repo['stargazers_count']})"
            )

        return "\n".join(results)
    except Exception as e:
        return f"Error searching repositories: {str(e)}"
```

#### Step 5: Import Tool with Connection

```bash
orchestrate tools import -k python -f github_tool.py -a github_api
```

---

## 5. Connections & Integration

### Lab 4: Multiple Connection Types

#### API Key Connection

Create `api-key-connection.yaml`:

```yaml
spec_version: v1
kind: connection
app_id: my_api_service
environments:
  draft:
    kind: api_key
    type: api_key_auth
```

Set credentials:

```bash
orchestrate connections set-credentials   --app-id my_api_service   --env draft   --api-key your_api_key   --url https://api.example.com
```

#### OAuth Connection

Create `oauth-connection.yaml`:

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
      authorization_url: https://login.salesforce.com/services/oauth2/authorize
      token_url: https://login.salesforce.com/services/oauth2/token
      scope: api refresh_token
```

#### Key-Value Connection

Create `kv-connection.yaml`:

```yaml
spec_version: v1
kind: connection
app_id: custom_service
environments:
  draft:
    kind: key_value
    type: key_value
```

Set credentials:

```bash
orchestrate connections set-credentials   --app-id custom_service   --env draft   --key api_key --value your_key   --key api_secret --value your_secret   --key base_url --value https://api.example.com
```

---

## 6. Knowledge Bases

### Lab 5: Create Knowledge Base with RAG

**Objective:** Build an agent that answers questions from uploaded documents.

#### Step 1: Create Knowledge Base (YAML)

Create `company_kb.yaml`:

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
    prompt_instruction: "Provide accurate answers based on company policies. If unsure, say so."
    max_docs_passed_to_llm: 5
    generated_response_length: Moderate
    idk_message: "I don't have information about that in the company policies."
  confidence_thresholds:
    retrieval_confidence_threshold: Low
    response_confidence_threshold: Low
  query_rewrite:
    enabled: true
  citations:
    citations_shown: 3
```

#### Step 2: Import Knowledge Base

```bash
orchestrate knowledge-bases import -f company_kb.yaml
```

#### Step 3: Create Agent with Knowledge Base

Create `hr-agent.yaml`:

```yaml
spec_version: v1
kind: native
name: HR_Assistant
description: HR assistant that answers questions about company policies
instructions: |
  You are an HR assistant. Use the company_policies knowledge base to answer questions about:
  - Employee benefits
  - Leave policies
  - IT guidelines
  - Company procedures

  Always cite your sources and be accurate. If you're unsure, say so.
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: default
knowledge_base: company_policies
collaborators: []
tools: []
```

#### Step 4: Import and Test

```bash
orchestrate agents import -f hr-agent.yaml
orchestrate chat start
```

Test with:

```text
What is the company's vacation policy?
```

---

## 7. Flow Builder / Planner Style

### Lab 6: Company Information Flow

**Objective:** Create a flow that validates company names and returns information.

#### Step 1: Create Company Validation Tool

Create `company_validator.py`:

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
    # Simulated company database
    companies = {
        "IBM": {
            "exists": True,
            "founded": 1911,
            "industry": "Technology",
            "headquarters": "Armonk, NY"
        },
        "Microsoft": {
            "exists": True,
            "founded": 1975,
            "industry": "Technology",
            "headquarters": "Redmond, WA"
        }
    }

    company_info = companies.get(company_name, {"exists": False})

    return {
        "company_name": company_name,
        **company_info
    }

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
        "IBM": "IBM holds more patents than any other U.S. technology company.",
        "Microsoft": "Microsoft's original name was 'Micro-Soft' (with a hyphen)."
    }

    return facts.get(company_name, f"No facts available for {company_name}")
```

#### Step 2: Import Tools

```bash
orchestrate tools import -k python -f company_validator.py
```

#### Step 3: Create Flow-Based Agent

Create `company-info-agent.yaml`:

```yaml
spec_version: v1
kind: native
name: Company_Info_Agent
description: Provides information about companies
instructions: |
  When a user asks about a company:
  1. First, validate the company exists using validate_company tool
  2. If the company exists, provide the basic information
  3. Then use get_company_fact to share an interesting fact
  4. If the company doesn't exist, politely inform the user

  Always be helpful and informative.
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: planner
collaborators: []
tools:
  - validate_company
  - get_company_fact
```

#### Step 4: Import and Test

```bash
orchestrate agents import -f company-info-agent.yaml
orchestrate chat start
```

Test with:

```text
Tell me about IBM
```

---

## 8. Multi-Agent Systems

### Lab 7: Customer Service Multi-Agent System

**Objective:** Create a supervisor agent that delegates to specialized agents.

#### Step 1: Create Specialized Agents

**Billing Agent** – `billing-agent.yaml`:

```yaml
spec_version: v1
kind: native
name: Billing_Agent
description: Handles billing inquiries, invoices, and payment issues
instructions: |
  You are a billing specialist. Help customers with:
  - Invoice questions
  - Payment issues
  - Billing disputes
  - Account balance inquiries

  Be professional and empathetic.
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: default
collaborators: []
tools: []
```

**Technical Support Agent** – `tech-support-agent.yaml`:

```yaml
spec_version: v1
kind: native
name: Tech_Support_Agent
description: Provides technical support and troubleshooting assistance
instructions: |
  You are a technical support specialist. Help customers with:
  - Product setup and configuration
  - Troubleshooting technical issues
  - Software updates
  - Technical documentation

  Provide clear, step-by-step guidance.
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: default
collaborators: []
tools: []
```

**Account Management Agent** – `account-agent.yaml`:

```yaml
spec_version: v1
kind: native
name: Account_Agent
description: Manages account settings, profile updates, and subscriptions
instructions: |
  You are an account management specialist. Help customers with:
  - Profile updates
  - Subscription changes
  - Account settings
  - Security settings

  Ensure customer data privacy and security.
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: default
collaborators: []
tools: []
```

#### Step 2: Import Specialized Agents

```bash
orchestrate agents import -f billing-agent.yaml
orchestrate agents import -f tech-support-agent.yaml
orchestrate agents import -f account-agent.yaml
```

#### Step 3: Create Supervisor Agent

Create `customer-service-supervisor.yaml`:

```yaml
spec_version: v1
kind: native
name: Customer_Service_Supervisor
description: Main customer service agent that routes requests to specialized agents
instructions: |
  You are a customer service supervisor. Analyze customer requests and route them to the appropriate specialist:

  - Billing_Agent: For billing, invoices, payments, charges
  - Tech_Support_Agent: For technical issues, setup, troubleshooting
  - Account_Agent: For account settings, profile, subscriptions

  If a request involves multiple areas, handle them sequentially.
  Always greet customers warmly and summarize the resolution.
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: planner
collaborators:
  - Billing_Agent
  - Tech_Support_Agent
  - Account_Agent
tools: []
```

#### Step 4: Import and Test

```bash
orchestrate agents import -f customer-service-supervisor.yaml
orchestrate chat start
```

Test with:

```text
I have a question about my last invoice and need help setting up my account
```

---

## 9. Agent Protocols (MCP & A2A)

### Lab 8: MCP Server Integration

**Objective:** Connect to an MCP server for additional tools.

#### Step 1: Install MCP Toolkit

```bash
# Import MCP toolkit from npm
orchestrate toolkits import   --kind mcp   --name filesystem   --source npm   --package @modelcontextprotocol/server-filesystem   --args '{"rootPath": "/tmp/workspace"}'
```

#### Step 2: Create Agent Using MCP Tools

Create `file-manager-agent.yaml`:

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

  Use the MCP filesystem tools to help users manage their files.
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: react
collaborators: []
tools:
  - filesystem:list_directory
  - filesystem:read_file
  - filesystem:search_files
```

#### Step 3: Import and Test

```bash
orchestrate agents import -f file-manager-agent.yaml
orchestrate chat start
```

---

### Lab 9: External Agent Integration (A2A)

**Objective:** Connect an external agent from another platform.

#### Step 1: Create External Agent Configuration

Create `external-news-agent.yaml`:

```yaml
spec_version: v1
kind: external
name: News_Agent
title: News Agent
description: External agent that searches and summarizes news articles
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

#### Step 2: Import External Agent

```bash
orchestrate agents import -f external-news-agent.yaml
```

#### Step 3: Create Supervisor with External Collaborator

Create `news-supervisor.yaml`:

```yaml
spec_version: v1
kind: native
name: News_Supervisor
description: Supervisor that can delegate to external news agent
instructions: |
  You coordinate news-related requests. When users ask about current events or news:
  1. Delegate to the News_Agent collaborator
  2. Summarize the results for the user
  3. Offer to search for related topics
llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct
style: default
collaborators:
  - News_Agent
tools: []
```

#### Step 4: Import and Test

```bash
orchestrate agents import -f news-supervisor.yaml
orchestrate chat start
```

---

## 10. Production Deployment

### Lab 10: Deploy to Production

#### Step 1: Add Production Environment

```bash
orchestrate env add   -n production   -u https://your-production-instance.cloud.ibm.com

orchestrate env activate production --api-key your-production-api-key
```

#### Step 2: Export Agent from Local

```bash
# Switch to local environment
orchestrate env activate local

# Export agent
orchestrate agents export -n Weather_Agent -o weather-agent-export.yaml
```

#### Step 3: Import to Production

```bash
# Switch to production
orchestrate env activate production

# Import agent
orchestrate agents import -f weather-agent-export.yaml
```

#### Step 4: Deploy Agent

```bash
orchestrate agents deploy --name Weather_Agent
```

#### Step 5: Verify Deployment

```bash
orchestrate agents list
```

---

## Workshop Exercises

You can use the following as optional or advanced exercises.

### Exercise 1: Build a Restaurant Recommendation Agent

**Requirements:**

- Create a tool that searches restaurants by cuisine type.
- Create a tool that gets restaurant reviews.
- Build an agent that recommends restaurants based on user preferences.
- Use the ReAct style for iterative reasoning.

### Exercise 2: Document Processing Pipeline

**Requirements:**

- Create a knowledge base from company documents.
- Build an agent that can answer questions from the documents.
- Implement confidence thresholds.
- Add citation support.

### Exercise 3: Multi-Agent Workflow

**Requirements:**

- Create 3 specialized agents (your choice of domains).
- Build a supervisor agent that routes requests.
- Test with complex multi-step queries.
- Implement error handling.

---

## Best Practices

### Agent Design

- **Single responsibility** – each agent should have a clear, focused purpose.  
- **Clear instructions** – write detailed, unambiguous instructions.  
- **Tool selection** – only include tools the agent actually needs.  
- **Testing** – test agents thoroughly before deployment.

### Tool Development

- **Error handling** – always include try–except blocks.  
- **Type hints** – use Python type hints for better LLM understanding.  
- **Documentation** – write clear docstrings.  
- **Validation** – validate inputs before processing.

### Security

- **Credentials** – never hardcode credentials.  
- **Connections** – use the connection framework for all external APIs.  
- **Validation** – validate all user inputs.  
- **Least privilege** – grant minimum necessary permissions.

### Performance

- **Caching** – cache frequently accessed data.  
- **Timeouts** – set appropriate timeouts for external calls.  
- **Batch processing** – process multiple items together when possible.  
- **Monitoring** – use observability tools to track performance.

---

## Troubleshooting

### Common Issues

**Agent not responding:**

```bash
# Check agent status
orchestrate agents list

# View agent details
orchestrate agents get -n Your_Agent_Name

# Check logs
docker logs docker-api-1
```

**Tool import fails:**

```bash
# Verify tool syntax
python your_tool.py

# Check dependencies
pip install -r requirements.txt

# Import with verbose output
orchestrate tools import -k python -f your_tool.py --verbose
```

**Connection issues:**

```bash
# List connections
orchestrate connections list

# Verify credentials
orchestrate connections get --app-id your_app_id

# Reset credentials
orchestrate connections set-credentials --app-id your_app_id --env draft
```

---

## Additional Resources

### Documentation

- watsonx Orchestrate ADK documentation  
- Agent builder guide  
- Tool development guide

### Community

- GitHub: `ibm-watsonx-orchestrate-adk`  
- Examples: ADK examples repo

Use these resources to continue experimenting beyond the workshop.