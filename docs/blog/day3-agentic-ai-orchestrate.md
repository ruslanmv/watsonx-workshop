# Day 3 – From RAG to Agents and Orchestrate

On Day 2 we made LLMs **know things** by adding Retrieval-Augmented Generation (RAG).  
On Day 3 we made those LLMs **do things** by wrapping them as agents and orchestration flows.

This short recap is meant as an internal blog or summary you can share with your team.

---

## What We Set Out to Do

By the end of Day 3, the goals were to:

- Put an **agent** on top of the RAG accelerator service.
- Explore common **agent frameworks** (CrewAI, Langflow, LangGraph).
- Understand how to move from notebooks to **watsonx Orchestrate** for production.
- Connect the dots with **governance** and evaluation.

In other words:

> Day 1: prompts → Day 2: RAG → Day 3: agents on top of RAG → Orchestrate & governance.

---

## Morning – Agentic AI & Frameworks

We started with an overview of **Agentic AI**:

- Agents **plan, choose tools, and act**, instead of just answering once.
- Tools can be anything:
  - RAG APIs (our accelerator `/ask` endpoint).
  - Calculators and search APIs.
  - Internal systems (tickets, HR, CRM…).

We looked at four complementary frameworks:

1. **CrewAI** – multi-agent “crews” in Python.  
2. **Langflow** – drag-and-drop builder for LangChain flows.  
3. **LangGraph** – state-machine style orchestration with nodes and edges.  
4. **watsonx Orchestrate** – IBM platform for building, governing, and deploying agents.

Key takeaway: the **patterns** (tool-calling, ReAct, plan–act, multi-agent) are more important than the specific library. Once you understand the patterns, you can switch frameworks.

---

## Afternoon – Labs

### Lab 3.1: Local Agent + Accelerator API

We built a small agent in the `simple-watsonx-environment` that:

- Exposes two tools to a Granite LLM:
  - `rag_service_tool(question)` – calls the accelerator `/ask` endpoint.
  - `calculator_tool(expression)` – does safe arithmetic.
- Uses Granite as a **planner** to:
  - Decide which tool to use.
  - Call it.
  - Combine the tool result into a final answer.

We also introduced **logging** for governance:

- Question, chosen tool, tool arguments.
- Tool output summary.
- Final answer, model id, latency.

These logs can feed into:

- `notebook:Analyze_Log_and_Feedback.ipynb` in the accelerator.  
- watsonx.governance Evaluation Studio.

### Framework Demos (CrewAI / LangGraph / Orchestrate)

Depending on time and interest, we also showed how the same idea looks in:

- **CrewAI**: an agent inside a crew uses the RAG service tool and calculator.  
- **LangGraph**: a small state graph with nodes for retrieval, generation, and evaluation.  
- **watsonx Orchestrate**: agents, tools, connections, and knowledge bases defined via YAML and ADK.

You should now feel comfortable reading agent definitions in any of these styles.

---

## Bridge to Orchestrate & Governance

We then zoomed out to see how this looks in a **governed production setting**:

- The accelerator `/ask` endpoint becomes a **tool** in Orchestrate.  
- Your Lab 3.1 planner prompt maps to an Orchestrate **agent** with instructions and tools.  
- Logs feed into **Evaluation Studio** and custom notebooks.  
- Policies in **watsonx.governance** restrict which models/tools can be used and how.

Think of Orchestrate as the place where your Day 3 patterns grow up:

- Multiple agents collaborating.
- Secure connections to enterprise systems.
- Evaluations and monitoring over time.

---

## Where to Go Next

Some natural next steps:

- Turn your agent notebook into:
  - A reusable Python module.
  - A more robust FastAPI service.
- Extend the accelerator with:
  - Additional endpoints (e.g. `/batch-ask`).
  - More tools (HR APIs, ticketing, monitoring).
- Experiment with:
  - CrewAI and LangGraph implementations of the same RAG agent.
  - watsonx Orchestrate Developer Edition to host agents locally.

Finally, consider using the **Capstone Day** to:

- Pick a concrete use case (HR helper, internal FAQ bot, RAG debugger…).  
- Build a thin but real **data → RAG → agent → API/UI → evaluation** story.  
- Share it with your wider team as a blueprint.

Day 3 is the moment where all the pieces connect — from raw models, to RAG, to agents, to governed orchestration.  
Everything you build next can reuse these foundations.
