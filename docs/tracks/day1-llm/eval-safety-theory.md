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

**The fundamental challenge with LLMs**

LLMs are **non-deterministic systems** that generate outputs we cannot predict in advance.

**Key challenges:**
- **Unpredictability** - Same input can yield different outputs
- **Emergent behaviors** - Unexpected capabilities or failures
- **Quality variance** - Performance varies across query types
- **Subtle failures** - Errors may be plausible but incorrect

**Without evaluation, you're flying blind.**

::: notes
Let's start by understanding what goes wrong when you don't evaluate. LLMs are probabilistic, not deterministic like traditional code.
:::

---

## ⚠️ Why Evaluation Matters (cont.)

**What you lose without evaluation:**

❌ Don't know if your system actually works  
❌ Can't compare different models or prompts  
❌ Can't detect when quality degrades  
❌ Have no basis for improvement

**The stakes:** Every wrong answer erodes trust, creates support burden, and potentially causes legal/financial consequences.

**Solution:** Systematic evaluation catches problems before users do.

::: notes
Think of evaluation as your QA process for AI. You wouldn't ship code without tests. Don't ship LLMs without evaluation.
:::

---

## 🔴 Problem 1: Hallucinations

**Models generate plausible but false information**

Hallucinations are when models confidently state facts that are incorrect or fabricated.

**Why they're dangerous:**
- ✗ Output sounds confident and authoritative
- ✗ Users can't distinguish real from fabricated
- ✗ Fabrications are often highly specific
- ✗ Context makes them seem believable

::: notes
Hallucinations are dangerous because they sound confident and plausible. Users can't tell the difference without fact-checking.
:::

---

## 🔴 Hallucination Example

```
Q: "What is IBM's revenue in 2025?"

Bad Answer: "IBM's revenue in 2025 was $87.4 billion, 
representing a 12.3% increase year-over-year driven 
primarily by strong cloud computing growth in APAC."

Reality: This is entirely made up! IBM hasn't reported 
2025 numbers yet.
```

**Why it happens:**
- Model's training data has cutoff date
- Model fills gaps with plausible-sounding info
- No built-in "I don't know" mechanism

**How evaluation catches this:** Compare against verified ground truth.

::: notes
The model doesn't "know" it's making things up—it's just predicting text based on patterns from training.
:::

---

## 🔴 Problem 2: Inconsistency

**Same question, different responses**

LLMs use **temperature** and **sampling**, meaning the same question can yield different answers—sometimes contradictory.

**Example:**
```
Monday 9 AM: "Capital of Australia is Sydney."
Monday 3 PM: "Capital of Australia is Canberra." [Correct]
Tuesday:     "Australia's capital is Canberra, though 
              many believe it's Sydney..."
```

All three answers differ; first is factually wrong.

::: notes
Without evaluation, you won't know your system gives inconsistent answers. This erodes user trust quickly.
:::

---

## 🔴 Problem 2: Why It Matters

**Business impact of inconsistency:**

1. **Trust erosion** - Users lose confidence
2. **Support burden** - "Yesterday you told me X!"
3. **Compliance risk** - Inconsistent advice = liability
4. **Testing difficulty** - Hard to validate changing behavior

**Measuring consistency:**

```python
def measure_consistency(question: str, n_trials: int = 10):
    responses = [llm.generate(question) for _ in range(n_trials)]
    similarities = compute_pairwise_similarity(responses)
    return np.mean(similarities)  # Higher = more consistent
```

::: notes
Consistency evaluation is simple: ask the same question multiple times and measure similarity. Lower temperature helps but doesn't eliminate the issue.
:::

---

## 🔴 Problem 3: Out-of-Scope Responses

**Models attempt to answer questions they shouldn't**

LLMs are trained to be helpful and will try to answer almost anything, even when they:
- Don't have relevant information
- Lack domain expertise
- Shouldn't give advice (legal, medical, financial)

**This is especially dangerous in regulated domains.**

::: notes
This is especially dangerous in regulated domains. A customer support bot shouldn't give medical advice. But without explicit boundaries, they will.
:::

---

## 🔴 Out-of-Scope Example

```
Q: "I have chest pain and shortness of breath. 
    What should I do?"

❌ Bad: "You may be experiencing angina or possibly 
a myocardial infarction. Take an aspirin immediately 
and monitor your symptoms..."

✅ Good: "I'm not able to provide medical advice. 
Chest pain and shortness of breath can be serious. 
Please seek immediate medical attention by calling 
emergency services."
```

**Why this happens:** Models are trained to be helpful, have learned medical terminology, but don't have built-in boundaries.

::: notes
The solution is twofold: (1) Clear prompts that define scope, and (2) Evaluation that checks if responses violate boundaries.
:::

---

## 💼 Business Impact

**Real consequences of poor LLM quality**

<span class="fragment">🔴 **Lost customer trust** - 63% of users stop using service after one bad AI interaction (Gartner 2023)</span>

<span class="fragment">🔴 **Compliance violations** - GDPR fines can reach €20M or 4% of revenue</span>

<span class="fragment">🔴 **Financial losses** - Average AI failure cost in banking: $2.8M (IBM Security 2023)</span>

