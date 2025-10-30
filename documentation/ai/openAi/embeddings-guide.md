# Vector Embeddings - OpenAI API Guide

Learn how to turn text into numbers, unlocking use cases like search, clustering, recommendations, and more.

## New Embedding Models

`text-embedding-3-small` and `text-embedding-3-large`, our newest and most performant embedding models, are now available. They feature lower costs, higher multilingual performance, and new parameters to control the overall size.

## What are Embeddings?

OpenAI's text embeddings measure the relatedness of text strings. Embeddings are commonly used for:

- **Search** - where results are ranked by relevance to a query string
- **Clustering** - where text strings are grouped by similarity
- **Recommendations** - where items with related text strings are recommended
- **Anomaly detection** - where outliers with little relatedness are identified
- **Diversity measurement** - where similarity distributions are analyzed
- **Classification** - where text strings are classified by their most similar label

An embedding is a vector (list) of floating point numbers. The distance between two vectors measures their relatedness. Small distances suggest high relatedness and large distances suggest low relatedness.

Visit the [pricing page](https://openai.com/api/pricing/) to learn about embeddings pricing. Requests are billed based on the number of tokens in the input.

## How to Get Embeddings

To get an embedding, send your text string to the embeddings API endpoint along with the embedding model name (e.g., `text-embedding-3-small`):

### Example: Getting Embeddings

**Python:**
```python
from openai import OpenAI
client = OpenAI()

response = client.embeddings.create(
    input="Your text string goes here",
    model="text-embedding-3-small"
)

print(response.data[0].embedding)
```

**JavaScript:**
```javascript
import OpenAI from "openai";
const openai = new OpenAI();

const embedding = await openai.embeddings.create({
  model: "text-embedding-3-small",
  input: "Your text string goes here",
  encoding_format: "float",
});

console.log(embedding);
```

**cURL:**
```bash
curl https://api.openai.com/v1/embeddings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
    "input": "Your text string goes here",
    "model": "text-embedding-3-small"
  }'
```

### Response Format

The response contains the embedding vector (list of floating point numbers) along with some additional metadata:

```json
{
  "object": "list",
  "data": [
    {
      "object": "embedding",
      "index": 0,
      "embedding": [
        -0.006929283495992422,
        -0.005336422007530928,
        -4.547132266452536e-05,
        -0.024047505110502243
      ]
    }
  ],
  "model": "text-embedding-3-small",
  "usage": {
    "prompt_tokens": 5,
    "total_tokens": 5
  }
}
```

By default, the length of the embedding vector is:
- **1536** for `text-embedding-3-small`
- **3072** for `text-embedding-3-large`

To reduce the embedding's dimensions without losing its concept-representing properties, pass in the `dimensions` parameter.

## Embedding Models

OpenAI offers two powerful third-generation embedding models (denoted by `-3` in the model ID).

Usage is priced per input token. Below is an example of pricing pages of text per US dollar (assuming ~800 tokens per page):

| Model | ~ Pages per dollar | Performance on MTEB eval | Max input |
| --- | --- | --- | --- |
| text-embedding-3-small | 62,500 | 62.3% | 8192 |
| text-embedding-3-large | 9,615 | 64.6% | 8192 |
| text-embedding-ada-002 | 12,500 | 61.0% | 8192 |

## Use Cases

Here we show some representative use cases, using the Amazon fine-food reviews dataset.

### Obtaining the Embeddings

The dataset contains a total of 568,454 food reviews left by Amazon users up to October 2012. We use a subset of the 1000 most recent reviews for illustration purposes.

**Get embeddings from dataset:**
```python
from openai import OpenAI
client = OpenAI()

def get_embedding(text, model="text-embedding-3-small"):
    text = text.replace("\n", " ")
    return client.embeddings.create(input = [text], model=model).data[0].embedding

df['ada_embedding'] = df.combined.apply(lambda x: get_embedding(x, model='text-embedding-3-small'))
df.to_csv('output/embedded_1k_reviews.csv', index=False)
```

**Load from saved file:**
```python
import pandas as pd
import numpy as np

df = pd.read_csv('output/embedded_1k_reviews.csv')
df['ada_embedding'] = df.ada_embedding.apply(eval).apply(np.array)
```

### Reducing Embedding Dimensions

Using larger embeddings generally costs more and consumes more compute, memory and storage than using smaller embeddings.

Both new embedding models were trained with a technique that allows developers to trade-off performance and cost. Specifically, developers can shorten embeddings (i.e. remove some numbers from the end of the sequence) without the embedding losing its concept-representing properties by passing in the `dimensions` API parameter.

**Using dimensions parameter (recommended):**
```python
response = client.embeddings.create(
    model="text-embedding-3-small",
    input="Testing 123",
    dimensions=256
)
```

**Manual normalization (when needed):**
```python
from openai import OpenAI
import numpy as np

client = OpenAI()

def normalize_l2(x):
    x = np.array(x)
    if x.ndim == 1:
        norm = np.linalg.norm(x)
        if norm == 0:
            return x
        return x / norm
    else:
        norm = np.linalg.norm(x, 2, axis=1, keepdims=True)
        return np.where(norm == 0, x, x / norm)

response = client.embeddings.create(
    model="text-embedding-3-small",
    input="Testing 123",
    encoding_format="float"
)

cut_dim = response.data[0].embedding[:256]
norm_dim = normalize_l2(cut_dim)

print(norm_dim)
```

### Text Search Using Embeddings

To retrieve the most relevant documents, use the cosine similarity between the embedding vectors of the query and each document, and return the highest scored documents.

```python
from openai import OpenAI
import numpy as np

client = OpenAI()

def cosine_similarity(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))

def search_reviews(df, product_description, n=3):
    embedding = client.embeddings.create(
        input=product_description,
        model='text-embedding-3-small'
    ).data[0].embedding

    df['similarities'] = df.ada_embedding.apply(
        lambda x: cosine_similarity(x, embedding)
    )
    res = df.sort_values('similarities', ascending=False).head(n)
    return res

res = search_reviews(df, 'delicious beans', n=3)
```

### Code Search Using Embeddings

Code search works similarly to embedding-based text search. We extract functions from Python files and index them using `text-embedding-3-small`.

```python
from openai import OpenAI

client = OpenAI()

def get_embedding(text, model='text-embedding-3-small'):
    return client.embeddings.create(input=[text], model=model).data[0].embedding

df['code_embedding'] = df['code'].apply(get_embedding)

def search_functions(df, code_query, n=3):
    embedding = get_embedding(code_query, model='text-embedding-3-small')
    df['similarities'] = df.code_embedding.apply(
        lambda x: cosine_similarity(x, embedding)
    )
    res = df.sort_values('similarities', ascending=False).head(n)
    return res

res = search_functions(df, 'Completions API tests', n=3)
```

### Recommendations Using Embeddings

Because shorter distances between embedding vectors represent greater similarity, embeddings can be useful for recommendation.

```python
def recommendations_from_strings(
    strings: List[str],
    index_of_source_string: int,
    model="text-embedding-3-small",
) -> List[int]:
    """Return nearest neighbors of a given string."""

    # get embeddings for all strings
    embeddings = [get_embedding(string, model=model) for string in strings]

    # get the embedding of the source string
    query_embedding = embeddings[index_of_source_string]

    # calculate distances
    distances = [
        cosine_similarity(query_embedding, emb)
        for emb in embeddings
    ]

    # get indices sorted by similarity
    indices = np.argsort(distances)[::-1]
    return indices
```

### Data Visualization in 2D

The size of the embeddings varies with the complexity of the underlying model. To visualize this high dimensional data, we use the t-SNE algorithm to transform the data into two dimensions.

```python
import pandas as pd
from sklearn.manifold import TSNE
import matplotlib.pyplot as plt
import matplotlib

df = pd.read_csv('output/embedded_1k_reviews.csv')
matrix = df.ada_embedding.apply(eval).to_list()

# Create a t-SNE model and transform the data
tsne = TSNE(n_components=2, perplexity=15, random_state=42,
            init='random', learning_rate=200)
vis_dims = tsne.fit_transform(matrix)

colors = ["red", "darkorange", "gold", "turquoise", "darkgreen"]
x = [x for x,y in vis_dims]
y = [y for x,y in vis_dims]
color_indices = df.Score.values - 1

colormap = matplotlib.colors.ListedColormap(colors)
plt.scatter(x, y, c=color_indices, cmap=colormap, alpha=0.3)
plt.title("Amazon ratings visualized in language using t-SNE")
```

### Embeddings as Text Feature Encoder for ML

An embedding can be used as a general free-text feature encoder within a machine learning model.

**Regression example:**
```python
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(
    list(df.ada_embedding.values),
    df.Score,
    test_size=0.2,
    random_state=42
)

rfr = RandomForestRegressor(n_estimators=100)
rfr.fit(X_train, y_train)
preds = rfr.predict(X_test)
```

**Classification example:**
```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, accuracy_score

clf = RandomForestClassifier(n_estimators=100)
clf.fit(X_train, y_train)
preds = clf.predict(X_test)
```

### Zero-shot Classification

We can use embeddings for zero-shot classification without any labeled training data. For each class, we embed the class name or a short description. To classify new text, we compare its embedding to all class embeddings and predict the class with the highest similarity.

```python
from openai import OpenAI
import numpy as np

client = OpenAI()

def cosine_similarity(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))

def get_embedding(text, model='text-embedding-3-small'):
    return client.embeddings.create(input=[text], model=model).data[0].embedding

# Prepare labels
labels = ['negative', 'positive']
label_embeddings = [get_embedding(label) for label in labels]

def label_score(review_embedding, label_embeddings):
    return (cosine_similarity(review_embedding, label_embeddings[1]) -
            cosine_similarity(review_embedding, label_embeddings[0]))

# Classify
review_embedding = get_embedding('Sample Review')
prediction = 'positive' if label_score(review_embedding, label_embeddings) > 0 else 'negative'
```

### Clustering

Clustering is one way of making sense of a large volume of textual data. Embeddings are useful for this task, as they provide semantically meaningful vector representations of each text.

```python
import numpy as np
from sklearn.cluster import KMeans

matrix = np.vstack(df.ada_embedding.values)
n_clusters = 4

kmeans = KMeans(n_clusters=n_clusters, init='k-means++', random_state=42)
kmeans.fit(matrix)
df['Cluster'] = kmeans.labels_
```

## FAQ

### How can I tell how many tokens a string has before I embed it?

In Python, you can split a string into tokens with OpenAI's tokenizer `tiktoken`.

```python
import tiktoken

def num_tokens_from_string(string: str, encoding_name: str) -> int:
    """Returns the number of tokens in a text string."""
    encoding = tiktoken.get_encoding(encoding_name)
    num_tokens = len(encoding.encode(string))
    return num_tokens

num_tokens_from_string("tiktoken is great!", "cl100k_base")
```

For third-generation embedding models like `text-embedding-3-small`, use the `cl100k_base` encoding.

### How can I retrieve K nearest embedding vectors quickly?

For searching over many vectors quickly, we recommend using a vector database. Examples of working with vector databases and the OpenAI API are available in the OpenAI Cookbook on GitHub.

### Which distance function should I use?

We recommend **cosine similarity**. The choice of distance function typically doesn't matter much.

OpenAI embeddings are normalized to length 1, which means that:
- Cosine similarity can be computed slightly faster using just a dot product
- Cosine similarity and Euclidean distance will result in identical rankings

### Can I share my embeddings online?

Yes, customers own their input and output from our models, including embeddings. You are responsible for ensuring that the content you input to our API does not violate any applicable law or our Terms of Use.

### Do V3 embedding models know about recent events?

No, the `text-embedding-3-large` and `text-embedding-3-small` models lack knowledge of events that occurred after September 2021. This is generally not as much of a limitation as it would be for text generation models but in certain edge cases it can reduce performance.
