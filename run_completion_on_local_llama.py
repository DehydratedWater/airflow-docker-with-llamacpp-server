from langchain.chat_models import ChatOpenAI

llm = ChatOpenAI(temperature=0.7,
                model="models/llama-2-7b.Q5_K_M.gguf", 
                openai_api_base="http://0.0.0.0:5555/v1", 
                openai_api_key="sx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                max_tokens=2000,
                model_kwargs={
                    "logit_bias": {},
                    # "stop": ["[/INST]"],
                    # "max_tokens": 3000
                },
                # logit_bias={},
                streaming=True,
                )

# print(llm.predict("The poem about cat: "))

for chunk in llm.stream("The short poem about cat: "):
    print(chunk.content, end="", flush=True)