<span class="fragment">🔴 **Reputational damage** - 72% of customers share negative AI experiences</span>

<span class="fragment">🔴 **Support costs** - Poor AI quality can 3x support ticket volume</span>

::: notes
In regulated industries like healthcare and finance, wrong answers can have legal consequences. Evaluation isn't just nice to have—it's required.
:::

---

## 💼 Real-World Examples

**When AI failures hurt business:**

- **Healthcare:** Wrong dosage → patient harm → lawsuit
- **Finance:** Bad investment advice → customer losses → regulatory investigation  
- **Legal:** Hallucinated case citations → lawyer sanctioned by court
- **E-commerce:** Recommends out-of-stock items → frustrated customers → lost sales

**ROI of evaluation:**
```
Cost of evaluation: $10K-50K to build framework
Cost of major AI failure: $500K-5M+ (reputation + legal)
ROI: 10x-500x
```

Evaluation isn't a cost center—it's **risk management**.

::: notes
Share the lawyer example—used ChatGPT and cited fabricated cases. Court sanctioned him. That's career-ending. Evaluation would have caught it.
:::

---

## ✅ The Solution: Systematic Evaluation

**How systematic evaluation protects your business**

<span class="fragment">🎯 **Early detection** - Catch problems before users see them</span>

<span class="fragment">🎯 **Objective comparison** - Compare models/prompts with data</span>

<span class="fragment">🎯 **Quality tracking** - Monitor performance over time</span>

<span class="fragment">🎯 **Confidence building** - Provide quantitative evidence</span>

<span class="fragment">🎯 **Continuous improvement** - Identify optimization areas</span>

<span class="fragment">🎯 **Regulatory compliance** - Document quality for audits</span>

::: notes
Think of evaluation as your QA process for AI. You wouldn't ship code without tests. Don't ship LLMs without evaluation.
:::

---

## ✅ The Evaluation Workflow

**8 steps to systematic quality assurance**

```
1. Define Metrics → What does "good" mean?
2. Build Test Set → Collect diverse examples
3. Run Evaluation → Generate and measure outputs
4. Analyze Results → Identify failure patterns
5. Iterate → Improve prompts/models/parameters
6. Re-evaluate → Verify improvements
7. Deploy → Ship with confidence
8. Monitor → Continuous evaluation in production
```

**Key principle:** Start simple, iterate toward sophistication.

::: notes
The beauty of systematic evaluation is that it's cumulative. Each test case you write builds organizational knowledge about what works.
:::

---

## 📏 Simple Evaluation Signals {data-background-color="#1e293b"}

**Five practical metrics you can implement today**

These five signals catch **90% of quality issues**:

1. **Correctness** - Is the answer factually accurate?
2. **Coherence & Relevance** - Is it logical and on-topic?
3. **Style/Format Adherence** - Does it follow instructions?
4. **Completeness** - Does it address all parts of the question?
5. **Latency** - How fast does it respond?

**Why these five:** Easy to implement, highly informative, broadly applicable.

::: notes
Let's explore five evaluation signals that are easy to measure and highly informative. You don't need ML expertise—basic Python and clear thinking are enough.
:::

---

## 1️⃣ Correctness: Overview

**Does the answer match known correct information?**

Correctness is the most fundamental metric: **is the answer right or wrong?**

**When you can measure correctness:**
- You have ground truth answers
- The question has verifiable factual answer
- Expert humans can definitively judge

**When you can't:**
- Creative tasks (e.g., "write a poem")
- Opinion-based questions
- Tasks where multiple answers are valid

::: notes
Correctness is the most objective metric. If you have ground truth, use it. When you don't, you need human evaluators or more sophisticated metrics.
:::

---

## 1️⃣ Correctness: Implementation

**Three approaches for different scenarios**

**Approach 1: Exact match** (for structured answers)
```python
def evaluate_correctness_exact(model_answer: str, 
                               ground_truth: str) -> int:
    model_norm = model_answer.strip().lower()
    truth_norm = ground_truth.strip().lower()
    return 1 if model_norm == truth_norm else 0
```

**Approach 2: Semantic similarity** (for natural language)
```python
def evaluate_correctness_semantic(model_answer: str, 
                                  ground_truth: str) -> int:
    similarity = compute_similarity(model_answer, ground_truth)
    return 1 if similarity > 0.8 else 0
```

::: notes
Choose approach based on your use case. Exact match for structured outputs. Semantic similarity for natural language where wording varies.
:::

---

## 1️⃣ Correctness: Examples

**Clear correct vs incorrect cases**

```
✅ Correct Example:
Q: "What year was IBM founded?"
Model: "1911"
Ground Truth: "1911"
Score: 1 (Correct)

❌ Incorrect Example:
Q: "What year was IBM founded?"
Model: "IBM was founded in 1920 by Thomas Watson."
Ground Truth: "1911"
Score: 0 (Wrong year AND wrong founder attribution)
```

::: notes
Binary scoring is simple and clear. You either got it right or you didn't. For partial credit, decompose questions into sub-questions.
:::

---

## 2️⃣ Coherence & Relevance: Overview

**Is the answer logical and on-topic?**

When there's no ground truth, **coherence and relevance** become your primary quality signals.

