# 🚀 Day 1 – LLMs & Prompting

Workshop Materials Overview

Welcome to Day 1 of the watsonx Workshop!

::: notes
This is a navigation deck for students to understand what materials are available and how to use them.
:::

---

## 📚 Quick Start {data-background-color="#0f172a"}

Three steps to success

::: notes
Keep it simple. Students should know exactly what to do first.
:::

---

## 🌅 Step 1: Theory First (Morning, 4 hours)

<span class="fragment">📖 Read `llm-concepts.md`</span>

<span class="fragment">📖 Read `prompt-patterns-theory.md`</span>

<span class="fragment">📖 Read `eval-safety-theory.md`</span>

::: notes
Theory builds the mental models. Don't skip it, even if you're experienced with LLMs.
:::

---

## 🧪 Step 2: Labs Second (Afternoon, 4 hours)

<span class="fragment">🔬 Follow `lab-1-quickstart-two-envs.md`</span>

<span class="fragment">🔬 Follow `lab-2-prompt-templates.md`</span>

<span class="fragment">🔬 Follow `lab-3-micro-eval.md`</span>

::: notes
Labs are sequential. Complete them in order for best results.
:::

---

## 📋 Step 3: Reference

<span class="fragment">📘 See `day1-summary-and-schedule.md` for complete overview</span>

::: notes
The summary document is comprehensive. Use it as a reference throughout the day.
:::

---

## 📁 File Structure {data-transition="zoom"}

How materials are organized

::: notes
Understanding the structure helps students navigate efficiently.
:::

---

## 🗂️ Directory Layout

```
day1-llm/
├── README.md (this file)
├── day1-summary-and-schedule.md
│
├── Theory (Morning)
│   ├── llm-concepts.md
│   ├── prompt-patterns-theory.md
│   └── eval-safety-theory.md
│
├── Lab Instructions (Afternoon)
│   ├── lab-1-quickstart-two-envs.md
│   ├── lab-2-prompt-templates.md
│   └── lab-3-micro-eval.md
│
└── Notebooks (Created by you during labs)
    ├── ollama_quickstart.ipynb
    ├── watsonx_quickstart.ipynb
    ├── prompt_patterns_ollama.ipynb
    ├── prompt_patterns_watsonx.ipynb
    └── micro_evaluation.ipynb
```

::: notes
Theory docs are reference material. Lab docs are step-by-step guides. Notebooks are what you build.
:::

---

## 🎯 Learning Objectives {data-background-color="#1e293b"}

What you'll master today

::: notes
Clear objectives help students track progress and understand success criteria.
:::

---

## 📖 Theory Modules

### 1.0 LLM Concepts

<span class="fragment">✅ Understand tokens, context windows, key parameters</span>

<span class="fragment">✅ Compare local vs managed deployments</span>

<span class="fragment">✅ Learn cost and resource considerations</span>

<span class="fragment">✅ See how LLMs fit in production architecture</span>

::: notes
Foundational concepts. These apply to all LLM work, not just this workshop.
:::

---

## 📖 Theory Modules

### 1.2 Prompt Patterns

<span class="fragment">✅ Master common prompt patterns</span>

<span class="fragment">✅ Learn prompt design principles</span>

<span class="fragment">✅ Create reusable templates</span>

<span class="fragment">✅ Understand accelerator prompt structure</span>

::: notes
Prompt engineering is both art and science. These patterns are proven best practices.
:::

---

## 📖 Theory Modules

### 1.3 Evaluation & Safety

<span class="fragment">✅ Know why evaluation matters</span>

<span class="fragment">✅ Understand evaluation signals</span>

<span class="fragment">✅ Learn safety considerations</span>

<span class="fragment">✅ Design production monitoring</span>

::: notes
Evaluation and safety aren't optional. They're essential for responsible AI.
:::

---

## 🧪 Lab Modules

### Lab 1.1: Quickstart (45 min)

<span class="fragment">🎯 Run first prompts in Ollama and watsonx.ai</span>

<span class="fragment">🎯 Modify parameters (temperature, max_tokens)</span>

<span class="fragment">🎯 Compare outputs and latency</span>

::: notes
First hands-on experience. Students gain confidence working with both environments.
:::

---

## 🧪 Lab Modules

### Lab 1.2: Prompt Templates (60 min)

<span class="fragment">🎯 Build reusable templates</span>

<span class="fragment">🎯 Implement in both environments</span>

<span class="fragment">🎯 Run comparative experiments</span>

::: notes
Templates are production patterns. This lab teaches scalable practices.
:::

---

## 🧪 Lab Modules

### Lab 1.3: Micro-Evaluation (60 min)

<span class="fragment">🎯 Create test set of prompts</span>

<span class="fragment">🎯 Apply rating rubric</span>

<span class="fragment">🎯 Analyze results with pandas and visualizations</span>

::: notes
Evaluation is critical for production. This lab builds a complete evaluation pipeline.
:::

---

