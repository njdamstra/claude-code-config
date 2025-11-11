# Index - LlamaIndex API Reference

Base index classes for LlamaIndex.

## BaseIndex

`BaseIndex` is the foundational class for all LlamaIndex indices. It provides core functionality for indexing, querying, and managing documents.

**Type**: `Generic[IS]`, `ABC`

### Constructor Parameters

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `nodes` | `List[Node]` | List of nodes to index | `None` |
| `show_progress` | `bool` | Whether to show tqdm progress bars | `False` |

### Properties

#### index_struct
```python
index_struct: IS
```
Get the index struct.

#### index_id
```python
index_id: str
```
Get the index ID.

#### docstore
```python
docstore: BaseDocumentStore
```
Get the docstore corresponding to the index.

#### storage_context
```python
storage_context: StorageContext
```
Get the storage context.

#### summary
```python
summary: str
```
Get or set the index summary.

#### ref_doc_info
```python
ref_doc_info: Dict[str, RefDocInfo]
```
Retrieve a dict mapping of ingested documents and their nodes+metadata.

### Class Methods

#### from_documents
```python
@classmethod
from_documents(
    documents: Sequence[Document],
    storage_context: Optional[StorageContext] = None,
    show_progress: bool = False,
    callback_manager: Optional[CallbackManager] = None,
    transformations: Optional[List[TransformComponent]] = None,
    **kwargs: Any
) -> IndexType
```

Create index from documents.

**Parameters:**
- `documents`: List of documents to build the index from

**Example:**
```python
from llama_index.core import VectorStoreIndex, Document

documents = [Document(text="doc1"), Document(text="doc2")]
index = VectorStoreIndex.from_documents(documents)
```

### Instance Methods

#### set_index_id
```python
set_index_id(index_id: str) -> None
```

Set the index id.

**Note:** If you decide to set the index_id on the index_struct manually, you will need to explicitly call `add_index_struct` on the `index_store` to update the index store.

#### build_index_from_nodes
```python
build_index_from_nodes(
    nodes: Sequence[BaseNode],
    **build_kwargs: Any
) -> IS
```

Build the index from nodes.

#### insert_nodes
```python
insert_nodes(
    nodes: Sequence[BaseNode],
    **insert_kwargs: Any
) -> None
```

Insert nodes into the index.

**Example:**
```python
from llama_index.core.schema import TextNode

nodes = [TextNode(text="new content")]
index.insert_nodes(nodes)
```

#### ainsert_nodes (async)
```python
async ainsert_nodes(
    nodes: Sequence[BaseNode],
    **insert_kwargs: Any
) -> None
```

Asynchronously insert nodes.

#### insert
```python
insert(document: Document, **insert_kwargs: Any) -> None
```

Insert a document into the index.

#### ainsert (async)
```python
async ainsert(document: Document, **insert_kwargs: Any) -> None
```

Asynchronously insert a document.

#### delete_nodes
```python
delete_nodes(
    node_ids: List[str],
    delete_from_docstore: bool = False,
    **delete_kwargs: Any
) -> None
```

Delete a list of nodes from the index.

**Parameters:**
- `node_ids`: A list of node IDs to delete
- `delete_from_docstore`: Whether to also delete from docstore

#### adelete_nodes (async)
```python
async adelete_nodes(
    node_ids: List[str],
    delete_from_docstore: bool = False,
    **delete_kwargs: Any
) -> None
```

Asynchronously delete a list of nodes from the index.

#### delete_ref_doc
```python
delete_ref_doc(
    ref_doc_id: str,
    delete_from_docstore: bool = False,
    **delete_kwargs: Any
) -> None
```

Delete a document and its nodes by using ref_doc_id.

#### adelete_ref_doc (async)
```python
async adelete_ref_doc(
    ref_doc_id: str,
    delete_from_docstore: bool = False,
    **delete_kwargs: Any
) -> None
```

Asynchronously delete a document and its nodes by using ref_doc_id.

#### update_ref_doc
```python
update_ref_doc(document: Document, **update_kwargs: Any) -> None
```

Update a document and its corresponding nodes.

This is equivalent to deleting the document and then inserting it again.