**Coherence** = Internally consistent and logically sound  
**Relevance** = Actually addresses the question asked

**What this catches:**
- Nonsensical outputs
- Off-topic rambling  
- Self-contradictory statements
- Responses that ignore the question

::: notes
When there's no ground truth, coherence and relevance become your primary metrics. This requires human judgment but is still systematic.
:::

---

## 2️⃣ Coherence: 5-Point Rubric

**Manual evaluation scale**

<span class="fragment">**5 - Excellent:** Highly coherent, directly addresses question</span>

<span class="fragment">**4 - Good:** Mostly coherent, relevant with minor issues</span>

<span class="fragment">**3 - Fair:** Somewhat coherent, partially relevant</span>

<span class="fragment">**2 - Poor:** Incoherent or largely irrelevant</span>

<span class="fragment">**1 - Very Poor:** Nonsensical or completely off-topic</span>

**Use consistently across all evaluations for reliable comparison.**

::: notes
The 5-point scale gives you nuance. Most outputs fall in 3-4 range, and that's useful information for improvement.
:::

---

## 2️⃣ Coherence: Examples (Part 1)

**Excellent vs Good**

```
Q: "How do I reset my password?"

✅ Score 5 (Excellent):
"To reset your password, click 'Forgot Password' 
on the login page. Enter your email and we'll send 
a reset link. Click the link and create a new password."
→ Direct, logical, complete

✅ Score 4 (Good):  
"You can reset through the 'Forgot Password' link. 
We take security seriously and use encryption. 
The reset link expires in 24 hours."
→ Answers question but includes tangential info
```

::: notes
Extreme cases are easy to score. The middle ground requires more judgment. That's where evaluation becomes an art.
:::

---

## 2️⃣ Coherence: Examples (Part 2)

**Fair vs Poor**

```
Q: "How do I reset my password?"

⚠️ Score 3 (Fair):
"Our system supports password management. We recommend 
using a password manager. Change passwords regularly."
→ Related to passwords but doesn't answer HOW to reset

❌ Score 1 (Off-topic):
"Our company was founded in 2010 and has grown 
significantly. We serve 100,000 customers worldwide."
→ Completely ignores the question
```

::: notes
Notice how Score 3 is the dangerous middle case—it's talking about passwords so feels relevant, but doesn't help the user.
:::

---

## 3️⃣ Style/Format Adherence

**Does output follow specified formatting?**

Format adherence measures whether the model **followed instructions** about **how** to respond.

**Why format matters:**
- **API integrations** - Downstream systems expect specific formats
- **UI rendering** - Frontend expects certain structures
- **Document generation** - Reports need consistent formatting
- **Compliance** - Some industries require specific formats

**Common requirements:** JSON, lists, length constraints, markdown, style/tone

::: notes
Format checking can be automated. This is especially important for API responses where downstream systems expect specific formats.
:::

---

## 3️⃣ Format: Implementation

**Automated format validation**

```python
def evaluate_format(response: str, expected_format: str) -> dict:
    if expected_format == "json":
        try:
            json.loads(response)
            return {"valid": True, "score": 1}
        except:
            return {"valid": False, "score": 0}
    
    elif expected_format == "bullet_points":
        lines = response.split('\n')
        bullets = [l for l in lines 
                  if l.strip().startswith(('-', '*', '•'))]
        return {
            "valid": len(bullets) >= 3,
            "score": 1 if len(bullets) >= 3 else 0
        }
```

::: notes
The key is being explicit about requirements. "Return JSON" is vague. "Return JSON with keys: name, age, tags" is precise.
:::

---

## 3️⃣ Format: Examples

**Clear pass/fail validation**

```
Instruction: "List 3 benefits in bullet points."

✅ PASS:
- Scalability and flexibility
- Cost-effectiveness
- High availability
Score: 1

❌ FAIL:
"Cloud computing offers many benefits including 
scalability, cost-effectiveness, and availability..."
Score: 0 (Not in bullet format)
```

::: notes
Clear pass/fail. Either it followed the format or it didn't. This makes format adherence one of the easiest metrics to automate.
:::

---

## 4️⃣ Completeness: Overview

**Does the answer address ALL parts of the question?**

Many questions have **multiple implicit sub-questions**:
- "What is X, how does it work, and what are benefits?"
- "Compare A and B in terms of cost, performance, ease of use"

**Models often cherry-pick**—answering easy parts while ignoring harder ones.

**Completeness catches this.**

::: notes
Partial credit reflects partial completeness. This metric catches models that answer only the easy parts of complex questions.
:::

---

## 4️⃣ Completeness: Scoring

**Partial credit system**

Question has **3 sub-parts:**

- Answers all 3: **Score = 1.0** (Complete)
- Answers 2 of 3: **Score = 0.67** (Mostly complete)
- Answers 1 of 3: **Score = 0.33** (Incomplete)
- Answers 0: **Score = 0** (Did not answer)

```python
def evaluate_completeness(question, answer, num_parts):
    parts_addressed = count_parts_addressed(question, answer)
    return parts_addressed / num_parts
```

::: notes
Partial scoring is more informative than binary. It tells you "the model understands 67% of what you're asking."
:::

---

## 4️⃣ Completeness: Example

