# 🧪 Lab 3.1: Local Agent + RAG Accelerator {data-background-color="#0f172a"}

::: notes
In this hands-on lab, you'll build a simple agent that decides which tool to call, using Granite as the planner. You'll wire it into your Day 2 RAG accelerator for production-like behavior.
:::

---

## 🎯 Lab Overview {data-transition="slide"}

<span class="fragment">Build a **simple agent** that decides which tool to call</span>

<span class="fragment">Use **Granite** as the planner LLM</span>

<span class="fragment">Wire it into the **accelerator RAG API** for production-like behavior</span>

::: notes
This lab brings together everything from Days 2 and 3: your RAG service becomes a tool for your agent!
:::

---

## Learning Objectives {data-transition="fade"}

By the end of this lab, you will:

<span class="fragment">Implement **tools** as Python functions and HTTP calls</span>

<span class="fragment">Use an **LLM to select and call tools**</span>

<span class="fragment">Log steps in a **structured way** for governance</span>

::: notes
These skills are the foundation for building production-grade agentic systems.
:::

---

## 📋 Prerequisites {data-background-color="#1e3a8a"}

<span class="fragment">**Day 2 RAG pipeline** implemented and mapped into accelerator</span>

<span class="fragment">Files: `retriever.py`, `pipeline.py`, `prompt.py`</span>

<span class="fragment">**Basic understanding** of orchestration patterns</span>

<span class="fragment">**Accelerator FastAPI app** running</span>

::: notes
Make sure your Day 2 work is complete before starting this lab.
:::

---

## 🔧 Step 1: Finalize Accelerator Back-End {data-transition="slide"}

### 1.1 Implement `rag/retriever.py`

Replace the placeholder `retrieve(q)` with real logic:

<span class="fragment">Choose backend: **Elasticsearch** or **Chroma**</span>

<span class="fragment">Use connection details from `config.yaml` / environment</span>

<span class="fragment">Use helper functions from `assets/data_asset/rag_helper_functions.py`</span>

::: notes
The retriever is the core of your RAG system. Make sure it's working correctly.
:::

---

## Retriever Return Format {data-transition="fade"}

Return a **list of chunks**:

```python
[
    {
        "id": "...",
        "text": "...",
        "score": 0.95,
        "metadata": {...}
    },
    ...
]
```

<span class="fragment">Each chunk needs: **ID, text, score, metadata**</span>

::: notes
This structured format makes it easy to work with results and build citations.
:::

---

## 1.2 Implement `rag/pipeline.py` {data-transition="slide"}

Replace placeholder `answer_question(q)` with:

<span class="fragment">Call `retrieve(q)` to get **top-k chunks**</span>

<span class="fragment">Construct prompt using `rag/prompt.py`</span>

<span class="fragment">Call **watsonx.ai LLM** (Granite) configured via `service/deps.py`</span>

<span class="fragment">Return a dict with answer, chunks, model_id, latency_ms</span>

::: notes
The pipeline orchestrates retrieval and generation into a complete RAG workflow.
:::

---

## Pipeline Return Format {data-transition="fade"}

```python
{
    "answer": "...",
    "chunks": [...],
    "model_id": "ibm/granite-...",
    "latency_ms": 1234
}
```

<span class="fragment">Include **metadata** for observability</span>

::: notes
This metadata is crucial for monitoring and debugging in production.
:::

---

## 1.3 Improve `service/deps.py` {data-transition="slide"}

Implement a proper **settings class** using `pydantic.BaseSettings`:

<span class="fragment">**Fields**: watsonx endpoint, API key, project ID</span>

<span class="fragment">Vector DB connection info</span>

<span class="fragment">Index name, top_k, etc.</span>

<span class="fragment">Initialize `settings` as a **reusable instance**</span>

::: notes
Centralized configuration makes your service easier to deploy and maintain.
:::

---

## 1.4 Harden `service/api.py` {data-transition="fade"}

Ensure the FastAPI app:

<span class="fragment">**Validates** request with `AskReq` (question: str)</span>

<span class="fragment">**Calls** `answer_question`</span>

<span class="fragment">**Returns**: answer, citations, metadata</span>

<span class="fragment">Add basic **error handling** and **logging**</span>

::: notes
A robust API is essential when agents depend on your service.
:::

---

## 🚀 Step 2: Bring Up the Accelerator Service {data-background-color="#064e3b"}

### Start the FastAPI App

<span class="fragment">Via `uvicorn` or `Makefile` target</span>

<span class="fragment">Default port: **8000**</span>

::: notes
Make sure your service is running before building the agent.
:::

---

## Test the Accelerator {data-transition="slide"}

### Test with curl

```bash
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question": "What is RAG?"}'
```

