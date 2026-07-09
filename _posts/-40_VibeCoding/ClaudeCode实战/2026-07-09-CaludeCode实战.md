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

Skills are reusable slash commands that Claude Code can invoke to accomplish specific tasks. They're like CLI tools for Claude — modular functions that encapsulate domain-specific logic.

### 3.1 What Are Skills?

A skill is a self-contained function that:
- Takes user input (args)
- Runs independently (in isolation or in the main session)
- Returns structured output
- Can be triggered via `/<skill-name>` or invoked programmatically

**Built-in Skills** (available by default):
- `/verify` — test changes end-to-end
- `/run` — launch and drive the app
- `/code-review` — review diff for bugs
- `/simplify` — optimize code for readability
- `/loop` — run a command on recurring interval
- `/deep-research` — multi-source fact-checking research
- `/dataviz` — create charts and visualizations

### 3.2 Creating Custom Skills

Skills are defined in `.claude/skills/` directory as markdown files with frontmatter:

```markdown
---
name: format-code
description: Auto-format code using project's linter
trigger: format
---

# Format Code

This skill runs the project's code formatter and reports results.

## Steps

1. Run linter with --fix flag
2. Check for formatting errors
3. Report summary of changes

## Example

User types: `/format`
Result: Code formatted, summary displayed
```

### 3.3 Skill vs Agent

| Aspect | Skill | Agent |
|--------|-------|-------|
| **Scope** | Single focused task | Multi-step reasoning |
| **Isolation** | Optional (can run in session) | Full isolation |
| **Output** | Structured or text | Conversational |
| **Trigger** | Slash command (`/`) | Programmatic call |
| **Persistence** | Lives in `.claude/skills/` | Spawned on demand |
| **Parallelization** | No | Yes (via Workflow) |

### 3.4 Common Skill Patterns

**Linting & Formatting**
```bash
# .claude/skills/lint.md
- Run project linter with --fix
- Report errors and fixes
- Suggest code improvements
```

**Testing**
```bash
# .claude/skills/test.md
- Run project test suite
- Report pass/fail
- Show coverage delta
```

**Build & Deploy**
```bash
# .claude/skills/deploy.md
- Build production bundle
- Run smoke tests
- Deploy to staging/prod
```

---

## Chapter 4: Sub Agent (Reduce-map)

## Chapter 5: Hooks

## Chapter 6: MCP (External Data Access)

# Part III: Harness Engineering

## Chapter 7: Headless Mode and CI/CD

## Chapter 8: Agent SDK

## Chapter 9: Plugins & Packages

## Chapter 10: End-to-End Integration


## Conclusion