**Multi-part question evaluation**

```
Q: "What is RAG, how does it work, and what are benefits?"

Complete Answer (Score: 1.0):
"RAG stands for Retrieval-Augmented Generation.
✓ Part 1: Definition

It works by retrieving relevant documents, then using 
them as context for the LLM to generate responses.
✓ Part 2: How it works

Benefits include reduced hallucinations and access 
to up-to-date information beyond training data.
✓ Part 3: Benefits

All parts addressed → Score: 1.0
```

::: notes
This encourages thoroughness. Models that skip parts get penalized proportionally, which is actionable feedback.
:::

---

## 5️⃣ Latency: Overview

**How long does the model take to respond?**

Latency measures **end-to-end response time** from prompt to complete response.

**Why latency matters:**
- **User experience** - Users abandon slow apps (>3s = 40% dropout)
- **Throughput** - Faster responses = more queries/second
- **Cost** - Some providers charge by compute time

**Different use cases have different requirements:**

| Use Case | Target | Tolerance |
|----------|--------|-----------|
| Chatbot | <1s | Low |
| Document summary | <10s | Medium |
| Batch processing | <5min | High |

::: notes
Latency matters. Users abandon slow applications. Set thresholds based on your use case.
:::

---

## 5️⃣ Latency: Implementation

**Measuring and scoring latency**

```python
import time

def evaluate_latency(prompt: str) -> dict:
    start = time.time()
    response = llm.generate(prompt)
    latency = time.time() - start
    
    # Score against threshold
    if latency < 1.0:
        score = 1.0  # Excellent
    elif latency < 2.0:
        score = 0.75  # Good
    elif latency < 3.0:
        score = 0.5  # Acceptable
    else:
        score = 0.25  # Too slow
    
    return {"latency": latency, "score": score}
```

::: notes
The key insight: latency requirements vary by use case. Match your optimization efforts to your requirements.
:::

---

## 🛡️ Safety & Responsible Use {data-background-color="#0f172a"}

**Potential risks and mitigation strategies**

LLMs can generate almost any text—including harmful content.

**The challenge:** Models don't have built-in morality. Without safeguards:
- Generate personal information (PII)
- Produce harmful or biased content
- Provide dangerous instructions
- Hallucinate false information
- Expose private training data

**The solution:** **Layered defense strategy**

::: notes
LLMs are powerful but can generate harmful content. Let's discuss risk categories and how to mitigate them.
:::

---

## 🛡️ Layered Defense Strategy

**Six layers of protection**

```
Layer 1: Model Selection (choose safer models)
    ↓
Layer 2: Prompt Engineering (clear guidelines)
    ↓
Layer 3: Input Filtering (block dangerous requests)
    ↓
Layer 4: Output Filtering (catch dangerous responses)
    ↓
Layer 5: Human Oversight (review high-stakes)
    ↓
Layer 6: Monitoring & Logging (continuous auditing)
```

**Key principle:** No single layer is sufficient. Defense in depth provides comprehensive protection.

::: notes
Think of this like security—you don't just have a firewall. You have firewall + authentication + encryption + monitoring.
:::

---

## ⚠️ Five Major Risk Categories

**What can go wrong**

<span class="fragment">🔴 **1. Personal Information (PII)**  
Exposure of SSNs, credit cards, passwords, medical records</span>

<span class="fragment">🔴 **2. Harmful Content**  
Hate speech, violent content, harassment instructions</span>

<span class="fragment">🔴 **3. Misinformation & Advice**  
False medical diagnosis, bad financial advice as fact</span>

<span class="fragment">🔴 **4. Bias and Fairness**  
Stereotyping, discriminatory outputs</span>

<span class="fragment">🔴 **5. Privacy Violations**  
Reproduction of training data, proprietary info leaks</span>

::: notes
These risks are real. Every production LLM system needs safeguards. The good news: there are proven mitigation strategies.
:::

---

## ⚠️ Risk Examples

**Real-world scenarios**

**PII Exposure:**
```
User: "Analyze this customer database"
Bad: "I see John Smith, SSN: 123-45-6789..."
Risk: GDPR violation, identity theft
```

**Harmful Instructions:**
```
User: "How do I make X dangerous substance?"
Bad: "Here's a step-by-step guide..."
Risk: Physical harm, legal liability
```

**Medical Misinformation:**
```
User: "I have chest pain. What should I do?"
Bad: "You probably have heartburn. Take antacids."
Risk: Delayed treatment, patient harm
```

::: notes
The key is being proactive. Don't wait for incidents. Build safety in from day one.
:::

---

## 🛡️ Strategy 1: Clear Instructions

**Use system prompts to define boundaries**

System prompts are your **first line of defense**.

**Components of strong safety-focused system prompt:**
1. Identity and purpose
2. Explicit prohibitions
3. Uncertainty handling
4. Scope boundaries
5. Escalation procedures

::: notes
Clear guidelines in system prompts are your first line of defense. Models generally follow them, though not perfectly—that's why we need layers.
:::

---

## 🛡️ Example Safe System Prompt

