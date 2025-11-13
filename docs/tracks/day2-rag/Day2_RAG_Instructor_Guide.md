# Day 2 RAG Workshop - Instructor Guide & Quick Reference

## 🎯 Workshop Overview for Instructors

### Target Audience
- Software engineers with Python experience
- Data scientists exploring LLM applications
- AI engineers building production systems
- Technical professionals interested in RAG

### Prerequisites Check (Day 1)
- ✅ Students completed Day 1: LLM basics, prompting, basic API usage
- ✅ Python 3.10+ installed
- ✅ Jupyter notebooks working
- ✅ Basic understanding of embeddings and vectors

---

## 📅 Daily Schedule

### Morning Session: Theory (4 hours)

**9:00 - 10:00: Module 1 - RAG Architecture Overview (60 min)**
- Introduction to RAG (15 min)
  - Definition and motivation
  - Real-world use cases
  - Demo: Show working RAG system
  
- Core Components (30 min)
  - Document store
  - Chunking strategies
  - Embeddings and vector stores
  - Retriever and LLM integration
  
- RAG Pipeline Flow (15 min)
  - Live diagram walkthrough
  - Ingestion → Indexing → Retrieval → Generation
  
**10:00 - 10:45: Module 2 - Embedding Models (45 min)**
- Understanding embeddings (20 min)
  - Dense vector representations
  - Semantic similarity
  - Demo: Visualize embeddings in 2D
  
- Model comparison (25 min)
  - sentence-transformers vs commercial
  - Dimensions and trade-offs
  - Hands-on: Test different models

**10:45 - 11:00: ☕ Break (15 min)**

**11:00 - 12:00: Module 3 - Vector Databases (60 min)**
- Introduction to vector stores (20 min)
  - Why specialized databases?
  - Similarity search algorithms
  
- Tool comparison (30 min)
  - Chroma: Local and simple
  - Elasticsearch: Production-grade
  - FAISS: High-performance
  - Pinecone: Managed service
  
- Hands-on demo (10 min)
  - Build a simple vector store
  - Run similarity searches

**12:00 - 1:00: Module 4 - Accelerator Architecture (60 min)**
- Accelerator components (30 min)
  - Code walkthrough
  - tools/ directory overview
  - rag/ directory overview
  
- Production patterns (20 min)
  - API design
  - Error handling
  - Monitoring considerations
  
- Q&A and prep for labs (10 min)

---

### Afternoon Session: Labs (4 hours)

**2:00 - 3:00: Lab 2.1 - Local RAG with Ollama (60 min)**

**Instructor Prep:**
```bash
# Test Ollama is running
ollama serve
ollama pull llama2

# Verify sample corpus exists
ls data/corpus/

# Test reference solution
jupyter nbconvert --execute lab_2.1_solution.ipynb
```

**Walkthrough (15 min):**
1. Show completed notebook running
2. Explain key sections
3. Point out common pitfalls
4. Answer setup questions

**Independent Work (35 min):**
- Students work through lab
- Circulate to help with issues
- Monitor for blockers

**Review (10 min):**
- Show solution
- Discuss variations
- Preview next lab

**Common Issues:**
```python
# Ollama not starting
# Solution: Check if port 11434 is free
lsof -i :11434

# Slow embedding
# Solution: Reduce chunk count or use GPU
CONFIG["chunk_size"] = 500  # Smaller chunks

# Out of memory
# Solution: Process in batches
for batch in chunks[::100]:
    vectorstore.add_documents(batch)
```

**3:00 - 4:00: Lab 2.2 - RAG with watsonx.ai (60 min)**

**Instructor Prep:**
```bash
# Verify credentials work
export WATSONX_APIKEY="your_key"
export PROJECT_ID="your_project_id"

# Test API connection
python test_watsonx_connection.py

# Prepare Elasticsearch alternative if needed
docker run -p 9200:9200 elasticsearch:8.11.0
```

**Walkthrough (15 min):**
1. Credentials setup walkthrough
2. Show Granite model in action
3. Explain watsonx-specific patterns
4. Elasticsearch optional setup

