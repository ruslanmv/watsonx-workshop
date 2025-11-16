# 🌉 Bridge to watsonx Orchestrate & Governance {data-background-color="#0f172a"}

::: notes
This session connects your notebook patterns to watsonx Orchestrate and governance tools, showing the path from development to production.
:::

---

## 🎯 Learning Objectives {data-transition="slide"}

<span class="fragment">Understand how **notebook patterns** translate to watsonx Orchestrate & governance tools</span>

<span class="fragment">Recognize where **policies and monitoring** fit</span>

<span class="fragment">Map your development work to **production systems**</span>

::: notes
This bridge session is crucial for understanding the production deployment path.
:::

---

## 🔗 Mapping Accelerator + Agent to Orchestrate {data-background-color="#1e3a8a"}

Think of watsonx Orchestrate as a **platform** that can host the patterns you built in notebooks

### Conceptual Mapping

<span class="fragment">`accelerator/service/api.py` → **Reusable "RAG answer" action** (tool/service)</span>

<span class="fragment">Agent notebook → **Blueprint for multi-step orchestrated workflow**</span>

::: notes
Everything you built can scale to enterprise production with the right platform.
:::

---

## Example Orchestrate Flow {data-transition="slide"}

### Workflow Steps

<span class="fragment">**1. Receive** a user request (chat, API, UI)</span>

<span class="fragment">**2. Decide** whether to:</span>

<span class="fragment">   - Call the **RAG service** (accelerator `/ask` endpoint)</span>

<span class="fragment">   - Call a **calculator** or other utility tool</span>

<span class="fragment">   - **Escalate to a human** (handoff/ticket)</span>

<span class="fragment">**3. Log** all steps and outcomes for governance</span>

::: notes
This is a typical production agent workflow with proper governance.
:::

---

## In Orchestrate Terms {data-transition="fade"}

<span class="fragment">**Agent** = Top-level orchestrator that plans and delegates</span>

<span class="fragment">**Tools** = Your APIs (RAG, calculator, external systems)</span>

<span class="fragment">**Connections** = How tools authenticate to external services</span>

<span class="fragment">**Knowledge bases** = RAG-ready corpora defined in Orchestrate</span>

::: notes
These concepts map directly to what you've been building.
:::

---

## ⚖️ Governance & Evaluation {data-background-color="#064e3b"}

watsonx.governance adds a layer of **control and insight** over your agents and models

::: notes
Governance isn't just compliance - it's about making your AI systems better and more trustworthy.
:::

---

## Model & Asset Catalog {data-transition="slide"}

<span class="fragment">**Track** which models, prompts, tools, and agents exist</span>

<span class="fragment">**Versioning** and metadata</span>

<span class="fragment">**Lineage** - What depends on what?</span>

::: notes
The catalog gives you visibility into all your AI assets.
:::

---

## Policies {data-transition="fade"}

<span class="fragment">**Allowed models** / endpoints</span>

<span class="fragment">**Risk profiles** and approval workflows</span>

### Example Policy

<span class="fragment">"Customer-facing agents may only use models with a given **risk rating**"</span>

::: notes
Policies enforce organizational standards and compliance requirements.
:::

---

## Evaluation Studio {data-transition="slide"}

<span class="fragment">Run **experiments** on your agents/RAG flows</span>

<span class="fragment">**Compare** LLMs, prompts, retrieval strategies</span>

<span class="fragment">Track **metrics** like:</span>

<span class="fragment">  - Faithfulness</span>

<span class="fragment">  - Answer relevance</span>

<span class="fragment">  - Content safety</span>

::: notes
Evaluation Studio enables systematic improvement of your AI systems.
:::

---

## Monitoring {data-transition="fade"}

<span class="fragment">Track **runs and metrics** over time</span>

<span class="fragment">Detect **drift or degradation**</span>

<span class="fragment">Investigate **failures and edge-cases**</span>

::: notes
Continuous monitoring catches problems before users do.
:::

