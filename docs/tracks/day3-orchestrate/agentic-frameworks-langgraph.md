# 🔗 LangGraph: Graph-Based Agent Orchestration {data-background-color="#7c2d12"}

::: notes
This section covers LangGraph, a library for building stateful, graph-based agent applications with complex workflows. LangGraph gives you fine-grained control over agent execution.
:::

---

## 🎯 What is LangGraph? {data-transition="slide"}

<span class="fragment">**LangGraph** is a library for building **stateful, multi-actor applications** with LLMs</span>

<span class="fragment">Think of it as a **state machine** for AI agents</span>

<span class="fragment">Provides **explicit control** over workflow execution</span>

::: notes
Unlike CrewAI's role-based approach, LangGraph uses explicit graph structures for fine-grained control over agent behavior.
:::

---

## Core Concept {data-transition="fade"}

Applications are modeled as **graphs** where:

<span class="fragment">**Nodes** represent computation steps (functions)</span>

<span class="fragment">**Edges** define the flow of execution</span>

<span class="fragment">**State** is passed between nodes and updated throughout execution</span>

::: notes
This graph-based model makes complex workflows explicit and debuggable.
:::

---

## 🤔 Why LangGraph? {data-background-color="#1e3a8a"}

### Challenges with Chain-Based Approaches

<span class="fragment">Traditional LangChain chains are **linear** and **stateless**</span>

<span class="fragment">Hard to implement **loops** and **conditional logic**</span>

<span class="fragment">Difficult to **debug** complex workflows</span>

::: notes
Chains work well for simple linear workflows but break down for complex agent systems.
:::

---

## LangGraph Solutions {data-transition="zoom"}

<span class="fragment">**Cycles and Loops** - Build iterative workflows</span>

<span class="fragment">**Conditional Routing** - Dynamic decision-making</span>

<span class="fragment">**State Management** - Persistent state across steps</span>

<span class="fragment">**Complex Workflows** - Multi-path, branching logic</span>

<span class="fragment">**Human-in-the-Loop** - Pause for approval or input</span>

::: notes
LangGraph addresses all the limitations of simple chains by providing graph-based orchestration.
:::

---

## 🧩 LangGraph Core Components {data-background-color="#064e3b"}

### StateGraph

<span class="fragment">The main abstraction for building applications</span>

```python
from langgraph.graph import StateGraph

graph = StateGraph(StateSchema)
```

::: notes
StateGraph is the foundation. You define a state schema, then build a graph around it.
:::

---

## State Schema {data-transition="slide"}

Defines the structure of state using TypedDict:

```python {data-line-numbers="1-2|4-7"}
from typing_extensions import TypedDict

class State(TypedDict):
    messages: list
    user_input: str
    result: str
```

<span class="fragment">State flows through the entire graph</span>

<span class="fragment">Nodes can **read** and **update** state fields</span>

::: notes
The state schema defines what data flows through your graph. Keep it focused on what you actually need.
:::

---

## Nodes {data-transition="fade"}

Functions that process and update state:

```python {data-line-numbers="1-2|3-5|6-7"}
def my_node(state: State) -> dict:
    # Process state
    new_value = process(state["user_input"])

    # Return updates to state
    return {"result": new_value}
```

<span class="fragment">Nodes do the **actual work**</span>

<span class="fragment">Return **partial updates** to state (not full state)</span>

::: notes
Nodes are pure functions that transform state. This makes them easy to test and reason about.
:::

---

## Edges {data-transition="slide"}

Connections between nodes:

```python {data-line-numbers="1-2|4-9"}
# Simple edge
graph.add_edge("node_a", "node_b")

# Conditional edge
graph.add_conditional_edges(
    "decision_node",
    route_function,
    {"path_a": "node_x", "path_b": "node_y"}
)
```

<span class="fragment">Edges control **flow**</span>

<span class="fragment">Conditional edges enable **dynamic routing**</span>

::: notes
Nodes do the work, edges control the flow. Conditional edges are what make LangGraph powerful.
:::

---

## 🚀 LangGraph: Simple Example {data-background-color="#1e3a8a"}

### Step 1: Define State

```python {data-line-numbers="1-2|4-6"}
from typing_extensions import TypedDict
from langgraph.graph import StateGraph, START, END

class SimpleState(TypedDict):
    input: str
    output: str
```

::: notes
Start with a simple state schema. This example just transforms input to output.
:::

---

## Step 2: Create Nodes {data-transition="slide"}

```python {data-line-numbers="1-5"}
def process_node(state: SimpleState) -> dict:
    text = state["input"]
    processed = text.upper()  # Simple transformation
    return {"output": processed}
```

