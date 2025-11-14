# 📅 Day 1 – LLMs & Prompting

Complete Workshop Guide

**Date**: Day 1 of watsonx Workshop
**Duration**: 8 hours | **Track**: Core/Granite

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
This is the master overview for instructors. Use it to stay on schedule and ensure all learning objectives are met.
:::

---

## 🗓️ Workshop Schedule {data-background-color="#0f172a"}

**Morning**: Theory (4 hours)

**Afternoon**: Labs (4 hours)

::: notes
Clear morning/afternoon split. Theory builds the foundation, labs apply it.
:::

---

## 🌅 Morning Session (4 hours) {data-transition="zoom"}

Theory and concepts

::: notes
Morning is lecture-heavy but interactive. Keep students engaged with questions and demos.
:::

---

## ⏰ Morning Schedule

| Time | Duration | Topic |
|------|----------|-------|
| 9:00 - 9:15 | 15 min | **Welcome & Setup Check** |
| 9:15 - 10:30 | 75 min | **1.0 LLM Concepts** |
| 10:30 - 10:45 | 15 min | **Break** |
| 10:45 - 11:45 | 60 min | **1.2 Prompt Patterns** |
| 11:45 - 12:00 | 15 min | **Q&A** |
| 12:00 - 1:00 | 60 min | **Lunch** |

::: notes
Stick to this schedule. The breaks are important for retention. Don't skip them.
:::

---

## 🌆 Afternoon Session (4 hours)

Hands-on labs

::: notes
Afternoon is all about practice. Students should be coding, not listening.
:::

---

## ⏰ Afternoon Schedule

| Time | Duration | Topic |
|------|----------|-------|
| 1:00 - 1:45 | 45 min | **Lab 1.1: Quickstart** |
| 1:45 - 2:45 | 60 min | **Lab 1.2: Prompt Templates** |
| 2:45 - 3:00 | 15 min | **Break** |
| 3:00 - 4:00 | 60 min | **Lab 1.3: Micro-Evaluation** |
| 4:00 - 4:30 | 30 min | **1.3 Evaluation Theory** |
| 4:30 - 5:00 | 30 min | **Day 1 Wrap-up & Q&A** |

::: notes
Labs build on each other. Students must complete Lab 1.1 before moving to 1.2.
:::

---

## 🗺️ Learning Path {data-background-color="#1e293b"}

The progression through Day 1

::: notes
Show students where they're going. The path is intentional and cumulative.
:::

---

## 📚 Learning Path Diagram

```
Day 0 (Prerequisites)
    ↓
Day 1 Morning: Theory
    → 1.0 LLM Concepts
    → 1.2 Prompt Patterns
    ↓
Day 1 Afternoon: Labs
    → Lab 1.1: Quickstart
    → Lab 1.2: Templates
    → Lab 1.3: Evaluation
    ↓
Day 2: RAG (Retrieval-Augmented Generation)
```

::: notes
This visual helps students see the big picture. Day 1 is the foundation for Day 2.
:::

---

## 📖 Materials Provided

What students have access to

::: notes
Make sure students know where to find all resources.
:::

---

## 📝 Theory Documents

<span class="fragment">**1.0** `llm-concepts.md` - Core LLM concepts</span>

<span class="fragment">**1.2** `prompt-patterns-theory.md` - Prompt engineering</span>

<span class="fragment">**1.3** `eval-safety-theory.md` - Evaluation & safety</span>

::: notes
These are reference documents. Students can return to them after the workshop.
:::

---

## 🧪 Lab Instructions

<span class="fragment">**Lab 1.1** `lab-1-quickstart-two-envs.md`</span>

<span class="fragment">**Lab 1.2** `lab-2-prompt-templates.md`</span>

<span class="fragment">**Lab 1.3** `lab-3-micro-eval.md`</span>

::: notes
Step-by-step guides. Students should follow them closely but also explore beyond the instructions.
:::

---

## 💻 Notebooks to Create

Students will build:

<span class="fragment">📘 `ollama_quickstart.ipynb`</span>

<span class="fragment">📘 `watsonx_quickstart.ipynb`</span>

<span class="fragment">📘 `prompt_patterns_ollama.ipynb`</span>

<span class="fragment">📘 `prompt_patterns_watsonx.ipynb`</span>

<span class="fragment">📘 `micro_evaluation.ipynb`</span>

::: notes
Five notebooks by day's end. These are tangible deliverables students can take with them.
:::

---

## 📚 Reference Materials

<span class="fragment">📁 `labs-src/` - Reference RAG notebooks</span>

<span class="fragment">📁 `accelerator/` - Production code structure</span>

::: notes
Students don't need to run these today, but they should know they exist for future reference.
:::

---

## 🎯 Learning Objectives by Module {data-background-color="#0f172a"}

What students will master