---

## 📓 Using Existing Notebooks as a Bridge {data-background-color="#7c2d12"}

You already have governance-related notebooks in `labs-src` and `accelerator`:

::: notes
These notebooks show you how to bridge from development to governed production.
:::

---

## Governance Notebook 1 {data-transition="slide"}

### `ibm-watsonx-governance-governed-agentic-catalog.ipynb`

Shows how to:

<span class="fragment">**Register** models & tools in a governed catalog</span>

<span class="fragment">**Create and use** governed tools (PII detectors, jailbreak detectors)</span>

::: notes
This notebook demonstrates the catalog and policy features.
:::

---

## Governance Notebook 2 {data-transition="fade"}

### `ibm-watsonx-governance-evaluation-studio-getting-started.ipynb`

Shows how to:

<span class="fragment">Define **evaluation datasets**</span>

<span class="fragment">Compute **metrics**: context relevance, faithfulness, answer relevance</span>

::: notes
This notebook shows systematic evaluation of your AI systems.
:::

---

## Governance Notebook 3 {data-transition="slide"}

### `accelerator/assets/notebook/notebook:Analyze_Log_and_Feedback.ipynb`

Concrete example of:

<span class="fragment">**Pulling logs** from a deployed service</span>

<span class="fragment">**Analyzing quality** and user feedback</span>

<span class="fragment">**Bridging logs** → evaluation datasets</span>

::: notes
This notebook shows the complete feedback loop from production to improvement.
:::

---

## Your Path Forward {data-transition="fade"}

Your Day 3 agent logs can be fed into these notebooks as a **first step** towards full governance

::: notes
Everything connects: development → logs → evaluation → improvement → production.
:::

---

## 📊 From Logs to Governance {data-background-color="#1e3a8a"}

### Where Do Logs Come From?

<span class="fragment">`rag/pipeline.py` - Retrieval and model calls</span>

<span class="fragment">`service/api.py` - User requests, status codes, errors</span>

<span class="fragment">Agent notebook (Lab 3.1) - Tool choices, planner outputs, tool responses</span>

::: notes
Comprehensive logging is the foundation of governance.
:::

---

## What to Do with Logs {data-transition="slide"}

These logs can be:

<span class="fragment">**1. Exported** periodically as CSV/JSON</span>

<span class="fragment">**2. Loaded** into:</span>

<span class="fragment">   - Evaluation Studio datasets</span>

<span class="fragment">   - Analysis notebooks (`Analyze_Log_and_Feedback.ipynb`)</span>

::: notes
Logs are data. Treat them as a valuable asset for improvement.
:::

---

## Governance Workflows {data-transition="fade"}

Governance workflows can then:

<span class="fragment">**Detect drift** in answer quality</span>

<span class="fragment">**Enforce thresholds**: "If faithfulness < 0.8, flag for review"</span>

<span class="fragment">**Support audit trails**: "Which tools and models were used?"</span>

::: notes
Governance enables both compliance and continuous improvement.
:::

---

## 🎯 Example Use Cases {data-background-color="#064e3b"}

Concrete patterns where orchestrate + governance shine:

::: notes
Let's look at real-world scenarios where this all comes together.
:::

---

## Use Case 1: Governed HR Assistant {data-transition="slide"}

<span class="fragment">Uses **RAG** over HR policies</span>

<span class="fragment">Tools for detecting **PII** and **harmful content**</span>

<span class="fragment">**Governed** model + tool catalog and metrics</span>

<span class="fragment">**Audit trail** for compliance</span>

::: notes
HR is a perfect use case for governed AI - high stakes, regulatory requirements.
:::

---

## Use Case 2: Customer Support Bot {data-transition="fade"}

<span class="fragment">Agent **routes** between FAQ RAG, ticket creation, and human handoff</span>

<span class="fragment">Governance **monitors** answer relevance and safety</span>

<span class="fragment">**Feedback loop** for continuous improvement</span>