## ✅ Prerequisites {data-background-color="#0f172a"}

What you need before Day 1

::: notes
Don't start without these. Fix setup issues on Day 0, not Day 1.
:::

---

## 📋 Required Setup

<span class="fragment">✅ Complete Day 0 (environment setup)</span>

<span class="fragment">✅ `simple-ollama-environment` working</span>

<span class="fragment">✅ `simple-watsonx-enviroment` with valid credentials</span>

<span class="fragment">✅ Jupyter accessible in both environments</span>

::: notes
All of these should be done on Day 0. Day 1 assumes working environments.
:::

---

## 📅 Workshop Flow {data-transition="zoom"}

The rhythm of the day

::: notes
Understanding the flow helps students pace themselves and manage energy.
:::

---

## ⏰ Daily Schedule

```
Morning (Theory)
├── 9:00-10:30   │ 1.0 LLM Concepts
├── 10:30-10:45  │ Break
├── 10:45-11:45  │ 1.2 Prompt Patterns
├── 11:45-12:00  │ Q&A
└── 12:00-13:00  │ Lunch

Afternoon (Labs)
├── 13:00-13:45  │ Lab 1.1: Quickstart
├── 13:45-14:45  │ Lab 1.2: Templates
├── 14:45-15:00  │ Break
├── 15:00-16:00  │ Lab 1.3: Evaluation
├── 16:00-16:30  │ 1.3 Evaluation Theory
└── 16:30-17:00  │ Wrap-up & Q&A
```

::: notes
Breaks are intentional. Don't skip them. They improve retention and prevent burnout.
:::

---

## 🔑 Key Concepts {data-background-color="#1e293b"}

Core ideas you'll encounter repeatedly

::: notes
These concepts appear throughout the day. Understand them early for maximum benefit.
:::

---

## 🪙 Tokens

<span class="fragment">📏 Sub-units of text (~4 chars/token in English)</span>

<span class="fragment">🪟 Models have token limits (context windows)</span>

<span class="fragment">💰 Costs calculated per token</span>

::: notes
Token limits are hard constraints. Always be aware of token counts when working with LLMs.
:::

---

## 🌡️ Temperature

<span class="fragment">❄️ `0.0` = Deterministic, focused</span>

<span class="fragment">🌤️ `0.7-1.0` = Balanced creativity</span>

<span class="fragment">🔥 `1.5+` = Very creative, less predictable</span>

::: notes
Temperature is one of the most important parameters. You'll experiment with it extensively in labs.
:::

---

## 🎨 Prompt Patterns

<span class="fragment">1️⃣ **Instruction**: Direct command</span>

<span class="fragment">2️⃣ **Few-shot**: Examples before task</span>

<span class="fragment">3️⃣ **Chain-of-thought**: Step-by-step reasoning</span>

<span class="fragment">4️⃣ **Style transfer**: Rewrite in different tone</span>

<span class="fragment">5️⃣ **Summarization**: Condense content</span>

::: notes
Five fundamental patterns. Master these and you can handle most prompting scenarios.
:::

---

## 📊 Evaluation

<span class="fragment">✅ **Correctness**: Matches ground truth?</span>

<span class="fragment">✅ **Coherence**: Logical and relevant?</span>

<span class="fragment">✅ **Style**: Follows format?</span>

<span class="fragment">✅ **Latency**: Fast enough?</span>

::: notes
These evaluation signals provide comprehensive quality assessment.
:::

---

## 📦 Deliverables {data-background-color="#0f172a"}

What you'll have by end of day

::: notes
Tangible artifacts prove learning and provide future reference.
:::

---

## ✅ Your Deliverables

<span class="fragment">📘 5 working Jupyter notebooks</span>

<span class="fragment">🎨 Reusable prompt templates</span>

<span class="fragment">📊 Evaluation results (CSV + visualizations)</span>

<span class="fragment">🧠 Understanding of LLM fundamentals</span>

::: notes
These aren't just exercises. They're production-ready patterns you can use immediately.
:::

---

## 🚧 Common Issues & Solutions {: #troubleshooting data-transition="zoom" }

Problems you might encounter

::: notes
Everyone hits these issues. Having solutions ready prevents frustration.
:::

---

## 🔧 Ollama Issues

**Problem**: Connection refused

**Solution**:
```bash
curl http://localhost:11434/api/tags
ollama serve
```

**Problem**: Model not found

**Solution**:
```bash
ollama pull qwen2.5:0.5b-instruct
```

::: notes
Most Ollama problems are service not running or model not pulled. Quick fixes.
:::

---

## 🔧 watsonx Issues

**Problem**: Invalid API key

**Solution**:
- Check `.env` file
- Verify key in IBM Cloud console
- Ensure no extra spaces

**Problem**: Rate limit

**Solution**:
- Add delays (`time.sleep(0.5)`)

::: notes
Credential issues are most common. Double-check .env formatting—no quotes, no extra whitespace.
:::

---

## 🔧 General Issues

**Problem**: Wrong Python kernel