::: notes
Clear objectives help students track their progress and understand what success looks like.
:::

---

## 1.0 LLM Concepts

<span class="fragment">✅ Understand tokens, context windows, parameters</span>

<span class="fragment">✅ Compare local vs managed deployments</span>

<span class="fragment">✅ Know cost and resource considerations</span>

<span class="fragment">✅ Understand accelerator architecture</span>

::: notes
These are foundational concepts. Students need these to understand everything else.
:::

---

## 1.2 Prompt Patterns

<span class="fragment">✅ Recognize common prompt patterns</span>

<span class="fragment">✅ Build reusable templates</span>

<span class="fragment">✅ Apply prompt engineering principles</span>

<span class="fragment">✅ Design production prompts</span>

::: notes
Prompt engineering is both an art and a science. These objectives cover both aspects.
:::

---

## Lab 1.1: Quickstart

<span class="fragment">✅ Run prompts in Ollama and watsonx</span>

<span class="fragment">✅ Modify parameters (temperature, max_tokens)</span>

<span class="fragment">✅ Compare outputs and latency</span>

<span class="fragment">✅ Connect to accelerator</span>

::: notes
First hands-on experience. Students should gain confidence working with both environments.
:::

---

## Lab 1.2: Templates

<span class="fragment">✅ Create reusable templates</span>

<span class="fragment">✅ Implement across backends</span>

<span class="fragment">✅ Run comparative experiments</span>

<span class="fragment">✅ Plan accelerator integration</span>

::: notes
Templates are production patterns. This lab teaches scalable practices.
:::

---

## 1.3 Evaluation & Safety

<span class="fragment">✅ Understand evaluation importance</span>

<span class="fragment">✅ Know basic evaluation signals</span>

<span class="fragment">✅ Recognize safety considerations</span>

<span class="fragment">✅ Plan production monitoring</span>

::: notes
Evaluation and safety aren't optional. They're essential for responsible AI deployment.
:::

---

## Lab 1.3: Evaluation

<span class="fragment">✅ Build test sets</span>

<span class="fragment">✅ Apply rating rubrics</span>

<span class="fragment">✅ Analyze results systematically</span>

<span class="fragment">✅ Design production logging schema</span>

::: notes
This lab ties everything together. Students build a complete evaluation pipeline.
:::

---

## ✅ Prerequisites Checklist {data-background-color="#1e293b"}

Confirm before starting

::: notes
Don't proceed if prerequisites aren't met. It's better to fix issues now than struggle later.
:::

---

## 📋 Required Setup

<span class="fragment">✅ Day 0 completed</span>

<span class="fragment">✅ `simple-ollama-environment` working</span>

<span class="fragment">✅ `simple-watsonx-enviroment` with credentials</span>

<span class="fragment">✅ Jupyter accessible in both environments</span>

<span class="fragment">✅ Ollama has a model pulled</span>

<span class="fragment">✅ watsonx.ai credentials verified</span>

<span class="fragment">✅ `watsonx-workshop` repo cloned</span>

::: notes
Go through this checklist at the start of the day. Fix any issues before beginning content.
:::

---

## 🔑 Key Concepts Summary

Core concepts students must understand

::: notes
These concepts appear repeatedly throughout the day. Make sure students grasp them early.
:::

---

## 🪙 Tokens

<span class="fragment">📏 Sub-units of text that LLMs process</span>

<span class="fragment">📐 ~4 characters per token (English average)</span>

<span class="fragment">🪟 Context window = max tokens (input + output)</span>

::: notes
Token limits are hard constraints. Understanding tokenization is essential for working with LLMs.
:::

---

## 🌡️ Temperature

<span class="fragment">❄️ 0.0 = Deterministic, focused</span>

<span class="fragment">🌤️ 0.7-1.0 = Balanced</span>

<span class="fragment">🔥 1.5+ = Creative, unpredictable</span>

::: notes
Temperature is one of the most important parameters. Students will experiment with it extensively in labs.
:::

---

## 🎨 Prompt Patterns

<span class="fragment">1️⃣ **Instruction**: Direct command</span>

<span class="fragment">2️⃣ **Few-shot**: Examples before task</span>

<span class="fragment">3️⃣ **Chain-of-thought**: Step-by-step reasoning</span>

<span class="fragment">4️⃣ **Style transfer**: Rewrite in different tone</span>

<span class="fragment">5️⃣ **Summarization**: Condense content</span>

::: notes
Five fundamental patterns. Master these and you can handle 90% of prompting scenarios.
:::

---

## 📊 Evaluation Signals

<span class="fragment">1️⃣ **Correctness**: Matches ground truth?</span>

<span class="fragment">2️⃣ **Coherence**: Logical and relevant?</span>

<span class="fragment">3️⃣ **Style**: Follows format?</span>

