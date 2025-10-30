# LlamaIndex TypeScript Technical Documentation

Data framework for building LLM applications with private data in TypeScript. Supports RAG, agents, workflows, and multi-step orchestration across Node.js, Deno, Bun, Cloudflare Workers, and edge runtimes.

## Core Architecture

### Package Structure

```typescript
// Core packages
llamaindex@0.11.25              // Main package (use for Node.js)
@llamaindex/core@0.6.22         // Core primitives (runtime-agnostic)
@llamaindex/workflow@1.1.20     // Event-driven orchestration
@llamaindex/openai@0.4.14       // OpenAI LLM integration
@llamaindex/groq@0.0.92         // Groq LLM integration
@llamaindex/env                  // Environment polyfills for edge
```

**Package selection rules:**
- `llamaindex` - Full-featured, Node.js-compatible (includes fs, crypto APIs)
- `@llamaindex/core` - Edge-compatible core (Cloudflare Workers, Vercel Edge)
- Import Node.js-specific classes directly: `import { PDFReader } from 'llamaindex/readers/PDFReader'`

### Runtime Support Matrix

```typescript
// Fully supported
Node.js >= 20 ✅
Deno ✅
Bun ✅
Cloudflare Workers ✅ (limitations: no fs, limited Node APIs)
Vercel Edge ✅ (limitations: no AsyncLocalStorage in some versions)
Nitro ✅

// Limited
Browser ❌ (no AsyncLocalStorage support)
```

## Document Loading & Ingestion

### SimpleDirectoryReader

```typescript
import { SimpleDirectoryReader, Document } from 'llamaindex';

// Load from directory (Node.js only)
const reader = new SimpleDirectoryReader();
const documents = await reader.loadData({
  directoryPath: './data'
});

// Supported formats: .txt, .pdf, .docx, .md, .csv, .json
```

### Manual Document Creation

```typescript
import { Document } from 'llamaindex';

// Create document manually
const doc = new Document({
  text: "Your document content",
  metadata: {
    source: "api",
    author: "system",
    timestamp: Date.now()
  },
  id_: "unique-doc-id" // Optional custom ID
});

// From multiple sources
const documents = [
  new Document({ text: content1, metadata: { source: "file1.txt" }}),
  new Document({ text: content2, metadata: { source: "file2.txt" }})
];
```

### Node Creation (Advanced)

```typescript
import { TextNode } from '@llamaindex/core/schema';

// Direct node creation (bypasses chunking)
const node1 = new TextNode({
  text: "Pre-chunked content",
  id_: "node-1",
  metadata: {
    source: "custom",
    page: 1
  }
});

const node2 = new TextNode({
  text: "Another chunk",
  id_: "node-2"
});

// Use nodes directly with index
import { VectorStoreIndex } from 'llamaindex';
const index = await VectorStoreIndex.init({ nodes: [node1, node2] });
```

## Node Parsing & Chunking

### Default Chunking

```typescript
import { VectorStoreIndex, Settings } from 'llamaindex';

// Global settings (affects all indexes)
Settings.chunkSize = 512;      // Default: 1024
Settings.chunkOverlap = 50;    // Default: 20

// Index automatically chunks documents
const index = await VectorStoreIndex.fromDocuments(documents);
```

### Text Splitters

```typescript
import { SentenceSplitter } from '@llamaindex/core/node-parser';

// Sentence-based splitter (respects sentence boundaries)
const splitter = new SentenceSplitter({
  chunkSize: 512,
  chunkOverlap: 50
});

// Use in index creation
const index = await VectorStoreIndex.fromDocuments(documents, {
  transformations: [splitter]
});

// Use standalone
const nodes = await splitter.getNodesFromDocuments(documents);
```

### Semantic Chunking

```typescript
import { SemanticSplitterNodeParser } from '@llamaindex/core/node-parser';
import { OpenAIEmbedding } from '@llamaindex/openai';

// Splits based on semantic similarity between sentences
const parser = new SemanticSplitterNodeParser({
  bufferSize: 1,
  breakpointPercentileThreshold: 95,
  embedModel: new OpenAIEmbedding()
});

const nodes = await parser.getNodesFromDocuments(documents);
```

### Sentence Window Parser