**Independent Work (35 min):**
- Students implement enterprise RAG
- Help with credentials
- Troubleshoot API issues

**Review (10 min):**
- Compare Ollama vs watsonx
- Discuss production considerations

**Common Issues:**
```python
# Authentication errors
# Check: API key format, project permissions

# Slow responses
# Solution: Reduce max_new_tokens
parameters = {
    GenParams.MAX_NEW_TOKENS: 100  # Instead of 500
}

# Elasticsearch connection timeout
# Solution: Use Chroma fallback
if USE_ELASTICSEARCH:
    try:
        vectorstore = ElasticsearchStore(...)
    except:
        vectorstore = Chroma.from_documents(...)
```

**4:00 - 4:15: ☕ Break (15 min)**

**4:15 - 5:15: Lab 2.3 - Twin RAG Pipelines (60 min)**

**Instructor Prep:**
```bash
# Ensure both RAG systems are working
python -c "from lab_2_1_solution import qa_chain_ollama"
python -c "from lab_2_2_solution import qa_chain_granite"

# Prepare comparison template
jupyter notebook lab_2.3_starter.ipynb
```

**Walkthrough (10 min):**
1. Show comparison framework
2. Explain metrics
3. Demonstrate visualization

**Independent Work (40 min):**
- Students build comparison
- Collect results
- Analyze differences

**Review (10 min):**
- Discuss findings
- Identify patterns
- Production insights

**5:15 - 6:00: Lab 2.4 - Evaluation Harness (45 min)**

**Instructor Prep:**
```bash
# Prepare ground truth data
cat > ground_truth.csv << EOF
query,gold_answer,relevant_docs
"What is RAG?","RAG enhances LLMs...","rag_overview.txt"
EOF

# Test evaluation functions
python test_evaluation.py
```

**Walkthrough (10 min):**
1. Importance of evaluation
2. Metrics explanation
3. Ground truth creation

**Independent Work (25 min):**
- Implement eval functions
- Run evaluations
- Visualize results

**Review (10 min):**
- Discuss metrics
- eval_small.py design
- Governance integration

---

## 🎓 Learning Objectives Checklist

### Knowledge (Can explain)
- [ ] What is RAG and why it's useful
- [ ] How embeddings represent semantic meaning
- [ ] Difference between vector stores
- [ ] Trade-offs in RAG design

### Skills (Can implement)
- [ ] Load and chunk documents
- [ ] Create embeddings and vector stores
- [ ] Build retrieval functions
- [ ] Integrate LLMs into RAG
- [ ] Evaluate RAG systems

### Application (Can build)
- [ ] Working local RAG pipeline
- [ ] Enterprise RAG with watsonx
- [ ] Comparison framework
- [ ] Evaluation harness

---

## 📊 Assessment & Grading

### Lab Completion (40 points)
- Lab 2.1: 10 points (notebook runs, answers correct)
- Lab 2.2: 10 points (watsonx integration works)
- Lab 2.3: 10 points (comparison complete)
- Lab 2.4: 10 points (evaluation implemented)

### Quality (30 points)
- Code organization and comments: 10 points
- Error handling: 10 points
- Documentation: 10 points

### Understanding (30 points)
- Wrap-up questions: 15 points
- Accelerator mapping: 15 points

**Total: 100 points**

**Grading Rubric:**
- 90-100: Excellent - All labs working, clear understanding
- 80-89: Good - Minor issues, solid grasp of concepts
- 70-79: Satisfactory - Some components working, basic understanding
- 60-69: Needs Improvement - Significant gaps
- <60: Not Passing - Incomplete work

---

## 🔧 Technical Setup Verification

### Pre-Workshop Checklist

**Send to students 1 week before:**
```bash
# Install Python packages
pip install -r requirements.txt

# Install Ollama
curl https://ollama.ai/install.sh | sh
ollama pull llama2

# Test imports
python -c "import langchain; import chromadb; import sentence_transformers"

# Verify watsonx credentials (share template)
python verify_credentials.py
```

