# 1.3 Lightweight Evaluation & Safety

As LLMs become central to your applications, you need ways to measure their performance and ensure they behave safely. This module covers practical evaluation strategies and responsible AI considerations.

---

## Learning Objectives

By the end of this module, you will:

- Understand why evaluation matters for LLM applications
- Know basic evaluation signals for assessing LLM outputs
- Be aware of safety and responsible use considerations
- Understand how evaluation integrates with the accelerator

---

## Why Evaluation Matters

### The Problem

LLMs are powerful but unpredictable. Without evaluation, you risk:

**Hallucinations**: Model generates plausible but false information
```
Q: "What is IBM's revenue in 2025?"
Bad Answer: "IBM's revenue in 2025 was $87.4 billion." [Made up number]
```

**Inconsistent Answers**: Same question, different responses
```
Monday: "The capital of Australia is Sydney."
Tuesday: "The capital of Australia is Canberra." [Correct]
```

**Business Impact**: Wrong answers can lead to:
- Lost customer trust
- Compliance violations
- Financial losses
- Reputational damage

### The Solution

**Systematic evaluation** helps you:
- Catch problems before they reach users
- Compare different models or prompts
- Track quality over time
- Build confidence in your system

---

## Simple Evaluation Signals

### 1. Correctness (Ground Truth Comparison)

**What it is**: Does the answer match known correct information?

**How to measure**:
```python
def evaluate_correctness(model_answer: str, ground_truth: str) -> int:
    """Returns 1 if correct, 0 if incorrect"""
    # Simple exact match
    if model_answer.strip().lower() == ground_truth.strip().lower():
        return 1
    
    # Or use semantic similarity
    similarity = compute_similarity(model_answer, ground_truth)
    return 1 if similarity > 0.8 else 0
```

**Example**:
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

**When to use**: When you have known correct answers (test sets, benchmarks)

### 2. Coherence and Relevance

**What it is**: Is the answer logically sound and on-topic?

**How to measure (manual rubric)**:
```
5 - Highly coherent, directly addresses the question
4 - Mostly coherent, relevant but may have minor issues
3 - Somewhat coherent, partially relevant
2 - Incoherent or largely irrelevant
1 - Nonsensical or completely off-topic
```

**Example**:
```
Question: "How do I reset my password?"
Answer: "To reset your password, click 'Forgot Password' on the login page..."
Score: 5 (Highly coherent and relevant)

---

Question: "How do I reset my password?"
Answer: "Our company was founded in 2010 and has grown significantly..."
Score: 1 (Off-topic)
```

**When to use**: For open-ended questions without clear ground truth

### 3. Style/Format Adherence

**What it is**: Does the output follow specified formatting?

**How to measure**:
```python
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
        bullet_lines = [l for l in lines if l.strip().startswith(('-', '*', '•'))]
        return 1 if len(bullet_lines) >= 3 else 0
    
    # Add more format checks as needed
```

**Example**:
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

**When to use**: For structured outputs, API responses, report generation

### 4. Completeness

**What it is**: Does the answer address all parts of the question?

**How to measure**:
```
Question has 3 sub-parts:
- Answers all 3: Score = 1.0
- Answers 2 of 3: Score = 0.66
- Answers 1 of 3: Score = 0.33
- Answers 0: Score = 0
```

**Example**:
```
Question: "What is RAG, how does it work, and what are its benefits?"

Full Answer:
"RAG stands for Retrieval-Augmented Generation. It works by first retrieving 
relevant documents, then using them as context for the LLM. Benefits include 
reduced hallucinations and up-to-date information."
Score: 1.0 (Addresses all 3 parts)

Partial Answer:
"RAG stands for Retrieval-Augmented Generation and helps reduce hallucinations."
Score: 0.66 (Only 2 of 3 parts)
```

### 5. Latency

**What it is**: How long does the model take to respond?

