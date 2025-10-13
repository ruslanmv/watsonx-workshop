# Granite Function-Calling Agent

# Granite Function Calling Agent

In this recipe, you will use the IBM® [Granite](https://www.ibm.com/granite) model now available on watsonx.ai™ to perform custom function calling.  

Traditional [large language models (LLMs)](https://www.ibm.com/topics/large-language-models), like the OpenAI GPT-5 (generative pre-trained transformer) model available through ChatGPT, and the IBM Granite™ models that we'll use in this recipe, are limited in their knowledge and reasoning. They produce their responses based on the data used to train them and are difficult to adapt to personalized user queries. To obtain the missing information, these [generative AI](https://www.ibm.com/topics/generative-ai) models can integrate external tools within the function calling. This method is one way to avoid fine-tuning a foundation model for each specific use-case. The function calling examples in this recipe will implement external [API](https://www.ibm.com/topics/api) calls.

The Granite model and tokenizer use [natural language processing (NLP)](https://www.ibm.com/topics/natural-language-processing) to parse query syntax. In addition, the models use function descriptions and function parameters to determine the appropriate tool calls. Key information is then extracted from user queries to be passed as function arguments.

# Steps

## Step 1. Set up your environment

While you can choose from several tools, this recipe is best suited for a Jupyter Notebook. Jupyter Notebooks are widely used within data science to combine code with various data sources such as text, images and data visualizations.

You can run this notebook in [Colab](https://colab.research.google.com/), or download it to your system and [run the notebook locally](https://github.com/ibm-granite-community/granite-kitchen/blob/main/recipes/Getting_Started_with_Jupyter_Locally/Getting_Started_with_Jupyter_Locally.md).

To avoid Python package dependency conflicts, we recommend setting up a [virtual environment](https://docs.python.org/3/library/venv.html).

Note, this notebook is compatible with Python 3.12 and well as Python 3.11, the default in Colab at the time of publishing this recipe. To check your python version, you can run the `!python --version` command in a code cell.


## Step 2. Set up a watsonx.ai instance

See [Getting Started with IBM watsonx](https://github.com/ibm-granite-community/granite-kitchen/blob/main/recipes/Getting_Started/Getting_Started_with_WatsonX.ipynb) for information on getting ready to use watsonx.ai.

You will need three credentials from the watsonx.ai set up to add to your environment: `WATSONX_URL`, `WATSONX_APIKEY`, and `WATSONX_PROJECT_ID`.

## Step 3. Install relevant libraries and set up credentials and the Granite model

We'll need a few libraries for this recipe. We will be using LangGraph and LangChain libraries to use Granite on watsonx.ai.

```python
! echo "::group::Install Dependencies"
%pip install uv
! uv pip install "git+https://github.com/ibm-granite-community/utils.git" \
    langgraph \
    langchain \
    langchain_ibm
! echo "::endgroup::"
```

Now we will get the credentials to use watsonx.ai and create the Granite model for use.

```python
from ibm_granite_community.notebook_utils import get_env_var
from langchain_core.utils.utils import convert_to_secret_str
from langchain.chat_models import init_chat_model

model = "ibm/granite-3-3-8b-instruct"

model_parameters = {
    "temperature": 0,
    "max_completion_tokens": 200,
    "repetition_penalty": 1.05,
}

llm = init_chat_model(
    model=model,
    model_provider="ibm",
    url=convert_to_secret_str(get_env_var("WATSONX_URL")),
    apikey=convert_to_secret_str(get_env_var("WATSONX_APIKEY")),
    project_id=get_env_var("WATSONX_PROJECT_ID"),
    params=model_parameters,
)
```

## Step 4: Define the functions

We define two functions to be used as tools by our agent. These functions can use real web API if you obtain the necessary API keys. If you are unable to get the API keys, the tools below will respond with a fixed, predetermined value for demonstration purposes.

The `get_stock_price` function in this recipe use an `AV_STOCK_API_KEY` key. To generate a free `AV_STOCK_API_KEY`, please visit the [Alpha Vantage website](https://www.alphavantage.co/support/#api-key).

Secondly, the `get_current_weather` function uses a `WEATHER_API_KEY`. To generate one, please [create an account](https://home.openweathermap.org/users/sign_up). Upon creating an account, select the "API Keys" tab to display your free key.

**Store these private keys in a separate `.env` file in the same level of your directory as this notebook.**

```python
AV_STOCK_API_KEY = convert_to_secret_str(get_env_var("AV_STOCK_API_KEY", "unset"))

WEATHER_API_KEY = convert_to_secret_str(get_env_var("WEATHER_API_KEY", "unset"))
```

We can now define our functions. The function's docstring and type information are important for generating the proper tool information since this information will be the basis of the tool description provided to the model.

In this recipe, the `get_stock_price` function uses the Stock Market Data API available through Alpha Vantage.

```python
import requests

def get_stock_price(ticker: str, date: str) -> dict:
    """
    Retrieves the lowest and highest stock prices for a given ticker and date.

    Args:
        ticker: The stock ticker symbol, for example, "IBM".
        date: The date in "YYYY-MM-DD" format for which you want to get stock prices.

    Returns:
        A dictionary containing the low and high stock prices on the given date.
    """
    print(f"Getting stock price for {ticker} on {date}")

    apikey = AV_STOCK_API_KEY.get_secret_value()
    if apikey == "unset":
        print("No API key present; using a fixed, predetermined value for demonstration purposes")
        return {
            "low": "245.4500",
            "high": "249.0300"
        }

    try:
        stock_url = f"https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol={ticker}&apikey={apikey}"
        stock_data = requests.get(stock_url)
        data = stock_data.json()
        stock_low = data["Time Series (Daily)"][date]["3. low"]
        stock_high = data["Time Series (Daily)"][date]["2. high"]
        return {
            "low": stock_low,
            "high": stock_high
        }
    except Exception as e:
        print(f"Error fetching stock data: {e}")
        return {
            "low": "none",
            "high": "none"
        }
```

The `get_current_weather` function retrieves the real-time weather in a given location using the Current Weather Data API via [OpenWeather](https://openweathermap.org/api).

```python
def get_current_weather(location: str) -> dict:
    """
    Fetches the current weather for a given location (default: San Francisco).

    Args:
        location: The name of the city for which to retrieve the weather information.

    Returns:
        A dictionary containing weather information such as temperature in celsius, weather description, and humidity.
    """
    print(f"Getting current weather for {location}")
    apikey=WEATHER_API_KEY.get_secret_value()
    if apikey == "unset":
        print("No API key present; using a fixed, predetermined value for demonstration purposes")
        return {
            "description": "thunderstorms",
            "temperature": 25.3,
            "humidity": 94
        }

    try:
        # API request to fetch weather data
        weather_url = f"https://api.openweathermap.org/data/2.5/weather?q={location}&appid={apikey}&units=metric"
        weather_data = requests.get(weather_url)
        data = weather_data.json()
        # Extracting relevant weather details
        weather_description = data["weather"][0]["description"]
        temperature = data["main"]["temp"]
        humidity = data["main"]["humidity"]

        # Returning weather details
        return {
            "description": weather_description,
            "temperature": temperature,
            "humidity": humidity
        }
    except Exception as e:
        print(f"Error fetching weather data: {e}")
        return {
            "description": "none",
            "temperature": "none",
            "humidity": "none"
        }
```

## Step 4: Build the agent

Now we use LangGraph to build the agent. First we setup the agent's state. The state is maintained by the agent as it handles a request. This state will hold the list of messages in the multi-turn conversation with the model.

```python
from typing import Annotated, TypedDict
from langchain_core.messages import BaseMessage
from langgraph.graph.message import add_messages

class State(TypedDict):
    # Messages have the type "list". The `add_messages` function
    # in the annotation defines how this state key should be updated
    # (in this case, it appends messages to the list, rather than overwriting them)
    messages: Annotated[list[BaseMessage], add_messages]
```

We now create a binding of the tools to the Granite model. When the model is called, the available tool descriptions are provided to the model.

```python
tools = [get_stock_price, get_current_weather]
llm_with_tools = llm.bind_tools(tools)
```

Now we begin to create the LangGraph graph for our agent. This graph consists of nodes which are functional blocks which are assembled into a graph with edges controlling workflow through the graph from a start node to an end node.

The first node we create is for calling Granite. It uses the list of messages from the state as the input to the model and returns the response message from the model to update the state.

```python
def llm_node(state: State) -> State:
    messages = state["messages"]
    response_message = llm_with_tools.invoke(messages)
    state_update = State(messages=[response_message])
    return state_update
```

We also want a node for tool calling when the model requests a tool be called with some arguments. Here we use the pre-built tool calling node implementation from LangGraph.

When the model wants to use a provided tool, it will request the tool name along with arguments. The tool node will call the tool with the arguments and add a tool message to the state with the results of the tool call.

```python
from langgraph.prebuilt import ToolNode

tool_node = ToolNode(tools=tools)
```

We also need some edges defined to control flow between the nodes we created.

We define a function to examine the state and decide whether to call to the tool node if Granite requested to use a tool or proceed to the END node in the graph finishing the workflow.

```python
from langchain_core.messages import AIMessage
from langgraph.graph import END

def route_tools(state: State) -> str:
    """
    This is conditional_edge function to route to the ToolNode if the last message
    in the state has tool calls. Otherwise, route to the END node to complete the
    workflow.
    """
    messages = state.get("messages")
    if not messages:
        raise ValueError(f"No messages found in input state to tool_edge: {state}")

    last_message = messages[-1]
    # If the last message is from the model and it contains a tool call request
    if isinstance(last_message, AIMessage) and len(last_message.tool_calls) > 0:
        return "tools"
    return END
```

We now have defined some nodes and a function to act as an edge.

Next we build the graph using the nodes and add edges between the nodes.

```python
from langgraph.graph import StateGraph

graph_builder = StateGraph(State)
```

We add two nodes. One for our llm node and another for our tools node.

The first argument is the unique node name. The second argument is the function or object that will be called whenever the node is used.

```python
graph_builder.add_node("llm", llm_node)
graph_builder.add_node("tools", tool_node)
```


Then we add the initial edge from the `START` node to our llm node. This starts the workflow.

```python
from langgraph.graph import START

graph_builder.add_edge(START, "llm")
```

Then we add a conditional edge from our llm node to either our tools node
or the final `END` node. The `route_tools` function we define above returns `tools` if the llm asks to use a tool,
and `END` if no tool call is requested.
This conditional routing defines the main agent loop.

```python
graph_builder.add_conditional_edges(
    "llm",
    route_tools,
    # The following dictionary lets you tell the graph to interpret the condition's outputs as a specific node
    # It defaults to the identity function, but if you
    # want to use a node named something else apart from "tools",
    # You can update the value of the dictionary to something else
    # e.g., "tools": "my_tools"
    {
        "tools": "tools",
        END: END,
    },
)
```


We then add an edge so that after a tool has been called, we return to our llm node to decide the next step.

```python
graph_builder.add_edge("tools", "llm")
```

Now that we have added all the nodes and edges to the builder, we compile this into our graph.

```python
from langgraph.graph.state import CompiledStateGraph

graph: CompiledStateGraph[State] = graph_builder.compile()
```

We can visualize the compiled graph to see the nodes and edges in the graph.

```python
from IPython.display import Image, display

try:
    display(Image(graph.get_graph().draw_mermaid_png()))
except Exception:
    # This requires some extra dependencies and is optional
    pass
```

## Step 5: Using the agent

To use our agent, we define a method to process a request to the agent. The input is processed by the agent's graph and the event stream of messages processed by the agent is displayed so we can see the workflow of the agent.

```python
from langchain_core.messages import HumanMessage

def function_calling_agent(graph: CompiledStateGraph, user_input: str):
    user_message = HumanMessage(user_input)
    print(user_message.pretty_repr())
    input = {"messages": [user_message]}
    for event in graph.stream(input):
        for value in event.values():
            print(value["messages"][-1].pretty_repr())
```

Let's ask some questions of the agent which rely upon using the provided tools.

```python
function_calling_agent(graph, "What is the weather in Miami?")
```

```python
function_calling_agent(graph, "What were the IBM stock prices on September 5, 2025?")
```

## Step 6: Simplifying your agent creation

LangGraph provides a method to that captures all of the work we did above to create a function calling agent. You just need to provide the model and the list of tools.

```python
from langgraph.prebuilt import create_react_agent

agent = create_react_agent(
    model=llm,
    tools=tools,
)

function_calling_agent(agent, "What is the weather in Miami?")
```

A note about the `prompt` argument to `create_react_agent`. Not specifying the `prompt` argument means the agent will behave as a function calling agent that we previously built above. The `prompt` argument is used as a system prompt to the model. For Granite 3, providing a system prompt will mean the default system prompt for tool calling will be not be present and the model may not properly handle tool calling. So we do not specify the `prompt` argument here.
