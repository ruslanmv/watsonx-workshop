# Granite Entity Extraction

# Entity Extraction from text using Granite

LLMs have demonstrated remarkable accuracy in the task of entity extraction. This cookbook focuses on extracting key entities from descriptions related to books.

## Install dependencies

```python
! echo "::group::Install Dependencies"
%pip install uv
! uv pip install git+https://github.com/ibm-granite-community/utils.git \
    transformers \
    'langchain_replicate @ git+https://github.com/ibm-granite-community/langchain-replicate.git' \
    pydantic
! echo "::endgroup::"
```

## Instantiate the Granite model

```python
import json
from langchain_replicate import ChatReplicate
from ibm_granite_community.notebook_utils import get_env_var

model_path = "ibm-granite/granite-4.0-h-small"
model = ChatReplicate(
    model=model_path,
    replicate_api_token=get_env_var('REPLICATE_API_TOKEN'),
)
```

## 1 - Entity Extraction by defining entities in the prompt

The first approach is straightforward and involves explicitly defining the entities within the prompt itself. In this method, we specify the entities to be extracted along with their descriptions directly in the prompt. This includes:

<u>**Entity Definitions:**</u> Each entity, such as title, author, price, and rating, is clearly outlined with a concise description of what it represents.

<u>**Prompt Structure:**</u> The prompt is structured to guide the LLM in understanding exactly what information is needed. By providing detailed instructions, we aim to ensure that the model focuses on extracting only the relevant data.

<u>**Output Format:**</u> The output is required to be in JSON format, which enforces a consistent structure for the extracted data. If any entity is not found, the model is instructed to return "Data not available," preventing ambiguity.

Provide some text with information for a book. In this case, we use generated commentary on 'The Hunger Games' by Suzanne Collins.

```python
books = [
    """The name of our next book is The Hunger Games. Now, some of you might have read this book earlier, but in
my personal opinion, reading it again won't hurt, right? It gets even more interesting when we read it a second time.
So, the author of this book is Suzanne Collins, who wrote many books in the past, but this particular book for her
has got a rating of 4.33/5, which I think is a pretty good number considering what we just saw for The Book Thief.
Anyways, this book is a work of fiction, written in English and falls in the Post Apocalyptic genre. This book has 374 pages.
It was published on the 10th of October, 2005. This book is priced at 5 dollars and 9 cents. If anyone is interested in this book,
you can approach Mr Hofstadter after this workshop, he will be glad to sell you this book for only 3 dollars.
Dont miss out this chance to grab such a memorable book.
""",
]
```

All the entities that need to be fetched are defined in the prompt itself along with the entity's description.

```python
from langchain_core.prompts import ChatPromptTemplate

entity_prompt = ChatPromptTemplate.from_template("""\
You are an AI Entity Extractor. You help extract entities from the following books.

{books}

- Analyze this information and extract the following entities as per this description:

{
    "title": "This is the title of the book.",
    "author": "This is author of the book. The one who wrote this book.",
    "price": "This is the price of the book.",
    "rating": "This is the rating given for this particular book."
}

- Your output should strictly be in a json format, which only contains the key and value. The key here is the entity to be extracted and the value is the entity which you extracted.
- Do not generate random entities on your own. If it is not present or you are unable to find any specified entity, you strictly have to output it as `Data not available`.
- Only do what is asked to you. Do not give any explanations in your output and do not hallucinate.
""",
).format_prompt(
     books="\n".join(f"Book {i}\n{book}" for i, book in enumerate(books, start=1)),
)
```

Invoking the model to get the results

```python
response = model.invoke(entity_prompt)
print(response.text())
```

```python
book_info_json = json.loads(response.text())
book_info_json
```

---

## 2 - Pydantic Class-Based Entity Definition

The second approach takes advantage of object-oriented programming principles by defining entities within a class structure. This method involves several key steps:

<u>**Class Definition:**</u> We create a class that encapsulates all the relevant entities as members. Each member corresponds to an entity such as title, author, etc., and can include type annotations for better validation and clarity.

<u>**Pydantic Integration:**</u> Utilizing Pydantic, a data validation library, we convert this class into a Pydantic model. This model not only defines the structure of our data but also provides built-in validation features, ensuring that any extracted data adheres to specified formats and types.