::: notes
Customer support benefits from both automation and quality control.
:::

---

## Use Case 3: Internal Knowledge Bot {data-transition="slide"}

<span class="fragment">**Weekly evaluation** runs on a curated question set</span>

<span class="fragment">Results feed into **prompt/model/index improvements**</span>

<span class="fragment">**Drift detection** alerts when quality degrades</span>

::: notes
Internal knowledge bots need continuous improvement to stay useful.
:::

---

## 🚀 How to Go from Lab to Production {data-background-color="#1e3a8a"}

From Day 3 notebooks to real systems:

::: notes
Here's the practical path from prototype to production.
:::

---

## Extract the Best Patterns {data-transition="slide"}

<span class="fragment">**From**: `agent_watsonx.ipynb` (agent loop + tools)</span>

<span class="fragment">**From**: `accelerator` service (RAG microservice)</span>

<span class="fragment">**From**: Governance notebooks (evaluation + catalog)</span>

::: notes
Your lab work contains all the patterns you need for production.
:::

---

## Embed in Delivery Pipeline {data-transition="fade"}

<span class="fragment">Use `Makefile` / `pyproject.toml` / Dockerfiles to **package** the accelerator</span>

<span class="fragment">**Deploy** accelerator API behind a stable endpoint</span>

<span class="fragment">**Register** it as a tool/connection in Orchestrate</span>

::: notes
Modern DevOps practices apply to AI systems too.
:::

---

## Connect to Governance {data-transition="slide"}

<span class="fragment">Ensure **models and agents** are registered in the catalog</span>

<span class="fragment">Route **logs** to Evaluation Studio or custom analysis</span>

<span class="fragment">Implement **policies** and approval workflows</span>

::: notes
Governance should be built in from the start, not bolted on later.
:::

---

## 💭 Discussion Prompts {data-background-color="#7c2d12"}

To close the session, consider:

<span class="fragment">Where would you use **orchestration** and **governance** in your organization?</span>

<span class="fragment">Which components from this workshop are **closest to your production needs**?</span>

<span class="fragment">What would you need to:</span>

<span class="fragment">  - Onboard **your own data**?</span>

<span class="fragment">  - Apply **your internal policies**?</span>

<span class="fragment">  - Connect to **your existing IT systems**?</span>

::: notes
Capture these ideas - they're great seeds for the capstone day and follow-up projects.
:::

---

## 🎯 Summary {data-background-color="#0f172a"}

### Key Takeaways

<span class="fragment">Your **notebook patterns** → watsonx Orchestrate **platform patterns**</span>

<span class="fragment">**Governance** adds control, insight, and continuous improvement</span>

<span class="fragment">**Path to production**: Extract patterns → Package → Deploy → Govern</span>

<span class="fragment">**Real use cases** need both automation and quality control</span>

---

## Navigation & Next Steps {data-background-color="#064e3b"}

### 🏠 Workshop Portal

**[Workshop Home](https://ruslanmv.com/watsonx-workshop/portal/)** | **[Day 3 Overview](../../portal/day3-portal.md)**

### Related Content

<span class="fragment">← [Agentic AI Overview](./agentic-ai-overview.md)</span>
<span class="fragment">← [CrewAI Framework](./agentic-frameworks-crewai.md)</span>
<span class="fragment">← [Langflow Framework](./agentic-frameworks-langflow.md)</span>
<span class="fragment">← [LangGraph Framework](./agentic-frameworks-langgraph.md)</span>

### Resources

<span class="fragment">📚 watsonx.ai: https://www.ibm.com/products/watsonx-ai</span>
<span class="fragment">⚖️ watsonx.governance: https://www.ibm.com/products/watsonx-governance</span>
<span class="fragment">🔧 watsonx Orchestrate: https://www.ibm.com/products/watsonx-orchestrate</span>

**Version:** 1.0 | **Updated:** January 2025

::: notes
The bridge from development to production is clear. You have all the pieces!
:::