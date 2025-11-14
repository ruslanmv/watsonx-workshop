# Day 2 RAG Workshop
## Instructor Guide & Quick Reference

---

## 🎯 Workshop Overview for Instructors {data-background-color="#0f172a"}

Your complete teaching guide

::: notes
Everything you need to deliver an excellent workshop
:::

---

### Target Audience

<span class="fragment">Software engineers with Python experience</span>

<span class="fragment">Data scientists exploring LLM applications</span>

<span class="fragment">AI engineers building production systems</span>

<span class="fragment">Technical professionals interested in RAG</span>

::: notes
Diverse audience. Adjust pace and depth accordingly.
:::

---

### Prerequisites Check (Day 1)

<span class="fragment">✅ Students completed Day 1: LLM basics, prompting, API usage</span>

<span class="fragment">✅ Python 3.10+ installed</span>

<span class="fragment">✅ Jupyter notebooks working</span>

<span class="fragment">✅ Basic understanding of embeddings and vectors</span>

::: notes
Verify prerequisites before starting. Saves time later.
:::

---

## 📅 Daily Schedule {data-background-color="#1e1e1e"}

Detailed timing guide

---

### Morning Session Overview

**9:00 - 10:00:** Module 1 - RAG Architecture (60 min)

**10:00 - 10:45:** Module 2 - Embeddings (45 min)

**10:45 - 11:00:** ☕ Break (15 min)

**11:00 - 12:00:** Module 3 - Vector Stores (60 min)

**12:00 - 1:00:** Module 4 - Accelerator (60 min)

::: notes
Stick to this schedule. Builds proper foundation.
:::

---

### Module 1: RAG Architecture (60 min) {data-background-color="#0f172a"}

Introduction to RAG

---

#### Module 1 Breakdown

**9:00 - 9:15:** Introduction to RAG (15 min)
<span class="fragment">Definition and motivation</span>
<span class="fragment">Real-world use cases</span>
<span class="fragment">**Demo:** Show working RAG system</span>

::: notes
Hook students with working demo first. Build excitement.
:::

---

#### Module 1: Core Components (30 min)

**9:15 - 9:45:**

<span class="fragment">Document store</span>

<span class="fragment">Chunking strategies</span>

<span class="fragment">Embeddings and vector stores</span>

<span class="fragment">Retriever and LLM integration</span>

::: notes
Use diagrams heavily. Visual learning matters.
:::

---

#### Module 1: RAG Pipeline (15 min)

**9:45 - 10:00:**

<span class="fragment">Live diagram walkthrough</span>

<span class="fragment">Ingestion → Indexing → Retrieval → Generation</span>

::: notes
Draw the flow live on whiteboard. Students follow along.
:::

---

### Module 2: Embedding Models (45 min) {data-background-color="#1e1e1e"}

Understanding embeddings

---

#### Module 2 Breakdown

**10:00 - 10:20:** Understanding embeddings (20 min)
<span class="fragment">Dense vector representations</span>
<span class="fragment">Semantic similarity</span>
<span class="fragment">**Demo:** Visualize embeddings in 2D</span>

::: notes
Show actual vector visualizations. Makes abstract concrete.
:::

---

#### Module 2: Model Comparison (25 min)

**10:20 - 10:45:**

<span class="fragment">sentence-transformers vs commercial</span>

<span class="fragment">Dimensions and trade-offs</span>

<span class="fragment">**Hands-on:** Test different models</span>

::: notes
Let students experiment. Quick 5-minute exercise.
:::

---

### ☕ Break (15 min)

**10:45 - 11:00**

<span class="fragment">Essential for retention!</span>

::: notes
Enforce the break. Brain needs rest.
:::

---

### Module 3: Vector Databases (60 min) {data-background-color="#0f172a"}

Specialized storage

---

#### Module 3 Breakdown

**11:00 - 11:20:** Introduction to vector stores (20 min)
<span class="fragment">Why specialized databases?</span>
<span class="fragment">Similarity search algorithms</span>

::: notes
Theory first, then tools. Build understanding.
:::

---

#### Module 3: Tool Comparison (30 min)

**11:20 - 11:50:**

<span class="fragment">**Chroma:** Local and simple</span>

