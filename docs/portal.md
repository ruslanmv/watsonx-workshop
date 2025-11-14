---
title: Workshop Portal
description: Interactive presentation portal for the watsonx Workshop Series
hide:
  - navigation
  - toc
---

<style>
.portal-hero {
  text-align: center;
  padding: 3rem 1rem;
  background: linear-gradient(135deg, #0b62a3 0%, #1e88e5 100%);
  color: white;
  border-radius: 8px;
  margin-bottom: 2rem;
}

.portal-hero h1 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  font-weight: 700;
}

.portal-hero p {
  font-size: 1.2rem;
  opacity: 0.95;
  max-width: 700px;
  margin: 0 auto;
}

.day-section {
  margin: 3rem 0;
  padding: 2rem;
  background: var(--md-default-bg-color);
  border-radius: 8px;
  border: 1px solid var(--md-default-fg-color--lightest);
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.day-header {
  display: flex;
  align-items: center;
  margin-bottom: 1.5rem;
  padding-bottom: 1rem;
  border-bottom: 2px solid #0b62a3;
}

.day-number {
  font-size: 3rem;
  font-weight: 700;
  color: #0b62a3;
  margin-right: 1rem;
  line-height: 1;
}

.day-title {
  flex: 1;
}

.day-title h2 {
  margin: 0;
  font-size: 1.8rem;
  color: #0b62a3;
}

.day-title p {
  margin: 0.5rem 0 0 0;
  color: var(--md-default-fg-color--light);
  font-size: 0.95rem;
}

.presentation-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
  margin-top: 1.5rem;
}

.presentation-card {
  background: var(--md-code-bg-color);
  border: 1px solid var(--md-default-fg-color--lightest);
  border-radius: 8px;
  padding: 1.5rem;
  transition: all 0.3s ease;
  text-decoration: none;
  display: block;
  position: relative;
  overflow: hidden;
}

.presentation-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(11, 98, 163, 0.2);
  border-color: #0b62a3;
}

.presentation-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(180deg, #0b62a3 0%, #1e88e5 100%);
}

.presentation-icon {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  display: block;
}

.presentation-title {
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
  color: var(--md-default-fg-color);
}

.presentation-description {
  font-size: 0.9rem;
  color: var(--md-default-fg-color--light);
  margin-bottom: 1rem;
  line-height: 1.5;
}

.presentation-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.85rem;
  color: var(--md-default-fg-color--lighter);
}

.presentation-duration {
  display: flex;
  align-items: center;
  gap: 0.3rem;
}

.presentation-type {
  background: #0b62a3;
  color: white;
  padding: 0.2rem 0.6rem;
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: 600;
}

.portal-footer {
  text-align: center;
  margin-top: 3rem;
  padding: 2rem;
  border-top: 2px solid var(--md-default-fg-color--lightest);
}

.quick-links {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin: 2rem 0;
}

.quick-link-card {
  background: var(--md-code-bg-color);
  border: 1px solid var(--md-default-fg-color--lightest);
  border-radius: 8px;
  padding: 1.5rem;
  text-align: center;
  transition: all 0.3s ease;
}

.quick-link-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.15);
}

@media (max-width: 768px) {
  .portal-hero h1 {
    font-size: 2rem;
  }

  .presentation-grid {
    grid-template-columns: 1fr;
  }

  .day-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .day-number {
    margin-bottom: 0.5rem;
  }
}
</style>

<div class="portal-hero">
  <h1>🎓 watsonx Workshop Portal</h1>
  <p>Welcome to your comprehensive learning journey. Select any day below to access interactive presentations and workshop materials.</p>
</div>

!!! tip "How to Use This Portal"
    - **Click any presentation card** to open the interactive slide deck
    - **Use arrow keys** to navigate through slides
    - **Press 'S'** for speaker notes (instructors)
    - **Press 'F'** for full-screen mode
    - **Press 'Esc'** for slide overview
    - **Print to PDF** using your browser (Ctrl+P / Cmd+P)

---

## Quick Navigation

<div class="quick-links">
  <div class="quick-link-card">
    <h3>📚 Documentation</h3>
    <p>Detailed written guides</p>
    <a href="../" class="md-button md-button--primary">Browse Docs</a>
  </div>

  <div class="quick-link-card">
    <h3>🚀 Quick Start</h3>
    <p>Get started immediately</p>
    <a href="../tracks/day0-env/prereqs-and-accounts/" class="md-button md-button--primary">Setup Guide</a>
  </div>

  <div class="quick-link-card">
    <h3>💾 GitHub</h3>
    <p>Source code & examples</p>
    <a href="https://github.com/ruslanmv/watsonx-workshop" class="md-button md-button--primary" target="_blank">Repository</a>
  </div>

  <div class="quick-link-card">
    <h3>📖 Resources</h3>
    <p>Additional materials</p>
    <a href="../resources/" class="md-button md-button--primary">Learn More</a>
  </div>
