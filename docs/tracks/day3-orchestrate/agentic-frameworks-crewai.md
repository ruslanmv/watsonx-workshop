# 👥 CrewAI Framework for Multi-Agent Systems {data-background-color="#1e3a8a"}

::: notes
This section covers CrewAI, a Python library for building multi-agent systems with collaborative AI agents. CrewAI makes multi-agent orchestration intuitive and accessible.
:::

---

## 🎯 What is CrewAI? {data-transition="slide"}

<span class="fragment">**CrewAI** is a Python framework for orchestrating **role-playing, autonomous AI agents**</span>

<span class="fragment">Think of it as building a **team** of AI specialists</span>

<span class="fragment">Each agent has its own **role**, **expertise**, and **tools**</span>

::: notes
CrewAI makes it easy to create multi-agent systems where each agent has specialized capabilities and they collaborate to solve complex problems.
:::

---

## Core Philosophy {data-transition="fade"}

<span class="fragment">Agents work together as a **crew** to accomplish complex tasks</span>

<span class="fragment">Each agent has a specific **role**, **goal**, and **backstory**</span>

<span class="fragment">Agents use **tools** to perform actions and gather information</span>

<span class="fragment">Collaboration patterns mirror **human teams**</span>

::: notes
CrewAI's strength is making multi-agent systems feel natural and intuitive, like managing a human team.
:::

---

## 🧩 CrewAI Core Components {data-background-color="#064e3b"}

### Three Building Blocks

<span class="fragment">**Agent** - An autonomous unit with specialized capabilities</span>

<span class="fragment">**Task** - Work to be performed</span>

<span class="fragment">**Crew** - The orchestrator that manages agents and tasks</span>

::: notes
These three components are all you need to build sophisticated multi-agent systems.
:::

---

## Component 1: Agent {data-transition="slide"}

An autonomous unit with:

<span class="fragment">**Role** - The agent's function (e.g., "Research Analyst")</span>

<span class="fragment">**Goal** - What the agent aims to achieve</span>

<span class="fragment">**Backstory** - Context that shapes the agent's behavior</span>

<span class="fragment">**Tools** - Functions the agent can execute</span>

::: notes
The Agent is the fundamental building block. Agents have personalities and capabilities just like human team members.
:::

---

## Component 2: Task {data-transition="fade"}

Work to be performed:

<span class="fragment">**Description** - What needs to be done</span>

<span class="fragment">**Expected Output** - Desired result format</span>

<span class="fragment">**Agent** - Which agent performs this task</span>

<span class="fragment">**Context** - Dependencies on other tasks</span>

::: notes
Tasks define the work. Clear task descriptions lead to better agent performance.
:::

---

## Component 3: Crew {data-transition="slide"}

The orchestrator that manages:

<span class="fragment">**Agents** - Collection of agents working together</span>

<span class="fragment">**Tasks** - List of tasks to accomplish</span>

<span class="fragment">**Process** - How tasks are executed (`sequential` or `hierarchical`)</span>

<span class="fragment">**Manager LLM** - (Optional) LLM for task delegation in hierarchical mode</span>

::: notes
The Crew brings everything together and manages how agents collaborate to complete tasks.
:::

---

## ⚙️ CrewAI Process Types {data-background-color="#7c2d12"}

### Sequential Process

```python
Process.sequential
```

<span class="fragment">Tasks executed **one after another** in order</span>

<span class="fragment">Output of one task feeds into the next</span>

<span class="fragment">Best for **linear workflows**</span>

::: notes
Sequential is the simplest process type. Use it when tasks have a clear order.
:::

---

## Hierarchical Process {data-transition="fade"}

```python
Process.hierarchical
```

<span class="fragment">A **manager agent** delegates tasks to other agents dynamically</span>

<span class="fragment">Manager decides **who does what** and **when**</span>

<span class="fragment">Best for **complex multi-agent coordination**</span>

::: notes
Hierarchical mode adds a layer of intelligence to task delegation.
:::

---

## 🚀 CrewAI Example: Basic Agent {data-transition="slide"}

### Step 1: Define a Tool

