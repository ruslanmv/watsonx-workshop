# CrewAI Framework for Multi-Agent Systems {data-background-color="#1e3a8a"}

::: notes
This section covers CrewAI, a Python library for building multi-agent systems with collaborative AI agents.
:::

---

## What is CrewAI? {data-transition="slide"}

<div class="fragment">

**CrewAI** is a Python framework for orchestrating **role-playing, autonomous AI agents**.

</div>

<div class="fragment">

### Core Philosophy

- Agents work together as a **crew** to accomplish complex tasks
- Each agent has a specific **role**, **goal**, and **backstory**
- Agents use **tools** to perform actions and gather information

</div>

::: notes
CrewAI makes it easy to create multi-agent systems where each agent has specialized capabilities and they collaborate to solve complex problems.
:::

---

## CrewAI Core Components {data-transition="fade"}

### Agent

<div class="fragment">

An autonomous unit with:

- **Role**: The agent's function (e.g., "Research Analyst")
- **Goal**: What the agent aims to achieve
- **Backstory**: Context that shapes the agent's behavior
- **Tools**: Functions the agent can execute

</div>

### Task

<div class="fragment">

Work to be performed:

- **Description**: What needs to be done
- **Expected Output**: Desired result format
- **Agent**: Which agent performs this task

</div>

::: notes
The Agent and Task are the fundamental building blocks. Agents have personalities and capabilities, while Tasks define the work to be done.
:::

---

## CrewAI Core Components (Continued) {data-transition="fade"}

### Crew

<div class="fragment">

The orchestrator that manages:

- **Agents**: Collection of agents working together
- **Tasks**: List of tasks to accomplish
- **Process**: How tasks are executed (`sequential` or `hierarchical`)
- **Manager LLM**: (Optional) LLM for task delegation in hierarchical mode

</div>

::: notes
The Crew brings everything together and manages how agents collaborate to complete tasks.
:::

---

## CrewAI Process Types {data-background-color="#064e3b"}

### Sequential Process

<div class="fragment">

```python
Process.sequential
```

Tasks executed one after another in order

</div>

### Hierarchical Process

<div class="fragment">

```python
Process.hierarchical
```

A manager agent delegates tasks to other agents dynamically

</div>

::: notes
Choose sequential for simple linear workflows, hierarchical for complex multi-agent coordination.
:::

---

## CrewAI Example: Basic Agent {data-transition="slide"}

```python
from crewai import Agent, Task, Crew, Process
from crewai_tools import tool

# Define a simple tool
@tool("calculator")
def calculator(expression: str) -> str:
    """Evaluate a mathematical expression"""
    try:
        result = eval(expression)
        return str(result)
    except Exception as e:
        return f"Error: {str(e)}"
```

<span class="fragment">

Create an agent:

```python
math_agent = Agent(
    role="Math Expert",
    goal="Solve mathematical problems accurately",
    backstory="You are a skilled mathematician.",
    tools=[calculator],
    verbose=True
)
```

</span>

::: notes
This shows how to create a simple tool and agent. The @tool decorator makes any Python function available to agents.
:::

---

## CrewAI Example: Task & Crew {data-transition="fade"}

```python
# Define the task
math_task = Task(
    description="Calculate the result of (15 + 25) * 3",
    expected_output="The numerical result",
    agent=math_agent
)

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

::: notes
The crew orchestrates the execution. kickoff() starts the process and returns the final output.
:::

---

## CrewAI with RAG Integration {data-background-color="#1e3a8a"}

### Building a RAG Tool

```python
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
This tool integrates your RAG accelerator from Day 2 into CrewAI agents.
:::

---

## Multi-Agent Example: Research Team {data-transition="slide"}

```python
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

<span class="fragment">

```python
# Reviewer Agent
reviewer = Agent(
    role="Quality Reviewer",
    goal="Ensure accuracy and quality",
    backstory="Detail-oriented editor with high standards",
    tools=[],
    verbose=True
)
```

</span>

::: notes
This creates a three-agent team: one researches, one writes, one reviews.
:::

---

## Multi-Agent Example: Tasks {data-transition="fade"}

```python
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
Each task is assigned to the appropriate specialist agent.
:::

---

## Multi-Agent Example: Crew Execution {data-transition="fade"}