<u>**Dynamic Prompting:**</u> The Pydantic model can then be integrated with the prompt sent to the LLM. This allows for a more dynamic interaction where the model can adapt based on the defined structure of entities. If new entities are added or existing ones modified, changes can be made at the class level without needing to rewrite the entire prompt.

<u>**Enhanced Validation:**</u> By leveraging Pydantic's capabilities, we can ensure that any data extracted by the LLM meets our predefined criteria, enhancing data integrity and reliability.

This class-based approach offers greater flexibility and scalability compared to the first method. It allows for easier modifications and expansions as new requirements arise, making it particularly suitable for larger projects or those requiring frequent updates.

```python
from pydantic import BaseModel, Field, ValidationError
from langchain_core.utils.function_calling import convert_to_openai_function
```

Here we add a commentary for a second book.

```python
books.append("""
Our next book is titled Magic of Lands. Even if some of you have read it before, I believe giving it another read would be worthwhile --
it actually gets more captivating the second time around. The author, John Williams, who has several other books to his name,
received a 3 out of 5 rating for this particular one. Considering the ratings we've seen for other books like Endurance, that's a fair score.
This French drama is 330 pages long and was published on September 11, 2010. It's currently priced at $3.22.
However, if you're interested, you can contact Mr. Shakespeare after the session -- he's offering it at a discounted price of $2.
Don't miss the opportunity to grab such an intriguing read!
""")
```

We define all of the entities in a Python class along with the description.

```python
class Book(BaseModel):
    "This contains information about a book including its title, author, price, rating, and so on."
    title: str = Field(description="The title of the book")
    price: str = Field(description="Total cost of this book")
    author: str = Field(description="The person who wrote this book")
    rating: str = Field(description="Total rating for this book")
```

```python
class BooksInformation(BaseModel):
    "This contains information about multiple books."
    books: list[Book] = Field(description = "Information on multiple books. ")
```

And we then create a JSON object describing the classes to use in the prompt.

```python
book_function = convert_to_openai_function(BooksInformation)
print(json.dumps(book_function, indent=2))
```

The prompt is similar to the previous prompt, but here, the JSON describing the Pydantic classes is used instead of defining each entity in the prompt text.

```python
entity_prompt_with_pydantic = ChatPromptTemplate.from_template(
    """\
You are an AI Entity Extractor. You help extract entities from the following books.

{books}

- Analyze this information and extract the following entities as per this function definition:

{book_function}

- Generate output as a json representation of a BooksInformation object. Include only the json.
- Your output should strictly be in a json format, which only contains the key and value. The key here is the entity to be extracted and the value is the entity which you extracted.
- Do not generate random entities on your own. If it is not present or you are unable to find any specified entity, you strictly have to output it as `Data not available`.
- Only do what is asked to you. Do not give any explanations in your output and do not hallucinate.
""",
).format_prompt(
    book_function=json.dumps(book_function),
    books="\n".join(f"Book {i}\n{book}" for i, book in enumerate(books, start=1)),
)
```

Invoking the model to get the results as a JSON string.

```python
response = model.invoke(entity_prompt_with_pydantic)
print(response.text())
```

We can now instantiate the `Book` and `BooksInformation` classes with the extracted information. We'll need error handling in case we get an improperly-formatted response.

```python
# Parse the json response.
try:
    books_information = BooksInformation.model_validate_json(response.text())
    print(books_information.model_dump_json(indent=2))
except ValidationError as e:
    print(f"Error while parsing response: {e}")
```

## 3 - Structured Output directly to Pydantic type

Finally, we can even use the Pydantic type to guide the model's output directly into an instance of the Pydantic type. This uses the `with_structured_output` method on the model passing the desired Pydantic type.

First we create a simpler prompt with just the book information.

```python
entity_prompt_structured_output = ChatPromptTemplate.from_template(
    """\
You are an AI Entity Extractor. Extract entities from the following books.

{books}
""",
).format_prompt(
    books="\n".join(f"Book {i}\n{book}" for i, book in enumerate(books, start=1)),
)
```

Then we use `with_structured_output` with the `BooksInformation` type to guide the model output. The model will directly return a Pydantic instance containing the information on the books.

```python
model_structured_output = model.with_structured_output(BooksInformation, method="json_schema")

books_information = model_structured_output.invoke(entity_prompt_structured_output)

print(type(books_information).__name__)
print(books_information.model_dump_json(indent=2))  # type: ignore
```


