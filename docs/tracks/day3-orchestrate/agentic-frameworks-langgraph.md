# LangGraph: Graph-Based Agent Orchestration {data-background-color="#7c2d12"}

::: notes
This section covers LangGraph, a library for building stateful, graph-based agent applications with complex workflows.
:::

---

## What is LangGraph? {data-transition="slide"}

<div class="fragment">

**LangGraph** is a library for building **stateful, multi-actor applications** with LLMs.

</div>

<div class="fragment">

### Core Concept

Applications are modeled as **graphs** where:
- **Nodes** represent computation steps (functions)
- **Edges** define the flow of execution
- **State** is passed between nodes and updated throughout execution

</div>

::: notes
Unlike CrewAI's role-based approach, LangGraph uses explicit graph structures for fine-grained control.
:::

---

## Why LangGraph? {data-transition="fade"}

### Challenges with Chain-Based Approaches

<div class="fragment">

Traditional LangChain chains are **linear** and **stateless**

</div>

<div class="fragment">

### LangGraph Solutions

- **Cycles and Loops**: Build iterative workflows
- **Conditional Routing**: Dynamic decision-making
- **State Management**: Persistent state across steps
- **Complex Workflows**: Multi-path, branching logic
- **Human-in-the-Loop**: Pause for approval or input

</div>

::: notes
LangGraph addresses limitations of simple chains by providing graph-based orchestration.
:::

---

## LangGraph Core Components {data-background-color="#1e3a8a"}

### StateGraph

<div class="fragment">

The main abstraction for building applications

```python
from langgraph.graph import StateGraph

graph = StateGraph(StateSchema)
```

</div>

### State Schema

<div class="fragment">

Defines the structure of state using TypedDict

```python
from typing_extensions import TypedDict

class State(TypedDict):
    messages: list
    user_input: str
    result: str
```

</div>

::: notes
StateGraph is the foundation. The state schema defines what data flows through the graph.
:::

---

## LangGraph Core Components (Continued) {data-transition="fade"}

### Nodes

<div class="fragment">

Functions that process and update state

```python
def my_node(state: State) -> dict:
    # Process state
    new_value = process(state["user_input"])
    # Return updates to state
    return {"result": new_value}
```

</div>

### Edges

<div class="fragment">

Connections between nodes

```python
# Simple edge
graph.add_edge("node_a", "node_b")

# Conditional edge
graph.add_conditional_edges(
    "decision_node",
    route_function,
    {"path_a": "node_x", "path_b": "node_y"}
)
```

</div>

::: notes
Nodes do the work, edges control the flow. Conditional edges enable dynamic routing.
:::

---

## LangGraph: Simple Example {data-transition="slide"}

### Define State

```python
from typing_extensions import TypedDict
from langgraph.graph import StateGraph, START, END

class SimpleState(TypedDict):
    input: str
    output: str
```

<span class="fragment">

### Create Nodes

```python
def process_node(state: SimpleState) -> dict:
    text = state["input"]
    processed = text.upper()  # Simple transformation
    return {"output": processed}
```

</span>

::: notes
Start with a simple state schema and a single processing node.
:::

---

## LangGraph: Simple Example (Continued) {data-transition="fade"}

### Build the Graph

```python
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

<span class="fragment">

### Execute

```python
result = app.invoke({"input": "hello world"})
print(result)  # {"input": "hello world", "output": "HELLO WORLD"}
```

</span>

::: notes
Build the graph by adding nodes and edges, then compile and execute.
:::

---

## LangGraph with LLMs {data-background-color="#064e3b"}

### State for LLM Workflows

```python
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

## LangGraph RAG Example: Setup {data-transition="slide"}

```python
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
Set up the LLM and define state for a RAG workflow.
:::

---

## LangGraph RAG Example: Retrieval Node {data-transition="fade"}

```python
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
The retrieval node calls your RAG service from Day 2.
:::

---

## LangGraph RAG Example: Generation Node {data-transition="fade"}

```python
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
The generation node uses the LLM to polish the RAG response.
:::

---

## LangGraph RAG Example: Build Graph {data-transition="fade"}

```python
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

<span class="fragment">

### Execute

```python
result = rag_app.invoke({
    "question": "What is Retrieval-Augmented Generation?"
})
print(result["final_answer"])
```

</span>