<span class="fragment">4️⃣ **Completeness**: Addresses all parts?</span>

<span class="fragment">5️⃣ **Latency**: Fast enough?</span>

::: notes
These five signals provide comprehensive evaluation. Students will implement them all in Lab 1.3.
:::

---

## 👨‍🏫 Instructor Notes {data-background-color="#0f172a"}

Tips for successful delivery

::: notes
For instructors delivering this workshop. These tips come from experience.
:::

---

## 🌅 Morning Session Tips

<span class="fragment">📊 Use diagrams for architecture concepts</span>

<span class="fragment">💻 Live demo with watsonx Prompt Lab</span>

<span class="fragment">❓ Keep theory interactive with questions</span>

<span class="fragment">🎯 Relate concepts to students' use cases</span>

::: notes
Don't just lecture. Engage students with questions, examples, and their own experiences.
:::

---

## 🌆 Afternoon Session Tips

<span class="fragment">⏸️ Ensure all students complete Lab 1.1 before moving on</span>

<span class="fragment">🎨 Encourage creativity in template design</span>

<span class="fragment">👥 Form small groups for evaluation discussions</span>

<span class="fragment">🚶 Circulate during labs to answer questions</span>

<span class="fragment">💾 Have backup notebooks ready</span>

::: notes
Labs require active facilitation. Don't just sit at the front. Walk around and help.
:::

---

## 🚧 Common Issues

Problems you'll encounter and solutions

::: notes
Be prepared for these issues. They happen in every workshop.
:::

---

## 🔧 Issue 1: Ollama Not Running

**Symptom**: "Connection refused"

**Solution**:
```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# If not, start it
ollama serve
```

::: notes
Most common Ollama issue. Quick to diagnose and fix.
:::

---

## 🔧 Issue 2: watsonx 401 Errors

**Symptom**: "Invalid API key"

**Solution**:
- Verify credentials in `.env`
- Check for extra spaces or quotes
- Confirm API key in IBM Cloud console

::: notes
Credential issues are the #1 watsonx problem. Always double-check .env formatting.
:::

---

## 🔧 Issue 3: Rate Limits

**Symptom**: "Too many requests"

**Solution**:
- Add delays between requests (`time.sleep(0.5)`)
- Check IBM Cloud quota
- Use smaller test sets during development

::: notes
Rate limits protect the service. Students should respect them.
:::

---

## 🔧 Issue 4: Wrong Python Kernel

**Symptom**: "Module not found" errors

**Solution**:
- Select correct kernel in Jupyter
- Check: Kernel → Change Kernel → Python 3.11 (simple-env)

::: notes
This is easy to miss but causes confusion. Always verify the kernel is correct.
:::

---

## 🎯 Success Criteria {data-background-color="#1e293b"}

How to know students are on track

::: notes
Use these criteria to gauge student progress throughout the day.
:::

---

## ✅ By End of Day 1

Students should be able to:

<span class="fragment">1️⃣ **Explain** how LLMs work at a high level</span>

<span class="fragment">2️⃣ **Compare** local and managed LLM deployments</span>

<span class="fragment">3️⃣ **Write** effective prompts for different tasks</span>

<span class="fragment">4️⃣ **Build** reusable prompt templates in Python</span>

<span class="fragment">5️⃣ **Evaluate** LLM outputs systematically</span>

::: notes
If students can do these five things, Day 1 was successful.
:::

---

## ✅ Technical Deliverables

Students should have:

<span class="fragment">📘 5 working Jupyter notebooks</span>

<span class="fragment">🎨 Reusable prompt templates</span>

<span class="fragment">📊 Evaluation results (CSV + visualizations)</span>

<span class="fragment">🧠 Understanding of LLM fundamentals</span>

::: notes
These are tangible artifacts students can show to prove their learning.
:::

---

## 📚 Homework (Optional) {data-transition="zoom"}

For eager students

::: notes
Homework is optional but valuable for those who want to go deeper.
:::

---

## 🏠 Optional Assignments

<span class="fragment">1️⃣ **Expand test set**: Add 10 more diverse prompts to Lab 1.3</span>

<span class="fragment">2️⃣ **Try different models**: Ollama (`llama3.2:3b`), watsonx (other Granite variants)</span>

<span class="fragment">3️⃣ **Advanced prompting**: Implement multi-turn conversation</span>

<span class="fragment">4️⃣ **Read ahead**: Review Day 2 materials on RAG</span>

::: notes
Don't make homework mandatory. Day 1 is already full. This is for students who want more.
:::

---

## 🔗 Connections to Future Days {data-background-color="#0f172a"}

How Day 1 builds to Days 2-3

::: notes
Show students the arc. Today's learning compounds over the workshop.
:::

---

## 📅 Day 2 (RAG)

<span class="fragment">🔗 Today's prompts → prompts with retrieved context</span>