**Parameters:**
- `document`: Document to update
- `insert_kwargs` (in update_kwargs): kwargs to pass to insert
- `delete_kwargs` (in update_kwargs): kwargs to pass to delete

#### aupdate_ref_doc (async)
```python
async aupdate_ref_doc(document: Document, **update_kwargs: Any) -> None
```

Asynchronously update a document and its corresponding nodes.

#### refresh_ref_docs
```python
refresh_ref_docs(
    documents: Sequence[Document],
    **update_kwargs: Any
) -> List[bool]
```

Refresh an index with documents that have changed.

This allows users to save LLM and Embedding model calls, while only updating documents that have any changes in text or metadata. It will also insert any documents that previously were not stored.

**Returns:** List of booleans indicating which documents were refreshed.

#### arefresh_ref_docs (async)
```python
async arefresh_ref_docs(
    documents: Sequence[Document],
    **update_kwargs: Any
) -> List[bool]
```

Asynchronously refresh an index with documents that have changed.

#### as_query_engine
```python
as_query_engine(
    llm: Optional[LLMType] = None,
    **kwargs: Any
) -> BaseQueryEngine
```

Convert the index to a query engine.

Calls `index.as_retriever(**kwargs)` to get the retriever and then wraps it in a `RetrieverQueryEngine.from_args(retriever, **kwargs)` call.

**Example:**
```python
query_engine = index.as_query_engine()
response = query_engine.query("What is the main topic?")
```

#### as_chat_engine
```python
as_chat_engine(
    chat_mode: ChatMode = ChatMode.BEST,
    llm: Optional[LLMType] = None,
    **kwargs: Any
) -> BaseChatEngine
```

Convert the index to a chat engine.

Calls `index.as_query_engine(llm=llm, **kwargs)` to get the query engine and then wraps it in a chat engine based on the chat mode.

**Chat modes:**
- `ChatMode.BEST` (default): Chat engine that uses retrieval with context
- `ChatMode.CONTEXT`: Chat engine that uses a retriever to get context
- `ChatMode.CONDENSE_QUESTION`: Chat engine that condenses questions
- `ChatMode.CONDENSE_PLUS_CONTEXT`: Chat engine that condenses questions and uses a retriever to get context
- `ChatMode.SIMPLE`: Simple chat engine that uses the LLM directly

**Example:**
```python
chat_engine = index.as_chat_engine(chat_mode=ChatMode.CONTEXT)
response = chat_engine.chat("Tell me about the documents")
```

#### as_retriever (abstract)
```python
@abstractmethod
as_retriever(**kwargs: Any) -> BaseRetriever
```

Convert the index to a retriever. Must be implemented by subclasses.

## Usage Examples

### Creating and Using an Index

```python
from llama_index.core import VectorStoreIndex, Document

# Create documents
documents = [
    Document(text="LlamaIndex is a data framework for LLM applications."),
    Document(text="It provides tools for data ingestion and indexing.")
]

# Create index from documents
index = VectorStoreIndex.from_documents(documents)

# Query the index
query_engine = index.as_query_engine()
response = query_engine.query("What is LlamaIndex?")
print(response)

# Use as chat engine
chat_engine = index.as_chat_engine()
response = chat_engine.chat("Tell me more about data ingestion")
print(response)
```

### Updating Documents

```python
# Insert new document
new_doc = Document(text="LlamaIndex supports multiple vector stores.")
index.insert(new_doc)

# Update existing document
updated_doc = Document(text="Updated content", id_="doc-id")
index.update_ref_doc(updated_doc)

# Refresh with changed documents
documents = [doc1, doc2, doc3]
refreshed = index.refresh_ref_docs(documents)
print(f"Refreshed {sum(refreshed)} documents")
```

### Deleting Documents

```python
# Delete by reference document ID
index.delete_ref_doc("doc-id")

# Delete specific nodes
index.delete_nodes(["node-id-1", "node-id-2"], delete_from_docstore=True)
```

## Notes

- The `BaseIndex` class is abstract and should not be instantiated directly
- Use concrete implementations like `VectorStoreIndex`, `SummaryIndex`, etc.
- All async methods support concurrent operations for better performance
- The index automatically manages document storage and retrieval
- Custom transformations can be passed during index creation
