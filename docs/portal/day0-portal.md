# Day 0 Portal: Environment Setup

## 📋 Daily Overview

- **Duration**: 4 hours (flexible timing)
- **Format**: Self-paced setup + verification
- **Learning Objectives**:
  - Set up local development environment with Ollama
  - Configure IBM watsonx.ai cloud access
  - Verify both environments are working correctly
  - Prepare all prerequisites for the workshop
- **Prerequisites**: ✅ IBM Cloud account + Python 3.11+

---

## ☀️ Morning Session: Prerequisites & Setup (9:00 AM - 12:00 PM)

### Module 0.1: Prerequisites & Accounts (9:00 - 9:30, 30 min)

**Content**:

- 📖 [Read: Prerequisites & Accounts Guide](../tracks/day0-env/prereqs-and-accounts.md)
- 🎯 [Present: Prerequisites Slides (HTML)](../slides/day0-prereqs-and-accounts.html)

**Topics Covered**:

- Required accounts: IBM Cloud, watsonx.ai access
- Hardware requirements for local Ollama deployment
- Software prerequisites: Python 3.11+, pip, virtual environments
- API key generation and secure storage

**Instructor Notes**:

!!! tip "Pre-Workshop Communication"
    **Send 1 week before**: Link to prerequisites page with account creation instructions.
    **Send 2 days before**: Reminder to complete setup and generate API keys.
    **Morning of Day 0**: Quick poll - "Who has completed account setup?"

!!! warning "Common Blockers"
    - IBM Cloud approval can take 24-48 hours for some organizations
    - Corporate firewalls may block Ollama downloads
    - Python version conflicts (recommend pyenv or conda)

**Suggested Pacing**:

- 0-10 min: Account verification and troubleshooting
- 10-20 min: Hardware and software prerequisites review
- 20-30 min: API key generation walkthrough

---

### Module 0.2: Setup simple-ollama-environment (9:30 - 10:30, 60 min)

**Content**:

- 📖 [Read: Ollama Setup Guide](../tracks/day0-env/setup-simple-ollama-environment.md)
- 🎯 [Present: Ollama Setup Slides (HTML)](../slides/day0-setup-simple-ollama-environment.html)

**Topics Covered**:

- Installing Ollama on macOS, Linux, and Windows
- Downloading and running your first model (llama2:7b)
- Understanding local model storage and management
- Basic Ollama CLI commands

**Instructor Notes**:

!!! tip "Live Demo"
    **Installation** (10 min):
    ```bash
    # macOS/Linux
    curl -fsSL https://ollama.ai/install.sh | sh

    # Verify installation
    ollama --version
    ```

    **First Model** (5 min):
    ```bash
    # Pull model (this takes time!)
    ollama pull llama2:7b

    # Test run
    ollama run llama2:7b "Hello, world!"
    ```

!!! warning "Download Time Alert"
    llama2:7b is ~4GB. On slow connections, this can take 15-30 minutes.
    **Workaround**: Pre-download during break or have students start early.

**Success Criteria**:

- [ ] Ollama installed and running (`ollama --version` works)
- [ ] llama2:7b model downloaded successfully
- [ ] Test prompt returns valid response
- [ ] Ollama service starts on boot (optional but recommended)

☕ **Break**: 10:30 - 10:45 (15 min)

---

### Module 0.3: Setup simple-watsonx-environment (10:45 - 11:45, 60 min)

**Content**:

- 📖 [Read: watsonx Setup Guide](../tracks/day0-env/setup-simple-watsonx-enviroment.md)
- 🎯 [Present: watsonx Setup Slides (HTML)](../slides/day0-setup-simple-watsonx-environment.html)

**Topics Covered**:

- Creating watsonx.ai project in IBM Cloud
- Generating API keys and project IDs
- Installing IBM watsonx Python SDK
- Configuring `.env` file with credentials

**Instructor Notes**:

!!! tip "Environment Configuration"
    **Create `.env` template**:
    ```bash
    # watsonx.ai credentials
    WATSONX_API_KEY=your_api_key_here
    WATSONX_PROJECT_ID=your_project_id_here
    WATSONX_URL=https://us-south.ml.cloud.ibm.com
    ```

    **Security reminder**: Add `.env` to `.gitignore` immediately!

!!! example "Common Mistake"
    Students often confuse:
    - **API Key** (starts with `apikey-...`)
    - **Project ID** (UUID format)
    - **Space ID** (different from project ID)

    **Quick Check**: Show where to find each in IBM Cloud console.

**Success Criteria**:

- [ ] watsonx.ai project created in IBM Cloud
- [ ] API key generated and stored securely
- [ ] Project ID copied correctly
- [ ] `.env` file created with valid credentials
- [ ] `ibm-watsonx-ai` Python package installed

---

### Module 0.4: Verify Both Environments (11:45 - 12:00, 15 min)

**Content**:

- 📖 [Read: Verification Guide](../tracks/day0-env/verify-environments.md)
- 🎯 [Present: Verification Slides (HTML)](../slides/day0-verify-environments.html)

**Topics Covered**:

- Running verification scripts for Ollama
- Testing watsonx.ai API connectivity
- Troubleshooting common connection issues
- Confirming readiness for Day 1

**Instructor Notes**:

!!! tip "Verification Checklist"
    **Ollama Test**:
    ```bash
    # Should return model response
    curl http://localhost:11434/api/generate -d '{
      "model": "llama2:7b",
      "prompt": "Hello!",
      "stream": false
    }'
    ```

    **watsonx.ai Test**:
    ```python
    from ibm_watsonx_ai import Credentials, APIClient
    from dotenv import load_dotenv
    import os

    load_dotenv()
    credentials = Credentials(
        api_key=os.getenv("WATSONX_API_KEY"),
        url=os.getenv("WATSONX_URL")
    )
    client = APIClient(credentials)
    print("✅ watsonx.ai connection successful!")
    ```

**Success Criteria**:

- [ ] Ollama responds to curl test with JSON
- [ ] watsonx.ai Python client connects without errors
- [ ] Both environments return valid responses
- [ ] No authentication or network errors

🍴 **Lunch Break**: 12:00 - 1:00 PM (60 min)

---

## 🔬 Afternoon Session: Troubleshooting & Q&A (1:00 PM - 3:00 PM)

### Open Lab: Troubleshooting Session (1:00 - 2:30, 90 min)

**Format**: Instructor circulates to help students resolve any remaining issues.

**Common Issues to Address**:

<div class="grid cards" markdown>