<span class="fragment">Node reads `input` from state</span>

<span class="fragment">Processes it (uppercase conversion)</span>

<span class="fragment">Returns update for `output` field</span>

::: notes
This is a trivial example, but it shows the pattern: read from state, process, return updates.
:::

---

## Step 3: Build the Graph {data-transition="fade"}

```python {data-line-numbers="1-2|4-5|7-9|11-12"}
# Create graph
graph = StateGraph(SimpleState)

# Add node
graph.add_node("process", process_node)

# Define flow
graph.add_edge(START, "process")
graph.add_edge("process", END)

# Compile
app = graph.compile()
```

::: notes
Build the graph by adding nodes and edges, then compile it into an executable application.
:::

---

## Step 4: Execute {data-transition="slide"}

```python {data-line-numbers="1-2|3"}
result = app.invoke({"input": "hello world"})
print(result)
# {"input": "hello world", "output": "HELLO WORLD"}
```

<span class="fragment">State flows through the graph</span>

<span class="fragment">Final state includes both input and output</span>

::: notes
The invoke method runs the graph with the initial state and returns the final state.
:::

---

## 🤖 LangGraph with LLMs {data-background-color="#064e3b"}

### State for LLM Workflows

```python {data-line-numbers="1-3|5-9"}
from typing import List
from typing_extensions import TypedDict

class AgentState(TypedDict):
    messages: List[dict]  # Conversation history
    question: str         # User question
    documents: List[str]  # Retrieved docs
    answer: str          # Generated answer
```

::: notes
When working with LLMs, state typically includes messages, retrieved context, and generated outputs.
:::

---

## 📚 LangGraph RAG Example: Setup {data-transition="slide"}

```python {data-line-numbers="1-5|7-11"}
from langgraph.graph import StateGraph, START, END
from langchain_core.prompts import ChatPromptTemplate
from langchain_openai import ChatOpenAI
import requests

# Initialize LLM
llm = ChatOpenAI(model="gpt-4o-mini", temperature=0.2)

# State definition
class RAGState(TypedDict):
    question: str
    rag_response: dict
    final_answer: str
```

::: notes
Set up the LLM and define state for a RAG workflow. We'll build a two-node graph: retrieval and generation.
:::

---

## Retrieval Node {data-transition="fade"}

```python {data-line-numbers="1-3|5-13|15"}
def retrieval_node(state: RAGState) -> dict:
    """Call the RAG service to retrieve information"""
    question = state["question"]

    # Call RAG accelerator API
    url = "http://localhost:8000/ask"
    response = requests.post(
        url,
        json={"question": question},
        timeout=60
    )
    response.raise_for_status()
    data = response.json()

    return {"rag_response": data}
```

::: notes
The retrieval node calls your RAG service from Day 2. This is where agents and RAG come together!
:::

---

## Generation Node {data-transition="slide"}

```python {data-line-numbers="1-5|7-12|14-18"}
def generation_node(state: RAGState) -> dict:
    """Generate final answer using LLM"""
    question = state["question"]
    rag_response = state["rag_response"]

    # Extract answer and citations
    draft_answer = rag_response.get("answer", "No answer")
    citations = rag_response.get("citations", [])

    # Create prompt
    prompt = ChatPromptTemplate.from_template(
        "Question: {question}\n\n"
        "Draft Answer: {draft}\n\n"
        "Citations: {citations}\n\n"
        "Rewrite the answer to be clear and concise."
    )

    # Generate response
    messages = prompt.invoke({
        "question": question,
        "draft": draft_answer,
        "citations": str(citations)
    })
    result = llm.invoke(messages)

    return {"final_answer": result.content}
```

::: notes
The generation node uses the LLM to polish the RAG response. It reads from state and updates state.
:::

---

## Build RAG Graph {data-transition="fade"}

```python {data-line-numbers="1-2|4-6|8-11|13-14"}
# Create graph
graph = StateGraph(RAGState)

# Add nodes
graph.add_node("retrieve", retrieval_node)
graph.add_node("generate", generation_node)

# Define flow
graph.add_edge(START, "retrieve")
graph.add_edge("retrieve", "generate")
graph.add_edge("generate", END)

# Compile
rag_app = graph.compile()
```

::: notes
Connect the nodes in sequence: retrieve → generate → end. Simple linear flow.
:::

---

## Execute RAG Graph {data-transition="slide"}

```python
result = rag_app.invoke({
    "question": "What is Retrieval-Augmented Generation?"
})
print(result["final_answer"])
```

