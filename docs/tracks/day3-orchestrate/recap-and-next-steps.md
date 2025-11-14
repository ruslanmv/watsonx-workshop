# 🎯 Recap & Next Steps {data-background-color="#0f172a"}

## 2-Hour Interactive Discussion Session

::: notes
This is a 2-hour interactive recap and discussion to consolidate learning and plan next steps. Make it conversational and collaborative!
:::

---

## 📋 Session Overview {data-transition="slide"}

<span class="fragment">**Part 1** - Timeline Recap (20 min)</span>

<span class="fragment">**Part 2** - Group Reflection (30 min)</span>

<span class="fragment">**Part 3** - Open Q&A & Troubleshooting (40 min)</span>

<span class="fragment">**Part 4** - From Workshop to Real Projects (20 min)</span>

<span class="fragment">**Part 5** - Suggested Next Steps (10 min)</span>

::: notes
This structure ensures we cover both technical and strategic topics.
:::

---

## 🗺️ Part 1: Timeline Recap {data-background-color="#1e3a8a"}

Walk through the workshop story:

::: notes
Let's trace the journey from Day 0 to Day 3.
:::

---

## Day 0: Environment Setup {data-transition="slide"}

<span class="fragment">**Two env repos**: Ollama + watsonx</span>

<span class="fragment">**accelerator** repo</span>

<span class="fragment">**labs-src** reference notebooks</span>

::: notes
The foundation - getting all the tools and environments ready.
:::

---

## Day 1: LLM Basics & Prompting {data-transition="fade"}

<span class="fragment">**Prompt patterns** and reliability</span>

<span class="fragment">**Compare** local vs hosted models (Ollama vs watsonx)</span>

<span class="fragment">**Foundation** for everything that followed</span>

::: notes
Understanding how to work with LLMs is essential for everything else.
:::

---

## Day 2: RAG {data-transition="slide"}

<span class="fragment">**Local RAG notebooks** (Ollama + Chroma)</span>

<span class="fragment">**RAG notebooks** in labs-src (Elasticsearch, Chroma, Granite)</span>

<span class="fragment">**Accelerator** ingestion + retriever + pipeline skeleton</span>

<span class="fragment">Built a **production-like RAG service**</span>

::: notes
Day 2 was all about turning documents into answers.
:::

---

## Day 3: Orchestration & Agents {data-transition="fade"}

<span class="fragment">**Agent notebook** calling the accelerator API</span>

<span class="fragment">**Accelerator API** & (optional) Streamlit UI</span>

<span class="fragment">**Governance & Orchestrate** notebooks</span>

<span class="fragment">**Path to production** with watsonx platform</span>

::: notes
Day 3 brought it all together - agents using RAG as a tool.
:::

---

## 💬 Part 2: Group Reflection {data-background-color="#064e3b"}

### Suggested Questions

Let's discuss as a group:

::: notes
Open the floor for honest discussion and feedback.
:::

---

## Reflection Question 1 {data-transition="slide"}

### What was most surprising across the three days?

<span class="fragment">Share your "aha" moments</span>

::: notes
Instructor: Give people time to think and respond. Encourage sharing.
:::

---

## Reflection Question 2 {data-transition="fade"}

### What were the hardest parts of the labs?

<span class="fragment">Where did you hit friction with:</span>

<span class="fragment">  - **Environments**?</span>

<span class="fragment">  - **Libraries / SDKs**?</span>

<span class="fragment">  - **Conceptual pieces** (RAG, agents, governance)?</span>

::: notes
Understanding pain points helps improve future workshops.
:::

---

## Reflection Question 3 {data-transition="slide"}

### What are you most excited to try next?

<span class="fragment">Which techniques or tools resonated most?</span>

::: notes
Capture answers on a shared board or document.
:::

---

## 🔧 Part 3: Open Q&A & Troubleshooting {data-background-color="#7c2d12"}

Use this time to address remaining technical issues:

::: notes
This is hands-on problem-solving time. Be ready to debug!
:::

---

## Common Issue 1: Ollama / watsonx Environments {data-transition="slide"}

<span class="fragment">**Model loading** issues</span>

<span class="fragment">**API keys** and authentication</span>

<span class="fragment">**Network** connectivity</span>

::: notes
Walk through any unresolved environment issues together.
:::

---

## Common Issue 2: Accelerator Service {data-transition="fade"}

<span class="fragment">**`/ask` endpoint** behavior</span>

<span class="fragment">**Vector DB** connectivity</span>

<span class="fragment">**Logging & configuration**</span>

::: notes
The accelerator is the heart of the system - make sure it works!
:::

---

## Common Issue 3: Agent Notebooks {data-transition="slide"}

<span class="fragment">**Tool selection** logic</span>

<span class="fragment">**JSON formatting** issues</span>

<span class="fragment">**Error handling**</span>

::: notes
Encourage participants to share their code and walk through solutions live.
:::

---

## 🚀 Part 4: From Workshop to Real Projects {data-background-color="#1e3a8a"}

How to turn the accelerator into something "real":

