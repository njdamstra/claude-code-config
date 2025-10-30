# LlamaIndex Vector Stores - Examples and Integration Guide

LlamaIndex offers multiple integration points with vector stores and vector databases for building production RAG applications.

## Using Vector Stores in LlamaIndex

LlamaIndex provides two main ways to work with vector stores:

1. **As an Index**: Use a vector store as the storage backend for `VectorStoreIndex`
2. **As a Data Source**: Load data from vector stores using data connectors

## Supported Vector Stores

LlamaIndex supports 40+ vector store integrations, including:

### Cloud-Managed Vector Databases
- **Pinecone** - Fully managed vector database
- **Qdrant Cloud** - Managed Qdrant service
- **Weaviate Cloud** - Managed Weaviate service
- **Milvus/Zilliz** - Open-source and managed vector database
- **MongoDB Atlas** - Vector search in MongoDB
- **Redis** - Redis as vector database
- **Elasticsearch** - Vector search capabilities

### Self-Hosted Vector Databases
- **Chroma** - Open-source embedding database
- **Qdrant** - High-performance vector search engine
- **Weaviate** - Open-source vector database
- **Milvus** - Scalable vector database
- **LanceDB** - Embedded vector database
- **Faiss** - Facebook AI Similarity Search

### Cloud Provider Integrations
- **Azure AI Search** - Microsoft Azure vector search
- **AWS DocumentDB** - Amazon's vector store
- **Google AlloyDB** - PostgreSQL-compatible vector store
- **Google Cloud SQL for PostgreSQL** - PostgreSQL with vector support
- **Vertex AI Vector Search** - Google Cloud vector search

### SQL Databases with Vector Support
- **PostgreSQL (pgvector)** - PostgreSQL with vector extensions
- **TimescaleDB** - Time-series database with vectors
- **MariaDB** - Vector support in MariaDB
- **TiDB** - Distributed SQL with vector search
- **OceanBase** - Distributed database with vectors

### Specialized Stores
- **Neo4j** - Graph database with vector search
- **Cassandra/Astra DB** - Wide-column store with vectors
- **Supabase** - PostgreSQL-based platform
- **Upstash** - Serverless vector database
- **DeepLake** - Data lake for deep learning
- **DocArray** - Document array vector stores

## Basic Usage Pattern

### Using a Vector Store as an Index

**Default (In-Memory):**
```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader

# Load documents
documents = SimpleDirectoryReader("./data").load_data()

# Create index (uses in-memory SimpleVectorStore by default)
index = VectorStoreIndex.from_documents(documents)

# Query
query_engine = index.as_query_engine()
response = query_engine.query("What is the main topic?")
```

**Custom Vector Store:**
```python
from llama_index.core import VectorStoreIndex, StorageContext
from llama_index.vector_stores.pinecone import PineconeVectorStore
import pinecone

# Initialize Pinecone
pc = pinecone.Pinecone(api_key="your-api-key")
pinecone_index = pc.Index("quickstart")

# Create vector store
vector_store = PineconeVectorStore(pinecone_index=pinecone_index)

# Create storage context
storage_context = StorageContext.from_defaults(vector_store=vector_store)

# Build index
index = VectorStoreIndex.from_documents(
    documents,
    storage_context=storage_context
)

# Query
query_engine = index.as_query_engine()
response = query_engine.query("Your question here")
```

## Popular Vector Store Examples

### Pinecone

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from llama_index.vector_stores.pinecone import PineconeVectorStore
from pinecone import Pinecone, ServerlessSpec

# Initialize Pinecone
pc = Pinecone(api_key="your-api-key")

# Create index if it doesn't exist
if "quickstart" not in pc.list_indexes().names():
    pc.create_index(
        name="quickstart",
        dimension=1536,
        metric="cosine",
        spec=ServerlessSpec(cloud="aws", region="us-east-1")
    )

# Connect to index
pinecone_index = pc.Index("quickstart")

# Create vector store and index
vector_store = PineconeVectorStore(pinecone_index=pinecone_index)
storage_context = StorageContext.from_defaults(vector_store=vector_store)

documents = SimpleDirectoryReader("./data").load_data()
index = VectorStoreIndex.from_documents(
    documents,
    storage_context=storage_context
)
```

### Qdrant

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from llama_index.vector_stores.qdrant import QdrantVectorStore
import qdrant_client

# Create Qdrant client
client = qdrant_client.QdrantClient(
    host="localhost",
    port=6333
)

# Create vector store
vector_store = QdrantVectorStore(
    client=client,
    collection_name="my_collection"
)

# Build index
storage_context = StorageContext.from_defaults(vector_store=vector_store)
documents = SimpleDirectoryReader("./data").load_data()
index = VectorStoreIndex.from_documents(
    documents,
    storage_context=storage_context
)
```

### Chroma

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from llama_index.vector_stores.chroma import ChromaVectorStore
import chromadb

# Create Chroma client
db = chromadb.PersistentClient(path="./chroma_db")

# Create collection
chroma_collection = db.get_or_create_collection("quickstart")

# Create vector store
vector_store = ChromaVectorStore(chroma_collection=chroma_collection)

# Build index
storage_context = StorageContext.from_defaults(vector_store=vector_store)
documents = SimpleDirectoryReader("./data").load_data()
index = VectorStoreIndex.from_documents(
    documents,
    storage_context=storage_context
)
```

### Weaviate

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from llama_index.vector_stores.weaviate import WeaviateVectorStore
import weaviate

# Create Weaviate client
client = weaviate.Client("http://localhost:8080")

# Create vector store
vector_store = WeaviateVectorStore(
    weaviate_client=client,
    index_name="LlamaIndex"
)

# Build index
storage_context = StorageContext.from_defaults(vector_store=vector_store)
documents = SimpleDirectoryReader("./data").load_data()
index = VectorStoreIndex.from_documents(
    documents,
    storage_context=storage_context
)
```

