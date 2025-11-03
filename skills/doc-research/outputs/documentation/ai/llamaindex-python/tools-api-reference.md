[Skip to content](https://developers.llamaindex.ai/python/framework-api-reference/tools#llama_index.core.tools.types.AsyncBaseTool)

# Index

## AsyncBaseTool [\\#](https://developers.llamaindex.ai/python/framework-api-reference/tools\#llama_index.core.tools.types.AsyncBaseTool "Permanent link")

Bases: `[BaseTool](https://developers.llamaindex.ai/python/framework-api-reference/tools#llama_index.core.tools.types.BaseTool "BaseTool (llama_index.core.tools.types.BaseTool)")`

Base-level tool class that is backwards compatible with the old tool spec but also
supports async.

Source code in `.build/python/llama-index-core/llama_index/core/tools/types.py`

|     |     |
| --- | --- |
| ```<br>206<br>207<br>208<br>209<br>210<br>211<br>212<br>213<br>214<br>215<br>216<br>217<br>218<br>219<br>220<br>221<br>222<br>223<br>224<br>225<br>226<br>227<br>``` | ```<br>class AsyncBaseTool(BaseTool):<br>    """<br>    Base-level tool class that is backwards compatible with the old tool spec but also<br>    supports async.<br>    """<br>    def __call__(self, *args: Any, **kwargs: Any) -> ToolOutput:<br>        return self.call(*args, **kwargs)<br>    @abstractmethod<br>    def call(self, input: Any) -> ToolOutput:<br>        """<br>        This is the method that should be implemented by the tool developer.<br>        """<br>    @abstractmethod<br>    async def acall(self, input: Any) -> ToolOutput:<br>        """<br>        This is the async version of the call method.<br>        Should also be implemented by the tool developer as an<br>        async-compatible implementation.<br>        """<br>``` |

### call`abstractmethod`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/tools\#llama_index.core.tools.types.AsyncBaseTool.call "Permanent link")

```
call(input: Any) -> [ToolOutput](https://developers.llamaindex.ai/python/framework-api-reference/tools#llama_index.core.tools.types.ToolOutput "ToolOutput (llama_index.core.tools.types.ToolOutput)")

```

This is the method that should be implemented by the tool developer.

Source code in `.build/python/llama-index-core/llama_index/core/tools/types.py`

|     |     |
| --- | --- |
| ```<br>215<br>216<br>217<br>218<br>219<br>``` | ```<br>@abstractmethod<br>def call(self, input: Any) -> ToolOutput:<br>    """<br>    This is the method that should be implemented by the tool developer.<br>    """<br>``` |

### acall`abstractmethod``async`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/tools\#llama_index.core.tools.types.AsyncBaseTool.acall "Permanent link")

```
acall(input: Any) -> [ToolOutput](https://developers.llamaindex.ai/python/framework-api-reference/tools#llama_index.core.tools.types.ToolOutput "ToolOutput (llama_index.core.tools.types.ToolOutput)")

```

This is the async version of the call method.
Should also be implemented by the tool developer as an
async-compatible implementation.

Source code in `.build/python/llama-index-core/llama_index/core/tools/types.py`

|     |     |
| --- | --- |
| ```<br>221<br>222<br>223<br>224<br>225<br>226<br>227<br>``` | ```<br>@abstractmethod<br>async def acall(self, input: Any) -> ToolOutput:<br>    """<br>    This is the async version of the call method.<br>    Should also be implemented by the tool developer as an<br>    async-compatible implementation.<br>    """<br>``` |

## BaseToolAsyncAdapter [\\#](https://developers.llamaindex.ai/python/framework-api-reference/tools\#llama_index.core.tools.types.BaseToolAsyncAdapter "Permanent link")

Bases: `[AsyncBaseTool](https://developers.llamaindex.ai/python/framework-api-reference/tools#llama_index.core.tools.types.AsyncBaseTool "AsyncBaseTool (llama_index.core.tools.types.AsyncBaseTool)")`

Adapter class that allows a synchronous tool to be used as an async tool.

Source code in `.build/python/llama-index-core/llama_index/core/tools/types.py`

|     |     |
| --- | --- |
| ```<br>230<br>231<br>232<br>233<br>234<br>235<br>236<br>237<br>238<br>239<br>240<br>241<br>242<br>243<br>244<br>245<br>246<br>``` | ```<br>class BaseToolAsyncAdapter(AsyncBaseTool):<br>    """<br>    Adapter class that allows a synchronous tool to be used as an async tool.<br>    """<br>    def __init__(self, tool: BaseTool):<br>        self.base_tool = tool<br>    @property<br>    def metadata(self) -> ToolMetadata:<br>        return self.base_tool.metadata<br>    def call(self, input: Any) -> ToolOutput:<br>        return self.base_tool(input)<br>    async def acall(self, input: Any) -> ToolOutput:<br>        return await asyncio.to_thread(self.call, input)<br>``` |

## BaseTool [\\#](https://developers.llamaindex.ai/python/framework-api-reference/tools\#llama_index.core.tools.types.BaseTool "Permanent link")

Bases: `DispatcherSpanMixin`

Source code in `.build/python/llama-index-core/llama_index/core/tools/types.py`

|     |     |
| --- | --- |
| ```<br>145<br>146<br>147<br>148<br>149<br>150<br>151<br>152<br>153<br>154<br>155<br>156<br>157<br>158<br>159<br>160<br>161<br>162<br>163<br>164<br>165<br>166<br>167<br>168<br>169<br>170<br>171<br>172<br>173<br>174<br>175<br>176<br>177<br>178<br>179<br>180<br>181<br>182<br>183<br>184<br>185<br>186<br>187<br>188<br>189<br>190<br>191<br>192<br>193<br>194<br>195<br>196<br>197<br>198<br>199<br>200<br>201<br>202<br>203<br>``` | ```<br>class BaseTool(DispatcherSpanMixin):<br>    @property<br>    @abstractmethod<br>    def metadata(self) -> ToolMetadata:<br>        pass<br>    @abstractmethod<br>    def __call__(self, input: Any) -> ToolOutput:<br>        pass<br>    def _process_langchain_tool_kwargs(<br>        self,<br>        langchain_tool_kwargs: Any,<br>    ) -> Dict[str, Any]:<br>        """Process langchain tool kwargs."""<br>        if "name" not in langchain_tool_kwargs:<br>            langchain_tool_kwargs["name"] = self.metadata.name or ""<br>        if "description" not in langchain_tool_kwargs:<br>            langchain_tool_kwargs["description"] = self.metadata.description<br>        if "fn_schema" not in langchain_tool_kwargs:<br>            langchain_tool_kwargs["args_schema"] = self.metadata.fn_schema<br>        # Callback dont exist on langchain<br>        if "_callback" in langchain_tool_kwargs:<br>            del langchain_tool_kwargs["_callback"]<br>        if "_async_callback" in langchain_tool_kwargs:<br>            del langchain_tool_kwargs["_async_callback"]<br>        return langchain_tool_kwargs<br>    def to_langchain_tool(<br>        self,<br>        **langchain_tool_kwargs: Any,<br>    ) -> "Tool":<br>        """To langchain tool."""<br>        from llama_index.core.bridge.langchain import Tool<br>        langchain_tool_kwargs = self._process_langchain_tool_kwargs(<br>            langchain_tool_kwargs<br>        )<br>        return Tool.from_function(<br>            func=self.__call__,<br>            **langchain_tool_kwargs,<br>        )<br>    def to_langchain_structured_tool(<br>        self,<br>        **langchain_tool_kwargs: Any,<br>    ) -> "StructuredTool":<br>        """To langchain structured tool."""<br>        from llama_index.core.bridge.langchain import StructuredTool<br>        langchain_tool_kwargs = self._process_langchain_tool_kwargs(<br>            langchain_tool_kwargs<br>        )<br>        return StructuredTool.from_function(<br>            func=self.__call__,<br>            **langchain_tool_kwargs,<br>        )<br>``` |

### to\_langchain\_tool [\\#](https://developers.llamaindex.ai/python/framework-api-reference/tools\#llama_index.core.tools.types.BaseTool.to_langchain_tool "Permanent link")

```
to_langchain_tool(**langchain_tool_kwargs: Any) -> Tool

```

To langchain tool.

Source code in `.build/python/llama-index-core/llama_index/core/tools/types.py`

|     |     |
| --- | --- |
| ```<br>175<br>176<br>177<br>178<br>179<br>180<br>181<br>182<br>183<br>184<br>185<br>186<br>187<br>188<br>``` | ```<br>def to_langchain_tool(<br>    self,<br>    **langchain_tool_kwargs: Any,<br>) -> "Tool":<br>    """To langchain tool."""<br>    from llama_index.core.bridge.langchain import Tool<br>    langchain_tool_kwargs = self._process_langchain_tool_kwargs(<br>        langchain_tool_kwargs<br>    )<br>    return Tool.from_function(<br>        func=self.__call__,<br>        **langchain_tool_kwargs,<br>    )<br>``` |

### to\_langchain\_structured\_tool [\\#](https://developers.llamaindex.ai/python/framework-api-reference/tools\#llama_index.core.tools.types.BaseTool.to_langchain_structured_tool "Permanent link")

```
to_langchain_structured_tool(
    **langchain_tool_kwargs: Any,
) -> StructuredTool

```

To langchain structured tool.

Source code in `.build/python/llama-index-core/llama_index/core/tools/types.py`

|     |     |
| --- | --- |
| ```<br>190<br>191<br>192<br>193<br>194<br>195<br>196<br>197<br>198<br>199<br>200<br>201<br>202<br>203<br>``` | ```<br>def to_langchain_structured_tool(<br>    self,<br>    **langchain_tool_kwargs: Any,<br>) -> "StructuredTool":<br>    """To langchain structured tool."""<br>    from llama_index.core.bridge.langchain import StructuredTool<br>    langchain_tool_kwargs = self._process_langchain_tool_kwargs(<br>        langchain_tool_kwargs<br>    )<br>    return StructuredTool.from_function(<br>        func=self.__call__,<br>        **langchain_tool_kwargs,<br>    )<br>``` |

## ToolMetadata`dataclass`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/tools\#llama_index.core.tools.types.ToolMetadata "Permanent link")

Source code in `.build/python/llama-index-core/llama_index/core/tools/types.py`

|     |     |
| --- | --- |
| ```<br>22<br>23<br>24<br>25<br>26<br>27<br>28<br>29<br>30<br>31<br>32<br>33<br>34<br>35<br>36<br>37<br>38<br>39<br>40<br>41<br>42<br>43<br>44<br>45<br>46<br>47<br>48<br>49<br>50<br>51<br>52<br>53<br>54<br>55<br>56<br>57<br>58<br>59<br>60<br>61<br>62<br>63<br>64<br>65<br>66<br>67<br>68<br>69<br>70<br>71<br>72<br>73<br>74<br>75<br>76<br>77<br>78<br>79<br>80<br>81<br>82<br>83<br>84<br>85<br>86<br>87<br>88<br>89<br>90<br>``` | ```<br>@dataclass<br>class ToolMetadata:<br>    description: str<br>    name: Optional[str] = None<br>    fn_schema: Optional[Type[BaseModel]] = DefaultToolFnSchema<br>    return_direct: bool = False<br>    def get_parameters_dict(self) -> dict:<br>        if self.fn_schema is None:<br>            parameters = {<br>                "type": "object",<br>                "properties": {<br>                    "input": {"title": "input query string", "type": "string"},<br>                },<br>                "required": ["input"],<br>            }<br>        else:<br>            parameters = self.fn_schema.model_json_schema()<br>            parameters = {<br>                k: v<br>                for k, v in parameters.items()<br>                if k in ["type", "properties", "required", "definitions", "$defs"]<br>            }<br>        return parameters<br>    @property<br>    def fn_schema_str(self) -> str:<br>        """Get fn schema as string."""<br>        if self.fn_schema is None:<br>            raise ValueError("fn_schema is None.")<br>        parameters = self.get_parameters_dict()<br>        return json.dumps(parameters, ensure_ascii=False)<br>    def get_name(self) -> str:<br>        """Get name."""<br>        if self.name is None:<br>            raise ValueError("name is None.")<br>        return self.name<br>    @deprecated(<br>        "Deprecated in favor of `to_openai_tool`, which should be used instead."<br>    )<br>    def to_openai_function(self) -> Dict[str, Any]:<br>        """<br>        Deprecated and replaced by `to_openai_tool`.<br>        The name and arguments of a function that should be called, as generated by the<br>        model.<br>        """<br>        return {<br>            "name": self.name,<br>            "description": self.description,<br>            "parameters": self.get_parameters_dict(),<br>        }<br>    def to_openai_tool(self, skip_length_check: bool = False) -> Dict[str, Any]:<br>        """To OpenAI tool."""<br>        if not skip_length_check and len(self.description) > 1024:<br>            raise ValueError(<br>                "Tool description exceeds maximum length of 1024 characters. "<br>                "Please shorten your description or move it to the prompt."<br>            )<br>        return {<br>            "type": "function",<br>            "function": {<br>                "name": self.name,<br>                "description": self.description,<br>                "parameters": self.get_parameters_dict(),<br>            },<br>        }<br>``` |

### fn\_schema\_str`property`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/tools\#llama_index.core.tools.types.ToolMetadata.fn_schema_str "Permanent link")

```
fn_schema_str: str

```

Get fn schema as string.

### get\_name [\\#](https://developers.llamaindex.ai/python/framework-api-reference/tools\#llama_index.core.tools.types.ToolMetadata.get_name "Permanent link")

```
get_name() -> str

```

Get name.

Source code in `.build/python/llama-index-core/llama_index/core/tools/types.py`

|     |     |
| --- | --- |
| ```<br>55<br>56<br>57<br>58<br>59<br>``` | ```<br>def get_name(self) -> str:<br>    """Get name."""<br>    if self.name is None:<br>        raise ValueError("name is None.")<br>    return self.name<br>``` |

### to\_openai\_function [\\#](https://developers.llamaindex.ai/python/framework-api-reference/tools\#llama_index.core.tools.types.ToolMetadata.to_openai_function "Permanent link")

```
to_openai_function() -> Dict[str, Any]

```

Deprecated and replaced by `to_openai_tool`.
The name and arguments of a function that should be called, as generated by the
model.

Source code in `.build/python/llama-index-core/llama_index/core/tools/types.py`

|     |     |
| --- | --- |
| ```<br>61<br>62<br>63<br>64<br>65<br>66<br>67<br>68<br>69<br>70<br>71<br>72<br>73<br>74<br>``` | ```<br>@deprecated(<br>    "Deprecated in favor of `to_openai_tool`, which should be used instead."<br>)<br>def to_openai_function(self) -> Dict[str, Any]:<br>    """<br>    Deprecated and replaced by `to_openai_tool`.<br>    The name and arguments of a function that should be called, as generated by the<br>    model.<br>    """<br>    return {<br>        "name": self.name,<br>        "description": self.description,<br>        "parameters": self.get_parameters_dict(),<br>    }<br>``` |

### to\_openai\_tool [\\#](https://developers.llamaindex.ai/python/framework-api-reference/tools\#llama_index.core.tools.types.ToolMetadata.to_openai_tool "Permanent link")

```
to_openai_tool(
    skip_length_check: bool = False,
) -> Dict[str, Any]

```

To OpenAI tool.

Source code in `.build/python/llama-index-core/llama_index/core/tools/types.py`

|     |     |
| --- | --- |
| ```<br>76<br>77<br>78<br>79<br>80<br>81<br>82<br>83<br>84<br>85<br>86<br>87<br>88<br>89<br>90<br>``` | ```<br>def to_openai_tool(self, skip_length_check: bool = False) -> Dict[str, Any]:<br>    """To OpenAI tool."""<br>    if not skip_length_check and len(self.description) > 1024:<br>        raise ValueError(<br>            "Tool description exceeds maximum length of 1024 characters. "<br>            "Please shorten your description or move it to the prompt."<br>        )<br>    return {<br>        "type": "function",<br>        "function": {<br>            "name": self.name,<br>            "description": self.description,<br>            "parameters": self.get_parameters_dict(),<br>        },<br>    }<br>``` |

## ToolOutput [\\#](https://developers.llamaindex.ai/python/framework-api-reference/tools\#llama_index.core.tools.types.ToolOutput "Permanent link")

Bases: `BaseModel`

Tool output.

Source code in `.build/python/llama-index-core/llama_index/core/tools/types.py`

|     |     |
| --- | --- |
| ```<br> 93<br> 94<br> 95<br> 96<br> 97<br> 98<br> 99<br>100<br>101<br>102<br>103<br>104<br>105<br>106<br>107<br>108<br>109<br>110<br>111<br>112<br>113<br>114<br>115<br>116<br>117<br>118<br>119<br>120<br>121<br>122<br>123<br>124<br>125<br>126<br>127<br>128<br>129<br>130<br>131<br>132<br>133<br>134<br>135<br>136<br>137<br>138<br>139<br>140<br>141<br>142<br>``` | ```<br>class ToolOutput(BaseModel):<br>    """Tool output."""<br>    blocks: List[ContentBlock]<br>    tool_name: str<br>    raw_input: Dict[str, Any]<br>    raw_output: Any<br>    is_error: bool = False<br>    def __init__(<br>        self,<br>        tool_name: str,<br>        content: Optional[str] = None,<br>        blocks: Optional[List[ContentBlock]] = None,<br>        raw_input: Optional[Dict[str, Any]] = None,<br>        raw_output: Optional[Any] = None,<br>        is_error: bool = False,<br>    ):<br>        if content and blocks:<br>            raise ValueError("Cannot provide both content and blocks.")<br>        if content:<br>            blocks = [TextBlock(text=content)]<br>        elif blocks:<br>            pass<br>        else:<br>            blocks = []<br>        super().__init__(<br>            tool_name=tool_name,<br>            blocks=blocks,<br>            raw_input=raw_input,<br>            raw_output=raw_output,<br>            is_error=is_error,<br>        )<br>    @property<br>    def content(self) -> str:<br>        """Get the content of the tool output."""<br>        return "\n".join(<br>            [block.text for block in self.blocks if isinstance(block, TextBlock)]<br>        )<br>    @content.setter<br>    def content(self, content: str) -> None:<br>        """Set the content of the tool output."""<br>        self.blocks = [TextBlock(text=content)]<br>    def __str__(self) -> str:<br>        """String."""<br>        return self.content<br>``` |

### content`property``writable`[\\#](https://developers.llamaindex.ai/python/framework-api-reference/tools\#llama_index.core.tools.types.ToolOutput.content "Permanent link")

```
content: str

```

Get the content of the tool output.

Back to top