<span class="fragment">**Elasticsearch:** Production-grade</span>

<span class="fragment">**FAISS:** High-performance</span>

<span class="fragment">**Pinecone:** Managed service</span>

::: notes
Compare and contrast. Help students choose wisely.
:::

---

#### Module 3: Hands-on Demo (10 min)

**11:50 - 12:00:**

<span class="fragment">Build a simple vector store</span>

<span class="fragment">Run similarity searches</span>

::: notes
Quick demo. Students see it working.
:::

---

### Module 4: Accelerator Architecture (60 min) {data-background-color="#1e1e1e"}

Production patterns

---

#### Module 4 Breakdown

**12:00 - 12:30:** Accelerator components (30 min)
<span class="fragment">Code walkthrough</span>
<span class="fragment">tools/ directory overview</span>
<span class="fragment">rag/ directory overview</span>

::: notes
Show actual production code. Bridge to reality.
:::

---

#### Module 4: Production Patterns (20 min)

**12:30 - 12:50:**

<span class="fragment">API design</span>

<span class="fragment">Error handling</span>

<span class="fragment">Monitoring considerations</span>

::: notes
Real production concerns. Set proper expectations.
:::

---

#### Module 4: Q&A and Lab Prep (10 min)

**12:50 - 1:00:**

<span class="fragment">Answer questions</span>

<span class="fragment">Preview afternoon labs</span>

::: notes
Clear any confusion before lunch. Fresh start for labs.
:::

---

## Afternoon Session: Labs (4 hours) {data-background-color="#0f172a"}

Hands-on practice

---

### Lab 2.1: Local RAG with Ollama (60 min)

**2:00 - 3:00**

---

#### Lab 2.1: Instructor Prep

```bash
# Test Ollama is running
ollama serve
ollama pull llama2

# Verify sample corpus exists
ls data/corpus/

# Test reference solution
jupyter nbconvert --execute lab_2.1_solution.ipynb
```

::: notes
Test everything before students arrive. Be ready for issues.
:::

---

#### Lab 2.1: Walkthrough (15 min)

**2:00 - 2:15:**

<span class="fragment">1. Show completed notebook running</span>

<span class="fragment">2. Explain key sections</span>

<span class="fragment">3. Point out common pitfalls</span>

<span class="fragment">4. Answer setup questions</span>

::: notes
Don't code it live yet. Just explain the structure.
:::

---

#### Lab 2.1: Independent Work (35 min)

**2:15 - 2:50:**

<span class="fragment">Students work through lab</span>

<span class="fragment">Circulate to help with issues</span>

<span class="fragment">Monitor for blockers</span>

::: notes
Be proactive. Don't wait for students to ask.
:::

---

#### Lab 2.1: Review (10 min)

**2:50 - 3:00:**

<span class="fragment">Show solution</span>

<span class="fragment">Discuss variations</span>

<span class="fragment">Preview next lab</span>

::: notes
Quick recap. Keep momentum going.
:::

---

### Lab 2.1: Common Issues {data-background-color="#1e1e1e"}

Be ready for these

---

#### Issue: Ollama Not Starting

```python
# Solution: Check if port 11434 is free
lsof -i :11434
```

<span class="fragment">Kill existing process if needed</span>

::: notes
Most common issue. Have solution ready.
:::

---

#### Issue: Slow Embedding

```python
# Solution: Reduce chunk count
CONFIG["chunk_size"] = 500  # Smaller chunks
```

<span class="fragment">Or use GPU if available</span>

::: notes
Performance issue on older laptops
:::

---

#### Issue: Out of Memory

```python
# Solution: Process in batches
for batch in chunks[::100]:
    vectorstore.add_documents(batch)
```

::: notes
Common with large corpora
:::

---

### Lab 2.2: RAG with watsonx.ai (60 min) {data-background-color="#0f172a"}

**3:00 - 4:00**

Enterprise RAG

---

#### Lab 2.2: Instructor Prep

```bash
# Verify credentials work
export WATSONX_APIKEY="your_key"
export PROJECT_ID="your_project_id"

# Test API connection
python test_watsonx_connection.py

# Prepare Elasticsearch alternative
docker run -p 9200:9200 elasticsearch:8.11.0
```

