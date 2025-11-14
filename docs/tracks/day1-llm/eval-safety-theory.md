# 📊 Lightweight Evaluation & Safety

Measuring performance and ensuring safe behavior

::: notes
As LLMs become central to applications, we need systematic ways to measure quality and ensure safety. This module covers practical evaluation and responsible AI.
:::

---

## 🎯 Learning Objectives {data-background-color="#0f172a"}

By the end of this module, you will:

<span class="fragment">✅ Understand why evaluation matters for LLM applications</span>

<span class="fragment">✅ Know basic evaluation signals for assessing outputs</span>

<span class="fragment">✅ Be aware of safety and responsible use considerations</span>

<span class="fragment">✅ Understand how evaluation integrates with the accelerator</span>

::: notes
Evaluation isn't optional in production. It's the difference between shipping something that works and shipping something that breaks in production.
:::

---

## ⚠️ Why Evaluation Matters {data-transition="zoom"}

The problem with deploying LLMs without evaluation

::: notes
Let's start by understanding what goes wrong when you don't evaluate.
:::

---

## 🔴 Problem 1: Hallucinations

Model generates **plausible but false** information

```
Q: "What is IBM's revenue in 2025?"
Bad Answer: "IBM's revenue in 2025 was $87.4 billion."
```

<span class="fragment">**Made up number!**</span>

::: notes
Hallucinations are dangerous because they sound confident and plausible. Users can't tell the difference without fact-checking.
:::

---

## 🔴 Problem 2: Inconsistency

Same question, different responses

```
Monday: "The capital of Australia is Sydney."
Tuesday: "The capital of Australia is Canberra." [Correct]
```

::: notes
Without evaluation, you won't know your system gives inconsistent answers. This erodes user trust quickly.
:::

---

## 💼 Business Impact

Wrong answers lead to:

<span class="fragment">🔴 Lost customer trust</span>

<span class="fragment">🔴 Compliance violations</span>

<span class="fragment">🔴 Financial losses</span>

<span class="fragment">🔴 Reputational damage</span>

::: notes
In regulated industries like healthcare and finance, wrong answers can have legal consequences. Evaluation isn't just nice to have—it's required.
:::

---

## ✅ The Solution

**Systematic evaluation** helps you:

<span class="fragment">🎯 Catch problems before they reach users</span>

<span class="fragment">🎯 Compare different models or prompts</span>

<span class="fragment">🎯 Track quality over time</span>

<span class="fragment">🎯 Build confidence in your system</span>

::: notes
Think of evaluation as your QA process for AI. You wouldn't ship code without tests. Don't ship LLMs without evaluation.
:::

---

## 📏 Simple Evaluation Signals {data-background-color="#1e293b"}

Five practical metrics you can implement today

::: notes
Let's explore five evaluation signals that are easy to measure and highly informative.
:::

---

## 1️⃣ Correctness

Does the answer match **known correct information**?

```python {data-line-numbers="1-7"}
def evaluate_correctness(model_answer: str, ground_truth: str) -> int:
    """Returns 1 if correct, 0 if incorrect"""
    # Simple exact match
    if model_answer.strip().lower() == ground_truth.strip().lower():
        return 1

    # Or use semantic similarity
    similarity = compute_similarity(model_answer, ground_truth)
    return 1 if similarity > 0.8 else 0
```

::: notes
Correctness is the most objective metric. If you have ground truth, use it. When you don't have ground truth, you need human evaluators or more sophisticated metrics.
:::

---

## ✅ Correctness Example

```
Question: "What year was IBM founded?"
Model Answer: "1911"
Ground Truth: "1911"
Score: 1 (Correct)

---

Question: "What year was IBM founded?"
Model Answer: "1920"
Ground Truth: "1911"
Score: 0 (Incorrect)
```

::: notes
Binary scoring is simple and clear. You either got it right or you didn't.
:::

---

## 2️⃣ Coherence and Relevance

Is the answer **logically sound** and **on-topic**?

**Manual rubric:**
<span class="fragment">5 - Highly coherent, directly addresses the question</span>
<span class="fragment">4 - Mostly coherent, relevant but minor issues</span>
<span class="fragment">3 - Somewhat coherent, partially relevant</span>
<span class="fragment">2 - Incoherent or largely irrelevant</span>
<span class="fragment">1 - Nonsensical or completely off-topic</span>