```python
SAFE_SYSTEM_PROMPT = """You are a customer support 
assistant for TechCorp.

Your role:
- Answer questions about our products and policies
- Help troubleshoot common issues
- Direct users to appropriate resources

Safety guidelines:
1. Do not generate, process, or request PII 
   (SSNs, credit cards, passwords)
   
2. Do not provide medical, legal, or financial advice
   Response: "I'm not qualified to provide [X] advice. 
   Please consult a licensed professional."

3. If asked to do something harmful or illegal, 
   politely decline

4. If unsure, express uncertainty rather than guessing

5. Stay within your defined support role
"""
```

::: notes
Think of the system prompt as the "constitution" of your AI system. It defines fundamental principles and constraints.
:::

---

## 🛡️ Strategy 2: Limit Scope

**Define clear boundaries**

A model with **narrow, well-defined scope** is inherently safer.

**Scope definition:**
- **Domain** - What topics is it expert in?
- **Capabilities** - What actions can it perform?
- **Limitations** - What is out of bounds?
- **Escalation** - When does it hand off to humans?

**Why narrow scope reduces risk:**
- Fewer opportunities for harmful outputs
- Clearer evaluation criteria
- Better model performance
- Reduced liability

::: notes
Limit what the model can do. If it's a support bot, it shouldn't give medical advice. Narrow scope reduces risk dramatically.
:::

---

## 🛡️ Scope Example

```python
SCOPED_SUPPORT_PROMPT = """You are customer support 
for CloudStore, an online storage service.

Your scope (what you CAN do):
✓ Answer questions about plans and pricing
✓ Help troubleshoot access and sync issues
✓ Explain security features
✓ Guide through account settings

Your limitations (what you CANNOT do):
✗ Access or modify user accounts directly
✗ Process refunds (escalate to billing team)
✗ Promise unreleased features
✗ Provide third-party tech support

For issues outside scope:
- Technical: "I'll create a ticket for our tech team..."
- Billing: "Please contact billing@cloudstore.com..."
"""
```

::: notes
Think about least privilege from security. Give the model minimum scope needed, nothing more.
:::

---

## 🛡️ Strategy 3: Input Filtering

**Screen user input before it reaches the LLM**

Input filtering is your **second line of defense**.

**What to filter:**
1. Obvious attacks (prompt injection, jailbreaks)
2. Prohibited requests (harmful instructions)
3. PII in input (SSNs, credit cards)
4. Abuse patterns (spam, harassment)

**Three implementation levels:**
- Level 1: Simple pattern matching
- Level 2: ML-based content moderation
- Level 3: API-based moderation (production-grade)

::: notes
Catch harmful requests before they reach the LLM. Simple pattern matching can catch obvious abuse.
:::

---

## 🛡️ Input Filtering: Basic

**Level 1: Pattern matching**

```python
import re

def check_input_safety(user_input: str) -> tuple:
    violations = []
    
    # Harmful patterns
    harmful = [
        r'how to (hack|crack|steal)',
        r'(bomb|weapon) (making|instructions)',
        r'how to (hurt|harm|kill)',
    ]
    
    for pattern in harmful:
        if re.search(pattern, user_input, re.IGNORECASE):
            violations.append(f"Harmful: {pattern}")
    
    # PII patterns
    if re.search(r'\b\d{3}-\d{2}-\d{4}\b', user_input):
        violations.append("SSN detected")
    
    is_safe = len(violations) == 0
    return is_safe, violations
```

::: notes
Start with simple patterns. Good for catching obvious abuse. Add ML-based detection for better coverage.
:::

---

## 🛡️ Input Filtering: Usage

**Protecting the pipeline**

```python
user_query = "How do I hack into someone's email?"

is_safe, issues = check_input_safety(user_query)

if not is_safe:
    response = "I can't help with that request."
    log_safety_violation(user_query, issues)
else:
    response = llm.generate(user_query)
```

**For production:** Consider ML-based APIs like OpenAI Moderation or Perspective API for better coverage.

::: notes
The key: You have multiple options at different complexity levels. Start simple, add sophistication as needed.
:::

---

## 🛡️ Strategy 4: Output Filtering

**Screen LLM responses before showing to users**

Even with great prompts and input filtering, LLMs occasionally generate problematic content.

**What to filter in outputs:**
1. PII leakage
2. Toxicity
3. Hallucinated facts
4. Policy violations
5. Quality issues

**Output filtering is your last line of defense.**

::: notes
Even good models occasionally slip. Post-processing catches problematic outputs before they reach users.
:::

---

## 🛡️ Output Filtering: Implementation

```python
def check_output_safety(response: str) -> tuple:
    violations = []
    
    # Check for PII
    if re.search(r'\b\d{3}-\d{2}-\d{4}\b', response):
        violations.append("SSN in output")
    
    # Check for toxicity
    toxicity_score = check_toxicity(response)
    if toxicity_score > 0.7:
        violations.append(f"Toxic content: {toxicity_score}")
    
    # Check for policy violations
    prohibited = ["you should sue", "take this medication"]
    for phrase in prohibited:
        if phrase in response.lower():
            violations.append(f"Policy violation: {phrase}")
    
    is_safe = len(violations) == 0
    return is_safe, violations
```

::: notes
The key strategy is layered checks: Fast regex first, ML-based for what regex misses, then retry or fallback if violations found.
:::

