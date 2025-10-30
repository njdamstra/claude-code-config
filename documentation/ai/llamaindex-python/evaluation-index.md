[Skip to content](https://developers.llamaindex.ai/python/framework-api-reference/evaluation#llama_index.core.evaluation.BaseEvaluator)

# Index

Evaluation modules.

## BaseEvaluator [\\#](https://developers.llamaindex.ai/python/framework-api-reference/evaluation\#llama_index.core.evaluation.BaseEvaluator "Permanent link")

Bases: `PromptMixin`

Base Evaluator class.

Source code in `.build/python/llama-index-core/llama_index/core/evaluation/base.py`

|     |     |
| --- | --- |
| ```<br> 46<br> 47<br> 48<br> 49<br> 50<br> 51<br> 52<br> 53<br> 54<br> 55<br> 56<br> 57<br> 58<br> 59<br> 60<br> 61<br> 62<br> 63<br> 64<br> 65<br> 66<br> 67<br> 68<br> 69<br> 70<br> 71<br> 72<br> 73<br> 74<br> 75<br> 76<br> 77<br> 78<br> 79<br> 80<br> 81<br> 82<br> 83<br> 84<br> 85<br> 86<br> 87<br> 88<br> 89<br> 90<br> 91<br> 92<br> 93<br> 94<br> 95<br> 96<br> 97<br> 98<br> 99<br>100<br>101<br>102<br>103<br>104<br>105<br>106<br>107<br>108<br>109<br>110<br>111<br>112<br>113<br>114<br>115<br>116<br>117<br>118<br>119<br>120<br>121<br>122<br>123<br>124<br>125<br>126<br>127<br>128<br>129<br>130<br>131<br>132<br>133<br>134<br>135<br>``` | ```<br>class BaseEvaluator(PromptMixin):<br>    """Base Evaluator class."""<br>    def _get_prompt_modules(self) -> PromptMixinType:<br>        """Get prompt modules."""<br>        return {}<br>    def evaluate(<br>        self,<br>        query: Optional[str] = None,<br>        response: Optional[str] = None,<br>        contexts: Optional[Sequence[str]] = None,<br>        **kwargs: Any,<br>    ) -> EvaluationResult:<br>        """<br>        Run evaluation with query string, retrieved contexts,<br>        and generated response string.<br>        Subclasses can override this method to provide custom evaluation logic and<br>        take in additional arguments.<br>        """<br>        return asyncio_run(<br>            self.aevaluate(<br>                query=query,<br>                response=response,<br>                contexts=contexts,<br>                **kwargs,<br>            )<br>        )<br>    @abstractmethod<br>    async def aevaluate(<br>        self,<br>        query: Optional[str] = None,<br>        response: Optional[str] = None,<br>        contexts: Optional[Sequence[str]] = None,<br>        **kwargs: Any,<br>    ) -> EvaluationResult:<br>        """<br>        Run evaluation with query string, retrieved contexts,<br>        and generated response string.<br>        Subclasses can override this method to provide custom evaluation logic and<br>        take in additional arguments.<br>        """<br>        raise NotImplementedError<br>    def evaluate_response(<br>        self,<br>        query: Optional[str] = None,<br>        response: Optional[Response] = None,<br>        **kwargs: Any,<br>    ) -> EvaluationResult:<br>        """<br>        Run evaluation with query string and generated Response object.<br>        Subclasses can override this method to provide custom evaluation logic and<br>        take in additional arguments.<br>        """<br>        response_str: Optional[str] = None<br>        contexts: Optional[Sequence[str]] = None<br>        if response is not None:<br>            response_str = response.response<br>            contexts = [node.get_content() for node in response.source_nodes]<br>        return self.evaluate(<br>            query=query, response=response_str, contexts=contexts, **kwargs<br>        )<br>    async def aevaluate_response(<br>        self,<br>        query: Optional[str] = None,<br>        response: Optional[Response] = None,<br>        **kwargs: Any,<br>    ) -> EvaluationResult:<br>        """<br>        Run evaluation with query string and generated Response object.<br>        Subclasses can override this method to provide custom evaluation logic and<br>        take in additional arguments.<br>        """<br>        response_str: Optional[str] = None<br>        contexts: Optional[Sequence[str]] = None<br>        if response is not None:<br>            response_str = response.response<br>            contexts = [node.get_content() for node in response.source_nodes]<br>        return await self.aevaluate(<br>            query=query, response=response_str, contexts=contexts, **kwargs<br>        )<br>``` |

### evaluate [\\#](https://developers.llamaindex.ai/python/framework-api-reference/evaluation\#llama_index.core.evaluation.BaseEvaluator.evaluate "Permanent link")

```
evaluate(
    query: Optional[str] = None,
    response: Optional[str] = None,
    contexts: Optional[Sequence[str]] = None,
    **kwargs: Any
) -> [EvaluationResult](https://developers.llamaindex.ai/python/framework-api-reference/evaluation#llama_index.core.evaluation.EvaluationResult "EvaluationResult (llama_index.core.evaluation.base.EvaluationResult)")

```

Run evaluation with query string, retrieved contexts,
and generated response string.

Subclasses can override this method to provide custom evaluation logic and
take in additional arguments.

Source code in `.build/python/llama-index-core/llama_index/core/evaluation/base.py`

|     |     |
| --- | --- |
| ```<br>53<br>54<br>55<br>56<br>57<br>58<br>59<br>60<br>61<br>62<br>63<br>64<br>65<br>66<br>67<br>68<br>69<br>70<br>71<br>72<br>73<br>74<br>``` | ```<br>def evaluate(<br>    self,<br>    query: Optional[str] = None,<br>    response: Optional[str] = None,<br>    contexts: Optional[Sequence[str]] = None,<br>    **kwargs: Any,<br>) -> EvaluationResult:<br>    """<br>    Run evaluation with query string, retrieved contexts,<br>    and generated response string.<br>    Subclasses can override this method to provide custom evaluation logic and<br>    take in additional arguments.<br>    """<br>    return asyncio_run(<br>        self.aevaluate(<br>            query=query,<br>            response=response,<br>            contexts=contexts,<br>            **kwargs,<br>        )<br>    )<br>``` |

### aevaluate`abstractmethod``async`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/evaluation\#llama_index.core.evaluation.BaseEvaluator.aevaluate "Permanent link")

```
aevaluate(
    query: Optional[str] = None,
    response: Optional[str] = None,
    contexts: Optional[Sequence[str]] = None,
    **kwargs: Any
) -> [EvaluationResult](https://developers.llamaindex.ai/python/framework-api-reference/evaluation#llama_index.core.evaluation.EvaluationResult "EvaluationResult (llama_index.core.evaluation.base.EvaluationResult)")

```

Run evaluation with query string, retrieved contexts,
and generated response string.

Subclasses can override this method to provide custom evaluation logic and
take in additional arguments.

Source code in `.build/python/llama-index-core/llama_index/core/evaluation/base.py`

(... content continues, truncated for brevity in this response due to length ...)

Back to top