::: notes
When there's no ground truth, coherence and relevance become your primary metrics. This requires human judgment but is still systematic.
:::

---

## 🎯 Coherence Examples

```
Question: "How do I reset my password?"
Answer: "To reset your password, click 'Forgot Password' on the login page..."
Score: 5 (Highly coherent and relevant)

---

Question: "How do I reset my password?"
Answer: "Our company was founded in 2010 and has grown significantly..."
Score: 1 (Off-topic)
```

::: notes
Extreme cases are easy to score. The middle ground requires more judgment. That's where evaluation becomes an art.
:::

---

## 3️⃣ Style/Format Adherence

Does the output follow **specified formatting**?

```python {data-line-numbers="1-17"}
def evaluate_format(response: str, expected_format: str) -> int:
    """Check if response matches expected format"""
    if expected_format == "json":
        try:
            json.loads(response)
            return 1
        except:
            return 0

    elif expected_format == "bullet_points":
        lines = response.split('\n')
        bullet_lines = [l for l in lines
                       if l.strip().startswith(('-', '*', '•'))]
        return 1 if len(bullet_lines) >= 3 else 0

    # Add more format checks as needed
```

::: notes
Format checking can be automated. This is especially important for API responses where downstream systems expect specific formats.
:::

---

## 📋 Format Example

```
Instruction: "List 3 benefits of cloud computing in bullet points."

Good response:
- Scalability and flexibility
- Cost-effectiveness
- High availability
Score: 1

Bad response:
"Cloud computing offers many benefits including scalability..."
Score: 0 (Not in bullet format)
```

::: notes
Clear pass/fail. Either it followed the format or it didn't.
:::

---

## 4️⃣ Completeness

Does the answer address **all parts** of the question?

<span class="fragment">Question has 3 sub-parts:</span>
<span class="fragment">- Answers all 3: Score = 1.0</span>
<span class="fragment">- Answers 2 of 3: Score = 0.66</span>
<span class="fragment">- Answers 1 of 3: Score = 0.33</span>
<span class="fragment">- Answers 0: Score = 0</span>

::: notes
Partial credit reflects partial completeness. This metric catches models that answer only the easy parts of complex questions.
:::

---

## 📊 Completeness Example

```
Question: "What is RAG, how does it work, and what are its benefits?"

Full Answer:
"RAG stands for Retrieval-Augmented Generation. It works by first
retrieving relevant documents, then using them as context for the LLM.
Benefits include reduced hallucinations and up-to-date information."
Score: 1.0 (Addresses all 3 parts)

Partial Answer:
"RAG stands for Retrieval-Augmented Generation and helps reduce hallucinations."
Score: 0.66 (Only 2 of 3 parts)
```

::: notes
This encourages thoroughness. Models that skip parts of complex questions get penalized.
:::

---

## 5️⃣ Latency

How long does the model take to respond?

```python {data-line-numbers="1-15"}
import time

start = time.time()
response = llm.generate(prompt)
latency = time.time() - start

# Evaluate against threshold
if latency < 1.0:
    score = 1  # Excellent
elif latency < 3.0:
    score = 0.75  # Good
elif latency < 5.0:
    score = 0.5  # Acceptable
else:
    score = 0.25  # Too slow
```

::: notes
Latency matters. Users abandon slow applications. Set latency thresholds based on your use case. Chatbots need sub-second responses. Batch processing can tolerate minutes.
:::

---

## 🛡️ Safety & Responsible Use {data-background-color="#0f172a" data-transition="zoom"}

Potential risks and mitigation strategies

::: notes
LLMs are powerful but can generate harmful content. Let's discuss the categories of risk and how to mitigate them.
:::

---

## ⚠️ Risk Categories

<span class="fragment">🔴 **1. Personal Information (PII)**: SSNs, credit cards, passwords</span>

<span class="fragment">🔴 **2. Harmful Content**: Hate speech, violence, self-harm</span>

<span class="fragment">🔴 **3. Misinformation**: Medical/financial advice as fact</span>

