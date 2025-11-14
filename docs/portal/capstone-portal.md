# Capstone Portal: Build Your AI Application

## 📋 Project Overview

- **Duration**: 8 hours (full day, Friday)
- **Format**: Team project work with instructor support
- **Learning Objectives**:
  - Apply all workshop concepts (LLMs, RAG, Agents) to real project
  - Design and implement complete AI application
  - Present solution to peers and instructors
  - Prepare for production deployment
- **Prerequisites**: ✅ [Days 0-3 Complete](day3-portal.md)

---

## ☀️ Morning Session: Project Planning & Kickoff (9:00 AM - 12:00 PM)

### Module 4.0: Capstone Overview & Project Framing (9:00 - 9:30, 30 min)

**Content**:

- 📖 [Read: Capstone Overview](../tracks/capstone/capstone-overview.md)
- 🎯 [Present: Capstone Overview Slides (HTML)](../slides/capstone-overview.html)
- 📄 [Download: Capstone Slides (PDF)](../slides/capstone-overview.pdf)

**Topics Covered**:

- Capstone goals and success criteria
- Team formation and role assignment
- Project timeline and milestones
- Evaluation rubric and presentation format

**Instructor Notes**:

!!! tip "Team Formation Strategy"
    **Team Size**: 2-4 people (optimal: 3)

    **Role Assignment**:
    - **Architect**: Design system, make technical decisions
    - **Developer**: Implement core features
    - **Data Engineer**: Handle ingestion, chunking, evaluation
    - **Presenter**: Prepare demo and slides

    **Mixing Skill Levels**: Pair experienced with beginners for mentorship.

!!! warning "Scope Management"
    **Common Mistake**: Teams try to build too much in one day.

    **Guideline**: "Pick ONE feature and make it work well, not five features that barely work."

**Suggested Pacing**:

- 0-10 min: Capstone goals and format
- 10-20 min: Team formation
- 20-30 min: Review project ideas and select

---

### Module 4.1: Project Ideas & Selection (9:30 - 10:30, 60 min)

**Content**:

- 📖 [Read: Capstone Project Ideas](../tracks/capstone/capstone-project-ideas.md)
- 🎯 [Present: Project Ideas Slides (HTML)](../slides/capstone-project-ideas.html)

**Sample Project Ideas**:

<div class="grid cards" markdown>

-   :material-file-document-search: __Internal Knowledge Assistant__

    ---

    RAG system for company documentation

    **Components**:
    - Document ingestion (HR policies, engineering docs)
    - Vector search with Elasticsearch/Chroma
    - Q&A interface with citations

    **Difficulty**: ⭐⭐ Beginner-friendly

-   :material-email-search: __Smart Email Assistant__

    ---

    Agent that reads, categorizes, and responds to emails

    **Components**:
    - Email parsing (mock or real via Gmail API)
    - Classification agent (urgent/spam/action-needed)
    - Draft response tool

    **Difficulty**: ⭐⭐⭐ Intermediate

-   :material-cart: __E-commerce Product Advisor__

    ---

    RAG + Agent for product recommendations

    **Components**:
    - Product catalog RAG
    - Recommendation agent
    - Order placement tool (mock)

    **Difficulty**: ⭐⭐⭐ Intermediate

-   :material-hospital-building: __Medical Research Assistant__

    ---

    RAG over research papers with citation

    **Components**:
    - PDF ingestion (PubMed papers)
    - Semantic search with reranking
    - Citation formatting

    **Difficulty**: ⭐⭐⭐⭐ Advanced

-   :material-robot-happy: __Multi-Agent Research Team__

    ---

    CrewAI agents collaborate on research tasks

    **Components**:
    - Researcher agent (web search + RAG)
    - Writer agent (draft articles)
    - Critic agent (review and improve)

    **Difficulty**: ⭐⭐⭐⭐ Advanced

-   :material-lightbulb-on: __Custom Idea__

    ---

    Bring your own use case!

    **Requirements**:
    - Uses at least one of: LLM, RAG, or Agent
    - Clearly defined success criteria
    - Achievable in 6 hours

    **Difficulty**: Varies

</div>

**Team Decision Process**:

1. **Brainstorm** (15 min): Teams discuss interests and constraints
2. **Select Idea** (10 min): Pick from provided ideas or propose custom
3. **Define Scope** (20 min): Write 3-sentence project description
4. **Get Approval** (15 min): Pitch to instructor, refine if needed

!!! example "Project Scope Template"
    **Project Title**: [Name]

    **Problem**: [What problem are you solving in 1 sentence?]

    **Solution**: [What will you build in 1 sentence?]

    **Success Criteria**: [How will you know it works? 2-3 checkpoints]

☕ **Break**: 10:30 - 10:45 (15 min)

---

### Design & Planning Sprint (10:45 - 12:00, 75 min)