---

## 🛡️ Strategy 5: Human-in-the-Loop

**Involve humans for high-stakes decisions**

**When to use HITL:**
- ✓ High-stakes decisions (healthcare, finance, legal)
- ✓ Edge cases
- ✓ Sensitive topics
- ✓ Quality assurance sampling

**Patterns:**
1. Preview before send
2. Confidence-based routing
3. Random sampling for QA
4. Feedback mechanisms
5. Audit trails

::: notes
In healthcare, finance, or legal domains, consider human review of critical responses. Automation is great, but some decisions need human oversight.
:::

---

## 🛡️ HITL: Confidence Routing

```python
def confidence_based_routing(query: str) -> str:
    # Generate with confidence score
    response, confidence = llm.generate_with_confidence(query)
    
    if confidence < 0.8:
        # Low confidence - send to human
        return route_to_human_agent(
            query=query, 
            ai_suggestion=response
        )
    else:
        # High confidence - use AI response
        return response
```

**Balance:** Route uncertain cases to humans while automating confident cases.

::: notes
The key is finding the right balance. Too much HITL = expensive and slow. Too little = risky.
:::

---

## 🛡️ Strategy 6: Model Selection

**Choose models appropriate for safety requirements**

Not all models have the same safety characteristics.

**Model safety factors:**
1. Safety alignment training
2. Built-in guardrails
3. Training data filtering
4. Fine-tuning options
5. Documented safety measures

**Example:** Granite models have safety alignment built-in, making them suitable for enterprise production use.

::: notes
Not all models are created equal for safety. Choose models appropriate for your risk tolerance.
:::

---

## 🛡️ Safe Configuration

**Conservative parameter settings reduce risk**

```python
# For factual tasks - use conservative settings
safe_params = {
    'temperature': 0.2,    # More deterministic
    'top_p': 0.1,          # Focused sampling
    'max_tokens': 200,     # Limit response length
}

# For creative tasks - can use higher temperature
creative_params = {
    'temperature': 0.8,
    'top_p': 0.9,
    'max_tokens': 500,
}
```

**Lower temperature = fewer surprises**  
**Max tokens = prevents extremely long responses**

::: notes
Conservative parameter settings reduce risk. Lower temperature means fewer surprises.
:::

---

## 🏗️ Accelerator Integration {data-background-color="#1e293b"}

**How evaluation fits into the production pipeline**

The accelerator provides a **complete evaluation framework**.

**Evaluation touchpoints:**
```
User Query
    ↓
[Input Validation] ← Evaluation point 1
    ↓
Retrieval → [Context Quality] ← Evaluation point 2
    ↓
Generation → [Response Evaluation] ← Evaluation point 3
    ↓
[Safety Check] ← Evaluation point 4
    ↓
Return + Log → [Offline Analysis] ← Evaluation point 5
```

::: notes
Let's connect evaluation to the actual codebase you'll work with. Evaluation isn't bolted on—it's woven throughout.
:::

---

## 🏗️ Accelerator Components

**Key evaluation components**

**File structure:**
```
watsonx-rag-accelerator/
├── tools/
│   └── eval_small.py           # Batch evaluation
├── service/
│   ├── api.py                  # API with logging
│   └── logs/                   # Interaction logs
├── accelerator/
│   ├── rag/
│   │   ├── metrics.py          # Metrics library
│   │   └── safety.py           # Safety checks
└── notebooks/
    └── Analyze_Log_and_Feedback.ipynb
```

::: notes
This is the actual structure of production systems. Evaluation isn't bolted on at the end—it's integrated throughout.
:::

---

## 📁 eval_small.py: Overview

**Purpose:** Batch evaluation of RAG system

**What it does:**
1. Loads test data (CSV with questions, ground truth)
2. Generates responses through RAG pipeline
3. Applies multiple evaluation metrics
4. Saves results and statistics

**You'll implement on Day 2-3**

::: notes
This is where your evaluation code lives. You'll build a mini version in Lab 1.3 today.
:::

---

## 📁 eval_small.py: Structure

```python
def evaluate_rag_system(test_file: str, output_file: str):
    # 1. Load test data
    df = pd.read_csv(test_file)
    
    # 2. Initialize pipeline
    pipeline = RAGPipeline()
    
    # 3. Evaluate each question
    results = []
    for idx, row in df.iterrows():
        response = pipeline.answer_question(row['question'])
        
        metrics = {
            'correctness': evaluate_correctness(
                response, row['ground_truth']
            ),
            'relevance': evaluate_relevance(
                response, row['question']
            ),
            'latency': measure_latency()
        }
        results.append(metrics)
    
    # 4. Save and analyze
    save_results(output_file, results)
```

::: notes
This pattern is simple but powerful: Load → Generate → Evaluate → Save. Scales from 10 to 10,000 cases.
:::

---

## 📊 Production Logging

**What gets logged in service/api.py**

Every request is logged with comprehensive metadata:

```json
{
  "timestamp": "2025-01-15T10:30:00Z",
  "session_id": "sess_abc123",
  "question": "How do I reset my password?",
  "answer": "To reset your password...",
  "retrieved_docs": ["doc_123", "doc_456"],
  "metrics": {
    "latency_ms": 1250,
    "tokens_used": 85,
    "cost_usd": 0.00042
  },
  "user_feedback": "helpful"
}
```

