# Granite Summarization

# Document Summarization

This notebook demonstrates an application of long document summarization techniques to a work of literature using Granite.

## Install Dependencies

Granite utils provides some helpful functions for recipes.

```python
! echo "::group::Install Dependencies"
%pip install uv
! uv pip install git+https://github.com/ibm-granite-community/utils.git \
    transformers \
    'langchain_replicate @ git+https://github.com/ibm-granite-community/langchain-replicate.git' \
    docling
! echo "::endgroup::"
```

## Select your model

Select a Granite model from the [`ibm-granite`](https://replicate.com/ibm-granite) org on Replicate. Here we use the Replicate Langchain client to connect to the model.

To get set up with Replicate, see [Getting Started with Replicate](https://github.com/ibm-granite-community/granite-kitchen/blob/main/recipes/Getting_Started/Getting_Started_with_Replicate.ipynb).

To connect to a model on a provider other than Replicate, substitute this code cell with one from the [LLM component recipe](https://github.com/ibm-granite-community/granite-kitchen/blob/main/recipes/Components/Langchain_LLMs.ipynb).

```python
from langchain_replicate import ChatReplicate
from ibm_granite_community.notebook_utils import get_env_var

model_path = "ibm-granite/granite-4.0-h-small"
model = ChatReplicate(
    model=model_path,
    replicate_api_token=get_env_var('REPLICATE_API_TOKEN'),
    model_kwargs={
        "max_tokens": 2000, # Set the maximum number of tokens to generate as output.
        "min_tokens": 200, # Set the minimum number of tokens to generate as output.
        "presence_penalty": 0,
        "frequency_penalty": 0,
    },
)
```

## Split a book into chunks

The code in the following sections will fetch H.D. Thoreau's "Walden" from [Project Gutenberg](https://www.gutenberg.org/) for summarization.

We will then chunk the book text so that chunks fit in the context window size of the AI model.

### Count the tokens

Before sending our book chunks to the AI model, it's crucial to understand how much of the model's capacity we're using. Language models typically have a limit on the number of tokens they can process in a single request.

Key points:
- We're using the [`granite-4.0-h-small`](https://huggingface.co/ibm-granite/granite-4.0-h-small) model, which has a context window of 128K tokens.
- Tokenization can vary between models, so we use the specific tokenizer for our chosen model.

Understanding token count helps us optimize our prompts and ensure we're using the model efficiently.

```python
from transformers import AutoTokenizer

tokenizer = AutoTokenizer.from_pretrained(model_path)
```

### Summary of Summaries

Here we use a hierarchical abstractive summarization technique to adapt to the context length of the model. Our approach uses [Docling](https://docling-project.github.io/docling/) to understand the document's structure, chunk the document into text passages, and group the text passages by chapter which we can then summarize.

```python
import itertools
from typing import Iterator, Callable
from docling.document_converter import DocumentConverter
from docling_core.transforms.chunker.hierarchical_chunker import HierarchicalChunker
from docling_core.transforms.chunker.base import BaseChunk

def chunk_document(source: str, *, dropwhile: Callable[[BaseChunk], bool] = lambda c: False, takewhile: Callable[[BaseChunk], bool] = lambda c: True) -> Iterator[BaseChunk]:
    """Read the document and perform a hierarchical chunking"""
    converter = DocumentConverter()
    chunks = HierarchicalChunker().chunk(converter.convert(source=source).document)
    return itertools.takewhile(takewhile, itertools.dropwhile(dropwhile, chunks))

def merge_chunks(chunks: Iterator[BaseChunk], *, headings: Callable[[BaseChunk], list[str]] = lambda c: c.meta.headings) -> Iterator[dict[str, str]]:
    """Merge chunks having the same headings"""
    prior_headings: list[str] | None = None
    document: dict[str, str] = {}
    doc_id = 0
    for chunk in chunks:
        text = chunk.text.replace('\r\n', '\n')
        current_headings = headings(chunk)
        if prior_headings != current_headings:
            if document:
                yield document
            prior_headings = current_headings
            document = {
                'doc_id': str(doc_id:=doc_id+1),
                'title': " - ".join(current_headings),
                'text': text
            }
        else:
            document['text'] += f"\n\n{text}"
    if document:
        yield document

def chunk_dropwhile(chunk: BaseChunk) -> bool:
    """Ignore front matter prior to the book start"""
    return "WALDEN" not in chunk.meta.headings

def chunk_takewhile(chunk: BaseChunk) -> bool:
    """Ignore remaining chunks once we see this heading"""
    return "ON THE DUTY OF CIVIL DISOBEDIENCE" not in chunk.meta.headings

def chunk_headings(chunk: BaseChunk) -> list[str]:
    """Use the h1 and h2 (chapter) headings"""
    return chunk.meta.headings[:2]

documents: list[dict[str, str]] = list(merge_chunks(
    chunk_document(
        "https://www.gutenberg.org/cache/epub/205/pg205-images.html",
        dropwhile=chunk_dropwhile,
        takewhile=chunk_takewhile,
    ),
    headings=chunk_headings,
))

print(f"{len(documents)} documents created")
print(f"Max document size: {max(len(tokenizer.tokenize(document['text'])) for document in documents)} tokens")
```

## Summarize the chunks

Here we define a method to generate a response using a list of documents and a user prompt about those documents.

We create the prompt according to the [Granite Prompting Guide](https://www.ibm.com/granite/docs/models/granite/#chat-template) and provide the documents using the `documents` parameter.

```python
from ibm_granite_community.langchain.prompts import TokenizerChatPromptTemplate

prompt_template = TokenizerChatPromptTemplate.from_template("{user_prompt}", tokenizer=tokenizer)

def generate(user_prompt: str, documents: list[dict[str, str]]) -> str:
    """Use the chat template to format the prompt"""
    prompt = prompt_template.format_prompt(user_prompt=user_prompt, documents=documents)

    print(f"Input size: {len(tokenizer.tokenize(prompt.to_string()))} tokens")
    output = model.invoke(prompt, documents=documents)
    print(f"Output size: {len(tokenizer.tokenize(output.text()))} tokens")

    return output.text()
```

For each chapter, we create a separate summary. This can take a few minutes.

```python
if get_env_var('GRANITE_TESTING', 'false').lower() == 'true':
    documents = documents[:5] # shorten testing work

user_prompt = """\
Using only the the book chapter document, compose a summary of the book chapter.
Your response should only include the summary. Do not provide any further explanation."""

summaries: list[dict[str, str]] = []

for i, document in enumerate(documents, start=1):
    print(f"============================= {document['title']} ({i}/{len(documents)}) =============================")
    output = generate(user_prompt, [document])
    summaries.append({
        'doc_id': document['doc_id'],
        'title': document['title'],
        'text': output,
    })

print("Summary count: " + str(len(summaries)))
```

## Create the Final Summary

Now we need to summarize the chapter summaries. We prompt the model to create a unified summary of the chapter summaries we previously generated.

```python
from ibm_granite_community.notebook_utils import wrap_text

user_prompt = """\
Using only the book chapter summary documents, compose a single, unified summary of the book.
Your response should only include the unified summary. Do not provide any further explanation."""

output = generate(user_prompt, summaries)
print(wrap_text(output))
```

So we have now summarized a document larger than the AI model's context window length by breaking the document down into smaller pieces to summarize and then summarizing those summaries.