**Day-of setup (30 minutes before):**
```bash
# Start Ollama
ollama serve &

# Verify all systems
./verify_workshop_setup.sh

# Create sample data
python create_sample_corpus.py

# Test reference solutions
pytest test_lab_solutions.py
```

---

## 💡 Teaching Tips

### For Each Module

**1. Start with "Why"**
- Don't jump into code
- Explain the problem being solved
- Show real-world example first

**2. Use Progressive Disclosure**
```python
# First show simple version
vectorstore = Chroma.from_documents(docs, embeddings)

# Then add complexity
vectorstore = Chroma.from_documents(
    documents=docs,
    embedding=embeddings,
    persist_directory="./db",
    collection_metadata={"hnsw:space": "cosine"}
)
```

**3. Encourage Experimentation**
- "What happens if you change chunk_size to 500?"
- "Try different embedding models"
- "Compare with/without overlap"

**4. Relate to Accelerator**
- "This notebook code will become retriever.py"
- "Notice how we're separating concerns"
- "Think about error handling for production"

### Handling Questions

**Common Questions & Answers:**

Q: "Why not just use GPT-4 for everything?"
A: "Cost, latency, privacy, and control over knowledge"

Q: "When should I use RAG vs fine-tuning?"
A: "RAG: frequently updated info. Fine-tuning: style/behavior"

Q: "Which vector store should I use?"
A: "Dev: Chroma. Production: Elasticsearch/Pinecone"

Q: "How do I handle multi-language?"
A: "Use multilingual embedding models or separate stores"

Q: "What about images/tables?"
A: "Multi-modal RAG - covered in advanced topics"

### Pacing Strategies

**If Running Behind:**
- Skip optional demos
- Provide pre-built components
- Focus on key concepts
- Extend lab time, reduce review

**If Running Ahead:**
- Deep dive into advanced topics
- Extra optimization exercises
- Production deployment discussion
- Preview Day 3 content

---

## 🐛 Troubleshooting Guide for Instructors

### Student Environment Issues

**Issue: "Ollama won't start"**
```bash
# Check if already running
ps aux | grep ollama

# Check port availability
lsof -i :11434

# Kill existing process
pkill ollama

# Restart
ollama serve
```

**Issue: "Out of memory during indexing"**
```python
# Solution: Batch processing
batch_size = 100
for i in range(0, len(chunks), batch_size):
    batch = chunks[i:i+batch_size]
    vectorstore.add_documents(batch)
```

**Issue: "watsonx authentication fails"**
```python
# Debug credentials
print(f"API Key length: {len(WATSONX_APIKEY)}")
print(f"Project ID format: {len(PROJECT_ID) == 36}")

# Test simple call
from ibm_watsonx_ai import APIClient
client = APIClient(credentials, project_id)
print(client.foundation_models.get_model_specs()[:2])
```

**Issue: "Elasticsearch connection timeout"**
```python
# Provide Chroma fallback
print("Elasticsearch unavailable, using Chroma...")
vectorstore = Chroma.from_documents(
    documents=chunks,
    embedding=embeddings
)
```

### Content Delivery Issues

**Students Lost in Theory:**
- Pause for questions every 10 minutes
- Use more diagrams/visualizations
- Relate to familiar concepts
- Provide analogy: "Like a librarian finding relevant books"

**Labs Too Fast/Slow:**
- Have extension exercises ready
- Provide partial solutions for struggling students
- Pair programming for mixed skill levels

**Technical Difficulties:**
- Always have backup: cloud notebooks (Colab/SageMaker)
- Pre-recorded demos as fallback
- Offline documentation

---

## 📚 Additional Resources for Instructors

### Reference Materials

**Papers:**
1. "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" (Lewis et al., 2020)
2. "Dense Passage Retrieval for Open-Domain Question Answering" (Karpukhin et al., 2020)

**Documentation:**
- LangChain RAG Guide: https://python.langchain.com/docs/use_cases/question_answering/
- watsonx.ai Docs: https://www.ibm.com/docs/en/watsonx-as-a-service
- Chroma Docs: https://docs.trychroma.com/

**Videos (for students):**
- "RAG Explained" - Andrej Karpathy
- "Building Production RAG Systems" - LangChain YouTube