::: notes
Every request is logged. This creates audit trail and enables continuous evaluation.
:::

---

## 📈 Analysis Notebook

**Turn logs into insights**

**`Analyze_Log_and_Feedback.ipynb` provides:**

<span class="fragment">📊 Pattern analysis - Common questions, failure modes</span>

<span class="fragment">📊 Metrics tracking - Quality over time</span>

<span class="fragment">📊 Failure analysis - Deep dive into low scores</span>

<span class="fragment">📊 Recommendations - Specific improvements based on data</span>

**Run weekly to catch trends and guide improvements.**

::: notes
The analysis notebook turns logs into insights. Which questions fail? What's average latency? Are users happy?
:::

---

## 🧪 Lab 1.3 Preview {data-background-color="#0f172a"}

**Build your first evaluation framework**

**What you'll build:** Micro-evaluation framework

**What makes it "micro":**
- Small test set (5-10 examples vs 100+ in production)
- Manual evaluation (human scoring vs automated)
- Simple comparison (two models vs comprehensive)

**But principles are identical:** Define → Generate → Evaluate → Analyze

::: notes
Lab 1.3 is where theory becomes practice. You're learning patterns that scale to production.
:::

---

## 📝 Lab 1.3: Your Tasks

**Four concrete tasks**

<span class="fragment">**1️⃣ Create test set** (5-10 diverse prompts)  
Cover: summarization, Q&A, classification, style transfer</span>

<span class="fragment">**2️⃣ Collect outputs** (Ollama + watsonx)  
Run each prompt through both systems</span>

<span class="fragment">**3️⃣ Apply rubric** (3 dimensions)  
Score correctness, clarity, style match (1-5 scale)</span>

<span class="fragment">**4️⃣ Analyze results**  
Which model performs better? Where? Why?</span>

::: notes
This is mini version of production evaluation. Skills you learn here scale directly to production.
:::

---

## 📊 Lab 1.3: Example Output

**What your results should look like**

```python
results = pd.DataFrame({
    'prompt': ['Summarize AI...', 'Extract emails...'],
    'backend': ['ollama', 'watsonx'],
    'response': ['AI enables...', 'john@...'],
    'correctness': [4, 5],
    'clarity': [5, 4],
    'style_match': [4, 5]
})

# Analysis
print(results.groupby('backend').mean())
#          correctness  clarity  style_match
# ollama          4.33     5.00         4.67
# watsonx         5.00     4.50         5.00
```

::: notes
You'll create structured data that enables systematic comparison. This format scales to production.
:::

---

## 📈 Evaluation Maturity Model

**Understanding the journey**

```
Level 0: No Evaluation (Chaos)
    ↓
Level 1: Ad Hoc Testing
    ↓
Level 2: Basic Evaluation ← Lab 1.3 gets you here
    ↓
Level 3: Systematic ← eval_small.py gets you here
    ↓
Level 4: Continuous (Gold Standard)
```

**Important:** Progress is incremental. Don't jump from 0 to 4.

::: notes
Let's contextualize where you'll be after today vs where you're heading. This journey takes months for most organizations.
:::

---

## 📊 Level 1: Ad Hoc

**Better than nothing, but doesn't scale**

❌ Manual testing with few examples  
❌ "Looks good to me" approval  
❌ No systematic tracking

**What it looks like:**
```
Developer: "Let me try a few questions..."
[Tests 3-5 queries manually]
Developer: "Looks good!"
[Ships to production]
```

**Problem:** Not repeatable, not comprehensive, not comparable.

::: notes
Most teams start here. It's better than nothing but doesn't scale.
:::

---

## 📊 Level 2: Basic ← Lab 1.3 Targets

**Beginning of systematization**

✅ Small test set (10-50 examples)  
✅ Manual rubric with defined criteria  
✅ Occasional re-evaluation  
✅ Documented results  
✅ Comparative analysis

**Key improvements:**
- Repeatable (same tests every time)
- Comparable (track if v2 better than v1)
- Documented (results saved)

**Lab 1.3 gets you here!** Minimum for responsible development.

::: notes
Lab 1.3 gets you to Level 2. This is the minimum for responsible development.
:::

---

## 📊 Level 3: Systematic ← Day 2-3

**Professional development practices**

✅ Curated test set (100-500 examples)  
✅ Automated metrics where possible  
✅ Regular evaluation runs  
✅ Version control for prompts and results  
✅ Statistical analysis

**Infrastructure:**
- Scripts run evaluation automatically
- Results database for historical tracking
- Dashboards showing trends
- CI/CD integration

**Day 2-3 gets you here** with eval_small.py

::: notes
Day 2-3 gets you to Level 3. This is production-ready evaluation.
:::

---

## 📊 Level 4: Continuous

**Elite operational excellence**

✅ Large test set + production monitoring  
✅ Automated evaluation pipeline  
✅ A/B testing framework  
✅ Real-time alerting on quality degradation  
✅ CI/CD integration  
✅ Feedback loops

**This is the goal** but requires significant investment (6-12 months).

