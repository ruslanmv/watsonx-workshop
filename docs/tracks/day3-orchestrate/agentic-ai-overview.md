# 🤖 Agentic AI & Orchestration Overview {data-background-color="#0f172a"}


### Tutor

**Ruslan Idelfonso Magana Vsevolodovna**  
*PhD in Physics · AI Engineer*  

📧 [contact@ruslamv.com](mailto:contact@ruslamv.com)

<p style="text-align:right; margin-top:1.5rem;">
  <img
    src="../../../themes/assets/tutor.png"
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

::: notes
Welcome to Day 3! We're shifting from simple RAG patterns to powerful agentic AI systems. Today you'll learn how to build agents that can reason, plan, and execute multi-step workflows.
:::

---

## 🎯 Learning Objectives {data-transition="slide"}

By the end of Day 3 morning theory block, you will:

<span class="fragment">**Understand agentic AI fundamentals**</span>

<span class="fragment">**Master common agent patterns**</span>

<span class="fragment">**Compare agent frameworks**</span>

<span class="fragment">**Build production-ready agents**</span>

::: notes
These objectives build on your Day 2 RAG knowledge. You'll transform your RAG accelerator into an intelligent agent that can make decisions and use tools.
:::

---

## What You'll Learn {data-transition="fade"}

<span class="fragment">Explain what **Agentic AI** is and how it differs from single-shot LLM calls</span>

<span class="fragment">Describe common **agent patterns**: tool calling, ReAct, plan-act, multi-agent, graph-based flows</span>

<span class="fragment">Map patterns onto concrete frameworks: **CrewAI**, **Langflow**, **LangGraph**, **watsonx Orchestrate**</span>

<span class="fragment">Understand how your **RAG accelerator** becomes a reusable tool for agents</span>

::: notes
Each framework has strengths. We'll explore when to use each one based on your specific requirements.
:::

---

## 🚀 What Is Agentic AI? {data-background-color="#1e3a8a"}

### Traditional LLM Usage

<span class="fragment">Prompt in → answer out</span>

<span class="fragment">Single interaction</span>

<span class="fragment">No multi-step reasoning</span>

::: notes
So far in the workshop, we've used LLMs as simple functions: ask a question, get an answer. But LLMs can do so much more.
:::

---

## Agentic AI: The Evolution {data-transition="zoom"}

### LLMs with Reasoning + Action

<span class="fragment">**Decides** which tools to use (APIs, RAG services, calculators)</span>

<span class="fragment">**Plans** a sequence of steps</span>

<span class="fragment">**Executes** tools, reads results, continues reasoning</span>

<span class="fragment">**Adapts** based on outcomes</span>

::: notes
Agentic AI transforms LLMs from answering machines into autonomous problem-solvers.
:::

---

## 🤖 What Is an Agent? {data-background-color="#064e3b"}

An **agent** is a system that:

<span class="fragment">Has a **goal** ("help user with workshop questions")</span>

<span class="fragment">Has **capabilities** (tools, collaborators, knowledge bases)</span>

<span class="fragment">Uses an **LLM for planning and reflection**</span>

<span class="fragment">Takes **autonomous actions** to achieve the goal</span>

::: notes
Think of agents as AI-powered assistants that can think through problems and take action.
:::

---

## When Is Agentic AI Powerful? {data-transition="slide"}

### Ideal Use Cases

<span class="fragment">**Multi-step workflows** (search → filter → RAG → summarize)</span>

<span class="fragment">**Integration with existing systems** (ticketing, CRM, data lakes)</span>

<span class="fragment">**Traceability requirements** (which tools used, which docs read)</span>

<span class="fragment">**Complex decision-making** (routing, escalation, approval flows)</span>

::: notes
If your use case involves any of these, you need agentic AI, not just simple RAG.
:::

---

## 🔗 Core Agent Patterns {data-background-color="#7c2d12"}

We'll refer to these patterns throughout Day 3:

<span class="fragment">1. Tool-Calling Agent</span>

<span class="fragment">2. ReAct (Reason + Act)</span>

<span class="fragment">3. Plan-Act</span>

<span class="fragment">4. Multi-Agent / Crew</span>

<span class="fragment">5. Graph-Based Agent</span>

::: notes
Understanding these patterns is key to choosing the right framework and architecture.
:::

---

## Pattern 1: Tool-Calling Agent {data-transition="slide"}

### Concept

<span class="fragment">LLM chooses **one tool** at a time based on user input</span>