::: notes
Enterprise setup more complex. Test thoroughly.
:::

---

#### Lab 2.2: Walkthrough (15 min)

**3:00 - 3:15:**

<span class="fragment">1. Credentials setup walkthrough</span>

<span class="fragment">2. Show Granite model in action</span>

<span class="fragment">3. Explain watsonx-specific patterns</span>

<span class="fragment">4. Elasticsearch optional setup</span>

::: notes
Credentials are often the biggest hurdle
:::

---

#### Lab 2.2: Independent Work (35 min)

**3:15 - 3:50:**

<span class="fragment">Students implement enterprise RAG</span>

<span class="fragment">Help with credentials</span>

<span class="fragment">Troubleshoot API issues</span>

::: notes
Credential issues will happen. Be patient.
:::

---

#### Lab 2.2: Review (10 min)

**3:50 - 4:00:**

<span class="fragment">Compare Ollama vs watsonx</span>

<span class="fragment">Discuss production considerations</span>

::: notes
Highlight differences. When to use each.
:::

---

### Lab 2.2: Common Issues {data-background-color="#1e1e1e"}

Authentication and performance

---

#### Issue: Authentication Errors

```python
# Check: API key format, project permissions
# Verify: len(WATSONX_APIKEY) > 20
# Verify: len(PROJECT_ID) == 36
```

::: notes
Format validation catches most issues
:::

---

#### Issue: Slow Responses

```python
# Solution: Reduce max_new_tokens
parameters = {
    GenParams.MAX_NEW_TOKENS: 100  # Instead of 500
}
```

::: notes
Trade quality for speed if needed
:::

---

### ☕ Break (15 min)

**4:00 - 4:15**

<span class="fragment">Second wind needed!</span>

::: notes
Critical break. Students are tired.
:::

---

### Lab 2.3: Twin RAG Pipelines (60 min) {data-background-color="#0f172a"}

**4:15 - 5:15**

Comparison framework

---

#### Lab 2.3: Walkthrough (10 min)

**4:15 - 4:25:**

<span class="fragment">1. Show comparison framework</span>

<span class="fragment">2. Explain metrics</span>

<span class="fragment">3. Demonstrate visualization</span>

::: notes
This lab builds on previous two. Quick intro.
:::

---

#### Lab 2.3: Independent Work (40 min)

**4:25 - 5:05:**

<span class="fragment">Students build comparison</span>

<span class="fragment">Collect results</span>

<span class="fragment">Analyze differences</span>

::: notes
Students are tired. More time for this lab.
:::

---

#### Lab 2.3: Review (10 min)

**5:05 - 5:15:**

<span class="fragment">Discuss findings</span>

<span class="fragment">Identify patterns</span>

<span class="fragment">Production insights</span>

::: notes
Group discussion. Share learnings.
:::

---

### Lab 2.4: Evaluation Harness (45 min) {data-background-color="#1e1e1e"}

**5:15 - 6:00**

Final lab - shorter

---

#### Lab 2.4: Walkthrough (10 min)

**5:15 - 5:25:**

<span class="fragment">1. Importance of evaluation</span>

<span class="fragment">2. Metrics explanation</span>

<span class="fragment">3. Ground truth creation</span>

::: notes
Critical concept. Don't skip this.
:::

---

#### Lab 2.4: Independent Work (25 min)

**5:25 - 5:50:**

<span class="fragment">Implement eval functions</span>

<span class="fragment">Run evaluations</span>

<span class="fragment">Visualize results</span>

::: notes
Compressed lab. Focus on key concepts.
:::

---

#### Lab 2.4: Review (10 min)

**5:50 - 6:00:**

<span class="fragment">Discuss metrics</span>

<span class="fragment">eval_small.py design</span>

<span class="fragment">Governance integration</span>

::: notes
Wrap up day. Preview Day 3.
:::

---

## 🎓 Learning Objectives Checklist {data-background-color="#0f172a"}

Track student progress

---

### Knowledge (Can Explain)

<span class="fragment">☐ What is RAG and why it's useful</span>

<span class="fragment">☐ How embeddings represent semantic meaning</span>

