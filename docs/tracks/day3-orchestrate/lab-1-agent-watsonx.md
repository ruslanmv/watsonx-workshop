# Lab 3.1 – Local Agent in `simple-watsonx-enviroment` + Accelerator API

## Lab Overview
- Build a simple agent that decides which tool to call, using Granite as the planner.
- Wire it into the **accelerator** RAG API for production-like behaviour.

## Learning Objectives
- Implement tools as Python functions and HTTP calls.
- Use an LLM to select and call tools.
- Log steps in a structured way.

## Prerequisites
- Day 2 RAG pipeline implemented and mapped into:
  - `accelerator/rag/retriever.py`
  - `accelerator/rag/pipeline.py`
  - `accelerator/rag/prompt.py`
- Basic understanding of orchestration patterns.
- Accelerator FastAPI app running (even with minimal logic).

---

## Step 1 – Finalize Accelerator Back-End

### 1.1 Implement `rag/retriever.py`
- Replace the placeholder `retrieve(q)` with real logic:
  - Choose backend (e.g. Elasticsearch or Chroma).
  - Use:
    - Connection details from `config.yaml` / environment.
    - Helper functions from `assets/data_asset/rag_helper_functions.py` if using Elasticsearch.
  - Return a list of chunks:
    - Each chunk: `{ "id": ..., "text": ..., "score": ..., "metadata": {...} }`.

### 1.2 Implement `rag/pipeline.py`
- Replace the placeholder `answer_question(q)` with:
  - Call to `retrieve(q)` to get top-k chunks.
  - Prompt construction using `rag/prompt.py`:
    - `SYSTEM`
    - `USER_TEMPLATE.format(question=q, context=concat_chunks)`.
  - Call to watsonx.ai LLM (Granite) configured via `service/deps.py` settings.
  - Return a dict: `{"answer": ..., "chunks": [...], "model_id": ..., "latency_ms": ...}`.

### 1.3 Improve `service/deps.py`
- Implement a proper settings class, e.g. using `pydantic.BaseSettings`:
  - Fields:
    - watsonx endpoint, api key, project id.
    - Vector DB connection info.
    - Index name, top_k, etc.
- Initialize `settings` as a reusable instance.

### 1.4 Harden `service/api.py`
- Ensure the FastAPI app:
  - Validates request with `AskReq` (question: str).
  - Calls `answer_question`.
  - Returns:
    - `answer`
    - `citations` (built from `chunks`).
    - Optional metadata (model, latency).
- Add basic error handling and logging.

---

## Step 2 – Bring Up the Accelerator Service

- Start the FastAPI app (e.g. via `uvicorn` or `Makefile` target).
- Test `POST /ask` with:
  - curl
  - HTTP client
  - or a small Python script.

Example test:

```bash
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question": "What is RAG?"}'
```

---

## Step 3 – Build an Agent Notebook in `simple-watsonx-enviroment`

- Create `agent_watsonx.ipynb`.
- Define tools:

  - `rag_service_tool(question: str)`:
    - Calls `POST /ask` on the accelerator API.
    - Returns answer + citations.

  - `calculator_tool(expression: str)`:
    - Evaluates arithmetic safely (e.g. small AST-based evaluator).

- Wrap each tool so it returns a **clean text string** and a small metadata dict.

---

## Step 4 – Design the Planner Prompt

- System prompt:
  - Explain available tools and when to use them.
- Tool-selection format:
  - e.g. JSON:
    ```json
    { "tool": "rag_service", "arguments": { "question": "..." } }
    ```

- You can embed this in a prompt like:

```text
You are a planner agent. You must choose exactly ONE tool.

Tools:
- "rag_service": answer enterprise questions using the /ask RAG API.
- "calculator": evaluate arithmetic expressions like "2 * (3 + 4)".

Return a JSON object with:
- "tool": one of ["rag_service", "calculator"]
- "arguments": an object with the tool parameters.
```

---

## Step 5 – Implement Agent Loop

High-level steps:

1. **Planner step**
   - User input → Granite model → JSON with chosen tool + arguments.

2. **Tool execution step**
   - Python decodes JSON.
   - Calls the corresponding tool (`rag_service_tool` or `calculator_tool`).

3. **Final answer step**
   - Call Granite again with a prompt like:
     - “User question: ...; Tool used: ...; Tool output: ...; Please write a helpful final answer.”

4. **Return structured result**
   - Dictionary like:

```python
{
  "question": user_input,
  "tool": chosen_tool,
  "tool_args": tool_args,
  "tool_output": tool_output,
  "final_answer": final_answer,
}
```

---

## Step 6 – Log & Inspect

For each interaction, log:

- User question.
- Tool chosen.
- Tool arguments.
- Tool output summary.
- Final answer.
- Optional: timestamps, model id, latency.

Log format can be:

- List of dicts in memory (for quick exploration).
- JSONL file (one line per interaction).
- Pandas DataFrame for quick analysis in a notebook.

These logs can later be analyzed in:

- `accelerator/assets/notebook/notebook:Analyze_Log_and_Feedback.ipynb`
- watsonx.governance Evaluation Studio (after exporting as a dataset).

---

## Reference Notebooks

- `labs-src/ibm-watsonx-governance-governed-agentic-catalog.ipynb`
- `accelerator/assets/notebook/notebook:Create_and_Deploy_QnA_AI_Service.ipynb`

---

## Wrap-Up

- Strengths of the **notebook-based agent**:
  - Fast iteration.
  - Easy debugging.
  - Great for experimentation.

- Strengths of the **API-based RAG service**:
  - Clear contract (`/ask` endpoint).
  - Can be reused by:
    - Agents (this lab).
    - UIs (Streamlit app).
    - Other services.

- This pattern generalizes to **watsonx Orchestrate**:
  - Your accelerator API becomes a managed tool / connection.
  - Your planner logic becomes an Orchestrate agent with tools and flows.

---

## Checkpoint

- ✅ Accelerator API `/ask` implemented and tested.
- ✅ Agent notebook built and calling the accelerator service as a tool.
- ✅ Logging prepared for governance / evaluation.