<span class="fragment">Graph executes: START → retrieve → generate → END</span>

<span class="fragment">Final state contains question, rag_response, and final_answer</span>

::: notes
This is a simple RAG workflow, but you can extend it with validation, evaluation, or routing.
:::

---

## 🔀 Conditional Routing {data-background-color="#7c2d12"}

Route based on state:

```python {data-line-numbers="1-7"}
def should_continue(state: AgentState) -> str:
    """Decide next step based on state"""
    if state.get("needs_research"):
        return "research"
    elif state.get("needs_calculation"):
        return "calculate"
    else:
        return "respond"
```

::: notes
Routing functions examine state and decide which path to take next.
:::

---

## Add Conditional Edge {data-transition="fade"}

```python {data-line-numbers="1-9"}
graph.add_conditional_edges(
    "decision",
    should_continue,
    {
        "research": "research_node",
        "calculate": "calc_node",
        "respond": "respond_node"
    }
)
```

<span class="fragment">Based on `should_continue` return value, graph routes to different nodes</span>

::: notes
Conditional routing enables dynamic workflows based on runtime state. This is extremely powerful.
:::

---

## 🛠️ LangGraph with Tools {data-background-color="#1e3a8a"}

### Tool-Calling Agent Pattern

<span class="fragment">1. **Agent Node** - LLM decides which tool to use</span>

<span class="fragment">2. **Tool Node** - Executes the selected tool</span>

<span class="fragment">3. **Condition** - Check if more tools needed or finish</span>

::: notes
This is the ReAct pattern implemented in LangGraph. Let's build it step by step.
:::

---

## Tool Agent: State {data-transition="slide"}

```python {data-line-numbers="1-5"}
from typing import List, Literal
from langchain_core.messages import BaseMessage

class ToolAgentState(TypedDict):
    messages: List[BaseMessage]
```

<span class="fragment">For tool-calling agents, state is typically a **list of messages**</span>

<span class="fragment">Messages include user input, agent thoughts, tool results</span>

::: notes
The messages list acts as a conversation history that grows with each iteration.
:::

---

## Tool Agent: Define Tools {data-transition="fade"}

```python {data-line-numbers="1-2|4-10|12-16"}
from langchain_core.tools import tool

@tool
def calculator(expression: str) -> str:
    """Evaluate mathematical expression"""
    try:
        return str(eval(expression))
    except:
        return "Error"

@tool
def rag_search(question: str) -> str:
    """Search knowledge base"""
    # Call RAG service
    pass
```

::: notes
Define tools using LangChain's @tool decorator. These become available to the agent.
:::

---

## Tool Agent: Agent Node {data-transition="slide"}

```python {data-line-numbers="1-2|4-7"}
# Create LLM with tools
llm_with_tools = llm.bind_tools([calculator, rag_search])

def agent_node(state: ToolAgentState) -> dict:
    """Agent decides and calls tools"""
    response = llm_with_tools.invoke(state["messages"])
    return {"messages": [response]}
```

<span class="fragment">LLM bound with tools can **decide** which tool to call</span>

<span class="fragment">Returns messages with tool calls embedded</span>

::: notes
The agent node uses an LLM that can call tools based on the conversation.
:::

---

## Tool Agent: Tool Node {data-transition="fade"}

```python {data-line-numbers="1-2|4-5"}
from langgraph.prebuilt import ToolNode

# Create tool executor
tool_node = ToolNode([calculator, rag_search])
```

<span class="fragment">The tool_node will:</span>

<span class="fragment">1. Extract tool calls from last message</span>

<span class="fragment">2. Execute the tools</span>

<span class="fragment">3. Return tool results as messages</span>

::: notes
LangGraph provides a prebuilt ToolNode that handles tool execution automatically.
:::

---

## Tool Agent: Routing {data-transition="slide"}

```python {data-line-numbers="1-2|3-4|6-8|9-10"}
def should_continue(state: ToolAgentState) -> Literal["tools", "end"]:
    """Check if agent wants to use tools"""
    last_message = state["messages"][-1]

    # If the last message has tool calls, continue to tools
    if hasattr(last_message, "tool_calls") and last_message.tool_calls:
        return "tools"
    # Otherwise, we're done
    return "end"
```

::: notes
This routing function checks if the agent wants to use more tools or if it's finished.
:::

---

## Tool Agent: Complete Graph {data-transition="fade"}