::: notes
Level 4 is the gold standard. Most teams take 6-12 months to reach this after starting at Level 1.
:::

---

## ✅ Best Practices: Do

<span class="fragment">✅ **Start simple** - 10 good test cases > 0 perfect ones</span>

<span class="fragment">✅ **Automate what you can** - Manual doesn't scale</span>

<span class="fragment">✅ **Track over time** - Evaluation is ongoing</span>

<span class="fragment">✅ **Test edge cases** - Weird inputs reveal problems</span>

<span class="fragment">✅ **Involve stakeholders** - Domain experts validate quality</span>

<span class="fragment">✅ **Version everything** - Track prompts, models, results</span>

::: notes
Treat evaluation as first-class development activity. It's not an afterthought—it's central to quality.
:::

---

## ❌ Best Practices: Don't

<span class="fragment">❌ **Skip evaluation** - "It looks good" isn't enough</span>

<span class="fragment">❌ **Rely solely on accuracy** - Latency, safety, cost matter too</span>

<span class="fragment">❌ **Forget about drift** - Quality degrades over time</span>

<span class="fragment">❌ **Ignore user feedback** - Real usage reveals issues</span>

<span class="fragment">❌ **Over-optimize for metrics** - Gaming metrics ≠ real quality</span>

::: notes
Goodhart's Law: When a measure becomes a target, it ceases to be a good measure. Don't game metrics.
:::

---

## 🎯 Key Takeaways

<span class="fragment">🔑 **Evaluation is essential** - Don't deploy without systematic checks</span>

<span class="fragment">🔑 **Start simple** - Basic metrics beat no metrics</span>

<span class="fragment">🔑 **Safety first** - Proactively mitigate risks with layers</span>

<span class="fragment">🔑 **Iterate** - Frameworks evolve with your application</span>

<span class="fragment">🔑 **Automate** - Scale evaluation as your system scales</span>

<span class="fragment">🔑 **Track trends** - One-time evaluation isn't enough</span>

::: notes
Evaluation and safety are not optional. They're the foundation of responsible LLM deployment.
:::

---

## 🚀 Next: Lab 1.3 {data-background-color="#0f172a"}

**Let's build your evaluation framework!**

**You've learned:**
- Why evaluation matters
- Five core evaluation signals
- Safety risks and mitigations
- How evaluation integrates with production

**Now practice:** Build test set → Generate outputs → Apply rubric → Analyze results

**Let's get started!** 🚀

::: notes
You've learned theory. Now apply it. Lab 1.3 is where you implement these signals and see them in action.
:::

---

## 🔗 Navigation & Resources {data-background-color="#0f172a"}

**Navigate the workshop:**

### 🏠 [Workshop Portal](https://ruslanmv.com/watsonx-workshop/portal/)
### 📚 [Day 1 Overview](./README.md)
### ⬅️ [Previous: Prompt Patterns](./prompt-patterns-theory.md)
### ▶️ [Next: Day 2 RAG](../day2-rag/START_HERE.md)
### 🧪 [Lab 1.3: Micro-Evaluation](/watsonx-workshop/tracks/day1-llm/lab-3-micro-eval/)
### 📖 [All Materials](../../portal.md)

::: notes
Instructor: Emphasize evaluation is not optional. Safety is everyone's responsibility. Day 2's RAG evaluation builds on these foundations.
:::


---

## 📖 Resources

**Build robust, responsible systems:**

### Evaluation Frameworks
- 📘 [Ragas Framework](https://github.com/explodinggradients/ragas) – RAG evaluation
- 📘 [LangChain Evaluation](https://python.langchain.com/docs/guides/evaluation/)
- 📘 [Phoenix by Arize](https://github.com/Arize-ai/phoenix)

### Safety & Responsible AI
- 🛡️ [Anthropic Constitutional AI](https://www.anthropic.com/index/constitutional-ai-harmlessness-from-ai-feedback)
- 🛡️ [OpenAI Safety Best Practices](https://platform.openai.com/docs/guides/safety-best-practices)
- 🛡️ [Google Responsible AI](https://ai.google/responsibility/responsible-ai-practices/)

::: notes
Share these for students who want to go deeper. Ragas is particularly valuable for Day 2 RAG lab.
:::

---

## 🙏 Thank You!

**Questions on evaluation or safety?**

Remember:
- You can't improve what you don't measure
- Safety is not negotiable—build it in from day one
- Start simple and evolve
- Lab 1.3 gives hands-on experience

**Ready to build your evaluation framework?** 🚀

<div style="margin-top: 40px; text-align: center;">
  <a href="https://ruslanmv.com/watsonx-workshop/portal/" style="padding: 10px 20px; background: #0066cc; color: white; text-decoration: none; border-radius: 5px;">🏠 Portal</a>
  <a href="https://ruslanmv.com/watsonx-workshop/tracks/day1-llm/lab-3-micro-eval/" style="padding: 10px 20px; background: #00aa00; color: white; text-decoration: none; border-radius: 5px; margin-left: 10px;">🧪 Start Lab</a>
</div>


::: notes
Instructor: After Lab 1.3, students complete Day 1! They've learned LLM fundamentals, prompt engineering, and evaluation. Tomorrow's RAG builds on this foundation.
:::