<span class="fragment">🔗 Single LLM call → retrieval + LLM pipeline</span>

<span class="fragment">🔗 Manual evaluation → automated RAG metrics</span>

::: notes
Day 2 adds retrieval to the LLM calls students learned today. The foundation stays the same.
:::

---

## 📅 Day 3 (Agents & Orchestration)

<span class="fragment">🔗 Static prompts → dynamic tool-calling prompts</span>

<span class="fragment">🔗 Single-turn → multi-turn conversations</span>

<span class="fragment">🔗 Basic evaluation → production monitoring</span>

::: notes
Day 3 adds orchestration and agents. Again, the LLM fundamentals from Day 1 remain constant.
:::

---

## 🎓 Day 1 Completion Checklist

Final check before wrapping up

::: notes
Go through this checklist with students at the end of the day.
:::

---

## ✅ Theory Attended

<span class="fragment">✅ 1.0 LLM Concepts session</span>

<span class="fragment">✅ 1.2 Prompt Patterns session</span>

<span class="fragment">✅ 1.3 Evaluation & Safety session</span>

::: notes
If students missed sessions, share the slide decks for self-study.
:::

---

## ✅ Labs Completed

<span class="fragment">✅ Lab 1.1 (Quickstart)</span>

<span class="fragment">✅ Lab 1.2 (Templates)</span>

<span class="fragment">✅ Lab 1.3 (Evaluation)</span>

::: notes
Labs build on each other. Students who didn't finish should complete them before Day 2.
:::

---

## ✅ Deliverables Created

<span class="fragment">✅ Working notebooks in both environments</span>

<span class="fragment">✅ Prompt templates created</span>

<span class="fragment">✅ Evaluation results CSV generated</span>

::: notes
These are proof of learning. Students should save them and bring them to Day 2.
:::

---

## ✅ Understanding Achieved

<span class="fragment">✅ Can explain LLM concepts</span>

<span class="fragment">✅ Can write effective prompts</span>

<span class="fragment">✅ Can evaluate LLM outputs</span>

<span class="fragment">✅ Ready for Day 2 (RAG)</span>

::: notes
If students are uncertain on any of these, spend extra time in wrap-up Q&A.
:::

---

## 🔜 Day 2 Preview {data-background-color="#1e293b"}

What's coming tomorrow

::: notes
Give students a preview to build excitement for Day 2.
:::

---

## 📅 Tomorrow's Topics

<span class="fragment">1️⃣ **Retrieval-Augmented Generation (RAG)**</span>

<span class="fragment">2️⃣ **Vector databases** (Elasticsearch, Chroma)</span>

<span class="fragment">3️⃣ **Embedding models**</span>

<span class="fragment">4️⃣ **Accelerator integration**</span>

::: notes
Day 2 adds the "R" to make RAG. Students already know the "G" (generation) part from today.
:::

---

## 📝 Prepare for Day 2 By:

<span class="fragment">📖 Reviewing today's materials</span>

<span class="fragment">🔧 Ensuring accelerator code is accessible</span>

<span class="fragment">📄 Thinking about documents you'd like to use for RAG</span>

::: notes
Preparation makes Day 2 smoother. Students should come with documents in mind for the RAG exercises.
:::

---

## 🎉 Congratulations! {data-background-color="#0f172a" data-transition="zoom"}

You've completed Day 1!

<span class="fragment">🏆 Strong foundation in LLM fundamentals</span>

<span class="fragment">🏆 Practical prompt engineering skills</span>

<span class="fragment">🏆 Evaluation frameworks</span>

<span class="fragment">🏆 Ready for Day 2!</span>

::: notes
Celebrate student success! Day 1 is intensive. They should feel proud of what they've accomplished.
:::

---

## 📚 Resources

For continued learning

::: notes
Share these resources for students who want to dive deeper.
:::

---

## 📖 Documentation

<span class="fragment">📘 [IBM Granite Models](https://www.ibm.com/granite/docs)</span>

<span class="fragment">📘 [watsonx.ai Docs](https://www.ibm.com/docs/en/watsonx-as-a-service)</span>

<span class="fragment">📘 [Ollama Docs](https://ollama.com/docs)</span>

::: notes
Official docs are always the best reference. Bookmark these.
:::

---

## 📖 Prompt Engineering

<span class="fragment">📘 [OpenAI Prompt Guide](https://platform.openai.com/docs/guides/prompt-engineering)</span>

<span class="fragment">📘 [Granite Prompting Guide](https://www.ibm.com/granite/docs/models/granite/#chat-template)</span>

::: notes
Prompt engineering is a growing field. These guides are comprehensive and well-maintained.
:::

---

## 🙏 Thank You!

See you tomorrow for Day 2!

**Questions?**

::: notes
Open the floor for final questions. Thank students for their engagement and energy throughout the day.
:::