```typescript
import { SentenceWindowNodeParser } from '@llamaindex/core/node-parser';

// Stores surrounding sentences in metadata for context
const parser = new SentenceWindowNodeParser({
  windowSize: 3,                           // Sentences before/after
  windowMetadataKey: "window",
  originalTextMetadataKey: "original_sentence"
});

// Nodes contain single sentence + context in metadata
const nodes = await parser.getNodesFromDocuments(documents);
```

### Chunking Strategy Selection

```typescript
// Small chunks (256-512): Better precision, more API calls
Settings.chunkSize = 256;
Settings.chunkOverlap = 20;

// Medium chunks (1024): Balanced (default)
Settings.chunkSize = 1024;
Settings.chunkOverlap = 20;

// Large chunks (2048+): More context, less precision
Settings.chunkSize = 2048;
Settings.chunkOverlap = 200;

// Rule: overlap should be 10-20% of chunk size
```

## Embeddings

### OpenAI Embeddings

```typescript
import { OpenAIEmbedding } from '@llamaindex/openai';
import { Settings } from 'llamaindex';

// Set globally
Settings.embedModel = new OpenAIEmbedding({
  model: "text-embedding-3-small",  // or text-embedding-3-large
  dimensions: 1536                   // Optional: reduce dimensions
});

// Use locally
const embedModel = new OpenAIEmbedding({
  model: "text-embedding-ada-002"
});

const embedding = await embedModel.getTextEmbedding("query text");
// Returns: number[]
```

### Alternative Embedding Models

```typescript
import { HuggingFaceEmbedding } from '@llamaindex/community';

// Local embeddings (no API calls)
Settings.embedModel = new HuggingFaceEmbedding({
  modelType: "BAAI/bge-small-en-v1.5",
  quantized: false
});
```

### Batch Embeddings

```typescript
// Automatically handled by VectorStoreIndex
const index = await VectorStoreIndex.fromDocuments(documents, {
  insertBatchSize: 100  // Default: 2048
});

// Manual batch processing
const texts = ["text1", "text2", "text3"];
const embeddings = await embedModel.getTextEmbeddingsBatch(texts);
// Returns: number[][]
```

## Vector Stores & Indexes

### In-Memory Vector Store (Default)

```typescript
import { VectorStoreIndex } from 'llamaindex';

// Simplest: everything in memory
const index = await VectorStoreIndex.fromDocuments(documents);

// Query immediately
const queryEngine = index.asQueryEngine();
const response = await queryEngine.query({
  query: "What is the main topic?"
});
```

### Vector Store Index Methods

```typescript
// Create from documents
const index = await VectorStoreIndex.fromDocuments(documents);

// Create from nodes
const index = await VectorStoreIndex.init({ nodes });

// Insert additional documents
await index.insertNodes([newNode]);
await index.insert(newDocument);

// Delete by ID
await index.deleteNodes([nodeId]);
await index.deleteRef(docId);

// Get retriever
const retriever = index.asRetriever({
  similarityTopK: 5
});

// Get query engine
const queryEngine = index.asQueryEngine({
  similarityTopK: 3
});

// Get chat engine
const chatEngine = index.asChatEngine({
  chatMode: "context"  // or "openai", "react"
});
```

### Custom Vector Stores

```typescript
import { VectorStoreIndex } from 'llamaindex';
import { PineconeVectorStore } from '@llamaindex/community/vector-stores/pinecone';

// Pinecone example
const vectorStore = new PineconeVectorStore({
  indexName: "my-index",
  namespace: "default"
});

// Create index with custom store
const index = await VectorStoreIndex.init({
  vectorStore,
  nodes
});

// Load existing index
const index = await VectorStoreIndex.fromVectorStore(vectorStore);
```

### SummaryIndex (Linear Scan)

```typescript
import { SummaryIndex } from 'llamaindex';

// No embeddings - linear scan through all documents
const summaryIndex = await SummaryIndex.fromDocuments(documents);

// Better for: summaries, small datasets, complete context
const queryEngine = summaryIndex.asQueryEngine();
const response = await queryEngine.query({
  query: "Summarize everything"
});
```

## Query Engines

### Basic Query