**Objectives**:

- Design system architecture
- Create task breakdown and timeline
- Set up development environment
- Divide work among team members

**Deliverables**:

1. **Architecture Diagram** (Mermaid or whiteboard)
2. **Task List** with time estimates
3. **Git Repository** set up and shared
4. **Roles & Responsibilities** documented

**Instructor Activities**:

- Circulate to each team for 10-15 min design review
- Challenge unrealistic scopes ("Can you ship that by 4 PM?")
- Suggest simplifications and shortcuts
- Approve final designs

!!! tip "Architecture Template"
    ```mermaid
    flowchart LR
        A[User Input] --> B[Agent/RAG]
        B --> C[LLM watsonx]
        B --> D[Vector Store]
        B --> E[External API]
        C --> F[Response]
        D --> F
        E --> F
    ```

**Planning Checklist**:

- [ ] Architecture diagram drawn
- [ ] Components identified (ingestion, retrieval, generation, UI)
- [ ] Data sources identified (what documents/APIs?)
- [ ] Tech stack decided (Elasticsearch or Chroma? FastAPI or Streamlit?)
- [ ] Tasks assigned to team members
- [ ] Timeline created (what's done by 2 PM, 4 PM?)

🍴 **Lunch Break**: 12:00 - 1:00 PM (60 min)

---

## 🔬 Afternoon Session: Implementation & Integration (1:00 PM - 4:00 PM)

### Build Sprint (1:00 - 3:00, 2 hours)

**Format**: Teams work independently, instructors circulate for support.

**Suggested Milestones**:

**1:00 - 1:30**: Core ingestion/setup
- [ ] Data ingested (if RAG project)
- [ ] Vector store populated
- [ ] Basic LLM connection tested

**1:30 - 2:00**: Feature implementation
- [ ] Main feature working (retrieval or agent logic)
- [ ] Basic input/output flow complete

**2:00 - 2:30**: Integration
- [ ] All components connected
- [ ] End-to-end flow tested
- [ ] Error handling added

**2:30 - 3:00**: Polish & testing
- [ ] UI created (Streamlit/Gradio) or API endpoint
- [ ] Test with multiple queries
- [ ] Fix bugs

**Instructor Support**:

- **Office hours mode**: Teams raise hand or post in Slack for help
- **15-minute check-ins**: Quick status with each team every hour
- **Unblock**: Help teams get unstuck, suggest workarounds

!!! warning "Common Time Sinks"
    1. **Environment issues**: "Use what worked in Day 2 labs!"
    2. **Scope creep**: "Park that feature, focus on core functionality"
    3. **Perfectionism**: "Ship the MVP, polish if time permits"

☕ **Break**: 3:00 - 3:15 PM (15 min)

---

### Demo Prep & Rehearsal (3:15 - 4:00, 45 min)

**Objectives**:

- Create 5-minute demo presentation
- Prepare slides (optional) or live demo script
- Rehearse with team
- Test demo in presentation environment

**Demo Structure** (5 min total):

1. **Problem** (30 sec): What are you solving?
2. **Solution** (30 sec): What did you build?
3. **Demo** (3 min): Show it working (live or video)
4. **Learnings** (1 min): What did you learn? What would you do differently?

!!! tip "Demo Best Practices"
    **DO**:
    - ✅ Test demo beforehand (have backup video)
    - ✅ Show real inputs and outputs
    - ✅ Highlight what makes your solution unique
    - ✅ Be honest about challenges

    **DON'T**:
    - ❌ Read slides verbatim
    - ❌ Apologize for what doesn't work
    - ❌ Go over time (5 min is strict!)
    - ❌ Show only code (show user experience)

**Demo Checklist**:

- [ ] Demo script written (who says what, when)
- [ ] Test data/queries prepared
- [ ] Slides created (if using)
- [ ] Demo rehearsed at least once
- [ ] Backup plan if live demo fails (video, screenshots)

---

## 🎤 Late Afternoon: Presentations & Wrap-Up (4:00 PM - 5:00 PM)

### Team Presentations (4:00 - 4:50, 50 min)

**Format**: Each team presents for 5 minutes + 2 min Q&A.

**Presentation Order**: Randomized (draw numbers)

**Evaluation Criteria**:

| Criterion | Weight | Description |
|-----------|--------|-------------|
| **Functionality** | 40% | Does it work? Solves stated problem? |
| **Technical Quality** | 20% | Code quality, architecture, best practices |
| **Innovation** | 15% | Creative use of workshop concepts |
| **Presentation** | 15% | Clear communication, good demo |
| **Teamwork** | 10% | Collaboration, role distribution |

**Instructor Notes**:

!!! tip "Celebration Over Critique"
    **Goal**: Celebrate learning, not judge perfection.

    **Feedback Style**:
    - ✅ "I love how you used X for Y!"
    - ✅ "What would you add if you had another day?"
    - ❌ "This part is wrong because..."

**Audience Participation**:

- Students vote for "Best Demo" and "Most Creative"
- Post-its for feedback ("I liked...", "I learned...")

---

### Workshop Closing & Celebration (4:50 - 5:00, 10 min)

**Reflection Prompts**:

- "What was your favorite part of the workshop?"
- "What will you build next with these skills?"
- "Who would you like to thank?"

**Certificates** (if applicable):

- Distribute completion certificates
- Group photo

**Next Steps**:

1. **Share Projects**: Post to GitHub, LinkedIn
2. **Stay Connected**: Join IBM watsonx community
3. **Keep Learning**: Resources in [Recap & Next Steps](../tracks/day3-orchestrate/recap-and-next-steps.md)

---

## 📚 Quick Reference

### All Capstone Materials

<div class="grid cards" markdown>

-   :material-book-open-page-variant: __Planning & Ideas__

    ---

    - [Capstone Overview](../tracks/capstone/capstone-overview.md)
    - [Project Ideas](../tracks/capstone/capstone-project-ideas.md)

-   :material-presentation: __Slides__

    ---

    - [Capstone Overview Slides](../slides/capstone-overview.html)
    - [Project Ideas Slides](../slides/capstone-project-ideas.html)

-   :material-tools: __Technical Resources__

    ---

    - [Day 1 LLM Labs](../tracks/day1-llm/lab-1-quickstart-two-envs.md)
    - [Day 2 RAG Accelerator](../tracks/day2-rag/START_HERE.md)
    - [Day 3 Agent Labs](../tracks/day3-orchestrate/lab-1-agent-watsonx.md)

-   :material-chat-question: __Support__

    ---

    - Ask instructor during build sprint
    - Review previous day materials
    - Pair with another team for help

</div>

### Navigation

- [⬅️ Previous: Day 3 - Orchestration & Agents](day3-portal.md)
- [🏠 Workshop Home](../index.md)
- [📚 All Resources](../resources.md)

---

## 🎯 Learning Outcomes

By the end of the Capstone, participants will be able to:

1. ✅ **Design** complete AI application architecture from requirements
2. ✅ **Implement** end-to-end solution using workshop techniques
3. ✅ **Integrate** multiple components (LLMs, RAG, agents, UI)
4. ✅ **Collaborate** effectively in team setting with clear roles
5. ✅ **Present** technical project to non-technical audience
6. ✅ **Deploy** MVP solution that solves real problem

---

## 🔧 Troubleshooting

### Common Issues During Capstone

??? question "Team is stuck and losing time"
    **Symptoms**: Team hasn't made progress in 30+ minutes

    **Instructor Intervention**:
    1. **Diagnose**: "What's blocking you?"
    2. **Simplify**: "What's the absolute simplest version that could work?"
    3. **Unblock**: Provide working code snippet or suggest workaround
    4. **Adjust scope**: "Let's move this feature to 'nice-to-have' list"

    **Example**:
    - **Stuck on**: Custom embedding model won't load
    - **Solution**: "Use Day 2 accelerator's embedding code exactly as-is"

??? question "Demo isn't working 30 minutes before presentations"
    **Symptoms**: Panic, rushing, blame

    **Instructor Actions**:
    1. **Calm team**: "Let's take 2 minutes and breathe"
    2. **Backup plan**: "Do you have screenshots or a working part?"
    3. **Simplify demo**: "Show just the retrieval part, that works"
    4. **Video fallback**: "Can you screen-record it working?"

    **Reminder**: "A partial working demo beats a full broken one"

??? question "Team member not contributing"
    **Symptoms**: One person doing all work, others disengaged

    **Intervention**:
    - **Private conversation**: "How can I help you contribute?"
    - **Task assignment**: "Can you own the demo slides?"
    - **Pairing**: "Work with [active member] on this feature"

??? question "Scope is too ambitious"
    **Symptoms**: 2 PM and <30% done

    **Intervention**:
    1. **Reality check**: "You have 2 hours left. What MUST work?"
    2. **Prioritize**: Make "must-have" vs. "nice-to-have" list
    3. **Cut features**: "Let's remove the agent and just do RAG"
    4. **Adjust expectations**: "A simple working demo is a win"

---

## 📊 Instructor Notes

### Pre-Capstone Preparation

**1 Week Before**:
- Prepare project idea descriptions and difficulty ratings
- Create evaluation rubric
- Set up shared resources (Git templates, starter code)

**Day Before**:
- Verify all environments still work (Ollama, watsonx, vector DBs)
- Prepare demo environment (projector, screen sharing)
- Print project idea sheets

**Morning Of**:
- Set up breakout spaces for teams (if in-person)
- Create Slack channels for each team
- Test presentation equipment

### Pacing Strategy

**Tight Schedule Risks**:
- ⚠️ Teams underestimate implementation time
- ⚠️ Debugging takes longer than expected
- ⚠️ Presentations run over time

**Mitigation**:
- ⏰ Set strict milestones (1 PM, 2 PM, 3 PM check-ins)
- ⏰ Cut design phase if >30 min behind schedule
- ⏰ Enforce 5-min presentation limit (use timer)

### Success Metrics

**Minimum Success**:
- [x] 80%+ teams ship working demo (even if simple)
- [x] All teams present
- [x] Positive feedback on workshop overall

**Ideal Success**:
- [x] 100% teams ship working demo
- [x] At least 2 teams go "above and beyond" (complex features)
- [x] Students want to continue building after workshop

---

## 📝 Daily Schedule (At-a-Glance)

```mermaid
gantt
    title Capstone Day Schedule
    dateFormat HH:mm
    axisFormat %H:%M

    section Morning Planning
    Module 4.0: Capstone Overview     :09:00, 30m
    Module 4.1: Project Selection     :09:30, 60m
    Break                             :10:30, 15m
    Design & Planning Sprint          :10:45, 75m
    Lunch                             :12:00, 60m

    section Afternoon Build
    Build Sprint (Milestone 1)        :13:00, 30m
    Build Sprint (Milestone 2)        :13:30, 30m
    Build Sprint (Milestone 3)        :14:00, 30m
    Build Sprint (Polish)             :14:30, 30m
    Break                             :15:00, 15m
    Demo Prep & Rehearsal             :15:15, 45m

    section Presentations
    Team Presentations                :16:00, 50m
    Workshop Closing                  :16:50, 10m
```

---

## 💬 Common Student Questions

### Planning Questions

??? question "Q: Can we use external libraries or APIs?"
    **Answer**: Yes, with caveats.

    **Allowed**:
    - ✅ Any library from previous days (LangChain, CrewAI, etc.)
    - ✅ Public APIs (weather, news, etc.)
    - ✅ watsonx.ai, Ollama, Elasticsearch, Chroma

    **Avoid** (time sinks):
    - ❌ New frameworks you've never used
    - ❌ APIs requiring complex auth setup
    - ❌ Experimental or poorly documented tools

    **Guideline**: "If setup takes >15 minutes, reconsider"

??? question "Q: Do we need to deploy to production?"
    **Answer**: No, local demo is sufficient.

    **Capstone Goal**: Prove concept works
    **Not Required**:
    - Production deployment
    - Scalability testing
    - Security hardening
    - CI/CD pipelines

    **Bonus** (if time): Dockerize your app

??? question "Q: What if our idea doesn't work?"
    **Answer**: Pivot quickly!

    **Decision Point**: 2 PM
    - If <50% done by 2 PM → Simplify or pivot
    - If <25% done by 2 PM → Major pivot required

    **Fallback**: "Build simplest RAG Q&A on your topic"

### Technical Questions

??? question "Q: Can we combine RAG and agents?"
    **Answer**: Yes, that's encouraged!

    **Example Architecture**:
    ```
    User Query
        ↓
    Agent (decides: use RAG tool or take action?)
        ↓
    RAG Tool → Vector Store → LLM → Answer with citations
    ```

    **Complexity Warning**: Test RAG alone first, add agent later if time.

??? question "Q: Can we use our own data?"
    **Answer**: Absolutely!

    **Data Sources**:
    - Company docs (if not confidential)
    - Personal notes or blog posts
    - Public datasets (Kaggle, HuggingFace)
    - Sample data from workshop

    **Tip**: Start with small dataset (5-10 documents) for faster iteration

---

## 🏆 Awards & Recognition

### Student Awards (Optional)

- **🥇 Best Demo**: Most polished, impressive demonstration
- **🎨 Most Creative**: Unique or innovative approach
- **🏅 Best Teamwork**: Excellent collaboration and role distribution
- **🎯 Most Practical**: Solution with clear real-world value
- **🚀 Biggest Stretch**: Team that learned the most or overcame challenges

### Instructor Recognition

- Thank each team for specific contribution
- Highlight unique approaches
- Celebrate problem-solving and resilience

---

## 📝 Post-Workshop Actions

### For Students

1. **Push code to GitHub**: Share your work publicly
2. **Write blog post**: Document your learning journey
3. **Continue building**: Add features you didn't have time for
4. **Join community**: IBM watsonx forum, LangChain Discord

### For Instructors

1. **Collect feedback**: Survey on what worked, what didn't
2. **Archive projects**: Save codebases for future reference
3. **Update materials**: Note what was confusing or missing
4. **Celebrate**: Share student projects on social media (with permission)

---

**Last Updated**: 2025-01-13 | **Project Time**: 6 hours | **Success Rate**: Target 90% completion