# Day 1 – LLMs & Prompting - Workshop Materials

Welcome to Day 1 of the watsonx Workshop! This directory contains all materials for learning LLM fundamentals and prompt engineering.

---

## Quick Start

1. **Theory First** (Morning, 4 hours):
   - Read `llm-concepts.md`
   - Read `prompt-patterns-theory.md`
   - Read `eval-safety-theory.md`

2. **Labs Second** (Afternoon, 4 hours):
   - Follow `lab-1-quickstart-two-envs.md`
   - Follow `lab-2-prompt-templates.md`
   - Follow `lab-3-micro-eval.md`

3. **Reference**:
   - See `day1-summary-and-schedule.md` for complete overview

---

## File Structure

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

---

## Learning Objectives

### Theory Modules

**1.0 LLM Concepts** (`llm-concepts.md`)
- Understand tokens, context windows, and key parameters
- Compare local (Ollama) vs managed (watsonx.ai) deployments
- Learn cost and resource considerations
- See how LLMs fit in production architecture

**1.2 Prompt Patterns** (`prompt-patterns-theory.md`)
- Master common prompt patterns (instruction, few-shot, CoT, style transfer)
- Learn prompt design principles
- Create reusable templates
- Understand accelerator prompt structure

**1.3 Evaluation & Safety** (`eval-safety-theory.md`)
- Know why evaluation matters
- Understand evaluation signals (correctness, coherence, style, latency)
- Learn safety considerations
- Design production monitoring

### Lab Modules

**Lab 1.1: Quickstart** (`lab-1-quickstart-two-envs.md`)
- Duration: 45 minutes
- Run first prompts in Ollama and watsonx.ai
- Modify parameters (temperature, max_tokens)
- Compare outputs and latency

**Lab 1.2: Prompt Templates** (`lab-2-prompt-templates.md`)
- Duration: 60 minutes
- Build reusable templates for summarization, style transfer, Q&A
- Implement in both environments
- Run comparative experiments

**Lab 1.3: Micro-Evaluation** (`lab-3-micro-eval.md`)
- Duration: 60 minutes
- Create test set of prompts
- Apply rating rubric
- Analyze results with pandas and visualizations

---

## Prerequisites

Before Day 1:
- ✅ Complete Day 0 (environment setup)
- ✅ `simple-ollama-environment` working
- ✅ `simple-watsonx-enviroment` with valid credentials
- ✅ Jupyter accessible in both environments

---

## Workshop Flow

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

---

## Key Concepts

### Tokens
- Sub-units of text (~4 chars/token in English)
- Models have token limits (context windows)
- Costs calculated per token

### Temperature
- `0.0` = Deterministic, focused
- `0.7-1.0` = Balanced creativity
- `1.5+` = Very creative, less predictable

### Prompt Patterns
1. **Instruction**: Direct command
2. **Few-shot**: Examples before task
3. **Chain-of-thought**: Step-by-step reasoning
4. **Style transfer**: Rewrite in different tone
5. **Summarization**: Condense content

### Evaluation
- **Correctness**: Matches ground truth?
- **Coherence**: Logical and relevant?
- **Style**: Follows format?
- **Latency**: Fast enough?

---

## Deliverables

By end of Day 1, you will have:
- ✅ 5 working Jupyter notebooks
- ✅ Reusable prompt templates
- ✅ Evaluation results (CSV + visualizations)
- ✅ Understanding of LLM fundamentals

---

## Common Issues & Solutions

### Ollama
**Problem**: Connection refused  
**Solution**: Check if Ollama service is running
```bash
curl http://localhost:11434/api/tags
```

**Problem**: Model not found  
**Solution**: Pull the model
```bash
ollama pull qwen2.5:0.5b-instruct
```

### watsonx.ai
**Problem**: Invalid API key  
**Solution**: Check `.env` file, verify key in IBM Cloud console

**Problem**: Rate limit  
**Solution**: Add delays between requests (`time.sleep(0.5)`)

### General
**Problem**: Wrong Python kernel  
**Solution**: Select correct kernel in Jupyter (e.g., "Python 3.11 (simple-env)")

---

## Tips for Success

### Theory Sessions
- Take notes on key concepts
- Ask questions when unclear
- Relate concepts to your use cases

### Lab Sessions
- Follow instructions step-by-step
- Experiment beyond the examples
- Document interesting findings
- Help peers when possible

### Time Management
- Don't get stuck on one issue too long
- Ask for help after 5-10 minutes
- Labs build on each other—complete in order

---

## Resources

### Documentation
- [IBM Granite Models](https://www.ibm.com/granite/docs)
- [watsonx.ai Docs](https://www.ibm.com/docs/en/watsonx-as-a-service)
- [Ollama Documentation](https://ollama.com/docs)

### Prompt Engineering
- [OpenAI Prompt Guide](https://platform.openai.com/docs/guides/prompt-engineering)
- [Anthropic Prompt Tips](https://docs.anthropic.com/claude/docs/prompt-engineering)
- [Granite Prompting](https://www.ibm.com/granite/docs/models/granite/#chat-template)

### Python & Data Science
- [Pandas Documentation](https://pandas.pydata.org/docs/)
- [Jupyter Notebook Guide](https://jupyter-notebook.readthedocs.io/)

---

## Next Steps

### After Day 1
1. Review your notebooks and notes
2. Complete optional homework (expand test sets)
3. Read ahead: Day 2 materials on RAG

### Day 2 Preview
Tomorrow we'll learn:
- **Retrieval-Augmented Generation (RAG)**
- **Vector databases** (Elasticsearch, Chroma)
- **Embedding models**
- **Accelerator integration**

---

## Getting Help

### During Workshop
- 💬 Chat/Slack for questions
- 🙋 Raise hand for blocking issues
- 👥 Discuss with neighbors

### After Workshop
- 📧 Email instructors
- 💻 GitHub issues/discussions
- 🌐 Community forums

---

## Feedback

Your feedback helps improve the workshop!

**Please share**:
- What worked well?
- What was confusing?
- What would you like more/less of?
- Suggestions for improvement?

---

## License & Attribution

Materials created for the watsonx Workshop Series.

**Based on**:
- IBM Granite documentation
- watsonx.ai best practices
- Community contributions

---

## Version History

- **v1.0** (2025-01): Initial release
  - Theory modules
  - Lab instructions
  - Reference notebooks

---

**Ready to start? Begin with `llm-concepts.md`! 🚀**

For questions or issues, contact your workshop instructor.