```typescript
const queryEngine = index.asQueryEngine();

// Simple query
const response = await queryEngine.query({
  query: "What are the key findings?"
});

console.log(response.toString());
console.log(response.sourceNodes); // Retrieved chunks
```

### Query Configuration

```typescript
const queryEngine = index.asQueryEngine({
  similarityTopK: 5,              // Number of chunks to retrieve
  responseSynthesizer: {
    responseMode: "compact"       // compact | tree_summarize | no_text
  }
});

// Response modes:
// - compact: Concatenate chunks, fit in single LLM call
// - tree_summarize: Hierarchical summarization for large contexts
// - no_text: Return only retrieved chunks, no LLM synthesis
```

### Streaming Query

```typescript
const queryEngine = index.asQueryEngine();

const stream = await queryEngine.query({
  query: "Explain this concept",
  stream: true
});

// Stream response tokens
for await (const chunk of stream) {
  process.stdout.write(chunk.response);
}
```

### Custom Retrievers

```typescript
import { VectorIndexRetriever } from '@llamaindex/core/retrievers';

const retriever = new VectorIndexRetriever({
  index,
  similarityTopK: 3
});

// Retrieve without LLM synthesis
const nodes = await retriever.retrieve({
  query: "search query"
});

// Use with custom query engine
import { RetrieverQueryEngine } from '@llamaindex/core/query-engine';

const queryEngine = new RetrieverQueryEngine({
  retriever
});
```

### Metadata Filtering

```typescript
// Filter during query
const queryEngine = index.asQueryEngine({
  filters: {
    filters: [
      { key: "source", value: "document1.txt", operator: "==" },
      { key: "page", value: 5, operator: ">" }
    ]
  }
});

// Metadata must exist on nodes during index creation
const doc = new Document({
  text: content,
  metadata: {
    source: "document1.txt",
    page: 10,
    author: "John Doe"
  }
});
```

## Chat Engines

### Context Chat Engine

```typescript
import { VectorStoreIndex } from 'llamaindex';

const index = await VectorStoreIndex.fromDocuments(documents);

// Creates chat engine with memory
const chatEngine = index.asChatEngine({
  chatMode: "context",
  chatHistory: []  // Optional: pre-existing history
});

// Chat with memory
const response1 = await chatEngine.chat({
  message: "What is discussed in the document?"
});

const response2 = await chatEngine.chat({
  message: "Can you elaborate on that?"  // Uses previous context
});

// Reset conversation
chatEngine.reset();
```

### OpenAI Chat Engine (Agent-based)

```typescript
import { OpenAI } from '@llamaindex/openai';

const chatEngine = index.asChatEngine({
  chatMode: "openai",
  llm: new OpenAI({ model: "gpt-4" }),
  verbose: true  // See function calls
});

// Uses function calling to decide when to query index
const response = await chatEngine.chat({
  message: "Use the tool to answer: What is the budget?"
});
```

### Streaming Chat

```typescript
const chatEngine = index.asChatEngine();

const stream = await chatEngine.chat({
  message: "Explain this topic",
  stream: true
});

for await (const chunk of stream) {
  process.stdout.write(chunk.response);
}
```

### Chat History Management

```typescript
import type { ChatMessage } from '@llamaindex/core/llm/types';

// Manual history management
const chatHistory: ChatMessage[] = [
  { role: "user", content: "Previous question" },
  { role: "assistant", content: "Previous answer" }
];

const chatEngine = index.asChatEngine({
  chatHistory
});

// Add to history manually
chatHistory.push({
  role: "user",
  content: "New question"
});
```

## Agents

### OpenAI Agent

```typescript
import { OpenAIAgent, FunctionTool } from 'llamaindex';

// Define tools
const sumTool = FunctionTool.from(
  ({ a, b }: { a: number; b: number }) => a + b,
  {
    name: "sum",
    description: "Add two numbers together",
    parameters: {
      type: "object",
      properties: {
        a: { type: "number", description: "First number" },
        b: { type: "number", description: "Second number" }
      },
      required: ["a", "b"]
    }
  }
);

// Create agent
const agent = new OpenAIAgent({
  tools: [sumTool],
  verbose: true
});

// Chat with agent
const response = await agent.chat({
  message: "What is 5 + 7?"
});
```

### Query Engine Tool