```python {data-line-numbers="1-3|5-11"}
from crewai import Agent, Task, Crew, Process
from crewai_tools import tool

@tool("calculator")
def calculator(expression: str) -> str:
    """Evaluate a mathematical expression"""
    try:
        result = eval(expression)
        return str(result)
    except Exception as e:
        return f"Error: {str(e)}"
```

::: notes
The @tool decorator makes any Python function available to agents. This is how you give agents capabilities.
:::

---

## Step 2: Create an Agent {data-transition="fade"}

```python {data-line-numbers="1-7"}
math_agent = Agent(
    role="Math Expert",
    goal="Solve mathematical problems accurately",
    backstory="You are a skilled mathematician.",
    tools=[calculator],
    verbose=True
)
```

<span class="fragment">Role defines the agent's **identity**</span>

<span class="fragment">Goal defines the agent's **purpose**</span>

<span class="fragment">Backstory provides **context** for behavior</span>

::: notes
Notice how we're giving the agent a personality and purpose, not just a function to execute.
:::

---

## Step 3: Define a Task {data-transition="slide"}

```python {data-line-numbers="1-5"}
math_task = Task(
    description="Calculate the result of (15 + 25) * 3",
    expected_output="The numerical result",
    agent=math_agent
)
```

<span class="fragment">Task description tells the agent **what to do**</span>

<span class="fragment">Expected output sets **quality expectations**</span>

::: notes
Clear task descriptions lead to better results. Be specific about what you want.
:::

---

## Step 4: Create and Run Crew {data-transition="fade"}

```python {data-line-numbers="1-5|7-9"}
# Create the crew
crew = Crew(
    agents=[math_agent],
    tasks=[math_task],
    process=Process.sequential
)

# Execute
result = crew.kickoff()
print(result)
```

<span class="fragment">The crew orchestrates execution</span>

<span class="fragment">`kickoff()` starts the process and returns final output</span>

::: notes
The crew manages the entire workflow. You just need to define the pieces and kick it off!
:::

---

## 🔗 CrewAI with RAG Integration {data-background-color="#1e3a8a"}

### Building a RAG Tool

```python {data-line-numbers="1-3|5-16"}
import requests
from crewai_tools import tool

@tool("rag_service_tool")
def rag_service_tool(question: str) -> str:
    """Call the RAG service to answer questions from documents"""
    url = "http://localhost:8000/ask"
    payload = {"question": question}

    response = requests.post(url, json=payload, timeout=60)
    response.raise_for_status()
    data = response.json()

    answer = data.get("answer", "No answer found")
    citations = data.get("citations", [])

    return f"Answer: {answer}\nSources: {citations}"
```

::: notes
This tool integrates your RAG accelerator from Day 2 into CrewAI agents. Your RAG service becomes a tool!
:::

---

## 👥 Multi-Agent Example: Research Team {data-transition="slide"}

### Creating Specialized Agents

```python {data-line-numbers="1-7|9-15"}
# Researcher Agent
researcher = Agent(
    role="Research Analyst",
    goal="Find accurate information on given topics",
    backstory="Expert at finding and analyzing information",
    tools=[rag_service_tool],
    verbose=True
)

# Writer Agent
writer = Agent(
    role="Content Writer",
    goal="Create clear, engaging content",
    backstory="Skilled writer who creates compelling narratives",
    tools=[],
    verbose=True
)
```

::: notes
Notice how each agent has a distinct role and goal. The researcher has the RAG tool, the writer doesn't need it.
:::

---

## Add Reviewer Agent {data-transition="fade"}

```python {data-line-numbers="1-7"}
# Reviewer Agent
reviewer = Agent(
    role="Quality Reviewer",
    goal="Ensure accuracy and quality",
    backstory="Detail-oriented editor with high standards",
    tools=[],
    verbose=True
)
```

<span class="fragment">This creates a **three-agent team**: research → write → review</span>

<span class="fragment">Each agent specializes in one aspect of the workflow</span>

::: notes
Division of labor allows each agent to focus on what it does best.
:::

---

## Define Team Tasks {data-transition="slide"}