```python
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

::: notes
The crew executes tasks sequentially: research → write → review.
:::

---

## CrewAI Best Practices {data-background-color="#7c2d12"}

<div class="fragment">

### 1. Clear Role Definition
- Give agents specific, well-defined roles
- Avoid overlapping responsibilities

</div>

<div class="fragment">

### 2. Tool Specialization
- Assign tools to agents that need them
- Keep tool functions focused and simple

</div>

<div class="fragment">

### 3. Effective Task Descriptions
- Be specific about what each task should accomplish
- Define clear expected outputs

</div>

<div class="fragment">

### 4. Process Selection
- Use `sequential` for linear workflows
- Use `hierarchical` for complex, dynamic coordination

</div>

::: notes
Following these practices will help you build more effective multi-agent systems.
:::

---

## Lab Exercise: CrewAI Customer Support System {data-background-color="#581c87"}

### Objective

Build a customer support system with specialized agents

### Requirements

<div class="fragment">

**Create 3 Agents:**
1. **Support Agent** - Handles general inquiries (with RAG tool)
2. **Technical Agent** - Solves technical issues (with calculator tool)
3. **Manager Agent** - Routes requests to the right specialist

</div>

<div class="fragment">

**Test Cases:**
- "What is the return policy?" (Support)
- "Calculate discount: $100 - 20%" (Technical)
- "I need help with my order" (Manager delegates)

</div>

::: notes
This exercise reinforces multi-agent patterns and tool integration.
:::

---

## Lab Exercise: Solution Structure {data-transition="fade"}

```python
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
Students should implement this based on previous examples.
:::

---

## CrewAI Advanced Features {data-transition="slide"}

### Memory

<div class="fragment">

```python
crew = Crew(
    agents=[...],
    tasks=[...],
    memory=True  # Enable conversation memory
)
```

Agents can remember context from previous interactions

</div>

### Delegation

<div class="fragment">

```python
agent = Agent(
    role="Manager",
    allow_delegation=True  # Can delegate to other agents
)
```

Agents can ask other agents for help

</div>

::: notes
These features enable more sophisticated agent behaviors.
:::

---

## CrewAI Advanced Features (Continued) {data-transition="fade"}

### Custom LLM Configuration

```python
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

<span class="fragment">

### Callbacks

```python
def task_callback(output):
    print(f"Task completed: {output}")

task = Task(
    description="...",
    callback=task_callback
)
```

</span>

::: notes
Customize the LLM and add callbacks for monitoring and logging.
:::

---

## When to Use CrewAI {data-background-color="#064e3b"}

### Ideal Use Cases ✓

<div class="fragment">

- Multi-agent collaboration scenarios
- Role-based task decomposition
- Sequential or hierarchical workflows
- Rapid prototyping of agent systems

</div>

### Less Ideal ×

<div class="fragment">

- Simple single-agent tasks
- Complex state management requirements
- Fine-grained control over execution flow
- Production systems requiring strict guarantees

</div>

::: notes
CrewAI excels at multi-agent orchestration but isn't always the right choice.
:::

---

## CrewAI Resources {data-transition="zoom"}

### Documentation
- Official Docs: [docs.crewai.com](https://docs.crewai.com)
- GitHub: [github.com/joaomdmoura/crewAI](https://github.com/joaomdmoura/crewAI)

### Getting Started

```bash
pip install crewai crewai-tools
```

### Community Examples
- [CrewAI Examples Repository](https://github.com/joaomdmoura/crewAI-examples)

::: notes
These resources will help you continue learning beyond this workshop.
:::

---

## Summary: CrewAI {data-background-color="#1e3a8a"}

<div class="fragment">

### Key Takeaways

1. CrewAI enables **multi-agent orchestration** with role-playing
2. Core components: **Agents**, **Tasks**, **Crews**
3. Processes: **Sequential** and **Hierarchical**
4. Easy **tool integration** for capabilities
5. Great for **rapid prototyping** of agent systems

</div>

<div class="fragment">

### Next Steps

→ Explore **LangGraph** for more complex state management and flows

</div>

::: notes
CrewAI provides an intuitive way to build multi-agent systems. Next, we'll see how LangGraph offers more control.
:::