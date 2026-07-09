---
layout: post
title: Claude Code 实战 - Complete Guide to Agentic Development
categories: [-40 VibeCoding]
tags: [VibeCoding, ClaudeCode, Codex, Agents, Skills, Automation, CLAUDE.md]
number: [-0.0]
fullview: false
shortinfo: 从架构到实战 - 完整掌握Claude Code的核心能力：CLAUDE.md、Skills、Agents、Hooks、MCP、以及生产级工作流

---

> 🚀 **Complete Guide to Claude Code Agentic Development** - Learn how to build intelligent, autonomous development workflows with Skills, Agents, Hooks, and MCP integration.

## 📚 Quick Navigation

**Part I: Foundations**
- [Chapter 1: Architecture](#chapter-1-architecture) - System design and components
- [Chapter 2: Memory (Claude.md)](#chapter-2-memory-claudemd) - Project context and conventions

**Part II: Core Features**
- [Chapter 3: Skills](#chapter-3-skill-modular-function) - Reusable slash commands
- [Chapter 4: Sub Agents](#chapter-4-sub-agent-reduce-map) - Parallel processing and map-reduce
- [Chapter 5: Hooks](#chapter-5-hooks) - Automation triggers
- [Chapter 6: MCP](#chapter-6-mcp-external-data-access) - External system integration

**Part III: Advanced**
- [Chapter 7: Headless Mode](#chapter-7-headless-mode-and-cicd) - CI/CD automation
- [Chapter 8: Agent SDK](#chapter-8-agent-sdk) - Custom agent development
- [Chapter 9: Plugins](#chapter-9-plugins--packages) - Extensibility
- [Chapter 10: Integration](#chapter-10-end-to-end-integration) - Real-world workflows

---

目录
{:.article_content_title}

* TOC
{:toc}

---
{:.hr-short-left}


# Part I: Overall

## Chapter 1: Architecture

{: .img_middle_hg}
![ClaudeCode Overall Structure]({{site.url}}/assets/images/posts/-40_VibeCoding/ClaudeCode实战/C1_ClaudeCodeOverall.jpg)

### System Overview

Claude Code is built on a layered architecture that separates concerns while maintaining tight integration:

```
┌────────────────────────────────────────┐
│  User Interface Layer                  │
│  • CLI, IDE Extensions, Web App        │
└────────────────────────────────────────┘
           ↓
┌────────────────────────────────────────┐
│  Agent Orchestration Layer             │
│  • Skills, Workflows, Multi-Agent      │
└────────────────────────────────────────┘
           ↓
┌────────────────────────────────────────┐
│  Tool Execution Layer                  │
│  • File I/O, Bash, APIs, MCP Servers   │
└────────────────────────────────────────┘
           ↓
┌────────────────────────────────────────┐
│  Integration Layer                     │
│  • Git, Databases, External Systems    │
└────────────────────────────────────────┘
```

This separation enables:
- **Modularity** — Each layer evolves independently
- **Testability** — Mock layers for testing
- **Extensibility** — Add new tools without modifying core
- **Security** — Sandbox at each layer

## Chapter 2: Memory (Claude.md)

Claude.md is a markdown file that Claude Code reads automatically at the start of every session. It acts as persistent memory, providing context about your project structure, coding conventions, build commands, and rules.

### 2.0 Why CLAUDE.md Matters

**Without CLAUDE.md:**
- Claude starts fresh every session with zero context
- Repeats mistakes (uses wrong file structure, violates conventions)
- Suggests inappropriate libraries or patterns
- Takes longer to get up to speed
- Inconsistent code quality

**With CLAUDE.md:**
- Claude knows your project immediately
- Follows established conventions automatically
- Suggests tools you've already decided against avoiding
- Faster, more accurate implementations
- Consistent quality across all sessions

### 2.01 Structure & Format

A well-organized CLAUDE.md has these sections:

```markdown
# [Project Name]

[One-line description]

## Commands
- List all CLI commands you use
- Format: `command` — description

## Structure
- Explain directory layout
- Where things live in your project
- Special folders or files

## Rules
- Key conventions to follow
- Anti-patterns to avoid
- Tech stack decisions

## File Structure
- ASCII tree diagram
- Shows actual organization

## Conventions
- Naming patterns
- Coding style
- Test patterns
```

**Length Target:** 50-200 lines (sweet spot)
- Under 50 lines: Too vague, missing important context
- 50-150 lines: Just right, covers essentials
- 150-200 lines: Comprehensive, project-specific
- Over 200 lines: Diminishing returns, Claude loses signal

### 2.1 React Project Example

```markdown
# MyBlog UI

React 18 frontend with TypeScript, Vite, and TailwindCSS.

## Commands

- `npm run dev` — start dev server (localhost:5173)
- `npm run build` — production build to dist/
- `npm run lint` — ESLint + Prettier check
- `npm test` — Vitest unit tests
- `npm test -- --ui` — Vitest UI mode

Run lint and test before committing.

## Structure

- `src/components/` — React components (one per file)
- `src/pages/` — page-level components (route handlers)
- `src/hooks/` — custom React hooks
- `src/utils/` — utility functions (no side effects)
- `src/styles/` — global styles and Tailwind config
- `public/` — static assets

## Rules

- **Components**: functional components only, use composition over inheritance
- **TypeScript**: strict mode, no `any`, export types from components
- **Naming**: PascalCase for components (Button.tsx), camelCase for utils
- **Styling**: TailwindCSS classes only, no CSS files
- **State management**: React Context for global state, useState for local
- **Imports**: absolute imports from `src/`, not relative paths

## File Structure

```
src/
├── components/
│   ├── Button.tsx
│   ├── Card.tsx
│   └── Layout.tsx
├── pages/
│   ├── Home.tsx
│   └── About.tsx
├── hooks/
│   └── useTheme.ts
├── utils/
│   └── format.ts
└── App.tsx
```

## Conventions

- Components export both default and named exports
- Props interfaces named `{ComponentName}Props`
- Use `clsx()` for conditional classes, not ternaries
- Test files colocated: `Button.test.tsx` next to `Button.tsx`
```

**Sources:**
- [CLAUDE.md Best Practices for React — Medium](https://medium.com/@onix_react/claude-md-best-practices-a60d726dc2a5)
- [How to Set Up Your Project for Agentic Coding — Hashnode](https://effloow.hashnode.dev/the-perfect-claudemd-how-to-set-up-your-project-for-agentic-coding)

### 2.2 Express/Node.js Project Example

```markdown
# API Server

Node.js/Express backend with TypeScript, PostgreSQL, and Jest.

## Commands

- `npm run dev` — start dev server with hot reload
- `npm run build` — compile TypeScript to dist/
- `npm test` — run Jest tests
- `npm test -- --watch` — watch mode
- `npm run lint` — ESLint check
- `npm run seed` — populate database with fixtures

Run `npm run lint && npm test` before committing.

## Structure

- `src/routes/` — API route handlers (organized by resource)
- `src/controllers/` — business logic (requests → responses)
- `src/services/` — core logic (database, external APIs)
- `src/middleware/` — Express middleware (auth, validation, error)
- `src/models/` — database models (Sequelize/TypeORM)
- `src/types/` — shared TypeScript interfaces
- `src/utils/` — pure utility functions
- `tests/` — test files mirroring src/ structure

## Rules

- **TypeScript**: strict mode enabled, no `any` type
- **Response format**: all endpoints return `{ data?, error?, status }`
- **Error handling**: use custom AppError class, never throw raw errors
- **Logging**: use winston logger (src/utils/logger.ts), never console.log
- **Database**: use prepared statements, parameterized queries only
- **Validation**: use Joi/Zod for request validation before controller
- **Async**: use async/await, not .then()
- **Environment**: read from .env via dotenv, never hardcode secrets

## File Structure

```
src/
├── routes/
│   ├── users.ts
│   └── posts.ts
├── controllers/
│   ├── userController.ts
│   └── postController.ts
├── services/
│   ├── userService.ts
│   └── postService.ts
├── middleware/
│   ├── auth.ts
│   └── errorHandler.ts
├── models/
│   └── User.ts
├── types/
│   └── index.ts
└── app.ts
```

## Conventions

- Routes declare paths only, delegate to controllers
- Controllers handle HTTP concerns (req, res)
- Services contain business logic and data access
- All errors inherit from AppError
- Test database separate from development database
```

**Sources:**
- [Free CLAUDE.md Rules for Node.js/Express — GitHub Gist](https://gist.github.com/oliviacraft/aa4c6714175cf0163e7e07003b1e52f5)
- [CLAUDE.md — NestJS / Node.js Edition — GitHub](https://gist.github.com/oliviacraft/a3f5d4fe666e35e150fabe4a2edc025e)

### 2.3 Python AI/ML Project Example

```markdown
# ML Pipeline

Python machine learning project with PyTorch, Pandas, and scikit-learn.

## Commands

- `uv sync` — install dependencies from pyproject.toml
- `python -m pytest` — run tests (pytest)
- `python -m pytest tests/models/ -v` — run specific tests
- `ruff check .` — lint check
- `ruff format .` — format code
- `python train.py` — train model (outputs to models/latest.pkl)
- `python evaluate.py` — evaluate on test set

Run lint and tests before committing.

## Structure

- `src/` — main source code
  - `data/` — data loading and preprocessing
  - `models/` — model architectures and training logic
  - `utils/` — utility functions
- `notebooks/` — Jupyter exploratory analysis (EDA)
- `data/` — datasets (not committed, .gitignored)
- `models/` — trained model checkpoints
- `tests/` — unit tests mirroring src/

## Rules

- **Python**: 3.11+, use type hints on all functions
- **Dependencies**: managed via uv + pyproject.toml (no requirements.txt)
- **Imports**: absolute imports from `src/`, not relative
- **Naming**: snake_case for functions/variables, PascalCase for classes
- **ML Pipeline**: ALL operations MUST be reproducible
  - Set random seeds (numpy, torch, random) at start of scripts
  - Configuration in YAML files, not hardcoded
  - Log hyperparameters and metrics to MLflow
- **Data**: never modify raw data, create processed/ subfolder
- **Models**: save with timestamp and config, enable reproducibility
- **Testing**: test data preprocessing, model forward pass, not just accuracy

## File Structure

```
src/
├── data/
│   ├── __init__.py
│   ├── loader.py
│   └── preprocessor.py
├── models/
│   ├── __init__.py
│   ├── neural_net.py
│   └── trainer.py
├── utils/
│   ├── __init__.py
│   ├── metrics.py
│   └── config.py
└── __init__.py

tests/
├── test_preprocessor.py
└── test_models.py
```

## Conventions

- Every script has a `if __name__ == "__main__":` block
- Config loaded from YAML before any training
- Models checkpointed with epoch number: `model_epoch_10.pt`
- Seeds set in `utils/config.py` and loaded at entry
- Use `logging` module, not print()
- Type hints required on all public functions
```

**Sources:**
- [awesome-claude-code-toolkit — Python Project Template](https://github.com/rohitg00/awesome-claude-code-toolkit/blob/main/templates/claude-md/python-project.md)
- [How to Set Up CLAUDE.md for a Python Project — PyDevTools](https://pydevtools.com/handbook/how-to/how-to-use-the-pydevtools-claude-md-template/)

### 2.4 Best Practices Summary

| Aspect | Guideline |
|--------|-----------|
| **Length** | 60–200 lines max (aim for ~100) |
| **Sections** | Structure, Commands, Rules, Conventions |
| **Specificity** | Be concrete: exact paths, exact command names |
| **Updates** | Add a rule when Claude violates it twice |
| **Scope** | Tech stack + coding style, not team docs |

**Key References:**
- [Writing the Best CLAUDE.md: A Complete Guide for Claude Code — DataCamp](https://www.datacamp.com/tutorial/writing-the-best-claude-md)
- [TheDecipherist/claude-code-mastery — Complete Guide — GitHub](https://github.com/TheDecipherist/claude-code-mastery)
- [awesome-claude-md — Curated Examples — GitHub](https://github.com/josix/awesome-claude-md)

# Part II: Core

## Chapter 3: Skill (Modular Function)

Skills are reusable slash commands (`/command`) that Claude Code can invoke to accomplish specific tasks. They encapsulate domain-specific workflows into repeatable, shareable operations.

### 3.1 Understanding Skills

**What is a Skill?**

A skill is essentially a specialized tool that:
- Takes input (arguments, context, or interactive prompts)
- Performs a focused task (validation, deployment, content creation)
- Returns structured or human-readable output
- Can be triggered via `/command-name` or programmatically

**Why Use Skills?**

Instead of repeating complex workflows, skills:
- **Encode best practices** — Ensure consistency across runs
- **Save time** — No need to type full commands repeatedly
- **Reduce errors** — Validated, tested workflows
- **Enable onboarding** — New team members see available operations
- **Support automation** — Chain skills in workflows

### 3.2 Built-In Skills

Claude Code provides production-ready skills:

| Skill | Command | Purpose |
|-------|---------|---------|
| **Verify** | `/verify` | Test changes end-to-end (run app, check behavior) |
| **Run** | `/run` | Launch and drive the application |
| **Code Review** | `/code-review` | Audit diff for bugs and improvements |
| **Simplify** | `/simplify` | Optimize code for readability and efficiency |
| **Loop** | `/loop` | Repeat task on recurring interval |
| **Deep Research** | `/deep-research` | Multi-source fact-checking research |
| **Data Visualization** | `/dataviz` | Create charts, dashboards, graphs |

### 3.3 Creating Custom Skills

Custom skills live in `.claude/skills/` as markdown files with frontmatter:

```markdown
---
name: deploy-to-prod
description: Build and deploy to production with checks
trigger: deploy
---

# Deploy to Production

Safely deploys the application with pre-flight and post-flight checks.

## Workflow

1. Run tests to verify code quality
2. Build production bundle
3. Run smoke tests against bundle
4. Deploy to production server
5. Run post-deploy health checks

## Safety Checks

- ✓ Tests must pass
- ✓ No uncommitted changes
- ✓ Branch is up-to-date
- ✓ Staging deployment succeeds first
```

### 3.4 Skills vs Agents

| Aspect | Skill | Agent |
|--------|-------|-------|
| **Scope** | Single focused task | Multi-step reasoning |
| **Duration** | Seconds to minutes | Minutes to hours |
| **Output** | Deterministic result | Conversational response |
| **Trigger** | `/command` slash command | Programmatic call |
| **Context** | Inherits session context | Can request more context |
| **Error handling** | Explicit, structured | Reasoning-based recovery |

### 3.5 Best Practices

**DO:**
- ✓ Keep skills focused on one task
- ✓ Validate all inputs explicitly
- ✓ Provide clear success/failure messages
- ✓ Make skills idempotent (safe to run twice)
- ✓ Document assumptions and requirements

**DON'T:**
- ✗ Make skills too complex (use Agents for complex logic)
- ✗ Assume perfect input (validate everything)
- ✗ Make skills stateful (they should be independent)
- ✗ Hide errors (fail loudly and explicitly)

---

## Chapter 4: Sub Agents (Reduce-Map Pattern)

Sub-agents are specialized Claude instances that run independently, enabling parallel processing, diverse perspectives, and scaling of work beyond what a single agent can handle in one context window.

### 4.1 Understanding Sub-Agents

**What is a Sub-Agent?**

A sub-agent is:
- **Independent Claude instance** with its own system prompt (specialized role)
- **Isolated from main conversation** — has fresh context window
- **Capable of parallel execution** — multiple agents run simultaneously  
- **Focused on specific task** — e.g., security auditor, performance reviewer, style checker

**Why Use Sub-Agents?**

Instead of sequential processing:
- **Parallel exploration** — Find files, search code, review from multiple angles simultaneously
- **Protecting context** — Heavy research doesn't pollute main conversation
- **Specialized perspectives** — Different experts (security, performance, style) review independently
- **Scaling work** — Process 100 files in parallel instead of sequentially
- **Independent verification** — Multiple agents verify same finding reduces false positives

### 4.2 Agent Types Available

**General Purpose Agent**
```
Role: Open-ended reasoning
Tools: All available
Use: Default for most work
Speed: Moderate (full reasoning)
```

**Code Explorer Agent**
```
Role: Fast file and symbol search
Tools: Read, grep, find
Use: Locate code, find references
Speed: Fast (search-optimized)
```

**Code Reviewer Agent**
```
Role: Audit changes for bugs
Tools: Diff, file read, analysis
Use: Security, performance, correctness review
Speed: Moderate (detailed analysis)
```

**Architect Agent**
```
Role: Design and planning
Tools: File read, analysis
Use: Create implementation plans, evaluate trade-offs
Speed: Moderate (strategic thinking)
```

### 4.3 Map-Reduce Pattern

The map-reduce pattern parallelizes work across many items:

**Map Phase:** Apply same logic to each item
```javascript
const results = await Promise.all(
  files.map(file => 
    agent(`Review ${file} for security issues`, {
      agentType: 'code-reviewer',
      schema: FINDINGS_SCHEMA
    })
  )
)
```

**Reduce Phase:** Aggregate and prioritize results
```javascript
const criticalIssues = results
  .flatMap(r => r.issues)
  .filter(issue => issue.severity === 'critical')
  .sort((a, b) => b.priority - a.priority)
```

**Real Example: Parallel Code Review**
```javascript
// Traditional: Review 50 files sequentially = 10 minutes
// Parallel: Review 50 files concurrently = 2 minutes

const reviews = await Promise.all(
  files.map(file =>
    agent(`Security review: ${file}`, {
      agentType: 'code-reviewer',
      schema: REVIEW_SCHEMA
    })
  )
)

// Consolidate and deduplicate findings
const allIssues = reviews.flatMap(r => r.issues)
const uniqueIssues = dedup(allIssues, issue => `${issue.file}:${issue.line}`)
const prioritized = uniqueIssues.sort((a, b) => 
  SEVERITY_RANKING[b.severity] - SEVERITY_RANKING[a.severity]
)
```

### 4.4 Worktree Isolation

For agents that modify files in parallel, use `isolation: 'worktree'`:

```javascript
const agents = await Promise.all(
  files.map(file =>
    agent(`Migrate ${file} to new API`, {
      isolation: 'worktree'  // Each agent gets isolated git worktree
    })
  )
)
```

**Why Worktree Isolation?**
- Prevents file conflicts when multiple agents edit simultaneously
- Each agent gets clean, isolated filesystem
- Changes can be merged safely afterward
- Automatic cleanup after completion
- No merge conflicts between parallel agents

### 4.5 Common Advanced Patterns

**Pattern: Dedup + Multi-Lens Verify**
```javascript
// 1. Multiple finders search in parallel
const allFindings = await parallel([
  agent('Find security issues'),
  agent('Find performance issues'),
  agent('Find style violations')
])

// 2. Dedup across all findings
const unique = dedup(allFindings.flat())

// 3. Each unique finding reviewed by multiple expert lenses
const verified = await parallel(
  unique.map(f => parallel([
    agent(`Security lens: ${f.title}`),
    agent(`Performance lens: ${f.title}`),
    agent(`Correctness lens: ${f.title}`)
  ]))
)

// 4. Combine verdicts - majority rules
const confirmed = unique.filter((f, i) => {
  const verdicts = verified[i]
  const positives = verdicts.filter(v => v.real).length
  return positives >= 2  // 2 out of 3 must verify
})
```

**Pattern: Loop Until Dry (Discovery)**
```javascript
const bugs = []
let dry = 0

while (dry < 2) {  // Stop after 2 consecutive rounds with no new findings
  const found = (await parallel([
    agent('Find logic errors'),
    agent('Find API misuses'),
    agent('Find null pointer issues')
  ])).flatMap(r => r.bugs)
  
  const fresh = found.filter(b => !bugs.some(existing => 
    isSame(existing, b)
  ))
  
  if (fresh.length === 0) {
    dry++
    continue
  }
  
  dry = 0
  bugs.push(...fresh)
  console.log(`Found ${bugs.length} bugs total`)
}

return bugs
```

## Chapter 5: Hooks

## Chapter 6: MCP (External Data Access)

# Part III: Harness Engineering

## Chapter 7: Headless Mode and CI/CD

## Chapter 8: Agent SDK

## Chapter 9: Plugins & Packages

## Chapter 10: End-to-End Integration


## Conclusion







