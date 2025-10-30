[Skip to content](https://developers.llamaindex.ai/python/framework-api-reference/evaluation/faithfullness#llama_index.core.evaluation.FaithfulnessEvaluator)

# Faithfullness

Evaluation modules.

## FaithfulnessEvaluator [\#](https://developers.llamaindex.ai/python/framework-api-reference/evaluation/faithfullness\#llama_index.core.evaluation.FaithfulnessEvaluator "Permanent link")

Bases: `[BaseEvaluator](https://developers.llamaindex.ai/python/framework-api-reference/#llama_index.core.evaluation.BaseEvaluator "BaseEvaluator (llama_index.core.evaluation.base.BaseEvaluator)")`

Faithfulness evaluator.

Evaluates whether a response is faithful to the contexts
(i.e. whether the response is supported by the contexts or hallucinated.)

This evaluator only considers the response string and the list of context strings.

Parameters:

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| `raise_error(bool)` |  | Whether to raise an error when the response is invalid.<br>Defaults to False. | _required_ |
| `eval_template(Optional[Union[str,` | `BasePromptTemplate]]` | The template to use for evaluation. | _required_ |
| `refine_template(Optional[Union[str,` | `BasePromptTemplate]]` | The template to use for refining the evaluation. | _required_ |

Source code in `.build/python/llama-index-core/llama_index/core/evaluation/faithfulness.py`

|     |     |
| --- | --- |
| ```<br> 98<br> 99<br>100<br>101<br>102<br>103<br>104<br>105<br>106<br>107<br>108<br>109<br>110<br>111<br>112<br>113<br>114<br>115<br>116<br>117<br>118<br>119<br>120<br>121<br>122<br>123<br>124<br>125<br>126<br>127<br>128<br>129<br>130<br>131<br>132<br>133<br>134<br>135<br>136<br>137<br>138<br>139<br>140<br>141<br>142<br>143<br>144<br>145<br>146<br>147<br>148<br>149<br>150<br>151<br>152<br>153<br>154<br>155<br>156<br>157<br>158<br>159<br>160<br>161<br>162<br>163<br>164<br>165<br>166<br>167<br>168<br>169<br>170<br>171<br>172<br>173<br>174<br>175<br>176<br>177<br>178<br>179<br>180<br>181<br>182<br>183<br>184<br>185<br>186<br>187<br>188<br>189<br>190<br>191<br>192<br>193<br>194<br>195<br>196<br>197<br>198<br>199<br>200<br>201<br>``` | ```<br>class FaithfulnessEvaluator(BaseEvaluator):<br>    """<br>    Faithfulness evaluator.<br>    Evaluates whether a response is faithful to the contexts<br>    (i.e. whether the response is supported by the contexts or hallucinated.)<br>    This evaluator only considers the response string and the list of context strings.<br>    Args:<br>        raise_error(bool): Whether to raise an error when the response is invalid.<br>            Defaults to False.<br>        eval_template(Optional[Union[str, BasePromptTemplate]]):<br>            The template to use for evaluation.<br>        refine_template(Optional[Union[str, BasePromptTemplate]]):<br>            The template to use for refining the evaluation.<br>    """<br>    def __init__(<br>        self,<br>        llm: Optional[LLM] = None,<br>        raise_error: bool = False,<br>        eval_template: Optional[Union[str, BasePromptTemplate]] = None,<br>        refine_template: Optional[Union[str, BasePromptTemplate]] = None,<br>    ) -> None:<br>        """Init params."""<br>        self._llm = llm or Settings.llm<br>        self._raise_error = raise_error<br>        self._eval_template: BasePromptTemplate<br>        if isinstance(eval_template, str):<br>            self._eval_template = PromptTemplate(eval_template)<br>        if isinstance(eval_template, BasePromptTemplate):<br>            self._eval_template = eval_template<br>        else:<br>            model_name = self._llm.metadata.model_name<br>            self._eval_template = TEMPLATES_CATALOG.get(<br>                model_name, DEFAULT_EVAL_TEMPLATE<br>            )<br>        self._refine_template: BasePromptTemplate<br>        if isinstance(refine_template, str):<br>            self._refine_template = PromptTemplate(refine_template)<br>        else:<br>            self._refine_template = refine_template or DEFAULT_REFINE_TEMPLATE<br>    def _get_prompts(self) -> PromptDictType:<br>        """Get prompts."""<br>        return {<br>            "eval_template": self._eval_template,<br>            "refine_template": self._refine_template,<br>        }<br>    def _update_prompts(self, prompts: PromptDictType) -> None:<br>        """Update prompts."""<br>        if "eval_template" in prompts:<br>            self._eval_template = prompts["eval_template"]<br>        if "refine_template" in prompts:<br>            self._refine_template = prompts["refine_template"]<br>    async def aevaluate(<br>        self,<br>        query: str | None = None,<br>        response: str | None = None,<br>        contexts: Sequence[str] | None = None,<br>        sleep_time_in_seconds: int = 0,<br>        **kwargs: Any,<br>    ) -> EvaluationResult:<br>        """Evaluate whether the response is faithful to the contexts."""<br>        del kwargs  # Unused<br>        await asyncio.sleep(sleep_time_in_seconds)<br>        if contexts is None or response is None:<br>            raise ValueError("contexts and response must be provided")<br>        docs = [Document(text=context) for context in contexts]<br>        index = SummaryIndex.from_documents(docs)<br>        query_engine = index.as_query_engine(<br>            llm=self._llm,<br>            text_qa_template=self._eval_template,<br>            refine_template=self._refine_template,<br>        )<br>        response_obj = await query_engine.aquery(response)<br>        raw_response_txt = str(response_obj)<br>        if "yes" in raw_response_txt.lower():<br>            passing = True<br>        else:<br>            passing = False<br>            if self._raise_error:<br>                raise ValueError("The response is invalid")<br>        return EvaluationResult(<br>            query=query,<br>            response=response,<br>            contexts=contexts,<br>            passing=passing,<br>            score=1.0 if passing else 0.0,<br>            feedback=raw_response_txt,<br>        )<br>``` |

### aevaluate`async`[\#](https://developers.llamaindex.ai/python/framework-api-reference/evaluation/faithfullness\#llama_index.core.evaluation.FaithfulnessEvaluator.aevaluate "Permanent link")

```
aevaluate(
    query: str | None = None,
    response: str | None = None,
    contexts: Sequence[str] | None = None,
    sleep_time_in_seconds: int = 0,
    **kwargs: Any
) -> [EvaluationResult](https://developers.llamaindex.ai/python/framework-api-reference/#llama_index.core.evaluation.EvaluationResult "EvaluationResult (llama_index.core.evaluation.base.EvaluationResult)")

```

Evaluate whether the response is faithful to the contexts.

Source code in `.build/python/llama-index-core/llama_index/core/evaluation/faithfulness.py`

|     |     |
| --- | --- |
| ```<br>159<br>160<br>161<br>162<br>163<br>164<br>165<br>166<br>167<br>168<br>169<br>170<br>171<br>172<br>173<br>174<br>175<br>176<br>177<br>178<br>179<br>180<br>181<br>182<br>183<br>184<br>185<br>186<br>187<br>188<br>189<br>190<br>191<br>192<br>193<br>194<br>195<br>196<br>197<br>198<br>199<br>200<br>201<br>``` | ```<br>async def aevaluate(<br>    self,<br>    query: str | None = None,<br>    response: str | None = None,<br>    contexts: Sequence[str] | None = None,<br>    sleep_time_in_seconds: int = 0,<br>    **kwargs: Any,<br>) -> EvaluationResult:<br>    """Evaluate whether the response is faithful to the contexts."""<br>    del kwargs  # Unused<br>    await asyncio.sleep(sleep_time_in_seconds)<br>    if contexts is None or response is None:<br>        raise ValueError("contexts and response must be provided")<br>    docs = [Document(text=context) for context in contexts]<br>    index = SummaryIndex.from_documents(docs)<br>    query_engine = index.as_query_engine(<br>        llm=self._llm,<br>        text_qa_template=self._eval_template,<br>        refine_template=self._refine_template,<br>    )<br>    response_obj = await query_engine.aquery(response)<br>    raw_response_txt = str(response_obj)<br>    if "yes" in raw_response_txt.lower():<br>        passing = True<br>    else:<br>        passing = False<br>        if self._raise_error:<br>            raise ValueError("The response is invalid")<br>    return EvaluationResult(<br>        query=query,<br>        response=response,<br>        contexts=contexts,<br>        passing=passing,<br>        score=1.0 if passing else 0.0,<br>        feedback=raw_response_txt,<br>    )<br>``` |

Back to top