</div>

---

<!-- DAY 0 -->
<div class="day-section">
  <div class="day-header">
    <div class="day-number">0</div>
    <div class="day-title">
      <h2>Environment Setup</h2>
      <p>Monday | Self-Paced | Foundational Setup</p>
    </div>
  </div>

  <p>Prepare your development environment with both local (Ollama) and cloud (watsonx) configurations. This day ensures you have everything needed for the workshop.</p>

  <div class="presentation-grid">
    <a href="../slides/day0-prereqs-and-accounts.html" class="presentation-card">
      <span class="presentation-icon">🔑</span>
      <div class="presentation-title">Prerequisites & Accounts</div>
      <div class="presentation-description">Required accounts, API keys, and software prerequisites for the workshop</div>
      <div class="presentation-meta">
        <span class="presentation-duration">⏱️ 20 min</span>
        <span class="presentation-type">SETUP</span>
      </div>
    </a>

    <a href="../slides/day0-setup-simple-ollama-environment.html" class="presentation-card">
      <span class="presentation-icon">🐋</span>
      <div class="presentation-title">Setup Ollama Environment</div>
      <div class="presentation-description">Local LLM environment with Docker and Ollama for offline experimentation</div>
      <div class="presentation-meta">
        <span class="presentation-duration">⏱️ 30 min</span>
        <span class="presentation-type">LAB</span>
      </div>
    </a>

    <a href="../slides/day0-setup-simple-watsonx-environment.html" class="presentation-card">
      <span class="presentation-icon">☁️</span>
      <div class="presentation-title">Setup watsonx Environment</div>
      <div class="presentation-description">IBM watsonx cloud configuration and API integration setup</div>
      <div class="presentation-meta">
        <span class="presentation-duration">⏱️ 30 min</span>
        <span class="presentation-type">LAB</span>
      </div>
    </a>

    <a href="../slides/day0-verify-environments.html" class="presentation-card">
      <span class="presentation-icon">✅</span>
      <div class="presentation-title">Verify Environments</div>
      <div class="presentation-description">Test both environments to ensure proper configuration</div>
      <div class="presentation-meta">
        <span class="presentation-duration">⏱️ 15 min</span>
        <span class="presentation-type">VALIDATION</span>
      </div>
    </a>
  </div>
</div>

<!-- DAY 1 -->
<div class="day-section">
  <div class="day-header">
    <div class="day-number">1</div>
    <div class="day-title">
      <h2>LLMs & Prompting</h2>
      <p>Tuesday | 6 Hours | Foundation Concepts</p>
    </div>
  </div>

  <p>Master the fundamentals of Large Language Models and develop effective prompting strategies. Learn through hands-on exercises in both Ollama and watsonx environments.</p>

  <div class="presentation-grid">
    <a href="../slides/day1-llm-concepts.html" class="presentation-card">
      <span class="presentation-icon">🧠</span>
      <div class="presentation-title">LLM Concepts & Architecture</div>
      <div class="presentation-description">Understanding transformers, attention mechanisms, and model architectures</div>
      <div class="presentation-meta">
        <span class="presentation-duration">⏱️ 90 min</span>
        <span class="presentation-type">THEORY</span>
      </div>
    </a>

    <a href="../slides/day1-prompt-patterns-theory.html" class="presentation-card">
      <span class="presentation-icon">📝</span>
      <div class="presentation-title">Prompt Patterns & Templates</div>
      <div class="presentation-description">Chain-of-thought, few-shot learning, and advanced prompting techniques</div>
      <div class="presentation-meta">
        <span class="presentation-duration">⏱️ 90 min</span>
        <span class="presentation-type">THEORY</span>
      </div>
    </a>

    <a href="../slides/day1-eval-safety-theory.html" class="presentation-card">
      <span class="presentation-icon">🛡️</span>
      <div class="presentation-title">Evaluation & Safety</div>
      <div class="presentation-description">Model evaluation metrics, safety considerations, and responsible AI</div>
      <div class="presentation-meta">
        <span class="presentation-duration">⏱️ 60 min</span>
        <span class="presentation-type">THEORY</span>
      </div>
    </a>

    <a href="../slides/day1-summary-and-schedule.html" class="presentation-card">
      <span class="presentation-icon">📋</span>
      <div class="presentation-title">Day 1 Summary</div>
      <div class="presentation-description">Recap of key concepts and preview of Day 2 RAG systems</div>
      <div class="presentation-meta">
        <span class="presentation-duration">⏱️ 30 min</span>
        <span class="presentation-type">RECAP</span>
      </div>
    </a>
  </div>

  <div style="margin-top: 1.5rem; padding: 1rem; background: var(--md-code-bg-color); border-left: 4px solid #0b62a3; border-radius: 4px;">
    <strong>📖 Lab Materials:</strong> Access hands-on exercises in the
    <a href="../tracks/day1-llm/lab-1-quickstart-two-envs/">documentation section</a>
  </div>
