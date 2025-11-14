---
title: Workshop Portal
description: Interactive portal for the watsonx Workshop Series with daily guides and presentations
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
  border-radius: 12px;
  margin-bottom: 2rem;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
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
  border-radius: 12px;
  border: 1px solid var(--md-default-fg-color--lightest);
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  transition: all 0.3s ease;
}

.day-section:hover {
  box-shadow: 0 4px 12px rgba(11, 98, 163, 0.15);
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
  margin-right: 1.5rem;
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

.day-description {
  margin: 1rem 0 1.5rem 0;
  font-size: 1rem;
  line-height: 1.6;
  color: var(--md-default-fg-color);
}

.portal-button {
  display: inline-block;
  padding: 0.8rem 2rem;
  background: linear-gradient(135deg, #0b62a3 0%, #1e88e5 100%);
  color: white;
  text-decoration: none;
  border-radius: 6px;
  font-weight: 600;
  transition: all 0.3s ease;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.portal-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(11, 98, 163, 0.3);
  color: white;
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
  <p>Your comprehensive learning journey through IBM watsonx. Select any day below to access complete guides, presentations, and hands-on materials.</p>
</div>

!!! tip "How to Navigate This Portal"
    - **Click "Enter Day Portal"** to access complete daily guides with presentations, labs, and timing
    - Each day includes **interactive slides**, **documentation**, and **hands-on exercises**
    - **Instructor notes** and **timing recommendations** are built into each portal
    - All materials support **both instructor-led and self-paced** learning

---

## Quick Navigation

<div class="quick-links">
  <div class="quick-link-card">
    <h3>📚 Main Documentation</h3>
    <p>Browse the full docs</p>
    <a href="../" class="md-button md-button--primary">Home</a>
  </div>

  <div class="quick-link-card">
    <h3>🚀 Quick Start</h3>
    <p>Begin setup immediately</p>
    <a href="../tracks/day0-env/prereqs-and-accounts/" class="md-button md-button--primary">Setup Guide</a>
  </div>

  <div class="quick-link-card">
    <h3>💾 GitHub</h3>
    <p>Clone the repository</p>
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
      <p>Self-Paced | 4 Hours | Foundation</p>
    </div>
  </div>

  <div class="day-description">
    Prepare your development environment with both local (Ollama) and cloud (watsonx) configurations. This foundational day ensures you have everything needed for the complete workshop series.
  </div>

  <p><strong>What You'll Accomplish:</strong></p>
  <ul>
    <li>Set up IBM Cloud account and watsonx.ai access</li>
    <li>Configure local development environment with Ollama</li>
    <li>Install required software and dependencies</li>
    <li>Verify both environments are operational</li>
  </ul>

  <p style="margin-top: 1.5rem;">
    <a href="day0-portal/" class="portal-button">📋 Enter Day 0 Portal</a>
  </p>
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

  <div class="day-description">
    Master the fundamentals of Large Language Models with IBM's Granite family. Learn effective prompting strategies, evaluation techniques, and responsible AI practices through hands-on exercises.
  </div>

  <p><strong>What You'll Learn:</strong></p>
  <ul>
    <li>LLM architecture and transformer fundamentals</li>
    <li>Prompt engineering patterns and templates</li>
    <li>Chain-of-thought and few-shot learning techniques</li>
    <li>Model evaluation metrics and safety considerations</li>
  </ul>

  <p style="margin-top: 1.5rem;">
    <a href="day1-portal/" class="portal-button">🧠 Enter Day 1 Portal</a>
  </p>
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

  <div class="day-description">
    Build enterprise-grade RAG applications from scratch. Work with vector databases, embedding models, and deploy complete API/UI implementations ready for production use.
  </div>

  <p><strong>What You'll Build:</strong></p>
  <ul>
    <li>End-to-end document processing pipeline</li>
    <li>Vector database integration (Elasticsearch or Chroma)</li>
    <li>Production-ready FastAPI backend with citations</li>
    <li>Interactive Streamlit chat interface</li>
    <li>Model evaluation and comparison workflows</li>
  </ul>

  <p style="margin-top: 1.5rem;">
    <a href="day2-portal/" class="portal-button">🏗️ Enter Day 2 Portal</a>
  </p>
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

  <div class="day-description">
    Create intelligent agents with tool-using capabilities, multi-agent collaboration, and enterprise governance. Integrate with watsonx Orchestrate for production-ready orchestration.
  </div>

  <p><strong>What You'll Implement:</strong></p>
  <ul>
    <li>Tool-using agents with ReAct patterns</li>
    <li>Multi-agent workflows with CrewAI and LangGraph</li>
    <li>watsonx.governance integration for evaluation</li>
    <li>watsonx Orchestrate connections and flows</li>
    <li>Enterprise governance and security patterns</li>
  </ul>

  <p style="margin-top: 1.5rem;">
    <a href="day3-portal/" class="portal-button">🤖 Enter Day 3 Portal</a>
  </p>
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

  <div class="day-description">
    Apply everything you've learned in a comprehensive team project. Choose from curated project ideas or design your own custom AI application using the skills and patterns from Days 0-3.
  </div>

  <p><strong>Project Options Include:</strong></p>
  <ul>
    <li>Custom RAG application for specific domain</li>
    <li>Multi-agent research or analysis system</li>
    <li>Enterprise knowledge management solution</li>
    <li>Your own innovative AI application</li>
  </ul>

  <p style="margin-top: 1.5rem;">
    <a href="capstone-portal/" class="portal-button">🎓 Enter Capstone Portal</a>
  </p>
</div>

---

## Workshop Learning Path

Track your progress through the complete curriculum:

```mermaid
graph LR
    A[Day 0<br/>Environment<br/>Setup] --> B[Day 1<br/>LLMs &<br/>Prompting]
    B --> C[Day 2<br/>RAG<br/>Systems]
    C --> D[Day 3<br/>Agents &<br/>Orchestration]
    D --> E[Capstone<br/>Applied<br/>Project]

    style A fill:#E3F2FD,stroke:#1E88E5,stroke-width:2px
    style B fill:#F1F8E9,stroke:#7CB342,stroke-width:2px
    style C fill:#FFF3E0,stroke:#FB8C00,stroke-width:2px
    style D fill:#F3E5F5,stroke:#8E24AA,stroke-width:2px
    style E fill:#E0F7FA,stroke:#00ACC1,stroke-width:2px
```

---

## For Instructors

<div class="grid cards" markdown>

-   :material-presentation-play: **Complete Teaching Materials**

    ---

    Each daily portal includes:

    - Detailed session agendas with timing
    - Interactive presentation slides
    - Instructor notes and tips
    - Common troubleshooting guidance

-   :material-clock-outline: **Flexible Scheduling**

    ---

    - Recommended timings for each module
    - Built-in break schedules
    - Lab time estimates
    - Adjust pacing based on audience

-   :material-account-group: **Student Resources**

    ---

    - Share portal links for easy access
    - All materials support self-paced learning
    - Lab solutions available
    - Discussion forum integration

-   :material-download: **Offline Capability**

    ---

    - Download complete repository
    - Export slides to PDF
    - All labs work offline
    - Docker for isolated environments

</div>

---

<div class="portal-footer">
  <h2>Ready to Start?</h2>
  <p style="margin: 1rem 0; font-size: 1.1rem;">Select any day above to begin your watsonx learning journey</p>

  <div style="margin: 2rem 0;">
    <a href="day0-portal/" class="md-button md-button--primary" style="margin: 0.5rem;">
      🚀 Start with Day 0
    </a>
    <a href="../tracks/day0-env/prereqs-and-accounts/" class="md-button" style="margin: 0.5rem;">
      📚 Browse Documentation
    </a>
  </div>

  <hr style="margin: 2rem 0;">

  <p><strong>Need Help?</strong></p>
  <p>
    <a href="https://github.com/ruslanmv/watsonx-workshop/discussions">💬 Discussions</a> •
    <a href="https://github.com/ruslanmv/watsonx-workshop/issues">🐛 Report Issues</a> •
    <a href="../resources/">📖 Resources</a>
  </p>

  <p style="color: var(--md-default-fg-color--light); margin-top: 2rem;">
    Built with care for the watsonx Community<br/>
    Copyright © 2025 Ruslan Magana
  </p>
</div>