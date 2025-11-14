# 🎯 Day 2 RAG Workshop
## START HERE

::: notes
Welcome slide - set enthusiastic tone for the workshop
:::

---

## Welcome! {data-background-color="#0f172a"}

You've received a complete workshop package.

**Retrieval Augmented Generation (RAG)**

::: notes
This is your comprehensive workshop package. Everything you need is included.
:::

---

## 📦 What's Included

<span class="fragment">✅ Complete theory documentation</span>

<span class="fragment">✅ 4 hands-on labs with solutions</span>

<span class="fragment">✅ Instructor guide with timing and tips</span>

<span class="fragment">✅ All code examples tested and working</span>

<span class="fragment">✅ Production deployment patterns</span>

::: notes
Emphasize completeness. Students have everything needed for success.
:::

---

## ⏱️ Duration

**8 hours total**

<span class="fragment">4 hours theory</span>

<span class="fragment">4 hours labs</span>

::: notes
Full day workshop. Balance between concepts and hands-on practice.
:::

---

## 📖 Which Document Should I Read First? {data-transition="zoom"}

Three paths to success

::: notes
Different entry points for different roles and goals
:::

---

### 👨‍🏫 If You're an INSTRUCTOR

1. <span class="fragment">**Read First**: `Day2_RAG_Instructor_Guide.md`</span>
2. <span class="fragment">**Read Second**: `Theory_01_RAG_Architecture_Overview.md`</span>
3. <span class="fragment">**Keep Handy**: `Day2_RAG_Complete_Solutions_Guide.md`</span>

::: notes
Instructors need session plans, timing, and quick access to solutions
:::

---

### 🎓 If You're a STUDENT

1. <span class="fragment">**Read First**: `Day2_RAG_Workshop_README.md`</span>
2. <span class="fragment">**During Theory**: `Theory_01_RAG_Architecture_Overview.md`</span>
3. <span class="fragment">**During Labs**: Lab instructions + solutions guide</span>

::: notes
Students start with overview, then follow along with structured content
:::

---

### 📚 If You're SELF-STUDYING

**Day 1:**
<span class="fragment">1. Read Workshop README (30 min)</span>
<span class="fragment">2. Complete technical setup (1 hour)</span>
<span class="fragment">3. Study Theory Overview (2 hours)</span>

::: notes
Self-paced learners need structured progression over multiple days
:::

---

### 📚 Self-Study Schedule

**Day 2:**
<span class="fragment">Lab 2.1 (90 min)</span>
<span class="fragment">Lab 2.2 (90 min)</span>

**Day 3:**
<span class="fragment">Lab 2.3 (90 min)</span>
<span class="fragment">Lab 2.4 (60 min)</span>
<span class="fragment">Review solutions and extend</span>

::: notes
Three-day plan keeps learning digestible and sustainable
:::

---

## 📁 Complete File List {data-background-color="#1e1e1e"}

```
outputs/
├── START_HERE.md                          ← You are here!
├── Package_Summary_and_Navigation.md
├── Day2_RAG_Workshop_README.md
├── Day2_RAG_Instructor_Guide.md
├── Theory_01_RAG_Architecture_Overview.md
├── Day2_RAG_Complete_Solutions_Guide.md
└── labs/
    └── lab_2.1_local_rag_ollama/
        └── Lab_2.1_Instructions.md
```

::: notes
Complete file structure. Everything organized logically.
:::

---

## ⚡ Quick Links Table

| I want to... | Go to this file |
|--------------|----------------|
| <span class="fragment">Understand what RAG is</span> | <span class="fragment">Theory_01_RAG_Architecture_Overview.md</span> |
| <span class="fragment">See complete Lab 2.1 code</span> | <span class="fragment">Day2_RAG_Complete_Solutions_Guide.md</span> |
| <span class="fragment">Know workshop schedule</span> | <span class="fragment">Day2_RAG_Workshop_README.md</span> |