<span class="fragment">You can also test with:</span>

<span class="fragment">- HTTP client (Postman, Insomnia)</span>

<span class="fragment">- Small Python script</span>

::: notes
Verify your accelerator is working before integrating it with the agent.
:::

---

## 🤖 Step 3: Build Agent Notebook {data-background-color="#1e3a8a"}

### Create `agent_watsonx.ipynb`

In your `simple-watsonx-environment`:

<span class="fragment">Define **two tools**</span>

<span class="fragment">Implement **planner prompt**</span>

<span class="fragment">Build **agent loop**</span>

::: notes
The notebook format makes it easy to iterate and debug your agent.
:::

---

## Define Tools {data-transition="slide"}

### Tool 1: RAG Service Tool

```python
def rag_service_tool(question: str):
    """Call the RAG service to answer questions"""
    url = "http://localhost:8000/ask"
    payload = {"question": question}

    response = requests.post(url, json=payload, timeout=60)
    response.raise_for_status()
    data = response.json()

    answer = data.get("answer", "No answer found")
    citations = data.get("citations", [])

    return f"Answer: {answer}\nSources: {citations}"
```

::: notes
This tool turns your Day 2 RAG service into a capability your agent can use!
:::

---

## Tool 2: Calculator Tool {data-transition="fade"}

```python
def calculator_tool(expression: str):
    """Evaluate arithmetic safely"""
    import ast
    import operator

    # Safe operators
    operators = {
        ast.Add: operator.add,
        ast.Sub: operator.sub,
        ast.Mult: operator.mul,
        ast.Div: operator.truediv
    }

    # Parse and evaluate
    try:
        tree = ast.parse(expression, mode='eval')
        # ... safe evaluation logic ...
        return str(result)
    except Exception as e:
        return f"Error: {str(e)}"
```

::: notes
Never use eval() directly! Use AST-based evaluation for safety.
:::

---

## Wrap Tools {data-transition="slide"}

Each tool should return:

<span class="fragment">**Clean text string** - The result</span>

<span class="fragment">**Metadata dict** - Tool name, execution time, etc.</span>

```python
{
    "tool": "rag_service",
    "output": "Answer: ...",
    "execution_time_ms": 234
}
```

::: notes
Structured tool outputs enable better logging and debugging.
:::

---

## 📝 Step 4: Design Planner Prompt {data-background-color="#7c2d12"}

### System Prompt

Explain **available tools** and **when to use them**

### Tool Selection Format

Use **JSON** for structured output:

```json
{
    "tool": "rag_service",
    "arguments": {
        "question": "..."
    }
}
```

::: notes
Structured output makes it easy to parse the LLM's decision.
:::

---

## Example Planner Prompt {data-transition="slide"}

```
You are a planner agent. You must choose exactly ONE tool.

Tools:
- "rag_service": answer enterprise questions using the /ask RAG API
- "calculator": evaluate arithmetic expressions like "2 * (3 + 4)"

Return a JSON object with:
- "tool": one of ["rag_service", "calculator"]
- "arguments": an object with the tool parameters

Examples:
User: "What is RAG?"
Response: {"tool": "rag_service", "arguments": {"question": "What is RAG?"}}

User: "Calculate 15 * 23"
Response: {"tool": "calculator", "arguments": {"expression": "15 * 23"}}
```

::: notes
Few-shot examples help the LLM understand the expected format.
:::

---

## 🔄 Step 5: Implement Agent Loop {data-background-color="#1e3a8a"}

### High-Level Steps

<span class="fragment">**1. Planner step** - User input → Granite → JSON with chosen tool + arguments</span>

<span class="fragment">**2. Tool execution step** - Python decodes JSON → calls tool</span>

<span class="fragment">**3. Final answer step** - Call Granite again to format final answer</span>

<span class="fragment">**4. Return structured result** - Log everything</span>

::: notes
This is the basic agent loop pattern used in most agentic systems.
:::

---

## Planner Step {data-transition="slide"}

```python {data-line-numbers="1-4|6-10|12-13"}
# 1. Planner step
planner_prompt = f"""
{PLANNER_SYSTEM_PROMPT}

User question: {user_input}
"""

response = granite_llm.generate(planner_prompt)
plan_json = extract_json(response)

# Parse the plan
chosen_tool = plan_json["tool"]
tool_args = plan_json["arguments"]
```

::: notes
The planner uses the LLM to decide which tool to use and with what arguments.
:::

---

## Tool Execution Step {data-transition="fade"}

```python {data-line-numbers="1-6"}
# 2. Tool execution step
if chosen_tool == "rag_service":
    tool_output = rag_service_tool(**tool_args)
elif chosen_tool == "calculator":
    tool_output = calculator_tool(**tool_args)
else:
    tool_output = f"Unknown tool: {chosen_tool}"
```