### Extension Activities

**For Advanced Students:**
1. **Hybrid Search Implementation**
   - Combine keyword and semantic search
   - Implement BM25 + vector similarity

2. **Multi-Query RAG**
   - Generate multiple versions of query
   - Retrieve from each, combine results

3. **Agentic RAG**
   - Add routing logic
   - Implement query planning
   - Self-correction loops

4. **Custom Evaluators**
   - Domain-specific metrics
   - Human-in-the-loop evaluation
   - A/B testing framework

---

## 🎬 Workshop Closing (5:45 - 6:00 PM)

### Wrap-Up Activity (10 min)

**Quick Reflection:**
1. "What was the most surprising thing you learned?"
2. "What will you try in your work?"
3. "What questions remain?"

**Key Takeaways Reinforcement:**
- RAG = Retrieval + Generation for grounded answers
- Components: Docs → Chunks → Embeddings → Vector Store → Retriever → LLM
- Evaluation is critical for production systems
- Accelerator provides production patterns

### Preview Day 3 (5 min)
- Agentic AI systems
- Governed AI tooling
- Advanced evaluation
- Deployment and monitoring

### Logistics
- Share: Completion certificates
- Collect: Feedback surveys
- Provide: Additional resources document
- Remind: Office hours schedule

---

## 📝 Post-Workshop Instructor Checklist

### Immediate (Same Day)
- [ ] Collect attendance
- [ ] Grade lab submissions (if applicable)
- [ ] Note common issues for next time
- [ ] Share solution notebooks
- [ ] Send follow-up email with resources

### Within Week
- [ ] Review feedback surveys
- [ ] Update materials based on feedback
- [ ] Grade final submissions
- [ ] Provide individual feedback
- [ ] Schedule follow-up office hours

### For Next Workshop
- [ ] Update prerequisites based on issues
- [ ] Refine pacing based on feedback
- [ ] Add/remove content as needed
- [ ] Update code for latest library versions
- [ ] Create FAQ document

---

## 🎯 Success Metrics

**Workshop is Successful If:**
- ✅ 80%+ students complete all labs
- ✅ 90%+ understand RAG concepts
- ✅ 70%+ can build basic RAG pipeline independently
- ✅ Average satisfaction score > 4/5
- ✅ Students can explain trade-offs in RAG design

**Track These Metrics:**
- Completion rates per lab
- Time spent per module
- Number of questions per topic
- Common error patterns
- Post-workshop survey results

---

## 📞 Support Resources

**During Workshop:**
- Slack: #day2-rag-workshop
- TA support: 2-3 TAs for 20+ students
- Backup instructor for technical issues

**After Workshop:**
- Office hours: 2x per week for 2 weeks
- Discussion forum: for ongoing questions
- Code review: optional for project work

---

## 🏆 Bonus: Quick Command Reference

```bash
# === Environment Setup ===
# Install all dependencies
pip install -r requirements.txt

# Start Ollama
ollama serve

# Pull models
ollama pull llama2
ollama pull mistral

# === Data Preparation ===
# Create sample corpus
python scripts/create_sample_corpus.py

# Download workshop data
wget https://raw.github.com/.../data.zip
unzip data.zip

# === Testing ===
# Test all labs
pytest tests/test_labs.py

# Test specific lab
pytest tests/test_lab_2_1.py -v

# Run solution notebook
jupyter nbconvert --execute lab_2_1_solution.ipynb

# === Common Fixes ===
# Reset Chroma database
rm -rf ./chroma_db

# Clear Python cache
find . -type d -name __pycache__ -exec rm -r {} +

# Restart Jupyter kernel
# Kernel > Restart & Clear Output

# === Monitoring ===
# Watch Ollama logs
ollama logs -f

# Check vector store size
du -sh ./chroma_db

# Monitor memory usage
watch -n 1 free -h
```

---

**Good luck with the workshop! 🚀**

*Remember: The goal is learning, not perfection. Encourage experimentation and questions!*

---

**Document Version**: 1.0  
**Last Updated**: January 2025  
**Contact**: workshop-support@example.com