```typescript
import { QueryEngineTool, VectorStoreIndex } from 'llamaindex';

const index = await VectorStoreIndex.fromDocuments(documents);

// Create query engine tool for agent
const queryTool = new QueryEngineTool({
  queryEngine: index.asQueryEngine(),
  metadata: {
    name: "document_search",
    description: "Search through technical documentation to find specific information"
  }
});

// Agent can now search documents
const agent = new OpenAIAgent({
  tools: [queryTool],
  verbose: true
});

const response = await agent.chat({
  message: "What does the documentation say about error handling?"
});
```

### Multi-Tool Agent

```typescript
import { OpenAIAgent, FunctionTool, QueryEngineTool } from 'llamaindex';

// Multiple indexes for different topics
const techDocsIndex = await VectorStoreIndex.fromDocuments(techDocs);
const marketingIndex = await VectorStoreIndex.fromDocuments(marketingDocs);

// Multiple tools
const techTool = new QueryEngineTool({
  queryEngine: techDocsIndex.asQueryEngine(),
  metadata: {
    name: "tech_docs",
    description: "Search technical documentation"
  }
});

const marketingTool = new QueryEngineTool({
  queryEngine: marketingIndex.asQueryEngine(),
  metadata: {
    name: "marketing_content",
    description: "Search marketing materials"
  }
});

const calculatorTool = FunctionTool.from(
  (expr: string) => eval(expr),
  {
    name: "calculator",
    description: "Evaluate mathematical expressions"
  }
);

// Agent selects appropriate tool
const agent = new OpenAIAgent({
  tools: [techTool, marketingTool, calculatorTool]
});
```

### ReAct Agent (Non-OpenAI)

```typescript
import { ReActAgent } from 'llamaindex';
import { Groq } from '@llamaindex/groq';

// Works with any LLM
const agent = new ReActAgent({
  tools: [queryTool],
  llm: new Groq({ model: "mixtral-8x7b-32768" })
});

const response = await agent.chat({
  message: "Find information about deployment"
});
```

## Workflows

### Basic Workflow

```typescript
import { Workflow, StartEvent, StopEvent } from '@llamaindex/workflow';

// Define events
class ProcessEvent extends Event {
  data: string;
}

// Create workflow
const workflow = new Workflow();

// Define handler
workflow.addStep(StartEvent, async (ctx, ev) => {
  const result = await someProcessing(ev.data);
  return new ProcessEvent({ data: result });
});

workflow.addStep(ProcessEvent, async (ctx, ev) => {
  const final = await finalProcessing(ev.data);
  return new StopEvent({ result: final });
});

// Run workflow
const result = await workflow.run({ data: "input" });
```

### RAG Workflow

```typescript
import { Workflow, StartEvent, StopEvent } from '@llamaindex/workflow';

class QueryEvent extends Event {
  query: string;
}

class RetrieveEvent extends Event {
  query: string;
  nodes: any[];
}

const ragWorkflow = new Workflow();

// Retrieve step
ragWorkflow.addStep(QueryEvent, async (ctx, ev) => {
  const retriever = ctx.data.retriever;
  const nodes = await retriever.retrieve({ query: ev.query });
  return new RetrieveEvent({ query: ev.query, nodes });
});

// Synthesize step
ragWorkflow.addStep(RetrieveEvent, async (ctx, ev) => {
  const llm = ctx.data.llm;
  const context = ev.nodes.map(n => n.text).join('\n');
  const response = await llm.complete({
    prompt: `Context: ${context}\n\nQuestion: ${ev.query}`
  });
  return new StopEvent({ result: response });
});
```

## LLM Integration

### OpenAI

```typescript
import { OpenAI } from '@llamaindex/openai';
import { Settings } from 'llamaindex';

// Set globally
Settings.llm = new OpenAI({
  model: "gpt-4o",
  temperature: 0.7,
  maxTokens: 1000,
  apiKey: process.env.OPENAI_API_KEY  // Optional, defaults to env
});

// Use locally
const llm = new OpenAI({
  model: "gpt-3.5-turbo",
  temperature: 0
});

// Direct completion
const response = await llm.complete({
  prompt: "Explain quantum computing"
});

// Chat completion
const chatResponse = await llm.chat({
  messages: [
    { role: "system", content: "You are a helpful assistant" },
    { role: "user", content: "Hello!" }
  ]
});
```