<span class="fragment">Execute the selected tool with parsed arguments</span>

::: notes
Simple dispatch based on the tool name. Add error handling in production!
:::

---

## Final Answer Step {data-transition="slide"}

```python {data-line-numbers="1-9|11-12"}
# 3. Final answer step
final_prompt = f"""
User question: {user_input}

Tool used: {chosen_tool}
Tool output: {tool_output}

Please write a helpful final answer for the user.
"""

response = granite_llm.generate(final_prompt)
final_answer = response.strip()
```

::: notes
The final step uses the LLM to format the tool output into a user-friendly answer.
:::

---

## Return Structured Result {data-transition="fade"}

```python
# 4. Return structured result
return {
    "question": user_input,
    "tool": chosen_tool,
    "tool_args": tool_args,
    "tool_output": tool_output,
    "final_answer": final_answer,
    "timestamp": datetime.now().isoformat()
}
```

<span class="fragment">This structure is perfect for **logging and analysis**</span>

::: notes
Structured logs enable governance and continuous improvement.
:::

---

## 📊 Step 6: Log & Inspect {data-background-color="#064e3b"}

For each interaction, log:

<span class="fragment">**User question**</span>

<span class="fragment">**Tool chosen**</span>

<span class="fragment">**Tool arguments**</span>

<span class="fragment">**Tool output** summary</span>

<span class="fragment">**Final answer**</span>

<span class="fragment">**Optional**: timestamps, model ID, latency</span>

::: notes
Comprehensive logging is essential for debugging and governance.
:::

---

## Log Format Options {data-transition="slide"}

<span class="fragment">**List of dicts** in memory (for quick exploration)</span>

<span class="fragment">**JSONL file** (one line per interaction)</span>

<span class="fragment">**Pandas DataFrame** for quick analysis in notebook</span>

### Future Analysis

<span class="fragment">Use `accelerator/assets/notebook/notebook:Analyze_Log_and_Feedback.ipynb`</span>

<span class="fragment">Export to **watsonx.governance Evaluation Studio**</span>

::: notes
These logs bridge development and production governance.
:::

---

## 📚 Reference Notebooks {data-background-color="#1e3a8a"}

Helpful references in `labs-src`:

<span class="fragment">`ibm-watsonx-governance-governed-agentic-catalog.ipynb`</span>

<span class="fragment">`accelerator/assets/notebook/notebook:Create_and_Deploy_QnA_AI_Service.ipynb`</span>

::: notes
These notebooks show additional patterns and best practices.
:::

---

## 🎯 Wrap-Up {data-transition="slide"}

### Strengths of Notebook-Based Agent

<span class="fragment">**Fast iteration** - Quick changes and testing</span>

<span class="fragment">**Easy debugging** - See every step</span>

<span class="fragment">**Great for experimentation** - Try different prompts, tools</span>

::: notes
Notebooks are perfect for development and prototyping.
:::

---

## Strengths of API-Based RAG Service {data-transition="fade"}

<span class="fragment">**Clear contract** - `/ask` endpoint</span>

<span class="fragment">**Reusable** by multiple consumers:</span>

<span class="fragment">  - Agents (this lab)</span>

<span class="fragment">  - UIs (Streamlit app)</span>

<span class="fragment">  - Other services</span>

::: notes
The API design makes your RAG service a reusable building block.
:::

---

## Bridge to watsonx Orchestrate {data-background-color="#7c2d12"}

This pattern generalizes to **watsonx Orchestrate**:

<span class="fragment">Your **accelerator API** becomes a managed tool/connection</span>

<span class="fragment">Your **planner logic** becomes an Orchestrate agent with tools and flows</span>

<span class="fragment">Add **governance** and **monitoring**</span>

::: notes
Everything you're building here can scale to enterprise production with Orchestrate.
:::

---

## ✅ Checkpoint {data-transition="zoom"}

Before moving on, verify:

<span class="fragment">✅ Accelerator API `/ask` implemented and tested</span>

<span class="fragment">✅ Agent notebook built and calling the accelerator service as a tool</span>

<span class="fragment">✅ Logging prepared for governance/evaluation</span>

::: notes
If all three checkpoints pass, you're ready for production deployment patterns!
:::

---

## 🚀 Next Steps {data-background-color="#0f172a"}

<span class="fragment">**Experiment** with different prompts</span>

<span class="fragment">**Add more tools** (web search, database queries)</span>

<span class="fragment">**Implement error handling** and retries</span>

<span class="fragment">**Export logs** for analysis</span>

<span class="fragment">**Explore watsonx Orchestrate** for production deployment</span>

::: notes
You've built the foundation. Now it's time to expand and productionize!
:::