::: notes
Let's talk about the path from prototype to production.
:::

---

## Production Microservice {data-transition="slide"}

<span class="fragment">**Hardened FastAPI app**</span>

<span class="fragment">**Config** via `service/deps.py` and environment variables</span>

<span class="fragment">**Health checks**, observability, logging</span>

<span class="fragment">**Error handling** and retries</span>

::: notes
Production services need more than just working code.
:::

---

## Scalable Ingestion Pipeline {data-transition="fade"}

<span class="fragment">**Batch** extraction / chunking / embedding</span>

<span class="fragment">**Scheduling** (nightly or event-driven)</span>

<span class="fragment">**Monitoring** index size and freshness</span>

<span class="fragment">**Incremental updates** vs full rebuilds</span>

::: notes
Ingestion isn't one-and-done - it needs to be a maintained pipeline.
:::

---

## Integration & Deployment {data-transition="slide"}

<span class="fragment">**CI/CD pipelines** using Makefile, pyproject.toml, Dockerfiles</span>

<span class="fragment">**Deployment targets**: Kubernetes / OpenShift / Cloud Foundry / VM</span>

<span class="fragment">**Governance and evaluation** workflows with watsonx.governance</span>

::: notes
Modern deployment practices apply to AI systems.
:::

---

## 📚 Part 5: Suggested Next Steps {data-background-color="#064e3b"}

Potential directions for deeper dives:

::: notes
Here are concrete next steps you can take after the workshop.
:::

---

## Next Step 1: Retrieval & Ranking {data-transition="slide"}

<span class="fragment">**Hybrid search** (lexical + semantic)</span>

<span class="fragment">**Rerankers** and scoring strategies in `retriever.py`</span>

<span class="fragment">**Query expansion** and reformulation</span>

::: notes
Better retrieval directly improves answer quality.
:::

---

## Next Step 2: Prompting & Safety {data-transition="fade"}

<span class="fragment">**Advanced prompt** strategies in `prompt.py`</span>

<span class="fragment">**Safety / refusal** patterns and guardrails</span>

<span class="fragment">**Structured outputs** with JSON schema</span>

::: notes
Prompt engineering is an ongoing skill to develop.
:::

---

## Next Step 3: Multi-Tenancy {data-transition="slide"}

<span class="fragment">**Tenant-aware** configuration in `service/deps.py`</span>

<span class="fragment">**Per-tenant** indices and model settings</span>

<span class="fragment">**Access control** and data isolation</span>

::: notes
Multi-tenancy is essential for SaaS deployments.
:::

---

## Next Step 4: UI & UX {data-transition="fade"}

<span class="fragment">**Richer Streamlit UI** (`ui/app.py`)</span>

<span class="fragment">**Conversation history**, feedback buttons</span>

<span class="fragment">**Source highlighting** and citations</span>

<span class="fragment">**Chat experience** optimization</span>

::: notes
Great UX makes your AI system actually useful.
:::

---

## 📖 Resources {data-background-color="#1e3a8a"}

Pointers to:

<span class="fragment">**Internal docs** and repos</span>

<span class="fragment">**IBM public samples** (`labs-src`, GitHub repos)</span>

<span class="fragment">**Governance and Orchestrate** documentation</span>

<span class="fragment">**Community** forums and Discord</span>

::: notes
Learning doesn't stop here - use these resources to keep growing.
:::

---

## 📋 Optional: Feedback Form {data-transition="slide"}

Share a link or QR code to a short survey covering:

<span class="fragment">**Overall satisfaction**</span>

<span class="fragment">**Clarity** of explanations</span>

<span class="fragment">**Lab difficulty**</span>

<span class="fragment">**Topics** you want more of</span>

::: notes
Use this feedback to plan the capstone day and any follow-up sessions.
:::

---

## 🎯 Final Thoughts {data-background-color="#0f172a"}

### The Journey

<span class="fragment">**Day 0-1**: Foundation - LLMs and prompting</span>

<span class="fragment">**Day 2**: RAG - Turning documents into knowledge</span>

<span class="fragment">**Day 3**: Agents - Adding reasoning and action</span>

<span class="fragment">**Beyond**: Production - Scaling with governance</span>

::: notes
You've come a long way in three days!
:::

---

## 🚀 You're Ready {data-transition="zoom"}

### What You've Learned

<span class="fragment">How to build **RAG systems** from scratch</span>

<span class="fragment">How to create **agents** that use tools</span>

<span class="fragment">How to connect to **watsonx** for production</span>

<span class="fragment">How to add **governance** and monitoring</span>

### What's Next

<span class="fragment">**Build** something for your organization</span>

<span class="fragment">**Share** what you've learned with your team</span>

<span class="fragment">**Stay connected** - keep learning and improving</span>

::: notes
The workshop may be ending, but your AI journey is just beginning. Go build amazing things!
:::

---

## 🙏 Thank You! {data-background-color="#0f172a" data-transition="zoom"}

### Questions?

Open floor for final questions and discussion

::: notes
End on a high note. Congratulate everyone on completing the workshop!
:::