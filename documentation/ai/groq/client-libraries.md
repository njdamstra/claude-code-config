[![Groq](https://console.groq.com/groq-logo.svg)](https://console.groq.com/home)

[Docs](https://console.groq.com/docs/overview) [Login](https://console.groq.com/home)

[Log In](https://console.groq.com/login)

# Groq Client Libraries

Groq provides both a Python and JavaScript/Typescript client library.

PythonJavaScript

## [Groq Python Library](https://console.groq.com/docs/libraries\#groq-python-library)

The [Groq Python library](https://pypi.org/project/groq/) provides convenient access to the Groq REST API from any Python 3.7+ application. The library includes type definitions for all request params and response fields, and offers both synchronous and asynchronous clients.

### [Installation](https://console.groq.com/docs/libraries\#installation)

shell

```
pip install groq
```

### [Usage](https://console.groq.com/docs/libraries\#usage)

Use the library and your secret key to run:

Python

```
1import os
2
3from groq import Groq
4
5client = Groq(
6    # This is the default and can be omitted
7    api_key=os.environ.get("GROQ_API_KEY"),
8)
9
10chat_completion = client.chat.completions.create(
11    messages=[\
12        {\
13            "role": "system",\
14            "content": "You are a helpful assistant."\
15        },\
16        {\
17            "role": "user",\
18            "content": "Explain the importance of fast language models",\
19        }\
20    ],
21    model="llama-3.3-70b-versatile",
22)
23
24print(chat_completion.choices[0].message.content)
```

While you can provide an `api_key` keyword argument, we recommend using [python-dotenv](https://github.com/theskumar/python-dotenv) to add `GROQ_API_KEY="My API Key"` to your `.env` file so that your API Key is not stored in source control.

The following response is generated:

JSON

```
{
  "id": "34a9110d-c39d-423b-9ab9-9c748747b204",
  "object": "chat.completion",
  "created": 1708045122,
  "model": "mixtral-8x7b-32768",
  "system_fingerprint": "fp_dbffcd8265",
  "choices": [\
    {\
      "index": 0,\
      "message": {\
        "role": "assistant",\
        "content": "Low latency Large Language Models (LLMs) are important in the field of artificial intelligence and natural language processing (NLP) for several reasons:\n\n1. Real-time applications: Low latency LLMs are essential for real-time applications such as chatbots, voice assistants, and real-time translation services. These applications require immediate responses, and high latency can lead to a poor user experience.\n\n2. Improved user experience: Low latency LLMs provide a more seamless and responsive user experience. Users are more likely to continue using a service that provides quick and accurate responses, leading to higher user engagement and satisfaction.\n\n3. Competitive advantage: In today's fast-paced digital world, businesses that can provide quick and accurate responses to customer inquiries have a competitive advantage. Low latency LLMs can help businesses respond to customer inquiries more quickly, potentially leading to increased sales and customer loyalty.\n\n4. Better decision-making: Low latency LLMs can provide real-time insights and recommendations, enabling businesses to make better decisions more quickly. This can be particularly important in industries such as finance, healthcare, and logistics, where quick decision-making can have a significant impact on business outcomes.\n\n5. Scalability: Low latency LLMs can handle a higher volume of requests, making them more scalable than high-latency models. This is particularly important for businesses that experience spikes in traffic or have a large user base.\n\nIn summary, low latency LLMs are essential for real-time applications, providing a better user experience, enabling quick decision-making, and improving scalability. As the demand for real-time NLP applications continues to grow, the importance of low latency LLMs will only become more critical."\
      },\
      "finish_reason": "stop",\
      "logprobs": null\
    }\
  ],
  "usage": {
    "prompt_tokens": 24,
    "completion_tokens": 377,
    "total_tokens": 401,
    "prompt_time": 0.009,
    "completion_time": 0.774,
    "total_time": 0.783
  },
  "x_groq": {
    "id": "req_01htzpsmfmew5b4rbmbjy2kv74"
  }
}
```

## [Groq Community Libraries](https://console.groq.com/docs/libraries\#groq-community-libraries)

Groq encourages our developer community to build on our SDK. If you would like your library added, please fill out this [form](https://docs.google.com/forms/d/e/1FAIpQLSfkg3rPUnmZcTwRAS-MsmVHULMtD2I8LwsKPEasuqSsLlF0yA/viewform?usp=sf_link).

Please note that Groq does not verify the security of these projects. **Use at your own risk.**

### [C\#](https://console.groq.com/docs/libraries\#c)

- [jgravelle.GroqAPILibrary](https://github.com/jgravelle/GroqApiLibrary) by [jgravelle](https://github.com/jgravelle)

### [Dart/Flutter](https://console.groq.com/docs/libraries\#dartflutter)

- [TAGonSoft.groq-dart](https://github.com/TAGonSoft/groq-dart) by [TAGonSoft](https://github.com/TAGonSoft)

### [PHP](https://console.groq.com/docs/libraries\#php)

- [lucianotonet.groq-php](https://github.com/lucianotonet/groq-php) by [lucianotonet](https://github.com/lucianotonet)

### [Ruby](https://console.groq.com/docs/libraries\#ruby)

- [drnic.groq-ruby](https://github.com/drnic/groq-ruby) by [drnic](https://github.com/drnic)

### Was this page helpful?

YesNoSuggest Edits

#### On this page

- [Groq Python Library](https://console.groq.com/docs/libraries#groq-python-library)
- [Groq Community Libraries](https://console.groq.com/docs/libraries#groq-community-libraries)

StripeM-Inner