</div>

<!-- DAY 2 -->
<div class="day-section">
  <div class="day-header">
    <div class="day-number">2</div>
    <div class="day-title">
      <h2>Retrieval-Augmented Generation (RAG)</h2>
      <p>Wednesday | 6 Hours | Production Systems</p>
    </div>
  </div>

  <p>Build production-ready RAG applications with vector databases, embedding models, and complete API/UI implementations. Choose between Elasticsearch and Chroma backends.</p>

  <div class="presentation-grid">
    <a href="../slides/day2-rag-architecture-overview.html" class="presentation-card">
      <span class="presentation-icon">🏗️</span>
      <div class="presentation-title">RAG Architecture Overview</div>
      <div class="presentation-description">End-to-end RAG pipeline: ingestion, retrieval, generation, and serving</div>
      <div class="presentation-meta">
        <span class="presentation-duration">⏱️ 90 min</span>
        <span class="presentation-type">THEORY</span>
      </div>
    </a>
  </div>

  <div style="margin-top: 1.5rem; padding: 1rem; background: var(--md-code-bg-color); border-left: 4px solid #0b62a3; border-radius: 4px;">
    <strong>🚀 Comprehensive Labs:</strong> Day 2 features extensive hands-on work. Start with
    <a href="../tracks/day2-rag/START_HERE/">START HERE guide</a> which includes:
    <ul style="margin: 0.5rem 0 0 1.5rem;">
      <li><strong>Lab 1:</strong> End-to-end accelerator setup</li>
      <li><strong>Lab 2A:</strong> Elasticsearch + LangChain</li>
      <li><strong>Lab 2B:</strong> Elasticsearch Python SDK</li>
      <li><strong>Lab 2C:</strong> Chroma + LangChain</li>
      <li><strong>Lab 3:</strong> Packaging & Evaluation</li>
    </ul>
  </div>
</div>

<!-- DAY 3 -->
<div class="day-section">
  <div class="day-header">
    <div class="day-number">3</div>
    <div class="day-title">
      <h2>Agents & Orchestration</h2>
      <p>Thursday | 6 Hours | Advanced AI Systems</p>
    </div>
  </div>

  <p>Create intelligent agents capable of using tools, multi-agent collaboration, and integrate with watsonx Orchestrate for enterprise governance.</p>

  <div class="presentation-grid">
    <a href="../slides/day3-agentic-ai-overview.html" class="presentation-card">
      <span class="presentation-icon">🤖</span>
      <div class="presentation-title">Agentic AI Overview</div>
      <div class="presentation-description">Agent frameworks: CrewAI, LangGraph, and ReAct patterns</div>
      <div class="presentation-meta">
        <span class="presentation-duration">⏱️ 90 min</span>
        <span class="presentation-type">THEORY</span>
      </div>
    </a>

    <a href="../slides/day3-bridge-orchestrate-governance.html" class="presentation-card">
      <span class="presentation-icon">⚙️</span>
      <div class="presentation-title">Orchestrate & Governance</div>
      <div class="presentation-description">Enterprise orchestration with watsonx and governance workflows</div>
      <div class="presentation-meta">
        <span class="presentation-duration">⏱️ 90 min</span>
        <span class="presentation-type">THEORY</span>
      </div>
    </a>

    <a href="../slides/day3-recap-and-next-steps.html" class="presentation-card">
      <span class="presentation-icon">🎯</span>
      <div class="presentation-title">Recap & Next Steps</div>
      <div class="presentation-description">Workshop recap, best practices, and production deployment guidance</div>
      <div class="presentation-meta">
        <span class="presentation-duration">⏱️ 60 min</span>
        <span class="presentation-type">RECAP</span>
      </div>
    </a>
  </div>

  <div style="margin-top: 1.5rem; padding: 1rem; background: var(--md-code-bg-color); border-left: 4px solid #0b62a3; border-radius: 4px;">
    <strong>🔬 Agent Notebooks:</strong> Explore reference implementations in the
    <a href="../tracks/day3-orchestrate/lab-1-agent-watsonx/">Day 3 labs</a>:
    <ul style="margin: 0.5rem 0 0 1.5rem;">
      <li>CrewAI multi-agent collaboration</li>
      <li>LangGraph stateful workflows</li>
      <li>watsonx Orchestrate integration</li>
    </ul>
  </div>