::: notes
Connect the nodes in sequence: retrieve → generate → end.
:::

---

## Conditional Routing {data-background-color="#7c2d12"}

### Route Based on State

```python
def should_continue(state: AgentState) -> str:
    """Decide next step based on state"""
    if state.get("needs_research"):
        return "research"
    elif state.get("needs_calculation"):
        return "calculate"
    else:
        return "respond"
```

<span class="fragment">

### Add Conditional Edge

```python
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

</span>

::: notes
Conditional routing enables dynamic workflows based on runtime state.
:::

---

## LangGraph with Tools {data-transition="slide"}

### Tool-Calling Agent Pattern

<div class="fragment">

1. **Agent Node**: LLM decides which tool to use
2. **Tool Node**: Executes the selected tool
3. **Condition**: Check if more tools needed or finish

</div>

::: notes
This is the ReAct pattern implemented in LangGraph.
:::

---

## LangGraph Tool Agent: State {data-transition="fade"}

```python
from typing import List, Literal
from langchain_core.messages import BaseMessage

class ToolAgentState(TypedDict):
    messages: List[BaseMessage]
    # Messages include user input, agent thoughts, tool results
```

::: notes
For tool-calling agents, state is typically a list of messages.
:::

---

## LangGraph Tool Agent: Agent Node {data-transition="fade"}

```python
from langchain_core.tools import tool

# Define tools
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

# Create LLM with tools
llm_with_tools = llm.bind_tools([calculator, rag_search])

def agent_node(state: ToolAgentState) -> dict:
    """Agent decides and calls tools"""
    response = llm_with_tools.invoke(state["messages"])
    return {"messages": [response]}
```

::: notes
The agent node uses an LLM that can call tools based on the conversation.
:::

---

## LangGraph Tool Agent: Tool Node {data-transition="fade"}

```python
from langgraph.prebuilt import ToolNode

# Create tool executor
tool_node = ToolNode([calculator, rag_search])

# The tool_node will:
# 1. Extract tool calls from last message
# 2. Execute the tools
# 3. Return tool results as messages
```

::: notes
LangGraph provides a prebuilt ToolNode for executing tools.
:::

---

## LangGraph Tool Agent: Routing {data-transition="fade"}

```python
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
This routing function checks if the agent wants to use more tools.
:::

---

## LangGraph Tool Agent: Complete Graph {data-transition="fade"}

```python
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
tool_graph.add_edge("tools", "agent")  # Loop back to agent

# Compile
tool_agent = tool_graph.compile()
```

::: notes
This creates a loop: agent → tools → agent → ... until agent decides to end.
:::

---

## LangGraph Tool Agent: Execution {data-transition="fade"}

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

::: notes
The agent will use both the RAG tool and calculator to answer this compound question.
:::

---

## Advanced: Subgraphs {data-background-color="#1e3a8a"}

### Composing Graphs

<div class="fragment">

```python
# Create specialized subgraph
research_graph = StateGraph(ResearchState)
research_graph.add_node("search", search_node)
research_graph.add_node("summarize", summarize_node)
research_subgraph = research_graph.compile()

# Use in main graph
main_graph = StateGraph(MainState)
main_graph.add_node("research", research_subgraph)
```

</div>

::: notes
Subgraphs enable modularity and reusability of complex workflows.
:::

---

## Advanced: Persistence & Checkpointing {data-transition="slide"}

### Save State Between Runs

```python
from langgraph.checkpoint.sqlite import SqliteSaver

# Create checkpointer
memory = SqliteSaver.from_conn_string(":memory:")

# Compile with checkpointing
app = graph.compile(checkpointer=memory)
```

<span class="fragment">

### Resume from Checkpoint

```python
# Execute with thread ID
config = {"configurable": {"thread_id": "conversation-1"}}
result = app.invoke({"input": "Hello"}, config)

# Continue same conversation
result = app.invoke({"input": "Tell me more"}, config)
```

</span>

::: notes
Persistence enables conversation memory and the ability to pause/resume workflows.
:::

---

## Advanced: Human-in-the-Loop {data-transition="fade"}

### Interrupt for Approval

```python
from langgraph.checkpoint.sqlite import SqliteSaver

# Compile with interrupt
app = graph.compile(
    checkpointer=SqliteSaver.from_conn_string(":memory:"),
    interrupt_before=["sensitive_action"]
)
```