### Groq

```typescript
import { Groq } from '@llamaindex/groq';

const llm = new Groq({
  model: "mixtral-8x7b-32768",
  apiKey: process.env.GROQ_API_KEY
});

Settings.llm = llm;

// Supported models:
// - mixtral-8x7b-32768
// - llama3-70b-8192
// - llama3-8b-8192
// - gemma-7b-it
```

### Streaming

```typescript
const llm = new OpenAI({ model: "gpt-4" });

const stream = await llm.complete({
  prompt: "Write a long essay",
  stream: true
});

for await (const chunk of stream) {
  process.stdout.write(chunk.text);
}
```

## Settings & Configuration

### Global Settings

```typescript
import { Settings } from 'llamaindex';
import { OpenAI } from '@llamaindex/openai';
import { OpenAIEmbedding } from '@llamaindex/openai';

// Configure once, use everywhere
Settings.llm = new OpenAI({ model: "gpt-4" });
Settings.embedModel = new OpenAIEmbedding();
Settings.chunkSize = 512;
Settings.chunkOverlap = 50;

// All subsequent operations use these settings
const index = await VectorStoreIndex.fromDocuments(documents);
```

### Per-Index Configuration

```typescript
import { SentenceSplitter } from '@llamaindex/core/node-parser';
import { OpenAIEmbedding } from '@llamaindex/openai';

// Override global settings for specific index
const index = await VectorStoreIndex.fromDocuments(documents, {
  transformations: [
    new SentenceSplitter({ chunkSize: 256 })
  ],
  embedModel: new OpenAIEmbedding({ model: "text-embedding-3-large" })
});
```

### Callback Manager

```typescript
Settings.callbackManager.on("llm-start", (event) => {
  console.log("LLM started:", event.detail);
});

Settings.callbackManager.on("llm-end", (event) => {
  console.log("LLM completed:", event.detail);
});

Settings.callbackManager.on("llm-tool-call", (event) => {
  console.log("Tool called:", event.detail.payload);
});

Settings.callbackManager.on("llm-tool-result", (event) => {
  console.log("Tool result:", event.detail.payload);
});
```

## Cloudflare Workers / SSR Integration

### TypeScript Configuration

```typescript
// tsconfig.json
{
  "compilerOptions": {
    "moduleResolution": "bundler",  // or "nodenext"
    "target": "esnext",
    "module": "esnext",
    "lib": ["esnext"]
  }
}
```

### Vite Configuration (Astro)

```javascript
// astro.config.mjs
import { defineConfig } from 'astro/config';
import wasm from 'vite-plugin-wasm';

export default defineConfig({
  vite: {
    plugins: [wasm()],
    ssr: {
      external: ["tiktoken"]  // Externalize tiktoken for SSR
    }
  }
});
```

### Cloudflare Workers Setup

```typescript
// worker.ts
import { setEnvs } from '@llamaindex/env';

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    // Set environment variables
    setEnvs(env);
    
    // Import after setEnvs
    const { OpenAI } = await import('@llamaindex/openai');
    const { VectorStoreIndex } = await import('@llamaindex/core');
    
    // Your code here
    return new Response("Hello!");
  }
};
```

### Environment Variables (.dev.vars)

```bash
# .dev.vars (DO NOT COMMIT)
OPENAI_API_KEY=sk-...
GROQ_API_KEY=gsk_...
```

### Known Cloudflare Limitations

```typescript
// ❌ Not available in Cloudflare Workers
import { SimpleDirectoryReader } from 'llamaindex';  // Requires fs
import { PDFReader } from 'llamaindex';  // Requires fs

// ✅ Use these instead
import { Document } from '@llamaindex/core';
// Manually create documents from API/edge storage

// ❌ Large bundle size
import * as llamaindex from 'llamaindex';  // >1MB

// ✅ Import specific modules
import { VectorStoreIndex } from '@llamaindex/core';
import { OpenAI } from '@llamaindex/openai';
```

### Astro SSR Endpoint Example