### Elasticsearch

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from llama_index.vector_stores.elasticsearch import ElasticsearchStore

# Create Elasticsearch vector store
vector_store = ElasticsearchStore(
    es_url="http://localhost:9200",
    index_name="llama_index"
)

# Build index
storage_context = StorageContext.from_defaults(vector_store=vector_store)
documents = SimpleDirectoryReader("./data").load_data()
index = VectorStoreIndex.from_documents(
    documents,
    storage_context=storage_context
)
```

### MongoDB Atlas

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from llama_index.vector_stores.mongodb import MongoDBAtlasVectorSearch
from pymongo import MongoClient

# Create MongoDB client
mongo_client = MongoClient("your-connection-string")

# Create vector store
vector_store = MongoDBAtlasVectorSearch(
    mongo_client,
    db_name="your_database",
    collection_name="your_collection",
    index_name="vector_index"
)

# Build index
storage_context = StorageContext.from_defaults(vector_store=vector_store)
documents = SimpleDirectoryReader("./data").load_data()
index = VectorStoreIndex.from_documents(
    documents,
    storage_context=storage_context
)
```

## Loading Data from Vector Stores

LlamaIndex also supports loading existing data from vector stores using data connectors.

### Chroma Data Loader

```python
from llama_index.readers.chroma import ChromaReader
import chromadb

# Create Chroma client
db = chromadb.PersistentClient(path="./chroma_db")
collection = db.get_collection("my_collection")

# Load data
reader = ChromaReader(collection=collection)
documents = reader.load_data()
```

### Qdrant Data Loader

```python
from llama_index.readers.qdrant import QdrantReader
import qdrant_client

# Create Qdrant client
client = qdrant_client.QdrantClient(host="localhost", port=6333)

# Load data
reader = QdrantReader(client=client)
documents = reader.load_data(
    collection_name="my_collection",
    limit=100
)
```

### Pinecone Data Loader

```python
from llama_index.readers.pinecone import PineconeReader

# Create reader
reader = PineconeReader(
    api_key="your-api-key",
    environment="us-east-1-aws"
)

# Load data with text mapping
id_to_text_map = {
    "id1": "Document text 1",
    "id2": "Document text 2"
}

documents = reader.load_data(
    index_name="your-index",
    id_to_text_map=id_to_text_map
)
```

## Hybrid Search Examples

Many vector stores support hybrid search combining vector similarity with keyword matching:

### Pinecone Hybrid Search

```python
from llama_index.core import VectorStoreIndex
from llama_index.vector_stores.pinecone import PineconeVectorStore

vector_store = PineconeVectorStore(
    pinecone_index=pinecone_index,
    add_sparse_vector=True  # Enable hybrid search
)

index = VectorStoreIndex.from_vector_store(vector_store)
query_engine = index.as_query_engine(
    vector_store_query_mode="hybrid",
    alpha=0.5  # Balance between dense and sparse
)
```

### Qdrant Hybrid Search

```python
from llama_index.vector_stores.qdrant import QdrantVectorStore

vector_store = QdrantVectorStore(
    client=client,
    collection_name="hybrid_collection",
    enable_hybrid=True
)

index = VectorStoreIndex.from_vector_store(vector_store)
query_engine = index.as_query_engine(
    vector_store_query_mode="hybrid"
)
```

## Best Practices

1. **Choose the Right Vector Store**:
   - For prototyping: Chroma, FAISS (local)
   - For production: Pinecone, Qdrant, Weaviate (managed)
   - For existing infrastructure: PostgreSQL with pgvector, Redis

2. **Dimension Considerations**:
   - Match vector dimensions to your embedding model
   - Common dimensions: 384, 768, 1536, 3072

3. **Indexing Strategy**:
   - Use HNSW for fast approximate search
   - Consider IVF for very large datasets
   - Flat index for small datasets or exact search

4. **Performance Optimization**:
   - Batch document insertions
   - Use async operations when available
   - Configure appropriate index parameters

5. **Metadata Filtering**:
   - Store relevant metadata with vectors
   - Use filters to narrow search space
   - Combine with hybrid search for best results

## Complete Example Notebooks

LlamaIndex provides extensive example notebooks for each vector store integration:

- [Pinecone Demo](https://developers.llamaindex.ai/python/examples/vector_stores/pineconeindexdemo)
- [Qdrant Demo](https://developers.llamaindex.ai/python/examples/vector_stores/qdrantindexdemo)
- [Chroma Demo](https://developers.llamaindex.ai/python/examples/vector_stores/chromaindexdemo)
- [Weaviate Demo](https://developers.llamaindex.ai/python/examples/vector_stores/weaviateindexdemo)
- [And 40+ more examples...](https://developers.llamaindex.ai/python/framework/community/integrations/vector_stores/)

## Additional Resources

- [Vector Store API Reference](https://developers.llamaindex.ai/python/framework-api-reference/storage/vector_store)
- [LlamaIndex Vector Store Integration Guide](https://developers.llamaindex.ai/python/framework/community/integrations/vector_stores/)
- [Vector Store Examples on GitHub](https://github.com/jerryjliu/llama_index/tree/main/docs/examples/vector_stores)