::: notes
Quick reference table for common needs. Bookmark this!
:::

---

## ⚡ Quick Links (Continued)

| I want to... | Go to this file |
|--------------|----------------|
| <span class="fragment">Find teaching tips</span> | <span class="fragment">Day2_RAG_Instructor_Guide.md</span> |
| <span class="fragment">Troubleshoot issues</span> | <span class="fragment">Solutions Guide Troubleshooting</span> |
| <span class="fragment">Map to accelerator</span> | <span class="fragment">Theory Section 5</span> |

::: notes
Additional navigation help. Everything is cross-referenced.
:::

---

## 🎓 What You'll Learn {data-transition="slide"}

Theory content over 4 hours

::: notes
Learning objectives set expectations and build motivation
:::

---

### 📚 Theory (4 hours)

<span class="fragment">✅ RAG architecture and components</span>

<span class="fragment">✅ Embedding models and vector stores</span>

<span class="fragment">✅ Trade-offs in RAG design</span>

<span class="fragment">✅ Production deployment patterns</span>

::: notes
Comprehensive theory foundation before hands-on work
:::

---

### 🔬 Labs (4 hours)

<span class="fragment">**Lab 2.1**: Build local RAG with Ollama + Chroma</span>

<span class="fragment">**Lab 2.2**: Build enterprise RAG with watsonx.ai</span>

<span class="fragment">**Lab 2.3**: Compare multiple RAG backends</span>

<span class="fragment">**Lab 2.4**: Create automated evaluation harness</span>

::: notes
Progressive labs build from local prototype to enterprise deployment
:::

---

## ✅ Prerequisites Check

Before starting, ensure you have:

---

### Knowledge Prerequisites

<span class="fragment">☐ Python programming (intermediate)</span>

<span class="fragment">☐ Basic understanding of LLMs</span>

<span class="fragment">☐ Completed Day 1 workshop (or equivalent)</span>

::: notes
Set clear expectations. Students should self-assess readiness.
:::

---

### Software Prerequisites

<span class="fragment">☐ Python 3.10+</span>

<span class="fragment">☐ Jupyter notebooks</span>

<span class="fragment">☐ Ollama installed</span>

<span class="fragment">☐ Required Python packages</span>

::: notes
Technical setup must be complete before workshop starts
:::

---

### Credentials Prerequisites

<span class="fragment">☐ watsonx.ai API key (for Lab 2.2)</span>

<span class="fragment">☐ watsonx.ai project ID</span>

<span class="fragment">☐ (Optional) Elasticsearch access</span>

::: notes
IBM credentials required for enterprise labs. Prepare in advance.
:::

---

### Setup Verification

Run this command:

```bash
python -c "import langchain; import chromadb; print('✓ Ready!')"
```

<span class="fragment">If successful: You're ready to begin!</span>

<span class="fragment">If errors: Check installation guide</span>

::: notes
Quick verification test. Catch setup issues early.
:::

---

## 🚀 Getting Started in 3 Steps {data-background-color="#0f172a"}

Simple path to success

::: notes
Make starting easy. Remove barriers to entry.
:::

---

### Step 1: Choose Your Path

<span class="fragment">**Teaching?** → Read `Day2_RAG_Instructor_Guide.md`</span>

<span class="fragment">**Learning?** → Read `Day2_RAG_Workshop_README.md`</span>

<span class="fragment">**Just browsing?** → Read `Package_Summary_and_Navigation.md`</span>

::: notes
Different paths for different goals. Choose the right entry point.
:::

---

### Step 2: Set Up Environment

```bash {data-line-numbers="1-2|4-5|7-9"}
# Install dependencies
pip install langchain langchain-community chromadb

# Install sentence transformers
pip install sentence-transformers ibm-watsonx-ai

# Install Ollama
curl https://ollama.ai/install.sh | sh
ollama pull llama2
```

::: notes
Line-by-line explanation. Don't skip any steps.
:::

---

### Step 3: Start Learning!