<span class="fragment">Agent picks a tool, calls it, formats result back to user</span>

### Example Tools

<span class="fragment">`rag_service_tool(question)` → calls your accelerator `/ask` endpoint</span>

<span class="fragment">`calculator_tool(expression)` → safe arithmetic evaluation</span>

::: notes
This is the simplest agent pattern. Perfect for scenarios where you have a handful of distinct capabilities.
:::

---

## Pattern 2: ReAct (Reason + Act) {data-transition="fade"}

### The Loop

<span class="fragment">**Thought:** "I should call the RAG service to get context"</span>

<span class="fragment">**Action:** Use tool `rag_service_tool`</span>

<span class="fragment">**Observation:** Tool output</span>

<span class="fragment">**Repeat** until goal achieved</span>

### Used In

<span class="fragment">CrewAI, LangGraph, watsonx Orchestrate "react style"</span>

::: notes
ReAct is one of the most popular agent patterns. It makes the agent's reasoning transparent and debuggable.
:::

---

## Pattern 3: Plan-Act {data-transition="slide"}

### Two-Phase Approach

<span class="fragment">**Phase 1 - Plan:** LLM creates a sequence of steps</span>

<span class="fragment">Example: "1) Retrieve docs. 2) Summarize. 3) Run calculator. 4) Draft email"</span>

<span class="fragment">**Phase 2 - Execute:** Tools are called to fulfill the plan</span>

### Benefits

<span class="fragment">Good for longer-running workflows</span>

<span class="fragment">Enables orchestrated flows with dependencies</span>

::: notes
Plan-Act separates planning from execution, making complex workflows more manageable.
:::

---

## Pattern 4: Multi-Agent / Crew {data-background-color="#1e3a8a"}

### Architecture

<span class="fragment">Several agents with **distinct roles**</span>

<span class="fragment">Researcher, Writer, Reviewer, Ops Agent</span>

<span class="fragment">A **supervisor** (or "Crew") coordinates them</span>

### Coordination

<span class="fragment">Delegate tasks</span>

<span class="fragment">Merge answers</span>

<span class="fragment">Route to the right specialist</span>

::: notes
Multi-agent systems enable division of labor and specialization, just like human teams.
:::

---

## Pattern 5: Graph-Based Agent {data-transition="zoom"}

### Workflow as State Machine

<span class="fragment">**Nodes** = actions/tools/sub-agents</span>

<span class="fragment">**Edges** = transitions based on state or LLM decisions</span>

### Examples

<span class="fragment">LangGraph **StateGraph**</span>

<span class="fragment">watsonx Orchestrate **flows** and **styles** (planner, react)</span>

::: notes
Graph-based agents provide the most control and flexibility for complex workflows.
:::

---

## 🎨 Framework Tour {data-background-color="#581c87"}

In the morning we'll conceptually walk through four frameworks:

<span class="fragment">**CrewAI** - Multi-agent crews</span>

<span class="fragment">**Langflow** - Visual builder</span>

<span class="fragment">**LangGraph** - Graph-based orchestration</span>

<span class="fragment">**watsonx Orchestrate** - Enterprise platform</span>

::: notes
Each framework implements the patterns differently. We'll explore the mental model and use cases for each.
:::

---

## Framework 1: CrewAI {data-transition="slide"}

### What It Is

<span class="fragment">A Python library for multi-agent "crews"</span>

### Mental Model

<span class="fragment">`Agent` - role, goal, backstory, tools</span>

<span class="fragment">`Task` - what needs doing, expected output</span>

<span class="fragment">`Crew` - group of agents + tasks + process</span>

::: notes
CrewAI makes it easy to create teams of AI agents that collaborate like human teams.
:::

---

## CrewAI: Where It Shines {data-transition="fade"}

<span class="fragment">**Faster prototyping** of multi-agent patterns</span>

<span class="fragment">**Narrative workflows** (research → writing → editing)</span>

<span class="fragment">**Role-based delegation** with clear responsibilities</span>

### Workshop Angle

<span class="fragment">Single CrewAI agent using your **accelerator RAG API + calculator**</span>

::: notes
CrewAI's strength is in making multi-agent systems feel intuitive and easy to prototype.
:::

---

## Framework 2: Langflow {data-background-color="#064e3b"}

### What It Is

<span class="fragment">A **visual builder** for LangChain flows</span>

### Mental Model