```typescript
// src/pages/api/chat.ts
import type { APIRoute } from 'astro';
import { VectorStoreIndex, Document } from '@llamaindex/core';
import { OpenAI } from '@llamaindex/openai';

export const POST: APIRoute = async ({ request }) => {
  const { query, documents } = await request.json();
  
  // Create documents from request
  const docs = documents.map((d: any) => 
    new Document({ text: d.text, metadata: d.metadata })
  );
  
  // Build index
  const index = await VectorStoreIndex.fromDocuments(docs);
  const queryEngine = index.asQueryEngine();
  
  // Query
  const response = await queryEngine.query({ query });
  
  return new Response(JSON.stringify({
    response: response.toString(),
    sources: response.sourceNodes
  }));
};
```

## Common Patterns

### Persistent Index Pattern

```typescript
// Save index to storage (Node.js)
const index = await VectorStoreIndex.fromDocuments(documents);
await index.storageContext.persist('./storage');

// Load index
import { StorageContext, VectorStoreIndex } from 'llamaindex';

const storageContext = await StorageContext.fromDefaults({
  persistDir: './storage'
});

const index = await VectorStoreIndex.init({ storageContext });
```

### Hybrid Search Pattern

```typescript
// Combine vector search with keyword filtering
const retriever = index.asRetriever({
  similarityTopK: 10,
  filters: {
    filters: [
      { key: "category", value: "technical", operator: "==" }
    ]
  }
});

const nodes = await retriever.retrieve({ query: "deployment steps" });
```

### Multi-Index Pattern

```typescript
// Separate indexes for different data types
const codeIndex = await VectorStoreIndex.fromDocuments(codeDocs);
const docsIndex = await VectorStoreIndex.fromDocuments(docFiles);

// Create separate tools
const codeTool = new QueryEngineTool({
  queryEngine: codeIndex.asQueryEngine(),
  metadata: {
    name: "code_search",
    description: "Search code examples"
  }
});

const docsTool = new QueryEngineTool({
  queryEngine: docsIndex.asQueryEngine(),
  metadata: {
    name: "docs_search",
    description: "Search documentation"
  }
});

// Agent routes queries
const agent = new OpenAIAgent({ tools: [codeTool, docsTool] });
```

### Vue Composition API Pattern

```typescript
// composables/useLlamaIndex.ts
import { ref } from 'vue';
import { VectorStoreIndex, Document, OpenAI } from 'llamaindex';

export function useLlamaIndex() {
  const loading = ref(false);
  const response = ref('');
  const error = ref<Error | null>(null);
  
  const query = async (queryText: string, documents: any[]) => {
    loading.value = true;
    error.value = null;
    
    try {
      const docs = documents.map(d => 
        new Document({ text: d.text, metadata: d.metadata })
      );
      
      const index = await VectorStoreIndex.fromDocuments(docs);
      const queryEngine = index.asQueryEngine();
      const result = await queryEngine.query({ query: queryText });
      
      response.value = result.toString();
    } catch (e) {
      error.value = e as Error;
    } finally {
      loading.value = false;
    }
  };
  
  return { query, loading, response, error };
}
```

### Nanostores Integration Pattern

```typescript
// stores/ragStore.ts
import { atom, computed } from 'nanostores';
import { persistentAtom } from '@nanostores/persistent';

export const $documents = persistentAtom<any[]>('documents', [], {
  encode: JSON.stringify,
  decode: JSON.parse
});

export const $chatHistory = atom<Array<{role: string; content: string}>>([]);

export const $isIndexed = computed($documents, docs => docs.length > 0);

// Usage in component
import { useStore } from '@nanostores/vue';
import { $documents, $chatHistory } from '@/stores/ragStore';

export default {
  setup() {
    const documents = useStore($documents);
    const chatHistory = useStore($chatHistory);
    
    // Use in component
  }
};
```

## Edge Cases & Gotchas

### Token Limit Management

```typescript
// Problem: Input exceeds LLM context window
// Solution: Adjust chunk retrieval
const queryEngine = index.asQueryEngine({
  similarityTopK: 3  // Reduce if hitting token limits
});

// Or use tree summarization for large contexts
const queryEngine = index.asQueryEngine({
  responseSynthesizer: {
    responseMode: "tree_summarize"  // Hierarchical processing
  }
});
```

### Embedding Dimension Mismatch