```python {data-line-numbers="1-5|7-11|13-17"}
# Research task
research_task = Task(
    description="Research the topic: {topic}",
    expected_output="Detailed research findings",
    agent=researcher
)

# Writing task
writing_task = Task(
    description="Write an article based on the research",
    expected_output="Well-written article",
    agent=writer
)

# Review task
review_task = Task(
    description="Review and improve the article",
    expected_output="Polished final article",
    agent=reviewer
)
```

::: notes
Each task is assigned to the appropriate specialist agent. Output flows from one task to the next.
:::

---

## Execute Multi-Agent Workflow {data-transition="fade"}

```python {data-line-numbers="1-6|8-11"}
# Create the crew
content_crew = Crew(
    agents=[researcher, writer, reviewer],
    tasks=[research_task, writing_task, review_task],
    process=Process.sequential,
    verbose=True
)

# Execute the workflow
result = content_crew.kickoff(
    inputs={"topic": "Retrieval-Augmented Generation"}
)

print(result)
```

<span class="fragment">The crew executes tasks **sequentially**: research → write → review</span>

::: notes
With just a few lines of code, you've created a sophisticated content creation pipeline!
:::

---

## ✅ CrewAI Best Practices {data-background-color="#064e3b"}

### 1. Clear Role Definition

<span class="fragment">Give agents **specific, well-defined roles**</span>

<span class="fragment">Avoid **overlapping responsibilities**</span>

<span class="fragment">Think like you're hiring a human team</span>

### 2. Tool Specialization

<span class="fragment">Assign tools to agents that **actually need them**</span>

<span class="fragment">Keep tool functions **focused and simple**</span>

::: notes
Good design practices lead to more effective and maintainable multi-agent systems.
:::

---

## Best Practices (Continued) {data-transition="slide"}

### 3. Effective Task Descriptions

<span class="fragment">Be **specific** about what each task should accomplish</span>

<span class="fragment">Define **clear expected outputs**</span>

<span class="fragment">Include **context** when tasks depend on each other</span>

### 4. Process Selection

<span class="fragment">Use `sequential` for **linear workflows**</span>

<span class="fragment">Use `hierarchical` for **complex, dynamic coordination**</span>

::: notes
The right process type makes your workflow more efficient and easier to debug.
:::

---

## 🧪 Lab Exercise: Customer Support System {data-background-color="#581c87"}

### Objective

Build a customer support system with specialized agents

### Requirements

<span class="fragment">Create **3 Agents**: Support (RAG tool), Technical (calculator tool), Manager (routes requests)</span>

<span class="fragment">Define appropriate **tasks** for each agent</span>

<span class="fragment">Use **sequential or hierarchical** process</span>

::: notes
This exercise reinforces multi-agent patterns and tool integration in a realistic scenario.
:::

---

## Lab Test Cases {data-transition="slide"}

Test your system with:

<span class="fragment">"What is the return policy?" → Should route to **Support Agent**</span>

<span class="fragment">"Calculate discount: $100 - 20%" → Should route to **Technical Agent**</span>

<span class="fragment">"I need help with my order" → **Manager delegates** appropriately</span>

::: notes
Testing different types of queries ensures your routing logic works correctly.
:::

---

## Lab Solution Structure {data-transition="fade"}

```python {data-line-numbers="1-8|10-14|16-17"}
# 1. Define tools
@tool("rag_support_tool")
def rag_support_tool(question: str) -> str:
    # Call RAG service for policy questions
    pass

@tool("calculator_tool")
def calculator_tool(expression: str) -> str:
    # Safe math evaluation
    pass

# 2. Create agents
support_agent = Agent(...)
technical_agent = Agent(...)
manager_agent = Agent(...)

# 3. Define tasks and crew
# Your code here...
```

::: notes
Students should implement this based on the previous examples. The structure is the same.
:::

---

## 🔧 CrewAI Advanced Features {data-background-color="#1e3a8a"}

### Memory

```python
crew = Crew(
    agents=[...],
    tasks=[...],
    memory=True  # Enable conversation memory
)
```

<span class="fragment">Agents can **remember context** from previous interactions</span>

<span class="fragment">Enables **multi-turn conversations**</span>

::: notes
Memory makes agents more contextually aware and conversational.
:::