-   :material-alert-circle: __Ollama Issues__

    ---

    - Service won't start
    - Model download fails
    - Port 11434 already in use
    - Slow inference on CPU

    [:octicons-arrow-right-16: Troubleshooting Guide](../tracks/day0-env/setup-simple-ollama-environment.md#troubleshooting)

-   :material-cloud-alert: __watsonx.ai Issues__

    ---

    - API authentication fails
    - Invalid project ID
    - Rate limiting errors
    - SDK version conflicts

    [:octicons-arrow-right-16: Troubleshooting Guide](../tracks/day0-env/setup-simple-watsonx-enviroment.md#troubleshooting)

-   :material-network-off: __Network Issues__

    ---

    - Corporate firewall blocks
    - Proxy configuration needed
    - VPN conflicts
    - Timeout errors

    [:octicons-arrow-right-16: Network Setup](../tracks/day0-env/prereqs-and-accounts.md)

-   :material-python: __Python Environment__

    ---

    - Version conflicts
    - Virtual environment issues
    - Package installation errors
    - Path configuration

    [:octicons-arrow-right-16: Python Setup](../tracks/day0-env/prereqs-and-accounts.md)

</div>

**Instructor Activities**:

1. **Group Troubleshooting** (30 min): Address common issues with whole class
2. **Individual Support** (45 min): One-on-one help for unique problems
3. **Advanced Setup** (15 min): Optional GPU configuration, Docker setup

!!! tip "Success Metrics"
    **Target**: 95% of students with both environments working by end of Day 0.
    **Backup Plan**: Provide cloud-based development environment (e.g., Google Colab) for students who can't get local setup working.

---

### Wrap-Up & Day 1 Preview (2:30 - 3:00, 30 min)

**Discussion Prompts**:

- "What was the most challenging part of setup?"
- "Any questions about the environments before we start using them?"
- "What are you most excited to learn in the workshop?"

**Preview Tomorrow (Day 1)**:

- Today: Set up the tools
- Tomorrow: Use them to build LLM applications
- Focus: Understand how LLMs work and master prompting techniques

**Homework (Optional)**:

- [ ] Test Ollama with different models (mistral, codellama)
- [ ] Explore watsonx.ai documentation
- [ ] Read ahead: [Day 1 LLM Concepts](../tracks/day1-llm/llm-concepts.md)

---

## 📚 Quick Reference

### All Day 0 Materials

<div class="grid cards" markdown>

-   :material-book-open-page-variant: __Setup Guides__

    ---

    - [Prerequisites & Accounts](../tracks/day0-env/prereqs-and-accounts.md)
    - [Ollama Setup](../tracks/day0-env/setup-simple-ollama-environment.md)
    - [watsonx Setup](../tracks/day0-env/setup-simple-watsonx-enviroment.md)
    - [Verification](../tracks/day0-env/verify-environments.md)

-   :material-presentation: __Slides__

    ---

    - [Prerequisites Slides](../slides/day0-prereqs-and-accounts.html)
    - [Ollama Setup Slides](../slides/day0-setup-simple-ollama-environment.html)
    - [watsonx Setup Slides](../slides/day0-setup-simple-watsonx-environment.html)
    - [Verification Slides](../slides/day0-verify-environments.html)

-   :material-tools: __Troubleshooting__

    ---

    - [Common Issues FAQ](#troubleshooting)
    - [Network Configuration](../tracks/day0-env/prereqs-and-accounts.md#network-configuration)
    - [Python Environment Setup](../tracks/day0-env/prereqs-and-accounts.md#python-setup)

-   :material-check-all: __Verification Checklist__

    ---

    - [Environment Verification Script](../tracks/day0-env/verify-environments.md)
    - [Pre-Workshop Checklist](../tracks/day0-env/prereqs-and-accounts.md)

</div>

### Navigation

- [➡️ Next: Day 1 - LLMs & Prompting](day1-portal.md)
- [🏠 Workshop Home](../index.md)
- [📚 All Resources](../resources.md)

---

## 🎯 Learning Outcomes

By the end of Day 0, participants will be able to:

1. ✅ **Set up** and run Ollama locally with at least one language model
2. ✅ **Configure** IBM watsonx.ai access with valid API credentials
3. ✅ **Verify** both environments are working correctly
4. ✅ **Troubleshoot** common installation and configuration issues
5. ✅ **Understand** the differences between local and cloud LLM deployments

---

## 🔧 Troubleshooting

### Common Issues During Day 0

??? question "Ollama installation fails"
    **Symptoms**: Install script errors or `ollama: command not found`

    **Solutions by Platform**:

    **macOS**:
    ```bash
    # Try Homebrew instead
    brew install ollama
    ```

    **Linux**:
    ```bash
    # Check if systemd is running
    systemctl status ollama

    # Start service manually
    sudo systemctl start ollama
    ```

    **Windows**:
    - Download installer from [ollama.ai/download](https://ollama.ai/download)
    - Run as administrator
    - Add to PATH manually if needed

??? question "Model download is too slow or fails"
    **Symptoms**: Download stalls or times out

    **Solutions**:
    1. **Check connection**: `curl -I https://ollama.ai`
    2. **Resume download**: Ollama auto-resumes, just run `ollama pull` again
    3. **Use smaller model**: `ollama pull llama2:7b` (4GB) instead of 13b (8GB)
    4. **Corporate network**: Ask IT to whitelist `ollama.ai` and `githubusercontent.com`

??? question "watsonx.ai API returns 401 Unauthorized"
    **Symptoms**: `401 Unauthorized` or `Invalid API key`

    **Diagnostic Steps**:
    ```bash
    # 1. Check .env file exists and is readable
    cat .env | grep WATSONX_API_KEY

    # 2. Verify API key format (should start with "apikey-")
    # 3. Check project ID is a valid UUID
    # 4. Test with curl
    curl -X POST "https://us-south.ml.cloud.ibm.com/ml/v1/text/generation?version=2023-05-29" \
      -H "Authorization: Bearer YOUR_API_KEY" \
      -H "Content-Type: application/json"
    ```

    **Solutions**:
    - Regenerate API key in IBM Cloud console
    - Verify project ID matches your watsonx.ai project
    - Check for extra spaces or quotes in `.env` file

??? question "Port 11434 already in use"
    **Symptoms**: `bind: address already in use`

    **Solution**:
    ```bash
    # Find process using port 11434
    lsof -i :11434
    # or on Linux
    sudo netstat -tulpn | grep 11434

    # Kill the process
    kill -9 <PID>

    # Restart Ollama
    ollama serve
    ```

??? question "Python package installation fails"
    **Symptoms**: `pip install` errors, version conflicts

    **Solutions**:
    ```bash
    # 1. Verify Python version
    python --version  # Should be 3.11 or higher

    # 2. Update pip
    pip install --upgrade pip

    # 3. Use virtual environment
    python -m venv .venv
    source .venv/bin/activate  # Windows: .venv\Scripts\activate

    # 4. Install packages
    pip install ibm-watsonx-ai python-dotenv

    # 5. If still fails, use conda
    conda create -n watsonx python=3.11
    conda activate watsonx
    pip install ibm-watsonx-ai python-dotenv
    ```

---

## 📊 Instructor Notes

### Pre-Workshop Preparation

**1 Week Before**:
- Send prerequisites email with account creation links
- Create shared troubleshooting document (Google Doc or Slack channel)
- Test all setup steps on fresh machines (macOS, Linux, Windows)

**2 Days Before**:
- Reminder email to complete setup
- Share backup plan (cloud notebooks) for students with issues
- Prepare USB drives with Ollama models (for slow networks)

**Morning of Day 0**:
- Quick poll: "Who completed setup?"
- Identify students who need help immediately
- Form buddy pairs (experienced + beginner)

### Pacing Adjustments

**If Running Behind** (>30 min late):
- Skip slides, go straight to hands-on setup
- Use screen sharing for group troubleshooting
- Assign working environment verification as homework

**If Running Ahead** (>30 min early):
- Demo advanced Ollama features (model customization, Modelfile)
- Explore watsonx.ai UI and prompt lab
- Preview Day 1 content (LLM architecture basics)

### Success Criteria

**Minimum for Day 1 Readiness**:
- [x] 90%+ students have working Ollama OR watsonx.ai (at least one)
- [x] All students have valid watsonx.ai credentials
- [x] API connectivity verified for watsonx.ai
- [x] Python environment with required packages

**Ideal State**:
- [x] 95%+ students have BOTH environments working
- [x] All students completed verification scripts successfully
- [x] No outstanding authentication or network issues

---

## 📝 Daily Schedule (At-a-Glance)

```mermaid
gantt
    title Day 0: Environment Setup Schedule
    dateFormat HH:mm
    axisFormat %H:%M

    section Morning Setup
    Module 0.1: Prerequisites        :09:00, 30m
    Module 0.2: Ollama Setup         :09:30, 60m
    Break                            :10:30, 15m
    Module 0.3: watsonx Setup        :10:45, 60m
    Module 0.4: Verification         :11:45, 15m
    Lunch                            :12:00, 60m

    section Afternoon Support
    Open Lab: Troubleshooting        :13:00, 90m
    Wrap-up & Day 1 Preview          :14:30, 30m
```

---

## 💬 Common Student Questions

### Setup Questions

??? question "Q: Do I need a GPU for Ollama?"
    **Short Answer**: No, but it helps significantly.

    **Detailed**:
    - **CPU only**: Works, but inference is slower (5-10s per response)
    - **GPU (NVIDIA)**: 10-100x faster, recommended for development
    - **Apple Silicon (M1/M2/M3)**: Excellent performance with Metal

    **Recommendation**: Start with CPU, upgrade to GPU if needed.

??? question "Q: How much does watsonx.ai cost?"
    **Pricing Model**: Pay-per-token usage

    **Approximate Costs** (as of 2025):
    - **Input**: $0.0003 per 1K tokens (~750 words)
    - **Output**: $0.0012 per 1K tokens
    - **Example**: 1,000 Q&A calls (~500K tokens) ≈ $150-200

    **Free Tier**: IBM offers trial credits for workshops.

    [Detailed Pricing →](https://www.ibm.com/products/watsonx-ai/pricing)

??? question "Q: Can I use other LLM providers (OpenAI, Anthropic)?"
    **Short Answer**: Yes, but workshop focuses on Ollama + watsonx.ai.

    **Alternatives**:
    - **OpenAI**: Replace watsonx SDK with OpenAI SDK
    - **Anthropic Claude**: Similar API, different SDK
    - **Azure OpenAI**: Enterprise option with Microsoft integration

    **Note**: Code examples use watsonx.ai, you'll need to adapt.

### Technical Questions

??? question "Q: What if my company blocks Ollama downloads?"
    **Workarounds**:
    1. **USB Transfer**: Download model on personal machine, transfer via USB
    2. **Cloud Alternative**: Use watsonx.ai only, skip Ollama labs
    3. **Corporate Proxy**: Configure Ollama to use proxy:
    ```bash
    export HTTP_PROXY=http://proxy.company.com:8080
    export HTTPS_PROXY=http://proxy.company.com:8080
    ollama pull llama2:7b
    ```

??? question "Q: Can I use WSL (Windows Subsystem for Linux)?"
    **Answer**: Yes, but with caveats.

    **Setup**:
    ```bash
    # In WSL Ubuntu
    curl -fsSL https://ollama.ai/install.sh | sh

    # Start service
    ollama serve &
    ```

    **Limitations**:
    - No GPU acceleration in WSL1 (use WSL2)
    - Network port forwarding may be needed
    - Slower than native Linux

---

**Last Updated**: 2025-01-13 | **Estimated Setup Time**: 3-4 hours | **Success Rate**: Target 95% completion