```typescript
// Problem: Changing embedding model after index creation
// Solution: Recreate index with new embeddings

// ❌ Wrong
Settings.embedModel = new OpenAIEmbedding({ model: "text-embedding-3-large" });
const index = await loadExistingIndex();  // Uses old embeddings

// ✅ Correct
Settings.embedModel = new OpenAIEmbedding({ model: "text-embedding-3-large" });
const index = await VectorStoreIndex.fromDocuments(documents);  // Recompute
```

### Async/Await Required

```typescript
// ❌ All LlamaIndex operations are async-only
const index = VectorStoreIndex.fromDocuments(documents);  // Wrong

// ✅ Must use await
const index = await VectorStoreIndex.fromDocuments(documents);  // Correct
```

### Memory Leaks with Large Indexes

```typescript
// Problem: In-memory index grows unbounded
// Solution: Use external vector store or pagination

// For large datasets
import { PineconeVectorStore } from '@llamaindex/community';

const vectorStore = new PineconeVectorStore({ indexName: "my-index" });
const index = await VectorStoreIndex.init({ vectorStore });

// Or process in batches
for (const batch of documentBatches) {
  const batchDocs = batch.slice(0, 100);
  await index.insertNodes(await splitter.getNodesFromDocuments(batchDocs));
}
```

### Metadata Not Searchable

```typescript
// Problem: Metadata filtering requires exact setup
// ❌ Filter won't work
const doc = new Document({ text: "content" });
// (no metadata)

const queryEngine = index.asQueryEngine({
  filters: { filters: [{ key: "source", value: "file.txt" }] }
});

// ✅ Correct
const doc = new Document({ 
  text: "content",
  metadata: { source: "file.txt" }  // Must exist during indexing
});
```

### Node.js API in Edge

```typescript
// Problem: SimpleDirectoryReader uses fs (Node.js only)
// ❌ Fails in Cloudflare Workers
import { SimpleDirectoryReader } from 'llamaindex';
const docs = await reader.loadData('./data');

// ✅ Fetch from R2/KV or use API
const text = await fetch('https://api.example.com/docs').then(r => r.text());
const doc = new Document({ text });
```

### Streaming Not Supported Everywhere

```typescript
// Some query engines don't support streaming
try {
  const stream = await queryEngine.query({ query: "test", stream: true });
} catch (error) {
  // Fallback to non-streaming
  const response = await queryEngine.query({ query: "test" });
}
```

### Module Resolution Issues

```typescript
// Problem: TypeScript can't find types
// Solution: Update tsconfig.json

{
  "compilerOptions": {
    "moduleResolution": "bundler"  // Not "node"
  }
}

// Or use specific imports
import type { ChatMessage } from '@llamaindex/core/llm/types';
```

### Sentence Tokenizer Parsing Errors

```typescript
// Problem: Complex text with special characters breaks parser
// Error: Expected "http://", "https://"... but "}" found

// Solution: Pre-process text or use simpler splitter
const cleanText = text
  .replace(/\{[^}]*\}/g, '')  // Remove {...}
  .replace(/\[[^\]]*\]/g, '');  // Remove [...]

const doc = new Document({ text: cleanText });
```

## Performance Optimization

### Batch Processing

```typescript
// Insert documents in batches
const index = await VectorStoreIndex.fromDocuments(documents, {
  insertBatchSize: 100  // Default: 2048
});

// Reduce for memory-constrained environments
const index = await VectorStoreIndex.fromDocuments(documents, {
  insertBatchSize: 10
});
```

### Caching Strategy

```typescript
import { atom } from 'nanostores';

// Cache index in memory (Astro SSR)
const $indexCache = atom<VectorStoreIndex | null>(null);

export async function getOrCreateIndex(documents: Document[]) {
  let index = $indexCache.get();
  
  if (!index) {
    index = await VectorStoreIndex.fromDocuments(documents);
    $indexCache.set(index);
  }
  
  return index;
}
```

### Retrieval Optimization

```typescript
// Balance speed vs accuracy
const queryEngine = index.asQueryEngine({
  similarityTopK: 3,          // Fewer = faster
  responseSynthesizer: {
    responseMode: "compact"    // Faster than tree_summarize
  }
});
```

## Testing