<span class="fragment">**Drag-and-drop** components (LLM, retriever, tools, routers, prompts)</span>

<span class="fragment">**Connect** them as a graph</span>

<span class="fragment">**Export** to Python / JSON for production</span>

::: notes
Langflow lowers the barrier to entry for building agent systems.
:::

---

## Langflow: Where It Shines {data-transition="fade"}

<span class="fragment">**Teaching and experimentation**</span>

<span class="fragment">**Non-Python teams** can build flows</span>

<span class="fragment">**Quickly trying** different chains without coding</span>

### Workshop Angle

<span class="fragment">Visually design a **RAG + tool-calling chain** that mirrors your accelerator + agent notebook</span>

::: notes
Great for demos, teaching, and iterating on designs before committing to code.
:::

---

## Framework 3: LangGraph {data-transition="slide"}

### What It Is

<span class="fragment">A Python framework for building LLM-powered **state machines**</span>

### Mental Model

<span class="fragment">Define a `GraphState` type</span>

<span class="fragment">Add **nodes** (functions) that read & write state fields</span>

<span class="fragment">Define **edges** (flow of control)</span>

::: notes
LangGraph gives you fine-grained control over agent execution flow.
:::

---

## LangGraph: Where It Shines {data-transition="fade"}

<span class="fragment">**Complex, long-running** agent workflows</span>

<span class="fragment">**Fine-grained control** - retries, routing, timeouts</span>

<span class="fragment">**Tight integration** with LangChain and watsonx.governance Evaluator</span>

### Workshop Angle

<span class="fragment">Use LangGraph to orchestrate: **RAG retrieval node → answer generation node → evaluation**</span>

::: notes
When you need predictable, controllable workflows, LangGraph is your go-to framework.
:::

---

## Framework 4: watsonx Orchestrate {data-background-color="#1e3a8a"}

### What It Is

<span class="fragment">An **enterprise platform** to define, govern, and deploy agents</span>

### Key Concepts

<span class="fragment">Agents, tools, connections, knowledge bases, flows</span>

<span class="fragment">Local **Developer Edition** and managed IBM Cloud deployments</span>

::: notes
watsonx Orchestrate is built for production, enterprise-scale agent deployments.
:::

---

## watsonx Orchestrate: Where It Shines {data-transition="fade"}

<span class="fragment">**Production deployment**</span>

<span class="fragment">**Governance, monitoring, integration** with corporate IT systems</span>

<span class="fragment">**Policy enforcement** and audit trails</span>

### Workshop Angle

<span class="fragment">Treat your accelerator `/ask` endpoint as a **tool in Orchestrate**</span>

<span class="fragment">Recreate patterns from your Day 3 notebook as an **Orchestrate agent**</span>

::: notes
If you need enterprise-grade agents with governance, watsonx Orchestrate is the solution.
:::

---

## ⏰ Morning Flow (Approx. 4h) {data-background-color="#7c2d12"}

### Suggested Agenda

<span class="fragment">**1. Intro & recap (30-45 min)** - Why agents on top of RAG?</span>

<span class="fragment">**2. Agent patterns walkthrough (45 min)** - Tool-calling, ReAct, plan-act, multi-agent, graph-based</span>

<span class="fragment">**3. Framework lightning demos (90-120 min)** - CrewAI, Langflow, LangGraph, Orchestrate concept demos</span>

<span class="fragment">**4. Bridge to afternoon labs (15-30 min)** - How accelerator `/ask` becomes THE key tool</span>

::: notes
This structure ensures you understand the concepts before diving into hands-on labs.
:::

---

## 🔗 How This Connects to Labs {data-transition="slide"}

### Day 2 → Day 3 Bridge

<span class="fragment">Day 2 gave you a **production-like RAG service** (`/ask` endpoint)</span>

<span class="fragment">Day 3 gives you **agents** that call that service as a tool</span>

::: notes
Your RAG service is no longer the end product - it's a building block for intelligent agents.
:::

---

## Lab 3.1 Preview {data-transition="fade"}

### Local Agent in simple-watsonx-environment

<span class="fragment">Agent has **two tools**: RAG service, calculator</span>

<span class="fragment">**Planner LLM** chooses which tool to call</span>

<span class="fragment">Composes **final answer** from tool results</span>

::: notes
You'll implement the tool-calling pattern hands-on, using your Day 2 RAG service.
:::

---

## Agent Framework Flexibility {data-background-color="#064e3b"}

You can re-express the same logic in different frameworks:

<span class="fragment">**CrewAI** for Python multi-agent setups</span>

<span class="fragment">**LangGraph** for stateful workflows and evaluation</span>

<span class="fragment">**Orchestrate** for production deployment and governance</span>

::: notes
Choose the framework that matches your team's skills and production requirements.
:::

---

## 🎯 Your Mental Model {data-transition="zoom"}

By the end of Day 3:

### The Complete Journey

<span class="fragment">**Docs** → **RAG (Day 2)** → **Agent on top (Day 3)** → **Orchestrated & governed in watsonx**</span>

::: notes
This is the path from raw documents to production-grade AI systems with governance.
:::

---

## Production Best Practices {data-background-color="#0f172a"}

Real-world agent deployment

---

### Best Practice 1: Start Simple

<span class="fragment">**Begin with single-agent, single-tool**</span>

<span class="fragment">Validate the pattern works before adding complexity</span>

```python
# Simple first
agent = create_agent(tools=[rag_tool])

# Then expand
agent = create_agent(tools=[rag_tool, calculator, api_tool])
```

::: notes
Complexity compounds errors. Start simple, validate, then expand.
:::

---

### Best Practice 2: Clear Tool Descriptions

```python {data-line-numbers="1-4|6-10"}
# Bad: Vague description
@tool
def search(query: str):
    """Search"""

# Good: Specific description
@tool
def search_knowledge_base(query: str):
    """Search company knowledge base for HR policies,
    benefits, and procedures. Returns excerpts with citations."""
```

::: notes
Specific descriptions lead to better tool selection.
:::

---

### Best Practice 3: Error Handling

```python {data-line-numbers="1-10"}
def safe_agent_run(query: str, max_iterations: int = 5):
    try:
        agent_executor = AgentExecutor(
            agent=agent,
            tools=tools,
            max_iterations=max_iterations
        )
        return agent_executor.invoke({"input": query})
    except Exception as e:
        return {"error": "Agent error", "details": str(e)}
```

::: notes
Always handle timeouts, loops, and tool failures.
:::

---

## Additional Resources {data-background-color="#064e3b"}

Comprehensive learning materials

---

### Research Papers

<span class="fragment">📄 ReAct Pattern: https://arxiv.org/abs/2210.03629</span>
<span class="fragment">📄 Tool Learning: https://arxiv.org/abs/2302.04761</span>
<span class="fragment">📄 Multi-Agent: https://arxiv.org/abs/2307.07924</span>

### Framework Documentation

<span class="fragment">🔧 CrewAI: https://docs.crewai.com/</span>
<span class="fragment">📊 LangGraph: https://langchain-ai.github.io/langgraph/</span>
<span class="fragment">🎨 Langflow: https://docs.langflow.org/</span>

::: notes
Foundational resources for deep learning.
:::

---

## Navigation & Next Steps {data-background-color="#0f172a"}

Continue your journey

---

### 🏠 Workshop Portal

**[Interactive Workshop Portal](https://ruslanmv.com/watsonx-workshop/portal/)**

**[Day 3 Overview](../../portal/day3-portal.md)**

**Day 3 Theory:**
<span class="fragment">✅ Agentic AI Overview (Current)</span>
<span class="fragment">📖 [CrewAI](./agentic-frameworks-crewai.md)</span>
<span class="fragment">📖 [Langflow](./agentic-frameworks-langflow.md)</span>
<span class="fragment">📖 [LangGraph](./agentic-frameworks-langgraph.md)</span>
<span class="fragment">📖 [watsonx Bridge](./bridge-orchestrate-governance.md)</span>

::: notes
Complete Day 3 materials and navigation
:::

---

## 🚀 Summary {data-background-color="#0f172a"}

### Key Takeaways

<span class="fragment">Agentic AI adds **reasoning + action** to LLMs</span>

<span class="fragment">Five core patterns: **tool-calling, ReAct, plan-act, multi-agent, graph-based**</span>

<span class="fragment">Four frameworks: **CrewAI, Langflow, LangGraph, watsonx Orchestrate**</span>

<span class="fragment">Your **RAG accelerator** becomes a reusable tool</span>

<span class="fragment">Production path: **Docs → RAG → Agent → Orchestrated & Governed**</span>

**Version:** 1.0 | **Updated:** January 2025 | **Part of:** watsonx AI Workshop

::: notes
These concepts form the foundation for everything we'll build today. Let's dive into the frameworks!
:::