```python {data-line-numbers="1-2|4-6|8-14|16-17"}
# Build graph
tool_graph = StateGraph(ToolAgentState)

# Add nodes
tool_graph.add_node("agent", agent_node)
tool_graph.add_node("tools", tool_node)

# Define flow
tool_graph.add_edge(START, "agent")
tool_graph.add_conditional_edges(
    "agent",
    should_continue,
    {"tools": "tools", "end": END}
)
tool_graph.add_edge("tools", "agent")  # Loop back

# Compile
tool_agent = tool_graph.compile()
```

::: notes
This creates a loop: agent → tools → agent → ... until agent decides to end.
:::

---

## Tool Agent: Execution {data-transition="slide"}

```python
from langchain_core.messages import HumanMessage

# Run the agent
result = tool_agent.invoke({
    "messages": [
        HumanMessage(content="What is RAG and calculate 15 * 23")
    ]
})

# Print conversation
for msg in result["messages"]:
    print(f"{msg.type}: {msg.content}")
```

<span class="fragment">The agent will use **both** the RAG tool and calculator to answer this compound question</span>

::: notes
The agent automatically decides which tools to use and in what order. This is the power of tool-calling agents.
:::

---

## 🔧 Advanced: Subgraphs {data-background-color="#064e3b"}

### Composing Graphs

```python {data-line-numbers="1-5|7-9"}
# Create specialized subgraph
research_graph = StateGraph(ResearchState)
research_graph.add_node("search", search_node)
research_graph.add_node("summarize", summarize_node)
research_subgraph = research_graph.compile()

# Use in main graph
main_graph = StateGraph(MainState)
main_graph.add_node("research", research_subgraph)
```

<span class="fragment">Subgraphs enable **modularity** and **reusability** of complex workflows</span>

::: notes
Build complex systems from composable subgraphs, just like functions in programming.
:::

---

## 💾 Advanced: Persistence & Checkpointing {data-transition="slide"}

### Save State Between Runs

```python {data-line-numbers="1-4|6-7"}
from langgraph.checkpoint.sqlite import SqliteSaver

# Create checkpointer
memory = SqliteSaver.from_conn_string(":memory:")

# Compile with checkpointing
app = graph.compile(checkpointer=memory)
```

::: notes
Checkpointing enables conversation memory and the ability to pause/resume workflows.
:::

---

## Resume from Checkpoint {data-transition="fade"}

```python {data-line-numbers="1-3|5-6"}
# Execute with thread ID
config = {"configurable": {"thread_id": "conversation-1"}}
result = app.invoke({"input": "Hello"}, config)

# Continue same conversation
result = app.invoke({"input": "Tell me more"}, config)
```

<span class="fragment">Same thread ID = same conversation context</span>

<span class="fragment">State persists across invocations</span>

::: notes
Persistence is critical for multi-turn conversations and long-running workflows.
:::

---

## 👤 Advanced: Human-in-the-Loop {data-background-color="#1e3a8a"}

### Interrupt for Approval

```python {data-line-numbers="1-6"}
# Compile with interrupt
app = graph.compile(
    checkpointer=SqliteSaver.from_conn_string(":memory:"),
    interrupt_before=["sensitive_action"]
)
```

::: notes
Interrupts enable human review and approval before critical actions.
:::

---

## Approve and Continue {data-transition="fade"}

```python {data-line-numbers="1-2|4-6"}
# Graph pauses at "sensitive_action"
result = app.invoke({"input": "Delete records"}, config)

# Review and approve
if user_approves():
    result = app.invoke(None, config)  # Continue from interrupt
```

<span class="fragment">Graph **pauses** before sensitive actions</span>

<span class="fragment">Human approves, then graph **continues**</span>

::: notes
Human-in-the-loop is essential for high-stakes decisions or compliance requirements.
:::

---

## 🧪 Lab Exercise: Multi-Step Agent {data-background-color="#581c87"}

### Objective

Build an agent that can:

<span class="fragment">1. Retrieve information from RAG</span>

<span class="fragment">2. Perform calculations</span>

<span class="fragment">3. Generate final response</span>

::: notes
This exercise combines multiple concepts: RAG integration, conditional routing, and tool calling.
:::

---

## Lab Requirements {data-transition="slide"}

Create a LangGraph application with:

<span class="fragment">State for question, context, calculations, and answer</span>

<span class="fragment">Retrieval node (calls RAG service)</span>

<span class="fragment">Analysis node (determines if calculation needed)</span>

<span class="fragment">Calculator node (performs math if needed)</span>

<span class="fragment">Generation node (creates final answer)</span>

<span class="fragment">Conditional routing between nodes</span>

::: notes
This is a realistic workflow that combines RAG, conditional logic, and tool use.
:::

---

## Lab Test Cases {data-transition="fade"}