<span class="fragment">🔴 **4. Bias and Fairness**: Stereotyping, unfair treatment</span>

<span class="fragment">🔴 **5. Privacy Violations**: Exposing training data</span>

::: notes
These risks are real. Every production LLM system needs safeguards against them. The good news: there are proven mitigation strategies.
:::

---

## 🛡️ Mitigation Strategy 1: Clear Instructions

**Example system prompt:**

```python {data-line-numbers="1-12"}
SAFE_SYSTEM_PROMPT = """You are a helpful assistant. Follow these guidelines:

1. Do not generate, process, or request personal information (PII)
2. Do not provide medical, legal, or financial advice
3. If asked to do something harmful or illegal, politely decline
4. If unsure, express uncertainty rather than guessing
5. Be respectful and unbiased in all responses
6. If a question is outside your scope, redirect to appropriate resources

Now, assist the user with their request."""
```

::: notes
Clear guidelines in the system prompt are your first line of defense. Models generally follow them, though not perfectly.
:::

---

## 🛡️ Mitigation Strategy 2: Limit Scope

**Define boundaries:**

```
You are a customer support assistant for [Product].
You help with account issues, billing questions, and basic troubleshooting.
For technical issues, escalate to the engineering team.
```

<span class="fragment">❌ Not: "You are an AI that can do anything."</span>

::: notes
Limit what the model can do. If it's a support bot, it shouldn't give medical advice. Narrow scope reduces risk.
:::

---

## 🛡️ Mitigation Strategy 3: Guardrails

**Pre-processing** (before LLM):

```python {data-line-numbers="1-12"}
def check_input_safety(user_input: str) -> bool:
    """Screen user input for harmful content"""
    harmful_patterns = [
        r'how to (hack|crack|steal)',
        r'(bomb|weapon) (instructions|recipe)',
        # ... more patterns
    ]

    for pattern in harmful_patterns:
        if re.search(pattern, user_input, re.IGNORECASE):
            return False  # Block request

    return True  # Allow request
```

::: notes
Catch harmful requests before they reach the LLM. Simple pattern matching can catch obvious abuse.
:::

---

## 🛡️ Guardrails: Post-processing

**After LLM generates response:**

```python {data-line-numbers="1-14"}
def check_output_safety(response: str) -> bool:
    """Screen LLM output for harmful content"""
    # Check for PII patterns
    if re.search(r'\d{3}-\d{2}-\d{4}', response):  # SSN pattern
        return False

    # Check for hate speech indicators
    # Use a library like Detoxify or Perspective API
    toxicity_score = check_toxicity(response)
    if toxicity_score > 0.7:
        return False

    return True
```

::: notes
Even good models occasionally slip. Post-processing catches outputs that violate your policies before they reach users.
:::

---

## 🛡️ Mitigation Strategy 4: Human-in-the-Loop

For high-stakes applications:

<span class="fragment">✅ **Preview before send**: Show user what model will say</span>

<span class="fragment">✅ **Feedback mechanisms**: Allow users to report issues</span>

<span class="fragment">✅ **Audit trails**: Log all interactions for review</span>

<span class="fragment">✅ **Manual review**: Have humans spot-check outputs</span>

::: notes
In healthcare, finance, or legal domains, consider human review of critical responses. Automation is great, but some decisions need human oversight.
:::

---

## 🛡️ Mitigation Strategy 5: Model Choice

**Choose appropriate models:**

