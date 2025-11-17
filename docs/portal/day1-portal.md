# Day 1 Portal: LLMs & Prompting with Ollama and watsonx.ai

## 📋 Daily Overview

- **Duration**: 8 hours (9:00 AM - 5:00 PM)
- **Format**: 4 hours theory (morning) + 4 hours labs (afternoon)
- **Learning Objectives**:
  - Understand LLM architecture, tokens, and context windows
  - Master core prompt patterns (instruction, few-shot, chain-of-thought)
  - Apply systematic evaluation frameworks to LLM outputs
  - Compare local (Ollama) vs. managed (watsonx.ai) deployments
- **Prerequisites**: ✅ [Day 0 Environment Setup Complete](day0-portal.md)

---

## ☀️ Morning Session: Theory & Presentations (9:00 AM - 12:00 PM)

### Module 1.0: LLM Concepts & Architecture (9:00 - 10:30, 90 min)

**Content**:

- 📖 [Read: LLM Concepts (Detailed Theory)](../tracks/day1-llm/llm-concepts.md)
- 🎯 [Present: LLM Concepts Slides (HTML)](../slides/day1-llm-concepts.html)
- 📄 [Download: LLM Concepts Slides (PDF)](../slides/day1-llm-concepts.pdf)

**Topics Covered**:

- What are Large Language Models? (Transformers, attention mechanism)
- Tokens, embeddings, and context windows (why they matter)
- Local deployment with Ollama vs. cloud with watsonx.ai
- Cost considerations and trade-offs for production use

**Instructor Notes**:

!!! tip "Teaching Emphasis"
    **Key Concept**: Token limits directly affect application design.
    **Live Demo**: Show same prompt in Ollama vs. watsonx, highlight latency and quality differences.
    **Common Question**: "When should I use local vs. cloud?"
    → Answer: Cost (local cheaper long-term), privacy (local keeps data on-premise), scale (cloud handles spikes).

!!! warning "Pacing Alert"
    If running behind, shorten deployment section to 15 min and show comparison table instead of live demo.

**Suggested Pacing**:

- 0-30 min: LLM fundamentals (architecture, training)
- 30-60 min: Deployment options (Ollama setup, watsonx.ai overview)
- 60-90 min: Live demo and cost comparison discussion

☕ **Break**: 10:30 - 10:45 (15 min)

---

### Module 1.2: Prompt Patterns & Templates (10:45 - 12:00, 75 min)

**Content**:

- 📖 [Read: Prompt Patterns Theory](../tracks/day1-llm/prompt-patterns-theory.md)
- 🎯 [Present: Prompt Patterns Slides (HTML)](../slides/day1-prompt-patterns-theory.html)
- 📄 [Download: Prompt Patterns Slides (PDF)](../slides/day1-prompt-patterns-theory.pdf)

**Topics Covered**:

- Instruction prompting (zero-shot): Clear task specification
- Few-shot learning: Learning from examples
- Chain-of-thought reasoning: Breaking down complex problems
- Template creation with Jinja2 for reusability

**Instructor Notes**:

!!! tip "Live Demo Script"
    **Task**: "Classify email sentiment"

    **Zero-shot** (30 sec):
    ```
    Classify this email as positive/negative/neutral: "Thanks for the quick response!"
    → Result: Often correct, but inconsistent format
    ```

    **Few-shot** (60 sec):
    ```
    Email: "You're the best!" → Sentiment: positive
    Email: "This is terrible." → Sentiment: negative
    Email: "I received the package." → Sentiment: neutral

    Email: "Thanks for the quick response!" → Sentiment:
    → Result: Consistent format, higher accuracy
    ```

    **Debrief**: Ask class, "What changed? Why did few-shot work better?"

!!! example "Common Mistake"
    Students often forget to escape curly braces in Jinja2 templates.
    **Quick Fix**: Show `{{ "{{ variable }}" }}` syntax.

**Suggested Pacing**:

- 0-20 min: Instruction prompting with examples
- 20-40 min: Few-shot learning (emphasize example selection)
- 40-60 min: Chain-of-thought reasoning
- 60-75 min: Jinja2 templates introduction

🍴 **Lunch Break**: 12:00 - 1:00 PM (60 min)

---

### Module 1.3: Evaluation & Safety (During Lunch or Early Afternoon, 30 min)

**Content**:

- 📖 [Read: Evaluation & Safety Theory](../tracks/day1-llm/eval-safety-theory.md)
- 🎯 [Present: Evaluation Slides (HTML)](../slides/day1-eval-safety-theory.html)
- 📄 [Download: Evaluation Slides (PDF)](../slides/day1-eval-safety-theory.pdf)

**Topics Covered**:

- Evaluation signals: accuracy, relevance, coherence, safety
- Lightweight evaluation frameworks (manual review, automated checks)
- Safety considerations: bias, toxicity, hallucination

**Instructor Notes**:

!!! info "Flexible Timing"
    This module can be presented:
    - **Option 1**: Right before lunch (11:30-12:00) to keep afternoon for labs only
    - **Option 2**: Right after lunch (1:00-1:30) as a "digest" session
    - **Option 3**: Integrated into Lab 1.3 as just-in-time learning

    Choose based on energy levels and group preferences.

---

## 🔬 Afternoon Session: Hands-On Labs (1:00 PM - 5:00 PM)

### Lab 1.1: Quickstart in Both Environments (1:00 - 2:00, 60 min)

**Objectives**:

- Successfully run prompts in Ollama (local environment)
- Successfully run prompts in watsonx.ai (cloud environment)
- Compare response quality, latency, and ease of use

<div class="grid cards" markdown>

-   :material-laptop: __Ollama (Local)__

    ---

    Run models on your laptop

    - Model: `llama2:7b`
    - Latency: ~2-5s
    - Cost: Free (after hardware)

-   :material-cloud: __watsonx.ai (Cloud)__

    ---

    IBM's managed AI platform

    - Model: `ibm/granite-13b-chat-v2`
    - Latency: ~1-3s
    - Cost: Pay-per-token

</div>

**Instructions**:

- 📝 [Student Instructions](../tracks/day1-llm/lab-1-quickstart-two-envs.md)
- 💡 [Troubleshooting Common Issues](../tracks/day1-llm/lab-1-quickstart-two-envs.md#troubleshooting)

**For Instructors Only**:

- ✅ [Complete Solutions (Code & Outputs)](../tracks/day1-llm/lab-1-quickstart-two-envs.md#solutions)
- 📊 [Expected Performance Benchmarks](../tracks/day1-llm/lab-1-quickstart-two-envs.md#expected-results)

**Success Criteria**:

- [ ] Ollama responds to "Hello, world" prompt with valid output
- [ ] watsonx.ai API returns JSON response with status 200
- [ ] Comparison table completed with latency measurements
- [ ] Can explain trade-offs between local and cloud deployment

**Typical Completion Time**: 45 minutes (15 min buffer for troubleshooting)

!!! tip "Instructor Circulation"
    **First 10 min**: Ensure everyone starts successfully (environment issues surface here)
    **Next 30 min**: Help stragglers, challenge fast finishers ("Try a different model")
    **Last 5 min**: Group checkpoint - "Show of hands: who completed all 3 checkpoints?"

---

### Lab 1.2: Prompt Templates in Ollama & watsonx (2:00 - 3:00, 60 min)

**Objectives**:

- Create reusable Jinja2 prompt templates
- Implement few-shot learning pattern with dynamic examples
- Test templates with multiple inputs and validate consistency

**Instructions**:

- 📝 [Student Instructions](../tracks/day1-llm/lab-2-prompt-templates.md)
- 💡 [Template Examples & Patterns](../tracks/day1-llm/lab-2-prompt-templates.md#examples)

**For Instructors Only**:

- ✅ [Complete Solutions](../tracks/day1-llm/lab-2-prompt-templates.md#solutions)
- 🎯 [Grading Rubric (if assessing)](../tracks/day1-llm/lab-2-prompt-templates.md#rubric)

**Success Criteria**:

- [ ] Template file created (`prompts/sentiment_analysis.j2`) with proper Jinja2 syntax
- [ ] Few-shot examples integrated (minimum 3 examples)
- [ ] Template tested with 5+ different inputs
- [ ] Output format is consistent across all test cases

!!! example "Challenge for Fast Finishers"
    **Extension**: Create a chain-of-thought template that breaks down a complex math problem step-by-step.
    **Hint**: Use intermediate variables in Jinja2 to store reasoning steps.

☕ **Break**: 3:00 - 3:15 PM (15 min)

---

### Lab 1.3: Micro-Evaluation Exercise (3:15 - 4:30, 75 min)

**Objectives**:

- Design evaluation criteria for LLM outputs (accuracy, relevance, format)
- Implement automated quality checks using Python
- Compare model performance systematically with statistical analysis

**Instructions**:

- 📝 [Student Instructions](../tracks/day1-llm/lab-3-micro-eval.md)
- 💡 [Evaluation Metrics Guide](../tracks/day1-llm/eval-safety-theory.md#evaluation-frameworks)

**For Instructors Only**:

- ✅ [Complete Solutions](../tracks/day1-llm/lab-3-micro-eval.md#solutions)
- 📊 [Example Evaluation Report](../tracks/day1-llm/lab-3-micro-eval.md#example-report)

**Success Criteria**:

- [ ] Evaluation framework defined with 3+ quantitative metrics
- [ ] Test set created with 10+ diverse examples
- [ ] Results analyzed with summary statistics (mean, std, min, max)
- [ ] Can articulate which model performs better and why

**Task Breakdown**:

1. **Define Metrics** (15 min): What makes a "good" output?
2. **Create Test Set** (15 min): Diverse examples covering edge cases
3. **Run Evaluation** (30 min): Automate scoring with Python
4. **Analyze Results** (15 min): Compare models, identify patterns

!!! warning "Common Pitfall"
    Students often create test sets that are too easy or too narrow.
    **Guidance**: "Include edge cases: ambiguous inputs, long texts, special characters."

🎯 **Wrap-Up & Q&A**: 4:30 - 5:00 PM (30 min)

**Discussion Prompts**:

- "What surprised you most about LLM behavior today?"
- "Which prompt pattern worked best for your use case?"
- "What questions do you still have about prompting or evaluation?"

**Preview Tomorrow (Day 2)**:

- Today: Single LLM calls with hand-crafted prompts
- Tomorrow: Add retrieval (RAG) for grounded, factual answers
- Bridge: "LLMs are great, but they don't know your data. That's where RAG comes in."

---

## 📚 Quick Reference

### All Day 1 Materials

<div class="grid cards" markdown>

-   :material-book-open-page-variant: __Theory & Slides__

    ---

    - [LLM Concepts](../tracks/day1-llm/llm-concepts.md) | [Slides](../slides/day1-llm-concepts.html)
    - [Prompt Patterns](../tracks/day1-llm/prompt-patterns-theory.md) | [Slides](../slides/day1-prompt-patterns-theory.html)
    - [Evaluation & Safety](../tracks/day1-llm/eval-safety-theory.md) | [Slides](../slides/day1-eval-safety-theory.html)

-   :material-flask-outline: __Labs & Notebooks__

    ---

    - [Lab 1.1: Quickstart](../tracks/day1-llm/lab-1-quickstart-two-envs.md)
    - [Lab 1.2: Templates](../tracks/day1-llm/lab-2-prompt-templates.md)
    - [Lab 1.3: Evaluation](../tracks/day1-llm/lab-3-micro-eval.md)
    - [Ollama Prompt Patterns Notebook](../assets/notebooks/day1/prompt_patterns_ollama.ipynb)
    - [watsonx Prompt Patterns Notebook](../assets/notebooks/day1/prompt_patterns_watsonx.ipynb)
    - [Micro Evaluation Notebook](../assets/notebooks/day1/micro_evaluation.ipynb)

-   :material-file-document-outline: __Instructor Resources__

    ---

    - [Day 1 Detailed Schedule](../tracks/day1-llm/day1-summary-and-schedule.md)
    - [Complete Instructor Guide](../tracks/day1-llm/README.md)
    - [Troubleshooting Guide](../tracks/day1-llm/README.md#troubleshooting)

-   :material-check-circle-outline: __Setup & Verification__

    ---

    - [Environment Verification](../tracks/day0-env/verify-environments.md)
    - [Student Handout (Printable)](../tracks/day1-llm/day1-summary-and-schedule.md)

</div>

### Navigation

- [⬅️ Previous: Day 0 - Environment Setup](day0-portal.md)
- [➡️ Next: Day 2 - RAG](day2-portal.md)
- [🏠 Workshop Home](../index.md)
- [📚 All Resources](../resources.md)

---

## 🎯 Learning Outcomes

By the end of Day 1, participants will be able to:

1. ✅ **Explain** how LLMs process text using tokens and embeddings
2. ✅ **Choose** appropriate deployment options (local vs. cloud) based on cost, privacy, and scale requirements
3. ✅ **Apply** instruction, few-shot, and chain-of-thought prompt patterns to real tasks
4. ✅ **Create** reusable prompt templates with Jinja2 for consistent outputs
5. ✅ **Design** and execute systematic evaluation frameworks to measure LLM performance
6. ✅ **Compare** model quality and latency across different deployment options

---

## 🔧 Troubleshooting

### Common Issues During Day 1

??? question "Ollama connection refused"
    **Symptoms**: `curl: (7) Failed to connect to localhost:11434`

    **Cause**: Ollama service not running

    **Solution**:
    ```bash
    # Start Ollama service
    ollama serve

    # In another terminal, verify
    ollama list
    ```

    **Prevention**: Add `ollama serve` to startup scripts

    [Detailed Guide →](../tracks/day0-env/setup-simple-ollama-environment.md#troubleshooting)

??? question "watsonx.ai authentication fails"
    **Symptoms**: `401 Unauthorized` or `Invalid API key`

    **Cause**: Invalid API key or project ID in `.env` file

    **Solution**:
    ```bash
    # Check your .env file
    cat .env | grep WATSONX

    # Expected format:
    # WATSONX_API_KEY=your_key_here
    # WATSONX_PROJECT_ID=your_project_id
    ```

    **Fix**: Regenerate API key at [IBM Cloud](https://cloud.ibm.com/iam/apikeys)

    [Detailed Guide →](../tracks/day0-env/setup-simple-watsonx-enviroment.md#troubleshooting)

??? question "Jinja2 template rendering error"
    **Symptoms**: `jinja2.exceptions.TemplateSyntaxError: unexpected '}'`

    **Cause**: Unescaped curly braces in template

    **Solution**:
    ```jinja2
    {# Wrong #}
    Use JSON format: {"key": "value"}

    {# Correct #}
    Use JSON format: {{ "{{ " }}"key": "value"{{ " }}" }}
    ```

    **Prevention**: Use `{% raw %}...{% endraw %}` for literal curly braces

    [Template Troubleshooting →](../tracks/day1-llm/lab-2-prompt-templates.md#troubleshooting)

??? question "Lab taking too long - what do I skip?"
    **Scenario**: 2:30 PM and students still on Lab 1.1

    **Instructor Actions**:
    1. **Assess**: How many students are stuck vs. exploring?
    2. **Decide**:
       - If >50% stuck: Do group walkthrough of solution
       - If <50% stuck: Help individually, let others continue
    3. **Adjust**: Merge Labs 1.2 and 1.3 into single 90-min session
    4. **Assign**: Lab 1.3 as homework, review solutions tomorrow morning

    **Communication**: "We're adjusting pace to ensure everyone succeeds. Lab 1.3 will be homework, and we'll review solutions first thing tomorrow."

---

## 📊 Teaching Notes

### Recommended Pacing Adjustments

**If Running Behind** (>15 min late):

- ⏭️ Skip live demo in Module 1.2, show pre-recorded video instead
- ⏭️ Combine Lab 1.1 and 1.2 into single 90-min session (provide starter template)
- ⏭️ Assign Lab 1.3 as homework, review solutions tomorrow morning
- ⏭️ Shorten wrap-up Q&A to 15 minutes

**If Running Ahead** (>15 min early):

- ➕ Add advanced prompt engineering topics (retrieval hints for RAG preview, citation formatting)
- ➕ Introduce Day 2 RAG concepts early (why LLMs need external knowledge)
- ➕ Let students experiment with different models (llama2 vs. mistral in Ollama)
- ➕ Have students present their evaluation results to the group

### Energy Management

**Morning (9:00 - 12:00)**:

- High energy: Use for conceptually dense content (LLM architecture)
- Interactive: Call on students frequently to maintain engagement
- Visual: Use diagrams and animations in slides

**Post-Lunch (1:00 - 2:00)**:

- Lower energy: Start with easy Lab 1.1 (hands-on reengages)
- Movement: Encourage students to stand, stretch during first lab
- Avoid: Heavy theory or long lectures right after lunch

**Late Afternoon (3:00 - 5:00)**:

- Fatigue sets in: Use pair programming for Lab 1.3
- Breaks: Enforce 15-min break at 3:00 PM (non-negotiable)
- Motivation: Highlight progress - "You've built 3 working systems today!"

---

## 📝 Daily Schedule (At-a-Glance)

```mermaid
gantt
    title Day 1: LLMs & Prompting Schedule
    dateFormat HH:mm
    axisFormat %H:%M

    section Morning Theory
    Module 1.0: LLM Concepts           :09:00, 90m
    Break                              :10:30, 15m
    Module 1.2: Prompt Patterns        :10:45, 75m
    Lunch                              :12:00, 60m

    section Afternoon Labs
    Lab 1.1: Quickstart                :13:00, 60m
    Lab 1.2: Templates                 :14:00, 60m
    Break                              :15:00, 15m
    Lab 1.3: Evaluation                :15:15, 75m
    Wrap-up & Q&A                      :16:30, 30m
```

---

## 💬 Common Student Questions

### Conceptual Questions

??? question "Q: How do LLMs 'understand' my prompt?"
    **Short Answer**: They don't "understand" like humans. They predict the most likely next tokens based on patterns learned from training data.

    **Analogy**: Like autocomplete on your phone, but trained on trillions of words.

    **Key Point**: This is why prompt engineering matters - we're guiding the prediction process.

??? question "Q: Which model should I use for production?"
    **Framework**: Cost vs. Quality vs. Latency trade-off

    | Use Case | Recommendation |
    |----------|----------------|
    | High-volume, cost-sensitive | Ollama (llama2-7b) |
    | Enterprise, compliance-critical | watsonx.ai (granite-13b) |
    | Maximum quality, budget flexible | watsonx.ai (granite-34b or llama-70b) |

    **Decision Matrix**: [See resources page](../resources.md#model-selection)

??? question "Q: How do I prevent hallucinations?"
    **Techniques**:
    1. **Lower temperature**: `temperature=0` for deterministic outputs
    2. **Add retrieval (RAG)**: Ground answers in real documents (Day 2 topic!)
    3. **Few-shot examples**: Show correct behavior explicitly
    4. **Evaluation**: Systematic testing catches hallucinations early (Lab 1.3)

    **Preview**: "Tomorrow we'll add RAG, which dramatically reduces hallucinations by giving the model real facts to reference."

### Technical Questions

??? question "Q: Why is Ollama so slow on my laptop?"
    **Possible Causes**:
    - Model too large for RAM (try llama2-7b instead of 13b)
    - CPU inference (GPU is 10-100x faster)
    - Background processes consuming resources

    **Quick Diagnosis**:
    ```bash
    # Check model size
    ollama list

    # Monitor resource usage during inference
    top  # or htop on Linux
    ```

    **Solution**: Use smaller model or upgrade to GPU-enabled machine

??? question "Q: Can I use my own fine-tuned model?"
    **Ollama**: Yes! [Import custom models](https://github.com/ollama/ollama/blob/main/docs/import.md)

    **watsonx.ai**: Yes, via [custom foundation models](https://www.ibm.com/docs/en/watsonx-as-a-service?topic=models-custom)

    **Note**: We don't cover fine-tuning in this workshop, but resources available in [Day 3 Recap](../tracks/day3-orchestrate/recap-and-next-steps.md#advanced-topics)

---

## 📝 Homework (Optional)

For students who want extra practice or fell behind:

### Required (If Behind)

- [ ] Complete Lab 1.3 (Micro-Evaluation Exercise)
- [ ] Review solutions for Labs 1.1 and 1.2
- [ ] Verify your environment for Day 2 RAG (requires vector database)

### Stretch Goals

- [ ] Implement all three prompt patterns (instruction, few-shot, CoT) for your own use case
- [ ] Create a prompt template library for common tasks (email drafting, summarization, Q&A)
- [ ] Design evaluation criteria for a real project you're working on
- [ ] Read ahead: [Day 2 RAG Architecture Overview](../tracks/day2-rag/Theory_01_RAG_Architecture_Overview.md)

### Reflection Questions

- What was the biggest "aha moment" for you today?
- Which concept is still unclear that we should review tomorrow?
- How might you apply LLM prompting in your current work?

---

## 🤝 Getting Help

**During Workshop**:

- Raise hand or use "help" sticky note on laptop
- Ask in workshop Slack/Teams channel
- Pair with neighbor for peer support

**After Hours**:

- Email: [instructor-email@example.com]
- Forum: [Workshop Discussion Board](https://example.com/forum)
- Office Hours: [Schedule available](https://example.com/office-hours)

**Technical Issues**:

- Environment problems: See [Day 0 Setup](../tracks/day0-env/prereqs-and-accounts.md)
- Code errors: Check [Troubleshooting Guide](../tracks/day1-llm/README.md#troubleshooting)
- Conceptual questions: Review [theory pages](../tracks/day1-llm/llm-concepts.md)

---

**Last Updated**: 2025-01-13 | **Estimated Teaching Time**: 8 hours | **Success Rate**: Target 95% lab completion