### Test Case 1: Pure RAG

```
"What is prompt engineering?"
```

<span class="fragment">Should use: retrieval → generation</span>

### Test Case 2: RAG + Calculation

```
"If embeddings are 768-dimensional and I have 1000 documents,
how many total numbers in the vector database?"
```

<span class="fragment">Should use: retrieval → analysis → calculator → generation</span>

::: notes
Make sure your routing logic correctly handles both simple and complex cases.
:::

---

## 🆚 LangGraph vs CrewAI {data-background-color="#064e3b"}

### When to Use LangGraph

<span class="fragment">Complex workflows with branching logic</span>

<span class="fragment">Iterative processes with loops</span>

<span class="fragment">Fine-grained control over execution</span>

<span class="fragment">State management requirements</span>

<span class="fragment">Human-in-the-loop scenarios</span>

<span class="fragment">Production applications needing persistence</span>

::: notes
LangGraph offers more control at the cost of more complexity.
:::

---

## When to Use CrewAI {data-transition="fade"}

<span class="fragment">Role-based multi-agent collaboration</span>

<span class="fragment">Sequential task delegation</span>

<span class="fragment">Rapid prototyping</span>

<span class="fragment">Simpler linear workflows</span>

::: notes
Choose based on your specific requirements. LangGraph offers more control, CrewAI offers simpler multi-agent patterns.
:::

---

## ✅ LangGraph Best Practices {data-transition="slide"}

### 1. Clear State Design

<span class="fragment">Include only necessary fields</span>

<span class="fragment">Use TypedDict for type safety</span>

<span class="fragment">Document state schema</span>

### 2. Node Responsibility

<span class="fragment">Keep nodes focused on single tasks</span>

<span class="fragment">Return partial state updates, not full state</span>

<span class="fragment">Handle errors gracefully</span>

::: notes
Good design practices make your graphs maintainable and debuggable.
:::

---

## Best Practices (Continued) {data-transition="fade"}

### 3. Routing Logic

<span class="fragment">Make routing conditions explicit</span>

<span class="fragment">Test all paths through the graph</span>

<span class="fragment">Avoid infinite loops</span>

### 4. Testing

<span class="fragment">Test individual nodes independently</span>

<span class="fragment">Test complete graph paths</span>

<span class="fragment">Use checkpoints for debugging</span>

::: notes
Testing is crucial. Start with unit tests for nodes, then integration tests for full graphs.
:::

---

## Best Practices (Continued) {data-transition="slide"}

### 5. Observability

<span class="fragment">Log state transitions</span>

<span class="fragment">Monitor node execution times</span>

<span class="fragment">Track errors and retries</span>

::: notes
Good observability makes production debugging much easier.
:::

---

## 📚 LangGraph Resources {data-background-color="#1e3a8a"}

### Documentation

<span class="fragment">[LangGraph Docs](https://langchain-ai.github.io/langgraph/)</span>

<span class="fragment">[LangGraph Tutorials](https://github.com/langchain-ai/langgraph/tree/main/docs/tutorials)</span>

<span class="fragment">[LangGraph Examples Repo](https://github.com/langchain-ai/langgraph/tree/main/examples)</span>

### Installation

```bash
pip install langgraph langchain-core langchain-openai
```

::: notes
Comprehensive documentation and examples are available to help you build more complex applications.
:::

---

## 🎯 Summary: LangGraph {data-background-color="#7c2d12"}

### Key Takeaways

<span class="fragment">**Graph-based** orchestration with explicit state management</span>

<span class="fragment">**Nodes** are functions, **edges** define flow</span>

<span class="fragment">**Conditional routing** enables dynamic workflows</span>

<span class="fragment">**Persistence** and **human-in-the-loop** for production</span>

<span class="fragment">**Fine-grained control** for complex applications</span>

---

## Navigation & Next Steps {data-background-color="#0f172a"}

### 🏠 Workshop Portal

**[Workshop Home](https://ruslanmv.com/watsonx-workshop/portal/)** | **[Day 3 Overview](../../portal/day3-portal.md)**

### Related Content

<span class="fragment">← [Agentic AI Overview](./agentic-ai-overview.md)</span>
<span class="fragment">← [CrewAI Framework](./agentic-frameworks-crewai.md)</span>
<span class="fragment">← [Langflow Framework](./agentic-frameworks-langflow.md)</span>
<span class="fragment">→ [watsonx Orchestrate](./bridge-orchestrate-governance.md)</span>

**Version:** 1.0 | **Updated:** January 2025

::: notes
LangGraph provides powerful primitives for building sophisticated agent applications with full control!
:::