```typescript
// tests/llamaindex.test.ts
import { describe, it, expect } from 'vitest';
import { Document, VectorStoreIndex } from 'llamaindex';

describe('LlamaIndex', () => {
  it('creates index from documents', async () => {
    const docs = [
      new Document({ text: "Test content" })
    ];
    
    const index = await VectorStoreIndex.fromDocuments(docs);
    expect(index).toBeDefined();
  });
  
  it('queries index', async () => {
    const docs = [
      new Document({ text: "Paris is the capital of France" })
    ];
    
    const index = await VectorStoreIndex.fromDocuments(docs);
    const queryEngine = index.asQueryEngine();
    
    const response = await queryEngine.query({
      query: "What is the capital of France?"
    });
    
    expect(response.toString()).toContain("Paris");
  });
});
```

## Type Safety

```typescript
// Leverage TypeScript for type-safe LlamaIndex usage

import type { ChatMessage } from '@llamaindex/core/llm/types';
import type { NodeWithScore } from '@llamaindex/core/schema';
import type { QueryEngine } from '@llamaindex/core/query-engine';

// Type chat history
const chatHistory: ChatMessage[] = [
  { role: "user", content: "Hello" },
  { role: "assistant", content: "Hi!" }
];

// Type query response
interface QueryResponse {
  response: string;
  sourceNodes: NodeWithScore[];
}

async function queryIndex(
  queryEngine: QueryEngine,
  query: string
): Promise<QueryResponse> {
  const result = await queryEngine.query({ query });
  return {
    response: result.toString(),
    sourceNodes: result.sourceNodes || []
  };
}
```

## Real-World Integration Example

```typescript
// src/lib/rag.ts
import { VectorStoreIndex, Document, OpenAI, Settings } from 'llamaindex';
import { persistentAtom } from '@nanostores/persistent';

// Configure
Settings.llm = new OpenAI({
  model: "gpt-4o-mini",
  apiKey: import.meta.env.OPENAI_API_KEY
});

// Store
export const $ragIndex = persistentAtom<any>('rag-index', null);

// Initialize
export async function initializeRAG(documents: any[]) {
  const docs = documents.map(d => 
    new Document({ text: d.content, metadata: d.metadata })
  );
  
  const index = await VectorStoreIndex.fromDocuments(docs);
  return index;
}

// Query
export async function queryRAG(index: VectorStoreIndex, query: string) {
  const queryEngine = index.asQueryEngine({
    similarityTopK: 5
  });
  
  const response = await queryEngine.query({ query });
  
  return {
    answer: response.toString(),
    sources: response.sourceNodes?.map(node => ({
      text: node.node.text,
      score: node.score,
      metadata: node.node.metadata
    })) || []
  };
}
```

```vue
<!-- src/components/RAGChat.vue -->
<script setup lang="ts">
import { ref } from 'vue';
import { queryRAG, initializeRAG } from '@/lib/rag';

const query = ref('');
const response = ref('');
const loading = ref(false);
const index = ref(null);

async function handleQuery() {
  if (!query.value || !index.value) return;
  
  loading.value = true;
  
  try {
    const result = await queryRAG(index.value, query.value);
    response.value = result.answer;
  } catch (error) {
    console.error('Query failed:', error);
  } finally {
    loading.value = false;
  }
}

async function loadDocuments() {
  const response = await fetch('/api/documents');
  const documents = await response.json();
  index.value = await initializeRAG(documents);
}

onMounted(() => {
  loadDocuments();
});
</script>

<template>
  <div class="rag-chat">
    <input 
      v-model="query" 
      @keyup.enter="handleQuery"
      :disabled="loading || !index"
      placeholder="Ask a question..."
    />
    <button 
      @click="handleQuery"
      :disabled="loading || !index"
    >
      {{ loading ? 'Processing...' : 'Ask' }}
    </button>
    
    <div v-if="response" class="response">
      {{ response }}
    </div>
  </div>
</template>
```

## Reference Links

- Official Docs: https://developers.llamaindex.ai/typescript/framework/
- GitHub: https://github.com/run-llama/LlamaIndexTS
- Discord: https://discord.gg/llamaindex
- API Reference: https://developers.llamaindex.ai/typescript/framework-api-reference/
- Workflows: https://developers.llamaindex.ai/typescript/framework/modules/data/workflows