</div>

<!-- CAPSTONE -->
<div class="day-section">
  <div class="day-header">
    <div class="day-number">🏆</div>
    <div class="day-title">
      <h2>Capstone Project</h2>
      <p>Friday | 4 Hours | Applied Learning</p>
    </div>
  </div>

  <p>Apply everything you've learned in a comprehensive team project. Choose from suggested ideas or create your own custom application.</p>

  <div class="presentation-grid">
    <a href="../slides/capstone-overview.html" class="presentation-card">
      <span class="presentation-icon">🎓</span>
      <div class="presentation-title">Capstone Overview</div>
      <div class="presentation-description">Project structure, requirements, and team formation guidelines</div>
      <div class="presentation-meta">
        <span class="presentation-duration">⏱️ 30 min</span>
        <span class="presentation-type">PROJECT</span>
      </div>
    </a>

    <a href="../slides/capstone-project-ideas.html" class="presentation-card">
      <span class="presentation-icon">💡</span>
      <div class="presentation-title">Project Ideas</div>
      <div class="presentation-description">Curated project suggestions across different domains and complexity levels</div>
      <div class="presentation-meta">
        <span class="presentation-duration">⏱️ 30 min</span>
        <span class="presentation-type">IDEATION</span>
      </div>
    </a>
  </div>

  <div style="margin-top: 1.5rem; padding: 1rem; background: var(--md-code-bg-color); border-left: 4px solid #0b62a3; border-radius: 4px;">
    <strong>🚀 Project Resources:</strong> Access complete
    <a href="../tracks/capstone/capstone-overview/">capstone documentation</a> including:
    <ul style="margin: 0.5rem 0 0 1.5rem;">
      <li>Project templates and scaffolding</li>
      <li>Evaluation criteria and rubrics</li>
      <li>Presentation guidelines</li>
      <li>Example submissions</li>
    </ul>
  </div>
</div>

---

## For Instructors

<div class="grid cards" markdown>

-   :material-presentation-play: **Presentation Mode**

    ---

    - All slides support speaker notes (press 'S')
    - Full-screen mode available (press 'F')
    - Slide overview for navigation (press 'Esc')
    - Export to PDF for offline use

-   :material-clock-outline: **Timing Guidance**

    ---

    - Presentation duration shown on each card
    - Built-in breaks and Q&A time
    - Flexible pacing based on audience
    - Lab time estimates in documentation

-   :material-account-group: **Student Resources**

    ---

    - Share portal link for easy access
    - Documentation provides detailed steps
    - Lab solutions available for reference
    - Discussion forum for Q&A

-   :material-download: **Offline Access**

    ---

    - Download repository for local use
    - Print slides to PDF if needed
    - All materials work offline
    - Docker for isolated environments

</div>

---

## Workshop Completion Path

Track your progress through the complete workshop:

```mermaid
graph LR
    A[Day 0<br/>Setup] --> B[Day 1<br/>LLMs]
    B --> C[Day 2<br/>RAG]
    C --> D[Day 3<br/>Agents]
    D --> E[Capstone<br/>Project]

    style A fill:#E3F2FD,stroke:#1E88E5
    style B fill:#F1F8E9,stroke:#7CB342
    style C fill:#FFF3E0,stroke:#FB8C00
    style D fill:#F3E5F5,stroke:#8E24AA
    style E fill:#E0F7FA,stroke:#00ACC1
```

---

<div class="portal-footer">
  <h2>Ready to Start Learning?</h2>
  <p style="margin: 1rem 0;">Select any day above to begin your watsonx journey</p>

  <div style="margin: 2rem 0;">
    <a href="../tracks/day0-env/prereqs-and-accounts/" class="md-button md-button--primary" style="margin: 0.5rem;">
      📚 Start with Documentation
    </a>
    <a href="../slides/day0-prereqs-and-accounts.html" class="md-button md-button--primary" style="margin: 0.5rem;">
      🎬 Jump to Presentations
    </a>
  </div>

  <hr style="margin: 2rem 0;">

  <p><strong>Need Help?</strong></p>
  <p>
    <a href="https://github.com/ruslanmv/watsonx-workshop/discussions">💬 Discussions</a> •
    <a href="https://github.com/ruslanmv/watsonx-workshop/issues">🐛 Issues</a> •
    <a href="../resources/">📖 Resources</a>
  </p>

  <p style="color: var(--md-default-fg-color--light); margin-top: 2rem;">
    Built with ❤️ for the watsonx Community<br/>
    Copyright © 2025 — Ruslan Magana
  </p>
</div>