<span class="fragment">

### Approve and Continue

```python
# Graph pauses at "sensitive_action"
result = app.invoke({"input": "Delete records"}, config)

# Review and approve
if user_approves():
    result = app.invoke(None, config)  # Continue from interrupt
```

</span>

::: notes
Interrupts enable human review and approval before critical actions.
:::

---

## Lab Exercise: Multi-Step Agent {data-background-color="#581c87"}

### Objective

Build an agent that can:
1. Retrieve information from RAG
2. Perform calculations
3. Generate final response

### Requirements

<div class="fragment">

**Create a LangGraph application with:**
- State for question, context, calculations, and answer
- Retrieval node (calls RAG service)
- Analysis node (determines if calculation needed)
- Calculator node (performs math if needed)
- Generation node (creates final answer)
- Conditional routing between nodes

</div>

::: notes
This exercise combines multiple concepts: RAG integration, conditional routing, and tool calling.
:::

---

## Lab Exercise: Test Cases {data-transition="fade"}

### Test Your Agent

<div class="fragment">

**Test Case 1**: Pure RAG
```
"What is prompt engineering?"
```
Should use: retrieval → generation

</div>

<div class="fragment">

**Test Case 2**: RAG + Calculation
```
"If embeddings are 768-dimensional and I have 1000 documents,
how many total numbers in the vector database?"
```
Should use: retrieval → analysis → calculator → generation

</div>

::: notes
Make sure your routing logic correctly handles both cases.
:::

---

## LangGraph vs CrewAI {data-background-color="#064e3b"}

### When to Use LangGraph

<div class="fragment">

✓ Complex workflows with branching logic
✓ Iterative processes with loops
✓ Fine-grained control over execution
✓ State management requirements
✓ Human-in-the-loop scenarios
✓ Production applications needing persistence

</div>

### When to Use CrewAI

<div class="fragment">

✓ Role-based multi-agent collaboration
✓ Sequential task delegation
✓ Rapid prototyping
✓ Simpler linear workflows

</div>

::: notes
Choose based on your specific requirements. LangGraph offers more control, CrewAI offers simpler multi-agent patterns.
:::

---

## LangGraph Best Practices {data-transition="slide"}

<div class="fragment">

### 1. Clear State Design
- Include only necessary fields
- Use TypedDict for type safety
- Document state schema

</div>

<div class="fragment">

### 2. Node Responsibility
- Keep nodes focused on single tasks
- Return partial state updates, not full state
- Handle errors gracefully

</div>

<div class="fragment">

### 3. Routing Logic
- Make routing conditions explicit
- Test all paths through the graph
- Avoid infinite loops

</div>

::: notes
Following these practices leads to maintainable and reliable graph applications.
:::

---

## LangGraph Best Practices (Continued) {data-transition="fade"}

<div class="fragment">

### 4. Testing
- Test individual nodes independently
- Test complete graph paths
- Use checkpoints for debugging

</div>

<div class="fragment">

### 5. Observability
- Log state transitions
- Monitor node execution times
- Track errors and retries

</div>

::: notes
Good testing and observability are crucial for production deployments.
:::

---

## LangGraph Resources {data-transition="zoom"}

### Documentation
- [LangGraph Docs](https://langchain-ai.github.io/langgraph/)
- [LangGraph Tutorials](https://github.com/langchain-ai/langgraph/tree/main/docs/tutorials)

### Installation

```bash
pip install langgraph langchain-core langchain-openai
```

### Examples
- [LangGraph Examples Repo](https://github.com/langchain-ai/langgraph/tree/main/examples)

::: notes
Comprehensive documentation and examples are available to help you build more complex applications.
:::

---

## Summary: LangGraph {data-background-color="#7c2d12"}

<div class="fragment">

### Key Takeaways

1. **Graph-based** orchestration with explicit state management
2. **Nodes** are functions, **edges** define flow
3. **Conditional routing** enables dynamic workflows
4. **Persistence** and **human-in-the-loop** for production
5. **Fine-grained control** for complex applications

</div>

<div class="fragment">

### Next Steps

→ Explore **Langflow** for visual workflow building

</div>

::: notes
LangGraph provides powerful primitives for building sophisticated agent applications with full control over execution.
:::