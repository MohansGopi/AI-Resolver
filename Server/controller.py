from transformers import AutoTokenizer, AutoModelForCausalLM
from peft import PeftModel
import torch


# Load base model and tokenizer
base_model = "facebook/opt-350m"
lora_model_path = "./Finetune(5)/content/output/lora_adapter"
tokenizer_path = "./Finetune(5)/content/output/tokenizer"

# Load tokenizer
tokenizer = AutoTokenizer.from_pretrained(tokenizer_path)

# Load base and LoRA fine-tuned model
base = AutoModelForCausalLM.from_pretrained(base_model, torch_dtype=torch.float32)
model = PeftModel.from_pretrained(base, lora_model_path)

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = model.to(device)
model.eval()

history=[]
def generate_response(user_input, max_tokens=512):
    global history
    # Step 1: Add current user message to history
    if history and history[-1]['content'] in ['outLookFixApp','outLookFixWeb','officeFixWeb','officeFixApp','Hello! How can I help you today?']:
      history = []
    history.append({"role": "user", "content": user_input})

    # Step 2: Rebuild chat-style prompt
    prompt = ""

    print(history)
    for message in history:
        if message["role"] == "user":
            prompt += f"User: {message['content']}\n"
        elif message["role"] == "assistant":
            prompt += f"AI: {message['content']}\n"
    prompt += "AI:"

    # Step 3: Tokenize and generate
    inputs = tokenizer(prompt, return_tensors="pt", truncation=True, max_length=512)
    inputs.pop("token_type_ids", None)
    inputs = {k: v.to(device) for k, v in inputs.items()}

    with torch.no_grad():
        outputs = model.generate(
            **inputs,
            max_new_tokens=max_tokens,
            do_sample=True,
            temperature=0.7,
            top_p=0.9,
            pad_token_id=tokenizer.eos_token_id
        )

    decoded = tokenizer.decode(outputs[0], skip_special_tokens=True)

    # Step 4: Extract the assistant's response
    if "AI:" in decoded:
        reply = decoded.split("AI:")[-1].strip()
    else:
        reply = decoded.replace(prompt, "").strip()

    # Step 5: Add assistant response to history
    history.append({"role": "assistant", "content": reply})

    return reply


class AI:
    async def Online(self, query: str) -> str:
        # Simulate an AI response for the query
        question = query.lower().strip()
        response = generate_response(question)
        print("AI:", response)
        # In a real application, this would involve more complex logic or API calls
        return response
