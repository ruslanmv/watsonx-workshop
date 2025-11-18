# Google Colab RAG Workshop Notebooks

This folder contains refactored versions of the Watsonx RAG workshop notebooks, optimized for **Google Colab**.

## 📚 Available Notebooks

### Lab 2.1: RAG with Watsonx, Chroma, and LangChain
**File:** `lab_2.1_watsonx_chroma_langchain_rag_colab.ipynb`

**What you'll learn:**
- Set up Watsonx.ai in Google Colab
- Create embeddings using Watsonx embedding models
- Build a vector database with Chroma
- Implement RAG using LangChain

**Prerequisites:**
- IBM Cloud API Key
- Watsonx Project ID

**Difficulty:** ⭐⭐ Easy

---

### Lab 2.2: RAG with Watsonx, Elasticsearch, and LangChain
**File:** `lab_2.2_watsonx_elasticsearch_langchain_rag_colab.ipynb`

**What you'll learn:**
- Connect to Elasticsearch Cloud from Colab
- Create embeddings using HuggingFace models
- Index documents into Elasticsearch
- Implement RAG with Watsonx and Elasticsearch

**Prerequisites:**
- IBM Cloud API Key
- Watsonx Space ID (not Project ID!)
- Elasticsearch Cloud endpoint ([Get free trial](https://cloud.elastic.co/))

**Difficulty:** ⭐⭐⭐ Intermediate

---

### Lab 2.2 Alternative: RAG with Watsonx and Elasticsearch Python SDK
**File:** `lab_2.2_alt_watsonx_elasticsearch_python_sdk_rag_colab.ipynb`

**What you'll learn:**
- Use Elasticsearch Python SDK directly (no LangChain)
- Perform k-NN semantic search
- Evaluate RAG results with ROUGE metrics
- Fine-tune retrieval parameters

**Prerequisites:**
- IBM Cloud API Key
- Watsonx Project ID
- Elasticsearch Cloud endpoint

**Difficulty:** ⭐⭐⭐ Intermediate

---

### Lab 3.1: AI Agent with Watsonx
**File:** `lab_3.1_agent_watsonx_colab.ipynb`

**What you'll learn:**
- Build an AI agent using Watsonx Granite models
- Implement tool selection via LLM planning
- Create custom tools (RAG service, calculator)
- Orchestrate multi-step agent workflows

**Prerequisites:**
- IBM Cloud API Key
- Watsonx Project ID

**Difficulty:** ⭐⭐⭐⭐ Advanced

---

## 🚀 Getting Started

### 1. Open in Google Colab

Click the "Open in Colab" button or upload the notebook to your Google Drive.

### 2. Get Your Credentials

#### IBM Cloud API Key
1. Go to [IBM Cloud API Keys](https://cloud.ibm.com/iam/apikeys)
2. Click "Create an IBM Cloud API key"
3. Copy and save the key securely

#### Watsonx Project ID
1. Go to [Watsonx.ai Projects](https://dataplatform.cloud.ibm.com/projects?context=wx)
2. Open your project
3. Go to **Manage** → **General** → **Details**
4. Copy the **Project ID**

#### Watsonx Space ID (for Lab 2.2)
1. Go to [Deployment Spaces](https://dataplatform.cloud.ibm.com/ml-runtime/spaces?context=wx)
2. Create a new space if you don't have one
3. Go to **Manage** → Copy the **Space GUID**

#### Elasticsearch Cloud (for Labs 2.2)
1. Sign up at [Elastic Cloud](https://cloud.elastic.co/)
2. Create a deployment (14-day free trial available)
3. Copy:
   - Cloud ID or Endpoint URL
   - Username (usually `elastic`)
   - Password

### 3. Run the Notebook

Follow the step-by-step instructions in each notebook. All dependencies will be installed automatically!

---

## 🔧 Key Differences from Local Versions

These Colab versions include:

✅ **Automatic dependency installation** - No manual `pip install` needed
✅ **Secure credential input** - Uses `getpass` for API keys
✅ **Remote data loading** - Downloads datasets via `wget`
✅ **Cloud-based Elasticsearch** - Connects to Elastic Cloud instead of local Docker
✅ **Mock services where needed** - RAG API calls use mock data when endpoints aren't available
✅ **Simplified setup** - No Docker, no `.env` files, no local infrastructure

---

## 📝 Workshop Flow

**Recommended order:**

1. **Start with Lab 2.1** (Chroma) - Easiest setup, no external services needed
2. **Try Lab 2.2** (Elasticsearch + LangChain) - Requires Elastic Cloud
3. **Explore Lab 2.2 Alternative** - Learn the low-level Elasticsearch SDK
4. **Finish with Lab 3.1** (Agent) - Most advanced topic

---

## 🆘 Troubleshooting

### "Failed to connect to Elasticsearch"
- Make sure your Elasticsearch Cloud deployment is running
- Check that the hostname, port, and credentials are correct
- For Elastic Cloud, use port `9243` (HTTPS)
- Some free trial deployments may have IP restrictions

### "API Key authentication failed"
- Verify your IBM Cloud API Key is correct
- Ensure you're using a **Project ID** (not Space ID) for Labs 2.1 and 3.1
- Ensure you're using a **Space ID** (not Project ID) for Lab 2.2

### "Out of memory" in Colab
- Restart the runtime: **Runtime** → **Restart runtime**
- For large datasets, reduce the number of documents (e.g., `nrows=500` instead of 1000)

### SSL Certificate errors
- For Elasticsearch, the notebooks will attempt to connect without SSL fingerprint if it can't be retrieved
- This is acceptable for development/learning, but not recommended for production

---

## 🌟 Next Steps After the Workshop

1. **Deploy your RAG system** - See the original notebooks for AI service deployment code
2. **Try different models** - Experiment with other Granite models from Watsonx
3. **Use your own data** - Replace the example datasets with your documents
4. **Build a chatbot** - Add a simple web UI using Gradio or Streamlit
5. **Optimize performance** - Fine-tune embedding models, adjust retrieval parameters

---

## 📚 Additional Resources

- [Watsonx.ai Documentation](https://ibm.github.io/watsonx-ai-python-sdk/samples.html)
- [LangChain Documentation](https://python.langchain.com/)
- [Elasticsearch Documentation](https://www.elastic.co/guide/index.html)
- [Chroma Documentation](https://docs.trychroma.com/)
- [RAG Best Practices](https://www.anthropic.com/index/contextual-retrieval)

---

## 💡 Tips for Success

- 📌 **Save your credentials securely** - Don't hardcode API keys in notebooks
- 🔄 **Restart runtime if needed** - Colab sessions timeout after inactivity
- 📊 **Monitor your usage** - Free Colab has compute limits
- 🧪 **Experiment freely** - Try different parameters, models, and datasets
- 💬 **Join the community** - Share your results and ask questions!

---

## 📄 License

Copyright © 2024 IBM. These notebooks and their source code are released under the terms of the MIT License.

---

**Happy Learning! 🎉**

If you encounter any issues or have questions, please refer to the main workshop documentation or reach out to the workshop instructors.