**How to measure**:
```python
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

**When to use**: Always, especially for user-facing applications

---

## Safety & Responsible Use

### Potential Risky Categories

LLMs can potentially generate harmful content in these categories:

1. **Personal Information (PII)**
   - Social security numbers, credit cards, passwords
   - Addresses, phone numbers, email addresses

2. **Harmful Content**
   - Hate speech, discrimination, harassment
   - Violence, self-harm, dangerous activities
   - Illegal activities, fraud schemes

3. **Misinformation**
   - Medical advice without disclaimers
   - Financial advice as fact
   - False claims about public figures

4. **Bias and Fairness**
   - Stereotyping based on protected attributes
   - Unfair treatment of groups
   - Lack of representation

5. **Privacy Violations**
   - Exposing training data
   - Re-identifying anonymized data
   - Leaking confidential business information

### Mitigation Strategies

#### 1. Clear Instructions to the Model

**Example system prompt**:
```python
SAFE_SYSTEM_PROMPT = """You are a helpful assistant. Follow these guidelines:

1. Do not generate, process, or request personal information (PII)
2. Do not provide medical, legal, or financial advice
3. If asked to do something harmful or illegal, politely decline
4. If unsure, express uncertainty rather than guessing
5. Be respectful and unbiased in all responses
6. If a question is outside your scope, redirect to appropriate resources

Now, assist the user with their request."""
```

#### 2. Proper Context & Scope

**Limit the model's role**:
```python
# Instead of:
"You are an AI that can do anything."

# Use:
"You are a customer support assistant for [Product]. 
You help with account issues, billing questions, and basic troubleshooting.
For technical issues, escalate to the engineering team."
```

#### 3. Guardrails and Review

**Pre-processing** (before sending to LLM):
```python
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

**Post-processing** (after LLM generates response):
```python
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

**Fallback responses**:
```python
SAFETY_FALLBACK = """I'm not able to help with that request. 
If you need assistance with [product/service], please contact [appropriate channel]."""
```

#### 4. Human-in-the-Loop

For high-stakes applications:
- **Preview before send**: Show user what the model will say
- **Feedback mechanisms**: Allow users to report issues
- **Audit trails**: Log all interactions for review
- **Manual review**: Have humans spot-check outputs

#### 5. Model Choice and Configuration

**Choose appropriate models**:
- Models trained with safety alignment (e.g., Granite's built-in guardrails)
- Avoid models fine-tuned on unfiltered web data for sensitive applications

**Configure safely**:
```python
# Lower temperature for factual tasks (more deterministic, less creative)
params = {
    "temperature": 0.2,  # Less randomness
    "top_p": 0.1,        # More focused
    "max_tokens": 200,   # Limit response length
}
```

---

## How This Ties into the Accelerator

### Evaluation Entry Points

#### 1. `tools/eval_small.py`

**Purpose**: Run a small evaluation dataset through your RAG system

**What you'll implement on Day 2-3**:
```python
# tools/eval_small.py

import pandas as pd
from accelerator.rag.pipeline import RAGPipeline

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
        
        results.append({
            'question': row['question'],
            'model_answer': response,
            'ground_truth': row['ground_truth'],
            'correctness': correctness,
            'relevance': relevance,
            'category': row['category']
        })
    
    # Save results
    results_df = pd.DataFrame(results)
    results_df.to_csv(output_file, index=False)
    
    # Summary stats
    print(f"Overall Correctness: {results_df['correctness'].mean():.2%}")
    print(f"Overall Relevance: {results_df['relevance'].mean():.2%}")
```

#### 2. `accelerator/assets/notebook/Analyze_Log_and_Feedback.ipynb`

**Purpose**: Analyze logs and user feedback from the production service

**What it does**:
- Load logs from `service/api.py`
- Analyze patterns:
  - Most common questions
  - Average response time
  - User feedback ratings
  - Error rates
- Generate insights for improvement

**Example log entry**:
```json
{
  "timestamp": "2025-01-15T10:30:00Z",
  "question": "How do I reset my password?",
  "answer": "To reset your password...",
  "retrieved_docs": ["doc_123", "doc_456"],
  "latency_ms": 1250,
  "user_feedback": "helpful",
  "model": "granite-13b-instruct"
}
```

### Your Manual Rubric Influences:

**What you log** (in `service/api.py`):
```python
@app.post("/ask")
async def ask_question(request: QuestionRequest):
    start_time = time.time()
    
    # Generate answer
    response = pipeline.answer_question(request.question)
    
    # Log for later evaluation
    log_entry = {
        "timestamp": datetime.now().isoformat(),
        "question": request.question,
        "answer": response.answer,
        "retrieved_docs": response.source_ids,
        "latency_ms": (time.time() - start_time) * 1000,
        "model": config.model_id,
        # Evaluation placeholders
        "user_feedback": None,  # Filled in later
        "correctness": None,    # Can be auto-evaluated if ground truth available
    }
    
    logger.info(log_entry)
    return response