---

## Delegation {data-transition="slide"}

```python
agent = Agent(
    role="Manager",
    allow_delegation=True  # Can delegate to other agents
)
```

<span class="fragment">Agents can **ask other agents for help**</span>

<span class="fragment">Creates **dynamic collaboration** patterns</span>

::: notes
Delegation enables more flexible and adaptive workflows.
:::

---

## Custom LLM Configuration {data-transition="fade"}

```python {data-line-numbers="1-5|7-10"}
from langchain_openai import ChatOpenAI

custom_llm = ChatOpenAI(
    model="gpt-4",
    temperature=0.7
)

agent = Agent(
    role="Specialist",
    llm=custom_llm  # Use specific LLM
)
```

<span class="fragment">Different agents can use **different LLMs**</span>

::: notes
You might want a powerful model for complex reasoning and a faster model for simple tasks.
:::

---

## Callbacks {data-transition="slide"}

```python {data-line-numbers="1-2|4-7"}
def task_callback(output):
    print(f"Task completed: {output}")

task = Task(
    description="...",
    callback=task_callback
)
```

<span class="fragment">Callbacks enable **monitoring and logging**</span>

<span class="fragment">Track progress in **long-running workflows**</span>

::: notes
Callbacks are useful for debugging and monitoring production systems.
:::

---

## 🎯 When to Use CrewAI {data-background-color="#064e3b"}

### Ideal Use Cases ✓

<span class="fragment">**Multi-agent collaboration** scenarios</span>

<span class="fragment">**Role-based task decomposition**</span>

<span class="fragment">**Sequential or hierarchical** workflows</span>

<span class="fragment">**Rapid prototyping** of agent systems</span>

::: notes
CrewAI excels when you need teams of specialized agents working together.
:::

---

## Less Ideal Use Cases {data-transition="fade"}

### When NOT to Use CrewAI ✗

<span class="fragment">Simple **single-agent** tasks</span>

<span class="fragment">Complex **state management** requirements</span>

<span class="fragment">Need **fine-grained control** over execution flow</span>

<span class="fragment">Production systems requiring **strict guarantees**</span>

::: notes
For these cases, LangGraph or watsonx Orchestrate might be better choices.
:::

---

## 📚 CrewAI Resources {data-background-color="#1e3a8a"}

### Documentation

<span class="fragment">Official Docs: [docs.crewai.com](https://docs.crewai.com)</span>

<span class="fragment">GitHub: [github.com/joaomdmoura/crewAI](https://github.com/joaomdmoura/crewAI)</span>

<span class="fragment">Examples: [CrewAI Examples Repository](https://github.com/joaomdmoura/crewAI-examples)</span>

### Getting Started

```bash
pip install crewai crewai-tools
```

::: notes
These resources will help you continue learning beyond this workshop.
:::

---

## 🎯 Summary: CrewAI {data-background-color="#1e3a8a"}

### Key Takeaways

<span class="fragment">CrewAI enables **multi-agent orchestration** with role-playing</span>

<span class="fragment">Core components: **Agents**, **Tasks**, **Crews**</span>

<span class="fragment">Processes: **Sequential** and **Hierarchical**</span>

<span class="fragment">Easy **tool integration** for capabilities</span>

<span class="fragment">Great for **rapid prototyping** of agent systems</span>

---

## Navigation & Next Steps {data-background-color="#0f172a"}

### 🏠 Workshop Portal

**[Workshop Home](https://ruslanmv.com/watsonx-workshop/portal/)** | **[Day 3 Overview](../../portal/day3-portal.md)**

### Related Content

<span class="fragment">← [Agentic AI Overview](./agentic-ai-overview.md)</span>
<span class="fragment">→ [Langflow Framework](./agentic-frameworks-langflow.md)</span>
<span class="fragment">→ [LangGraph Framework](./agentic-frameworks-langgraph.md)</span>
<span class="fragment">→ [watsonx Orchestrate](./bridge-orchestrate-governance.md)</span>

**Version:** 1.0 | **Updated:** January 2025

::: notes
CrewAI provides an intuitive way to build multi-agent systems. Next, explore other frameworks!
:::