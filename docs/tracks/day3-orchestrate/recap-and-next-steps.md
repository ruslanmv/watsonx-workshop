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

---

## 🔗 Navigation & Workshop Resources {data-background-color="#0f172a"}

**Complete your watsonx journey:**

### 🏠 [Return to Workshop Home](../../README.md)
Access all workshop materials, labs, and resources

### 📚 [Review Day 1: LLM Fundamentals](../day1-llm/README.md)
Revisit prompt engineering and evaluation basics

### 📚 [Review Day 2: RAG Workshop](../day2-rag/START_HERE.md)
Explore retrieval-augmented generation concepts

### 📚 [Review Day 3: Agentic AI](./agentic-ai-overview.md)
Deep dive into agent frameworks and orchestration

### 🎯 [Capstone Project](../capstone/capstone-overview.md)
Apply everything you've learned in a final project

### 🔧 [watsonx.orchestrate Labs](./watsonx-orchestrate-labs.md)
Hands-on exercises with IBM watsonx.orchestrate

::: notes
**Instructor guidance:**
- Encourage students to bookmark these resources
- Remind them that all materials remain accessible after the workshop
- Suggest reviewing theory slides for concepts that need reinforcement
- Point out the capstone project as the ultimate application of their skills

**Post-workshop support:**
- Set up a community channel (Slack, Discord, Teams) for continued learning
- Schedule optional office hours for follow-up questions
- Share recordings and additional materials if available
- Connect students with each other for peer learning
:::

---

## 📖 Curated Learning Resources

**Continue your AI engineering journey:**