<span class="fragment">☐ Difference between vector stores</span>

<span class="fragment">☐ Trade-offs in RAG design</span>

::: notes
Conceptual understanding. Test with questions.
:::

---

### Skills (Can Implement)

<span class="fragment">☐ Load and chunk documents</span>

<span class="fragment">☐ Create embeddings and vector stores</span>

<span class="fragment">☐ Build retrieval functions</span>

<span class="fragment">☐ Integrate LLMs into RAG</span>

<span class="fragment">☐ Evaluate RAG systems</span>

::: notes
Practical skills. Verify through labs.
:::

---

### Application (Can Build)

<span class="fragment">☐ Working local RAG pipeline</span>

<span class="fragment">☐ Enterprise RAG with watsonx</span>

<span class="fragment">☐ Comparison framework</span>

<span class="fragment">☐ Evaluation harness</span>

::: notes
Complete systems. Portfolio pieces.
:::

---

## 📊 Assessment & Grading {data-background-color="#1e1e1e"}

Evaluation rubric

---

### Lab Completion (40 points)

<span class="fragment">Lab 2.1: 10 points (notebook runs, answers correct)</span>

<span class="fragment">Lab 2.2: 10 points (watsonx integration works)</span>

<span class="fragment">Lab 2.3: 10 points (comparison complete)</span>

<span class="fragment">Lab 2.4: 10 points (evaluation implemented)</span>

::: notes
Basic functionality. Must work to pass.
:::

---

### Quality (30 points)

<span class="fragment">Code organization and comments: 10 points</span>

<span class="fragment">Error handling: 10 points</span>

<span class="fragment">Documentation: 10 points</span>

::: notes
Production quality matters
:::

---

### Understanding (30 points)

<span class="fragment">Wrap-up questions: 15 points</span>

<span class="fragment">Accelerator mapping: 15 points</span>

::: notes
Can they explain their choices?
:::

---

### Grading Scale

**Total: 100 points**

<span class="fragment">90-100: Excellent - All labs working, clear understanding</span>

<span class="fragment">80-89: Good - Minor issues, solid grasp</span>

<span class="fragment">70-79: Satisfactory - Some components working</span>

<span class="fragment">60-69: Needs Improvement - Significant gaps</span>

<span class="fragment"><60: Not Passing - Incomplete work</span>

::: notes
Clear expectations. Transparent grading.
:::

---

## 💡 Teaching Tips {data-background-color="#0f172a"}

Proven strategies

---

### Tip 1: Start with "Why"

<span class="fragment">Don't jump into code</span>

<span class="fragment">Explain the problem being solved</span>

<span class="fragment">Show real-world example first</span>

::: notes
Motivation before mechanics. Build context.
:::

---

### Tip 2: Use Progressive Disclosure

```python {data-line-numbers="1-2|4-9"}
# First show simple version
vectorstore = Chroma.from_documents(docs, embeddings)

# Then add complexity
vectorstore = Chroma.from_documents(
    documents=docs,
    embedding=embeddings,
    persist_directory="./db"
)
```

::: notes
Layer complexity. Don't overwhelm at start.
:::

---

### Tip 3: Encourage Experimentation

<span class="fragment">"What happens if you change chunk_size to 500?"</span>

<span class="fragment">"Try different embedding models"</span>

<span class="fragment">"Compare with/without overlap"</span>

::: notes
Active learning beats passive consumption
:::

---

### Tip 4: Relate to Accelerator

<span class="fragment">"This notebook code will become retriever.py"</span>

<span class="fragment">"Notice how we're separating concerns"</span>

<span class="fragment">"Think about error handling for production"</span>

::: notes
Connect to production. Build professional thinking.
:::

---

## Common Questions & Answers {data-background-color="#1e1e1e"}

Be ready for these

---

### Q: "Why not just use GPT-4 for everything?"

**A:** "Cost, latency, privacy, and control over knowledge"

::: notes
Common question. Clear business answer.
:::

---

### Q: "When should I use RAG vs fine-tuning?"

**A:** "RAG: frequently updated info. Fine-tuning: style/behavior"

::: notes
Different tools for different problems
:::

---

### Q: "Which vector store should I use?"