<span class="fragment">✅ Models trained with safety alignment (e.g., Granite's built-in guardrails)</span>

<span class="fragment">✅ Avoid models fine-tuned on unfiltered web data for sensitive applications</span>

::: notes
Not all models are created equal for safety. Granite models, for example, have safety alignment built in. Choose models appropriate for your risk tolerance.
:::

---

## 🛡️ Safe Configuration

```python {data-line-numbers="1-5"}
# Lower temperature for factual tasks (less creativity = less risk)
params = {
    "temperature": 0.2,  # More deterministic
    "top_p": 0.1,        # More focused
    "max_tokens": 200,   # Limit response length
}
```

::: notes
Conservative parameter settings reduce risk. Lower temperature means fewer surprises. Max tokens prevents extremely long (potentially problematic) responses.
:::

---

## 🏗️ Accelerator Integration {data-background-color="#1e293b"}

How evaluation fits into the production pipeline

::: notes
Let's connect evaluation to the actual codebase you'll work with.
:::

---

## 📁 Accelerator: tools/eval_small.py

**Purpose:** Run a small evaluation dataset through your RAG system

<span class="fragment">**You'll implement on Day 2-3**</span>

::: notes
This is where your evaluation code lives. You'll build a mini version in Lab 1.3 today, then extend it for RAG on Day 2.
:::

---

## 🔬 eval_small.py Structure

```python {data-line-numbers="1-20"}
def evaluate_rag_system(test_file: str, output_file: str):
    """
    Evaluate RAG system on a test set

    Args:
        test_file: CSV with columns [question, ground_truth, category]
        output_file: Where to save results
    """
    # Load test data
    df = pd.read_csv(test_file)

    # Initialize pipeline
    pipeline = RAGPipeline()

    results = []
    for idx, row in df.iterrows():
        # Generate answer
        response = pipeline.answer_question(row['question'])

        # Evaluate
        correctness = evaluate_correctness(response, row['ground_truth'])
        relevance = evaluate_relevance(response, row['question'])

        results.append({...})

    # Save results and compute stats
```

::: notes
This is the pattern you'll follow. Load test data, generate responses, evaluate, save results. Simple but powerful.
:::

---

## 📊 Production Logging

**What gets logged** (in `service/api.py`):

```json {data-line-numbers="1-12"}
{
  "timestamp": "2025-01-15T10:30:00Z",
  "question": "How do I reset my password?",
  "answer": "To reset your password...",
  "retrieved_docs": ["doc_123", "doc_456"],
  "latency_ms": 1250,
  "model": "granite-13b-instruct-v2",
  "user_feedback": "helpful",
  "correctness": null,  # Filled by evaluator
  "notes": ""
}
```

::: notes
Every request is logged. This creates an audit trail and enables continuous evaluation. You can re-evaluate past responses as your metrics improve.
:::

---

## 📈 Analysis Notebook

**Notebook:** `Analyze_Log_and_Feedback.ipynb`

**What it does:**
<span class="fragment">📊 Analyze patterns in logs</span>
<span class="fragment">📊 Track metrics over time</span>
<span class="fragment">📊 Identify common failure modes</span>
<span class="fragment">📊 Generate improvement recommendations</span>

::: notes
The analysis notebook turns logs into insights. Which questions fail most often? What's the average latency? Are users giving thumbs up or thumbs down?
:::

---

## 🧪 Lab 1.3 Preview {data-background-color="#0f172a"}

What you'll build this afternoon

::: notes
Let's preview Lab 1.3, where you'll implement a micro-evaluation framework.
:::

---

## 📝 Lab 1.3: Your Tasks

<span class="fragment">1️⃣ Create a **test set** of 5-10 diverse prompts</span>

<span class="fragment">2️⃣ Collect outputs from **Ollama and watsonx**</span>

<span class="fragment">3️⃣ Apply **manual rubric** (correctness, clarity, style)</span>

<span class="fragment">4️⃣ **Analyze results** comparatively</span>

::: notes
This is a mini version of production evaluation. The skills you learn here scale directly to production.
:::

---

## 📊 Lab 1.3: Example Output

| prompt | backend | answer | correctness | clarity | style_match |
|--------|---------|--------|-------------|---------|-------------|
| "Summarize AI..." | ollama | "AI is..." | 4 | 5 | 4 |
| "Summarize AI..." | watsonx | "Artificial..." | 5 | 5 | 5 |
| "Extract emails..." | ollama | "john@..." | 5 | 4 | 5 |

::: notes
You'll create a structured DataFrame like this. It enables systematic comparison and analysis.
:::

---

## 🔗 Connection to Production

**Your micro-framework is a prototype for:**

<span class="fragment">✅ `tools/eval_small.py` (automated evaluation)</span>

<span class="fragment">✅ `Analyze_Log_and_Feedback.ipynb` (production analytics)</span>

<span class="fragment">✅ Continuous monitoring dashboards</span>

::: notes
Start small, scale up. The patterns you learn with 10 prompts work with 10,000 prompts. Only the automation and scale change.
:::

---

## 📈 Evaluation Maturity Model {data-transition="zoom"}

Where are you in the evaluation journey?

::: notes
Let's contextualize where you'll be after today versus where you're heading.
:::

---

## 📊 Level 1: Ad Hoc

<span class="fragment">❌ Manual testing with few examples</span>

<span class="fragment">❌ "Looks good to me" approval</span>

<span class="fragment">❌ No systematic tracking</span>

::: notes
Most teams start here. It's better than nothing but doesn't scale.
:::

---

## 📊 Level 2: Basic ← Lab 1.3 targets this

<span class="fragment">✅ Small test set (10-50 examples)</span>

<span class="fragment">✅ Manual rubric</span>

<span class="fragment">✅ Occasional re-evaluation</span>

::: notes
Lab 1.3 gets you to Level 2. This is the minimum for responsible development.
:::

---

## 📊 Level 3: Systematic ← eval_small.py targets this

<span class="fragment">✅ Curated test set (100-500 examples)</span>

<span class="fragment">✅ Automated metrics where possible</span>

<span class="fragment">✅ Regular evaluation runs</span>

<span class="fragment">✅ Version control for prompts and results</span>

::: notes
Day 2-3 gets you to Level 3. This is production-ready evaluation.
:::

---

## 📊 Level 4: Continuous ← Production goal

<span class="fragment">✅ Large test set + production monitoring</span>

<span class="fragment">✅ Automated evaluation pipeline</span>

<span class="fragment">✅ A/B testing framework</span>

<span class="fragment">✅ Real-time alerting on quality degradation</span>

<span class="fragment">✅ Integration with CI/CD</span>

::: notes
Level 4 is the gold standard. Evaluation runs automatically on every change. Quality issues trigger alerts. This is where mature teams operate.
:::

---

## ✅ Best Practices {data-background-color="#1e293b"}

Evaluation dos and don'ts

::: notes
Let's wrap up with clear guidance on evaluation best practices.
:::

---

## ✅ Do

<span class="fragment">✅ **Start simple**: Don't over-engineer initially</span>

<span class="fragment">✅ **Automate what you can**: Manual review doesn't scale</span>

<span class="fragment">✅ **Track over time**: Evaluation is ongoing</span>

<span class="fragment">✅ **Test edge cases**: Don't just test happy paths</span>

<span class="fragment">✅ **Involve stakeholders**: Domain experts validate quality</span>

<span class="fragment">✅ **Version everything**: Track prompts, models, test sets</span>

::: notes
Treat evaluation as a first-class development activity. It's not an afterthought—it's central to quality.
:::

---

## ❌ Don't

<span class="fragment">❌ **Skip evaluation**: "It looks good" isn't enough</span>

<span class="fragment">❌ **Rely solely on accuracy**: Context matters (latency, safety, cost)</span>

<span class="fragment">❌ **Forget about drift**: Models and data change</span>

<span class="fragment">❌ **Ignore user feedback**: Real usage reveals issues testing doesn't</span>

<span class="fragment">❌ **Over-optimize for metrics**: Gaming metrics ≠ real quality</span>

::: notes
Goodhart's Law: When a measure becomes a target, it ceases to be a good measure. Don't game your metrics. Focus on real quality.
:::

---

## 🎯 Key Takeaways

<span class="fragment">🔑 **Evaluation is essential**: Don't deploy without systematic checks</span>

<span class="fragment">🔑 **Start simple**: Basic metrics beat no metrics</span>

<span class="fragment">🔑 **Safety first**: Proactively mitigate risks with guardrails</span>

<span class="fragment">🔑 **Iterate**: Evaluation frameworks evolve with your application</span>

<span class="fragment">🔑 **Automate**: Scale evaluation as your system scales</span>

::: notes
Evaluation and safety are not optional. They're the foundation of responsible LLM deployment. Start simple, but start now.
:::

---

## 🚀 Next: Lab 1.3

Let's build your first evaluation framework!

::: notes
You've learned the theory. Now it's time to apply it. Lab 1.3 is where you'll implement these evaluation signals and see them in action.
:::