**Solution**:
- Select correct kernel in Jupyter
- Kernel → Change Kernel → Python 3.11

::: notes
This is easy to miss but causes confusion. Always verify kernel is correct.
:::

---

## 💡 Tips for Success {data-background-color="#1e293b"}

How to get the most out of Day 1

::: notes
These tips come from experience teaching this workshop many times.
:::

---

## 📖 Theory Sessions

<span class="fragment">✅ Take notes on key concepts</span>

<span class="fragment">✅ Ask questions when unclear</span>

<span class="fragment">✅ Relate concepts to your use cases</span>

::: notes
Active engagement improves retention. Don't passively consume—actively participate.
:::

---

## 🧪 Lab Sessions

<span class="fragment">✅ Follow instructions step-by-step</span>

<span class="fragment">✅ Experiment beyond the examples</span>

<span class="fragment">✅ Document interesting findings</span>

<span class="fragment">✅ Help peers when possible</span>

::: notes
Labs are for exploration. Don't just copy-paste code. Understand what it does and why.
:::

---

## ⏰ Time Management

<span class="fragment">✅ Don't get stuck on one issue too long</span>

<span class="fragment">✅ Ask for help after 5-10 minutes</span>

<span class="fragment">✅ Labs build on each other—complete in order</span>

::: notes
If stuck for more than 10 minutes, ask for help. Don't waste time struggling alone.
:::

---

## 📚 Resources {data-background-color="#0f172a"}

For deeper learning

::: notes
These resources extend beyond the workshop. Bookmark them for future reference.
:::

---

## 📖 Documentation

<span class="fragment">📘 [IBM Granite Models](https://www.ibm.com/granite/docs)</span>

<span class="fragment">📘 [watsonx.ai Docs](https://www.ibm.com/docs/en/watsonx-as-a-service)</span>

<span class="fragment">📘 [Ollama Documentation](https://ollama.com/docs)</span>

::: notes
Official docs are always the best reference. They're comprehensive and up-to-date.
:::

---

## 📖 Prompt Engineering

<span class="fragment">📘 [OpenAI Prompt Guide](https://platform.openai.com/docs/guides/prompt-engineering)</span>

<span class="fragment">📘 [Anthropic Prompt Tips](https://docs.anthropic.com/claude/docs/prompt-engineering)</span>

<span class="fragment">📘 [Granite Prompting](https://www.ibm.com/granite/docs/models/granite/#chat-template)</span>

::: notes
Prompt engineering is a growing field. These guides are excellent starting points.
:::

---

## 🔜 Next Steps {data-transition="zoom"}

After Day 1

::: notes
Give students a sense of what comes next. Build excitement for Day 2.
:::

---

## 📅 After Day 1

<span class="fragment">1️⃣ Review your notebooks and notes</span>

<span class="fragment">2️⃣ Complete optional homework (expand test sets)</span>

<span class="fragment">3️⃣ Read ahead: Day 2 materials on RAG</span>

::: notes
Reinforcement between days improves retention. Encourage review but don't make it mandatory.
:::

---

## 📅 Day 2 Preview

Tomorrow we'll learn:

<span class="fragment">🔍 **Retrieval-Augmented Generation (RAG)**</span>

<span class="fragment">🗄️ **Vector databases** (Elasticsearch, Chroma)</span>

<span class="fragment">🎯 **Embedding models**</span>

<span class="fragment">🏗️ **Accelerator integration**</span>

::: notes
Day 2 adds the "R" to RAG. Students already know the "G" (generation) from today.
:::

---

## 💬 Getting Help {data-background-color="#1e293b"}

Where to ask questions

::: notes
Make sure students know all their support options.
:::

---

## 🆘 During Workshop

<span class="fragment">💬 Chat/Slack for questions</span>

<span class="fragment">🙋 Raise hand for blocking issues</span>

<span class="fragment">👥 Discuss with neighbors</span>

::: notes
Multiple channels for help. Use the one that's most appropriate for the situation.
:::

---

## 🆘 After Workshop

<span class="fragment">📧 Email instructors</span>

<span class="fragment">💻 GitHub issues/discussions</span>

<span class="fragment">🌐 Community forums</span>

::: notes
Support doesn't end when the workshop does. Students can reach out anytime.
:::

---

## ⭐ Feedback

Help us improve!

<span class="fragment">✅ What worked well?</span>

<span class="fragment">✅ What was confusing?</span>

<span class="fragment">✅ What would you like more/less of?</span>

<span class="fragment">✅ Suggestions for improvement?</span>

::: notes
Feedback is invaluable. It helps improve future workshops. Encourage honest, constructive feedback.
:::

---

## 🚀 Ready to Start?

Begin with `llm-concepts.md`!

::: notes
Time to dive in! Students should feel excited and prepared to start learning.
:::

---

## 📞 Questions?

For questions or issues, contact your workshop instructor.

::: notes
Final slide. Open floor for any clarification questions before starting the content.
:::