### watsonx Platform Documentation
- 📘 **[watsonx.ai Documentation](https://www.ibm.com/docs/en/watsonx-as-a-service)** – Complete platform reference
- 📘 **[watsonx.orchestrate Guide](https://www.ibm.com/docs/en/watsonx/watsonx-orchestrate)** – Agent orchestration patterns
- 📘 **[watsonx.governance Docs](https://www.ibm.com/docs/en/watsonx/watsonx-governance)** – Model risk management

### Agentic AI & Frameworks
- 🤖 **[LangGraph Documentation](https://langchain-ai.github.io/langgraph/)** – Build stateful multi-agent systems
- 🤖 **[CrewAI Guide](https://docs.crewai.com/)** – Role-based agent collaboration
- 🤖 **[LangFlow Tutorial](https://docs.langflow.org/)** – Visual agent workflow builder
- 🤖 **[AutoGen Framework](https://microsoft.github.io/autogen/)** – Multi-agent conversations

### RAG & Retrieval
- 🔍 **[Advanced RAG Techniques](https://www.promptingguide.ai/research/rag)** – State-of-the-art retrieval methods
- 🔍 **[Vector Database Comparison](https://weaviate.io/blog/vector-databases-compared)** – Choose the right vector store
- 🔍 **[Hybrid Search Guide](https://www.elastic.co/blog/improving-semantic-search-with-hybrid-search)** – Combine lexical and semantic retrieval

### Production AI & MLOps
- 🏗️ **[LLMOps Best Practices](https://www.databricks.com/blog/llm-mlops)** – Production deployment patterns
- 🏗️ **[AI Safety & Alignment](https://www.anthropic.com/index/core-views-on-ai-safety)** – Responsible AI development
- 🏗️ **[Monitoring LLM Applications](https://www.arize.com/blog/llm-monitoring)** – Observability and evaluation

::: notes
These resources represent the cutting edge of AI engineering. Students should:
- Bookmark this list for future reference
- Start with areas most relevant to their work
- Join communities around these tools and frameworks
- Contribute back to open-source projects as they gain expertise
:::

---

## 🎓 Workshop Completion Certificate

**Congratulations on completing the watsonx Workshop Series!**

You've successfully completed:
- ✅ **Day 0**: Environment Setup & Prerequisites
- ✅ **Day 1**: LLM Fundamentals, Prompting & Evaluation
- ✅ **Day 2**: Retrieval-Augmented Generation (RAG)
- ✅ **Day 3**: Agentic AI & Orchestration

<span class="fragment">**Skills Acquired:**
- Working with LLMs programmatically (Ollama & watsonx.ai)
- Designing and testing prompt templates
- Building RAG systems with vector databases
- Creating multi-agent workflows
- Implementing governance and evaluation frameworks
</span>

::: notes
**For instructors:**
If you have formal certificates to distribute:
1. Collect participant names and emails
2. Generate personalized certificates
3. Email them with workshop resources attached
4. Include LinkedIn skill endorsement suggestions:
   - Prompt Engineering
   - Large Language Models (LLM)
   - Retrieval-Augmented Generation (RAG)
   - AI Agent Development
   - IBM watsonx Platform

Consider creating a LinkedIn post template students can use to showcase their achievement!
:::

---

## 💡 Project Ideas to Apply Your Skills

**Turn your new knowledge into real-world projects:**

### Beginner Projects (Week 1-2)
<span class="fragment">📝 **Internal Knowledge Assistant** – RAG system for company documentation</span>
<span class="fragment">📧 **Email Categorization Agent** – Classify and route customer emails</span>
<span class="fragment">🔍 **Research Summarizer** – Summarize academic papers or reports</span>

### Intermediate Projects (Month 1-2)
<span class="fragment">🤖 **Customer Support Agent** – Multi-turn conversation with tool use</span>
<span class="fragment">📊 **Data Analysis Assistant** – Natural language to SQL queries</span>
<span class="fragment">🎯 **Content Recommendation System** – Personalized suggestions using RAG</span>

### Advanced Projects (Month 3+)
<span class="fragment">🏗️ **Multi-Agent Research Platform** – Agents collaborate on complex tasks</span>
<span class="fragment">🔐 **Compliance Checker** – Ensure documents meet regulatory requirements</span>
<span class="fragment">🌐 **Enterprise AI Gateway** – Unified interface for multiple LLM providers</span>

::: notes
Encourage students to:
- Start small and iterate
- Choose projects relevant to their work
- Share progress with the workshop community
- Document their journey (blog posts, GitHub repos)

Remind them that the accelerator codebase from this workshop is an excellent starting template for any of these projects!
:::

---

## 🤝 Stay Connected

**Join the community and keep learning:**

<span class="fragment">💬 **Workshop Community** – [Join our Discord/Slack](#) for continued discussions</span>

<span class="fragment">📧 **Newsletter** – Subscribe for AI engineering tips and updates</span>

<span class="fragment">🐙 **GitHub** – Star the [watsonx-workshop repo](https://github.com/ruslanmv/watsonx-workshop) and contribute improvements</span>

<span class="fragment">🐦 **Social Media** – Follow [@ruslanmv](https://twitter.com/ruslanmv) for AI insights</span>

<span class="fragment">📅 **Future Workshops** – Advanced topics and specialized deep-dives coming soon</span>

::: notes
**For instructors:**
- Set up the community platform before the workshop ends
- Send a follow-up email within 24 hours with:
  - Links to all resources
  - Community platform invitation
  - Survey for feedback
  - Certificate (if applicable)
  - Next workshop announcements

**Community building:**
- Create a dedicated channel for alumni
- Host monthly virtual meetups
- Share student success stories
- Facilitate peer-to-peer learning
:::

---

## 🎯 Your Next 30 Days Challenge

**Commit to continued growth:**

### Week 1: Consolidate
<span class="fragment">📚 Review all workshop materials and notes</span>
<span class="fragment">💻 Complete any unfinished lab exercises</span>
<span class="fragment">🔄 Refactor your code with new insights</span>

### Week 2: Build
<span class="fragment">🚀 Start a small RAG project (use workshop template)</span>
<span class="fragment">📝 Document your architecture and decisions</span>
<span class="fragment">🧪 Implement systematic evaluation</span>

### Week 3: Expand
<span class="fragment">🤖 Add an agent or tool integration</span>
<span class="fragment">📊 Create a demo presentation</span>
<span class="fragment">🎨 Improve the UI/UX</span>

### Week 4: Share
<span class="fragment">👥 Present to your team or management</span>
<span class="fragment">✍️ Write a blog post about your learning journey</span>
<span class="fragment">🌟 Contribute to the watsonx community</span>

::: notes
This 30-day challenge transforms workshop knowledge into lasting skills. Encourage students to:
- Pick a manageable scope
- Work in public (GitHub, blog posts)
- Ask for help in the community
- Celebrate small wins along the way

Consider creating a #30daychallenge hashtag for students to share progress!
:::

---

## 🚀 Final Words: You're Ready to Build

**The future of AI is being built by people like you.**

<span class="fragment">You now have the skills to:
- Build intelligent systems that augment human capabilities
- Deploy production-ready AI applications with confidence
- Evaluate and improve LLM systems systematically
- Contribute to the rapidly evolving AI ecosystem
</span>

<span class="fragment">**Remember:**
- Every expert was once a beginner
- The best way to learn is by building
- The community is here to support you
- Your unique perspective brings value to AI
</span>

<span class="fragment">**Now go build something amazing!** 🌟</span>

<div style="margin-top: 40px; text-align: center;">
<a href="../../README.md" style="padding: 10px 20px; background: #0066cc; color: white; text-decoration: none; border-radius: 5px;">🏠 Workshop Home</a>
<a href="../capstone/capstone-overview.md" style="padding: 10px 20px; background: #00aa00; color: white; text-decoration: none; border-radius: 5px; margin-left: 10px;">🎯 Capstone Project</a>
<a href="https://github.com/ruslanmv/watsonx-workshop" style="padding: 10px 20px; background: #333; color: white; text-decoration: none; border-radius: 5px; margin-left: 10px;">⭐ Star on GitHub</a>
</div>

::: notes
**Final instructor actions:**
1. Thank everyone for their participation and engagement
2. Acknowledge the effort and growth demonstrated
3. Take a group photo (if in person)
4. Share final logistics (certificates, community links, etc.)
5. Invite ongoing questions and collaboration

**Parting words:**
"Thank you for investing your time and energy in this workshop. Watching you progress from Day 0 setup through building complete AI systems has been incredibly rewarding. Remember: the skills you've gained here are in high demand, and the projects you build next could genuinely impact your organization and beyond. Stay curious, keep building, and don't hesitate to reach out. The watsonx community is here for you. Congratulations on completing this journey—now go create something extraordinary!"

**Post-workshop checklist:**
- [ ] Send follow-up email with resources
- [ ] Process feedback survey results
- [ ] Share recordings (if available)
- [ ] Update workshop materials based on feedback
- [ ] Schedule next workshop or advanced sessions
- [ ] Feature student projects in community
:::

---

## 📬 Contact & Support

**Need help or have questions?**

### Instructor Contact
**Ruslan Idelfonso Magana Vsevolodovna**
📧 [contact@ruslamv.com](mailto:contact@ruslamv.com)
💼 [LinkedIn](https://www.linkedin.com/in/ruslanmv/)
🐙 [GitHub](https://github.com/ruslanmv)

### Workshop Resources
🌐 **Workshop Repository**: [github.com/ruslanmv/watsonx-workshop](https://github.com/ruslanmv/watsonx-workshop)
📖 **Documentation**: Available in the `/docs` directory
💬 **Community**: [Discord/Slack link]

### IBM watsonx Support
🆘 **IBM Support**: [ibm.com/mysupport](https://www.ibm.com/mysupport)
📚 **watsonx Docs**: [ibm.com/docs/watsonx](https://www.ibm.com/docs/en/watsonx-as-a-service)
💡 **IBM Community**: [community.ibm.com](https://community.ibm.com/community/user/ai-datascience/home)

::: notes
Ensure students have multiple avenues for support after the workshop ends. Remind them that:
- Email is best for individual technical questions
- Community channels are great for peer learning
- GitHub issues work well for bugs or feature requests
- IBM support is available for watsonx-specific platform issues

Consider setting up a dedicated support schedule (e.g., "office hours" every other week) for the first month after the workshop.
:::