**A:** "Dev: Chroma. Production: Elasticsearch/Pinecone"

::: notes
Context-dependent answer
:::

---

### Q: "How do I handle multi-language?"

**A:** "Use multilingual embedding models or separate stores"

::: notes
Design decision with trade-offs
:::

---

## Pacing Strategies {data-background-color="#0f172a"}

Adapt to your audience

---

### If Running Behind

<span class="fragment">Skip optional demos</span>

<span class="fragment">Provide pre-built components</span>

<span class="fragment">Focus on key concepts</span>

<span class="fragment">Extend lab time, reduce review</span>

::: notes
Flexibility matters. Preserve core content.
:::

---

### If Running Ahead

<span class="fragment">Deep dive into advanced topics</span>

<span class="fragment">Extra optimization exercises</span>

<span class="fragment">Production deployment discussion</span>

<span class="fragment">Preview Day 3 content</span>

::: notes
Reward fast learners with depth
:::

---

## 🎬 Workshop Closing (5:45 - 6:00) {data-background-color="#1e1e1e"}

End strong

---

### Wrap-Up Activity (10 min)

**Quick Reflection:**

<span class="fragment">1. "What was the most surprising thing you learned?"</span>

<span class="fragment">2. "What will you try in your work?"</span>

<span class="fragment">3. "What questions remain?"</span>

::: notes
Group discussion. Consolidate learning.
:::

---

### Key Takeaways Reinforcement

<span class="fragment">RAG = Retrieval + Generation for grounded answers</span>

<span class="fragment">Components: Docs → Chunks → Embeddings → Vector Store → Retriever → LLM</span>

<span class="fragment">Evaluation is critical for production</span>

<span class="fragment">Accelerator provides production patterns</span>

::: notes
Repeat core concepts. Reinforce learning.
:::

---

### Preview Day 3 (5 min)

<span class="fragment">Agentic AI systems</span>

<span class="fragment">Governed AI tooling</span>

<span class="fragment">Advanced evaluation</span>

<span class="fragment">Deployment and monitoring</span>

::: notes
Build excitement for next day
:::

---

### Logistics

<span class="fragment">Share: Completion certificates</span>

<span class="fragment">Collect: Feedback surveys</span>

<span class="fragment">Provide: Additional resources document</span>

<span class="fragment">Remind: Office hours schedule</span>

::: notes
Administrative wrap-up
:::

---

## 🎯 Success Metrics {data-background-color="#0f172a"}

Track workshop effectiveness

---

### Workshop is Successful If:

<span class="fragment">✅ 80%+ students complete all labs</span>

<span class="fragment">✅ 90%+ understand RAG concepts</span>

<span class="fragment">✅ 70%+ can build basic RAG independently</span>

<span class="fragment">✅ Average satisfaction score > 4/5</span>

<span class="fragment">✅ Students can explain trade-offs</span>

::: notes
Measurable success criteria
:::

---

### Track These Metrics

<span class="fragment">Completion rates per lab</span>

<span class="fragment">Time spent per module</span>

<span class="fragment">Number of questions per topic</span>

<span class="fragment">Common error patterns</span>

<span class="fragment">Post-workshop survey results</span>

::: notes
Data drives improvement
:::

---

## 📞 Support Resources {data-background-color="#1e1e1e"}

Help for instructors

---

### During Workshop

<span class="fragment">Slack: #day2-rag-workshop</span>

<span class="fragment">TA support: 2-3 TAs for 20+ students</span>

<span class="fragment">Backup instructor for technical issues</span>

::: notes
Don't teach alone. Have support ready.
:::

---

### After Workshop

<span class="fragment">Office hours: 2x per week for 2 weeks</span>

<span class="fragment">Discussion forum: for ongoing questions</span>

<span class="fragment">Code review: optional for project work</span>

::: notes
Extended support. Learning continues.
:::

---

## Good luck with the workshop! 🚀 {data-background-color="#0f172a" data-transition="zoom"}

*Remember: The goal is learning, not perfection.*

*Encourage experimentation and questions!*

**Document Version**: 1.0
**Last Updated**: January 2025
**Contact**: workshop-support@example.com

::: notes
Final encouragement. You're ready to teach!
:::