```

**What metrics you compute** (in `eval_small.py`):
```python
# Metrics derived from your rubric
metrics = {
    "correctness": df['correctness'].mean(),
    "relevance": df['relevance'].mean(),
    "format_adherence": df['format_ok'].mean(),
    "avg_latency_ms": df['latency_ms'].mean(),
    "p95_latency_ms": df['latency_ms'].quantile(0.95),
}
```

---

## How This Connects to Lab 1.3

### What You'll Build

In Lab 1.3, you'll create a **micro-evaluation framework**:

1. **Test set**: 5-10 diverse prompts
2. **Data collection**: Run prompts through Ollama and watsonx
3. **Rating rubric**: Apply manual ratings (correctness, clarity, style)
4. **Analysis**: Compare backends, identify patterns

### Example Output (DataFrame)

| prompt | backend | answer | correctness | clarity | style_match |
|--------|---------|--------|-------------|---------|-------------|
| "Summarize AI..." | ollama | "AI is..." | 4 | 5 | 4 |
| "Summarize AI..." | watsonx | "Artificial..." | 5 | 5 | 5 |
| "Extract emails..." | ollama | "john@..." | 5 | 4 | 5 |

### Skills You'll Develop

- Programmatic evaluation loops
- Rating rubric design
- Comparative analysis
- Data-driven decision making

### Connection to Production

This micro-framework is a **prototype** for:
- `tools/eval_small.py` (automated evaluation)
- `Analyze_Log_and_Feedback.ipynb` (production analytics)
- Continuous monitoring dashboards

---

## Reference Notebooks

### Governance & Evaluation

**`ibm-watsonx-governance-evaluation-studio-getting-started.ipynb`**:
- Shows watsonx.governance evaluation features
- Demonstrates automated evaluation at scale
- Connects to compliance tracking

**From this, you'll learn**:
- How to structure evaluation datasets
- Metrics that matter for enterprise applications
- Integration with governance workflows

**Progression**:
```
Lab 1.3 (Manual, 10 questions)
    ↓
eval_small.py (Automated, 100 questions)
    ↓
Evaluation Studio (Continuous, production scale)
```

---

## Best Practices for Evaluation

### ✅ Do

1. **Start simple**: Don't over-engineer evaluation initially
2. **Automate what you can**: Manual review doesn't scale
3. **Track over time**: Evaluation is ongoing, not one-time
4. **Test edge cases**: Don't just test happy paths
5. **Involve stakeholders**: Domain experts should validate quality
6. **Version everything**: Track prompts, models, and test sets

### ❌ Don't

1. **Skip evaluation**: "It looks good" isn't enough
2. **Rely solely on accuracy**: Context matters (latency, safety, cost)
3. **Forget about drift**: Models and data change over time
4. **Ignore user feedback**: Real usage reveals issues testing doesn't
5. **Over-optimize for metrics**: Gaming metrics != real quality

---

## Evaluation Maturity Model

### Level 1: Ad Hoc
- Manual testing with a few examples
- "Looks good to me" approval
- No systematic tracking

### Level 2: Basic (← Lab 1.3 targets this)
- Small test set (10-50 examples)
- Manual rubric
- Occasional re-evaluation

### Level 3: Systematic (← `eval_small.py` targets this)
- Curated test set (100-500 examples)
- Automated metrics where possible
- Regular evaluation runs
- Version control for prompts and results

### Level 4: Continuous (← Production goal)
- Large test set + production monitoring
- Automated evaluation pipeline
- A/B testing framework
- Real-time alerting on quality degradation
- Integration with CI/CD

---

## Key Takeaways

- **Evaluation is essential**: Don't deploy LLMs without systematic quality checks
- **Start simple**: Basic metrics beat no metrics
- **Safety first**: Proactively mitigate risks with guardrails
- **Iterate**: Evaluation frameworks evolve with your application
- **Automate**: Scale evaluation as your system scales

**Next**: Let's build your first evaluation framework in Lab 1.3!