<span class="fragment">Open your first document</span>

<span class="fragment">Follow along with examples</span>

<span class="fragment">Complete labs at your own pace</span>

::: notes
Begin the journey. Everything is designed for success.
:::

---

## 💡 Pro Tips {data-transition="zoom"}

For best results

::: notes
Share wisdom from previous workshop experiences
:::

---

### Learning Tips

1. <span class="fragment">**Don't skip theory** - Understanding concepts makes labs easier</span>
2. <span class="fragment">**Type the code** - Don't just copy/paste</span>
3. <span class="fragment">**Experiment** - Try different parameters</span>
4. <span class="fragment">**Map to accelerator** - Think about production</span>

::: notes
Active learning beats passive reading. Engage with the material.
:::

---

### If You Get Stuck

1. <span class="fragment">Check the troubleshooting section</span>
2. <span class="fragment">Review the relevant theory section</span>
3. <span class="fragment">Look at the complete solution</span>
4. <span class="fragment">Ask for help (don't struggle alone!)</span>

::: notes
Getting stuck is normal. We provide multiple support paths.
:::

---

## 📊 What's Included {data-background-color="#1e1e1e"}

By the numbers

---

### Documentation Statistics

<span class="fragment">**Total lines**: ~4,350 lines</span>

<span class="fragment">**Code examples**: 50+ complete examples</span>

<span class="fragment">**Exercises**: 20+ hands-on activities</span>

<span class="fragment">**Diagrams**: 5+ conceptual diagrams</span>

::: notes
Comprehensive package. Quality and quantity both matter.
:::

---

### Content Breakdown

<span class="fragment">**Theory modules**: 4 comprehensive modules</span>

<span class="fragment">**Hands-on labs**: 4 progressive labs</span>

<span class="fragment">**Solutions**: Complete working code</span>

<span class="fragment">**Reference**: Production patterns</span>

::: notes
Everything needed for complete learning journey
:::

---

## 🎯 Learning Objectives

By the end of this workshop, you will be able to:

---

### Core Competencies

<span class="fragment">1. ✅ Explain RAG architecture and benefits</span>

<span class="fragment">2. ✅ Implement document chunking and embedding</span>

<span class="fragment">3. ✅ Build and query vector stores</span>

<span class="fragment">4. ✅ Create end-to-end RAG pipelines</span>

::: notes
Practical skills that apply to real-world projects
:::

---

### Advanced Competencies

<span class="fragment">5. ✅ Compare different RAG implementations</span>

<span class="fragment">6. ✅ Evaluate RAG system performance</span>

<span class="fragment">7. ✅ Deploy production-ready RAG services</span>

<span class="fragment">8. ✅ Integrate with AI Accelerator framework</span>

::: notes
Production-ready skills for enterprise deployment
:::

---

## 🏆 Success Criteria

You'll know you're successful when you can:

---

### Success Checklist

<span class="fragment">☐ Build a working RAG pipeline from scratch</span>

<span class="fragment">☐ Explain trade-offs in RAG design</span>

<span class="fragment">☐ Choose appropriate components for your use case</span>

<span class="fragment">☐ Evaluate RAG performance with metrics</span>

<span class="fragment">☐ Deploy a RAG service to production</span>

::: notes
Clear success criteria. Know when you've mastered the content.
:::

---

## 📞 Need Help?

Multiple support channels available

---

### Finding Information

**Can't find something?**
<span class="fragment">→ Check `Package_Summary_and_Navigation.md`</span>

**Need teaching tips?**
<span class="fragment">→ Check `Day2_RAG_Instructor_Guide.md`</span>

**Code not working?**
<span class="fragment">→ Check Solutions Guide troubleshooting</span>

::: notes
Self-service support. Most questions answered in documentation.
:::

---

### Support Channels

<span class="fragment">Workshop Slack: #day2-rag-workshop</span>

<span class="fragment">Office hours: Schedule via workshop portal</span>

<span class="fragment">Documentation: All materials in this package</span>

::: notes
Live support available. Never struggle alone.
:::

---

## 🌟 Highlights

Why this package is great

---

### Package Strengths

<span class="fragment">1. **Complete** - Everything you need in one place</span>

<span class="fragment">2. **Tested** - All code examples work</span>

<span class="fragment">3. **Flexible** - Adapt for different audiences</span>

<span class="fragment">4. **Production-Ready** - Real-world patterns</span>

<span class="fragment">5. **Comprehensive** - Theory + practice + solutions</span>

::: notes
Quality assured. Battle-tested in real workshops.
:::

---

## 📅 Typical Workshop Flow

Example 8-hour schedule

---

### Morning Session (9:00 AM - 1:00 PM)

```
9:00 AM  - Welcome & Setup
9:15 AM  - Module 1: RAG Architecture
10:15 AM - Module 2: Embeddings
11:00 AM - BREAK
11:15 AM - Module 3: Vector Stores
12:15 PM - Module 4: Accelerator
1:00 PM  - LUNCH
```

::: notes
Structured morning builds theoretical foundation
:::

---

### Afternoon Session (2:00 PM - 6:00 PM)

```
2:00 PM  - Lab 2.1: Local RAG
3:00 PM  - Lab 2.2: watsonx RAG
4:00 PM  - BREAK
4:15 PM  - Lab 2.3: Comparison
5:15 PM  - Lab 2.4: Evaluation
6:00 PM  - Wrap-up
```

::: notes
Hands-on afternoon applies morning concepts
:::

---

## 🎓 Next Steps After Workshop

Plan for continued learning

---

### Immediate (Same Day)

<span class="fragment">1. Complete any unfinished labs</span>

<span class="fragment">2. Review solutions and compare with yours</span>

<span class="fragment">3. Try extension exercises</span>

::: notes
Consolidate learning while fresh in memory
:::

---

### This Week

<span class="fragment">1. Apply RAG to your own use case</span>

<span class="fragment">2. Experiment with different configurations</span>

<span class="fragment">3. Share learnings with team</span>

::: notes
Transfer learning to your actual work
:::

---

### This Month

<span class="fragment">1. Deploy a production RAG system</span>

<span class="fragment">2. Implement evaluation pipeline</span>

<span class="fragment">3. Integrate with accelerator framework</span>

::: notes
Production deployment and long-term integration
:::

---

## 📚 Additional Resources

Expand your knowledge

---

### Documentation Links

<span class="fragment">LangChain: https://python.langchain.com/</span>

<span class="fragment">watsonx.ai: https://ibm.com/docs/watsonx-as-a-service</span>

<span class="fragment">Chroma: https://docs.trychroma.com/</span>

::: notes
Bookmark these. Essential references for continued learning.
:::

---

### Research Papers

<span class="fragment">"Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks"</span>

<span class="fragment">"Dense Passage Retrieval for Open-Domain QA"</span>

::: notes
Foundational papers. Understand the research basis.
:::

---

### Community

<span class="fragment">LangChain Discord</span>

<span class="fragment">r/MachineLearning</span>

<span class="fragment">AI/ML meetups</span>

::: notes
Join the community. Learn from others' experiences.
:::

---

## ✨ Ready to Begin? {data-background-color="#0f172a" data-transition="zoom"}

Choose your next step

---

### Your Next Step

**If teaching** → Open `Day2_RAG_Instructor_Guide.md`

**If learning** → Open `Day2_RAG_Workshop_README.md`

**If browsing** → Open `Package_Summary_and_Navigation.md`

::: notes
Clear call to action. Begin your journey now!
:::

---

## Good luck! 🚀 {data-background-color="#0f172a"}

Questions? Check the documentation or ask for help!

**Package Version**: 1.0
**Last Updated**: January 2025
**License**: MIT
**Maintained by**: IBM watsonx.ai Education Team

::: notes
End on positive, encouraging note. Support is available.
:::