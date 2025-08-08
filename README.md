# 🤖 AI-Resolver

**AI-Resolver** is a hybrid system that intelligently classifies and resolves technical issues using both traditional machine learning (offline mode) and fine-tuned large language models (online/server mode). It supports Windows and Linux troubleshooting using automated scripts.

---

## 📁 Project Structure

```
AI-Resolver/
├── App_/                  # Offline mode using SVM & TF-IDF
│   ├── app_.py            # CLI app to take queries and classify
│   ├── OflineController.py
│   ├── Model/             # Pre-trained ML models
│   └── powerSHellScripts/ # Bash and PowerShell scripts for fixes
├── Server/                # Online/server mode using LLM
│   ├── sever.py           # Server entry point
│   ├── controller.py
│   ├── Finetune(5)/       # LoRA fine-tuned adapter and tokenizer
│   └── requirments.txt    # Server dependencies
```

---

## 🧠 Features

- ✅ Query classification via SVM & TF-IDF (Offline)
- ✅ PowerShell/Bash scripts to auto-resolve issues
- ✅ Server mode using LLM fine-tuned with LoRA
- ✅ Supports Windows & Linux environments
- ✅ Easy to extend with more issue types

---

## 🚀 Getting Started

### 1. Install Requirements

For offline app:

```bash
pip install -r App_/guide.txt
```

For server:

```bash
pip install -r Server/requirments.txt
```

### 2. Run Offline App

```bash
python App_/app_.py
```

### 3. Run Server Mode (Online)

```bash
python Server/sever.py
```

---

## 🧪 Example Use Case

1. User enters query:  
   _"Outlook is not syncing on Windows 11"_

2. Offline:
   - Classifier maps to `Outlook app issue for window.ps1`
   - Runs the script directly

3. Server:
   - Sends query to fine-tuned LLM
   - Suggests appropriate fix or explanation

---

## 🔐 PowerShell/Bash Scripts

These scripts are used to automatically resolve issues:

- **Outlook app/web issues**
- **Office app/web issues**
- **Network connectivity fixes**

Separate versions are provided for **Windows (.ps1)** and **Linux (.sh)**.

---

## 🧩 Fine-Tuning Details

LoRA-based fine-tuning is located under:

```
Server/Finetune(5)/content/output/
```

Includes tokenizer files and adapter weights for efficient LLM inference.

---

## 📄 License

This project is licensed for educational and research purposes. Contact the author for commercial use.

---

## ✍️ Author

Built by Mohan – for intelligent, scriptable IT issue resolution.
