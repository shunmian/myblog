---
layout: post
title: Claude Code 实战
categories: [-40 VibeCoding]
tags: [VibeCoding, ClaudeCode, Codex]
number: [-0.0]
fullview: false
shortinfo: 详细了解ClaudeCode Agentic Harness

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

Sub-agents are specialized AI workers that can run in parallel or sequence. They're the core of scalable, multi-perspective analysis.

### 4.1 What Are Sub-Agents?

A sub-agent is:
- A Claude instance with its own system prompt (specialized role)
- Isolated from the main conversation
- Able to run in parallel with other agents
- Returning structured output or text

**When to use sub-agents:**
- Parallel exploration (find files, search code, review from multiple angles)
- Protecting context (heavy research doesn't pollute main conversation)
- Specialized perspectives (security reviewer, performance auditor, style checker)
- Scaling work (processing many items concurrently)

### 4.2 Available Agent Types

**General Purpose**
```
agent: claude (default)
- All tools available
- General reasoning
- Use for open-ended tasks
```

**Code Explorer**
```
agent: Explore
- Fast read-only search
- Finding files and symbols
- Cross-file references
```

**Code Reviewer**
```
agent: code-reviewer
- Audit changes for bugs
- Security review
- Performance optimization
```

**Architect**
```
agent: Plan
- Design implementation plans
- Architectural decisions
- Trade-off analysis
```

### 4.3 Map-Reduce Pattern

The map-reduce pattern parallelizes work across items:

**Map:** Apply same logic to each item
```javascript
const results = await Promise.all(
  files.map(file => agent(`Review ${file}`, {schema: FINDINGS}))
)
```

**Reduce:** Aggregate results
```javascript
const allFindings = results.flat()
  .filter(r => r.severity === 'critical')
  .sort((a, b) => b.severity - a.severity)
```

### 4.4 Sub-Agent Example

```javascript
// Find and review React components in parallel
const components = ['Button.tsx', 'Card.tsx', 'Modal.tsx']

const reviews = await Promise.all(
  components.map(comp => 
    agent(`Review ${comp} for accessibility and performance`, {
      schema: REVIEW_SCHEMA,
      agentType: 'code-reviewer'
    })
  )
)

// Combine results
const issuesFound = reviews
  .flatMap(r => r.issues)
  .sort((a, b) => b.severity - a.severity)

return issuesFound
```

### 4.5 Isolation & Worktrees

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

Each agent gets a temporary git worktree, preventing file conflicts.

---

## Chapter 5: Hooks

Hooks are automatic commands that run in response to events (before/after tool calls, on startup, etc.). They enable deterministic automation without user intervention.

### 5.1 Hook Types

**Startup Hooks**
```yaml
# hooks > startup > bash
- echo "Initializing project..."
- npm install
- docker-compose up -d
```
Runs once when Claude Code starts.

**Pre-Commit Hooks**
```yaml
# hooks > git-pre-commit > bash
- npm run lint
- npm test
```
Runs before `git commit`.

**Post-Tool Hooks**
```yaml
# hooks > tool-after > bash (on Bash tool calls)
- Check tool output for errors
- Log execution
- Trigger dependent operations
```

**Custom Event Hooks**
```yaml
# hooks > {custom-event} > bash
- Triggered programmatically
- Can chain multiple hooks
```

### 5.2 Hook Configuration

Hooks are configured in `.claude/settings.json` or `.claude/settings.local.json`:

```json
{
  "hooks": {
    "startup": {
      "bash": "npm install && npm run setup"
    },
    "git-pre-commit": {
      "bash": "npm run lint && npm test"
    }
  }
}
```

### 5.3 Hook Best Practices

**DO:**
- Keep hooks fast (< 10 seconds)
- Make them idempotent (safe to run multiple times)
- Log what they're doing
- Fail loudly (exit with non-zero on error)

**DON'T:**
- Run interactive commands (prompts block)
- Make network requests (uncertain latency)
- Modify files without user consent
- Chain too many hooks (degraded startup)

### 5.4 Common Hook Patterns

**Format on Commit**
```bash
npm run lint:fix && npm run format
```

**Run Tests Before Commit**
```bash
npm test -- --bail
```

**Build & Verify**
```bash
npm run build && npm run verify
```

---

## Chapter 6: MCP (External Data Access)

MCP (Model Context Protocol) enables Claude Code to access external systems: databases, APIs, file systems, version control, and more.

### 6.1 What Is MCP?

MCP is a protocol for Claude to:
- Query databases (SQL, NoSQL)
- Call external APIs
- Access file systems (remote or local)
- Interact with Git repositories
- Run shell commands safely

Think of it as "Claude's extension ecosystem" — plugins that extend Claude's capabilities beyond code.

### 6.2 Built-in MCP Servers

**Git Server**
```bash
# Access git history, blame, branches
git log --oneline
git blame src/utils.ts
```

**Bash/Shell Server**
```bash
# Safe shell command execution
npm test
docker ps
```

**File System Server**
```bash
# Read/write files safely
read: /path/to/file
write: /path/to/file
```

**Database Servers**
```bash
# Query databases (PostgreSQL, MySQL, etc.)
SELECT * FROM users LIMIT 10;
```

### 6.3 Configuring MCP Servers

MCP servers are configured in `.claude/settings.json`:

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgres://user:pass@localhost/dbname"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "/Users/lal/Documents"]
    }
  }
}
```

### 6.4 MCP Use Cases

**Database Queries**
```sql
-- Claude queries your database through MCP
SELECT COUNT(*) FROM orders WHERE status = 'pending'
```

**API Integration**
```javascript
// MCP calls external API
const response = await fetch('https://api.service.com/data')
```

**File Operations**
```bash
# MCP reads files with context
read: /project/src/critical-config.json
```

**Version Control**
```bash
# MCP queries git history
git log --since="2026-07-01" --oneline
```

### 6.5 Security & Permissions

MCP connections are protected:
- **Scoped access** — only allowed paths/databases
- **Read-only by default** — writes require approval
- **Audit logging** — track all MCP operations
- **Credential management** — secrets stored securely

Configure permissions in `.claude/settings.json`:

```json
{
  "permissions": {
    "bash": "always",  // Allow all bash commands
    "read": "always",   // Allow reading any file
    "write": "prompt"   // Ask before writing
  }
}
```

---

**Sources:**
- [Claude Code Official Docs — Skills & Agents](https://claude.ai/docs)
- [MCP Specification — Anthropic](https://anthropic.com/mcp)
- [Sub-Agent Patterns — GitHub](https://github.com/anthropics/claude-code-mastery)

# Part III: Harness Engineering

## Chapter 7: Headless Mode and CI/CD

Headless mode allows Claude Code to run in CI/CD pipelines without user interaction, enabling automated code generation, testing, and deployment.

### 7.1 What Is Headless Mode?

Headless mode is Claude Code running without:
- Interactive prompts
- Human input
- GUI/terminal UI
- Real-time feedback loops

**Use cases:**
- Automated code reviews in pull requests
- Nightly code generation and refactoring
- Continuous migration automation
- Scheduled testing and validation
- Build pipeline integration

### 7.2 Running Claude Code Headless

Via CLI:
```bash
claude code run --cwd /path/to/project --prompt "Add error handling to all API routes"
```

Via API:
```javascript
const client = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY
})

const response = await client.messages.create({
  model: 'claude-opus-4-8',
  max_tokens: 4096,
  system: fs.readFileSync('CLAUDE.md', 'utf-8'),
  messages: [{
    role: 'user',
    content: 'Fix all type errors in src/'
  }]
})
```

### 7.3 GitHub Actions Integration

Example workflow for automated code review:

```yaml
# .github/workflows/code-review.yml
name: Code Review
on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: anthropics/claude-code@v1
        with:
          api-key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Review the diff for this PR:
            - Check for security issues
            - Look for performance problems
            - Verify error handling
          post-comment: true
```

### 7.4 Headless Limitations

**Cannot do:**
- Interactive debugging (no REPL, no stepping)
- Real-time file watching
- GUI-based exploration
- User confirmation dialogs

**Workarounds:**
- Provide full context upfront (read CLAUDE.md)
- Use structured output schemas for deterministic results
- Break large tasks into smaller headless runs
- Implement approval gates for sensitive operations

### 7.5 Best Practices

**✓ DO:**
- Use CLAUDE.md to provide context
- Provide structured schemas for output
- Break work into small, focused tasks
- Log all operations for audit trail
- Set timeouts for long-running tasks

**✗ DON'T:**
- Expect interactive debugging
- Run without CLAUDE.md
- Ask for user confirmation
- Chain many sequential operations
- Rely on real-time file watching

---

## Chapter 8: Agent SDK

The Claude Agent SDK enables building custom AI agents that operate on your codebase with full tool access.

### 8.1 Agent Architecture

```
┌─────────────────────────────────────────┐
│     Your Application                    │
├─────────────────────────────────────────┤
│     Agent Layer                         │
│  ┌────────────────────────────────────┐ │
│  │ System Prompt (CLAUDE.md)          │ │
│  │ User Input → Reasoning → Actions   │ │
│  │ Loop until task complete           │ │
│  └────────────────────────────────────┘ │
├─────────────────────────────────────────┤
│     Tool Layer                          │
│  • Read/Write Files                    │
│  • Execute Bash                        │
│  • Call External APIs                  │
│  • Query Databases (MCP)               │
└─────────────────────────────────────────┘
```

### 8.2 Building with Agent SDK

```javascript
import Anthropic from "@anthropic-ai/sdk"

const client = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
})

// Agent loop
async function runAgent(task) {
  const messages = []
  
  while (true) {
    // Get Claude's response
    const response = await client.messages.create({
      model: 'claude-opus-4-8',
      max_tokens: 4096,
      system: 'You are a code assistant...',
      tools: [
        {
          name: 'read_file',
          description: 'Read a file',
          input_schema: {...}
        },
        {
          name: 'write_file',
          description: 'Write to a file',
          input_schema: {...}
        }
      ],
      messages: [...messages, {role: 'user', content: task}]
    })

    // Check if done
    if (response.stop_reason === 'end_turn') {
      return response.content
    }

    // Process tool calls
    for (const block of response.content) {
      if (block.type === 'tool_use') {
        const result = await executeTool(block.name, block.input)
        messages.push({
          role: 'assistant',
          content: response.content
        })
        messages.push({
          role: 'user',
          content: [{
            type: 'tool_result',
            tool_use_id: block.id,
            content: result
          }]
        })
      }
    }
  }
}

await runAgent('Fix all TypeScript errors in src/')
```

### 8.3 Tool Runner Pattern

```javascript
// Simplified tool runner
const toolRunner = {
  read_file: (path) => fs.readFileSync(path, 'utf-8'),
  write_file: (path, content) => fs.writeFileSync(path, content),
  bash: (cmd) => execSync(cmd, {encoding: 'utf-8'}),
  list_files: (dir) => fs.readdirSync(dir)
}

async function executeTool(name, input) {
  if (!toolRunner[name]) throw new Error(`Unknown tool: ${name}`)
  return await toolRunner[name](input)
}
```

### 8.4 Common Agent Patterns

**Iterative Refinement**
```
1. Claude analyzes code
2. Claude proposes changes
3. User approves/modifies
4. Claude implements
5. Loop until satisfied
```

**Task Decomposition**
```
1. User gives high-level goal
2. Claude breaks into steps
3. Claude executes each step
4. Claude validates results
```

**Error Recovery**
```
1. Claude tries approach A
2. Error occurs
3. Claude reads error
4. Claude tries approach B
5. Continue until success
```

---

## Chapter 9: Plugins & Packages

Claude Code can be extended with plugins that add new tools, commands, and capabilities.

### 9.1 Plugin Architecture

```
┌─────────────────────────┐
│   Claude Code Core      │
├─────────────────────────┤
│   Plugin Layer          │
│ ┌─────────────────────┐ │
│ │ Plugin A (MCP)      │ │
│ │ Plugin B (Skill)    │ │
│ │ Plugin C (Hook)     │ │
│ └─────────────────────┘ │
├─────────────────────────┤
│   Marketplace           │
│ (community plugins)     │
└─────────────────────────┘
```

### 9.2 Types of Plugins

**MCP Servers**
```bash
# Database access
npm install @modelcontextprotocol/server-postgres

# File system
npm install @modelcontextprotocol/server-filesystem

# Git operations
npm install @modelcontextprotocol/server-git
```

**Skills**
```markdown
# .claude/skills/custom-skill.md
Reusable commands for specific tasks
Triggered via /command syntax
```

**Hooks**
```json
// .claude/settings.json
{
  "hooks": {
    "startup": {...},
    "git-pre-commit": {...}
  }
}
```

### 9.3 Creating a Plugin

```javascript
// plugins/my-plugin/index.js
export default {
  name: 'my-plugin',
  version: '1.0.0',
  activate(context) {
    // Register commands, hooks, MCP servers
    context.commands.register('my-command', async () => {
      // Implementation
    })
  }
}
```

### 9.4 Community Plugins

Popular plugins available:
- **Database Tools** — PostgreSQL, MongoDB, Redis adapters
- **API Clients** — REST, GraphQL, gRPC tools
- **Cloud SDKs** — AWS, GCP, Azure integrations
- **Testing** — Jest, pytest, Vitest runners
- **Linting** — ESLint, Prettier, Ruff integrations

---

## Chapter 10: End-to-End Integration

A complete example: building a feature from requirements to deployment with Claude Code.

### 10.1 Feature: User Authentication

**Requirements:**
- Add JWT-based authentication
- Protect API routes
- Add login/logout endpoints
- Store tokens securely

### 10.2 Step-by-Step Workflow

**1. Plan with Claude**
```
Prompt: "Design JWT authentication for this Express API"
- Claude creates CLAUDE.md
- Claude plans file changes
- User approves approach
```

**2. Implement with Skill**
```bash
/new-feature "Add JWT authentication"
- Creates branch
- Generates boilerplate
- Sets up project structure
```

**3. Code Generation**
```
Prompt: "Implement JWT token generation in src/auth/tokenService.ts"
- Claude writes secure code
- Adds error handling
- Includes unit tests
```

**4. Automated Testing**
```bash
/test
- Runs full test suite
- Reports coverage
- Identifies gaps
```

**5. Code Review**
```bash
/code-review
- Security checks
- Performance review
- Best practices validation
```

**6. Documentation**
```bash
/generate-docs
- API documentation
- Integration guide
- Example usage
```

**7. Deploy**
```bash
/deploy-blog (for our project)
# Or:
git push origin feature/auth
gh pr create --title "Add JWT authentication"
```

### 10.3 Real-World Flow

```
Developer starts → CLAUDE.md loaded
     ↓
/new-feature command
     ↓
Claude plans approach (Agent)
     ↓
User approves
     ↓
Claude implements (parallel Skills)
     ↓
Tests run (pre-commit Hook)
     ↓
Code Review (skill)
     ↓
Deploy (skill)
     ↓
Monitoring (MCP database access)
     ↓
Done
```

### 10.4 Integration Checklist

**Before Starting:**
- [ ] CLAUDE.md is up-to-date
- [ ] .claude/settings.json configured
- [ ] Skills are defined for common tasks
- [ ] Hooks are set for validation
- [ ] MCP servers are connected

**During Development:**
- [ ] Use `/serve-blog` or equivalent for development
- [ ] Use `/validate-posts` or equivalent for checking
- [ ] Use `/code-review` for safety checks
- [ ] Use `/test` before committing

**Before Deployment:**
- [ ] All tests pass
- [ ] Code review approved
- [ ] Documentation updated
- [ ] CLAUDE.md reflects changes
- [ ] git status is clean

**After Deployment:**
- [ ] Verify in production
- [ ] Monitor for errors
- [ ] Collect feedback
- [ ] Update CLAUDE.md for next iteration

### 10.5 Best Practices Summary

| Practice | Why |
|----------|-----|
| **CLAUDE.md first** | Ensures Claude has full context |
| **Skills for repetition** | Consistency across runs |
| **Hooks for safety** | Automated validation before commits |
| **MCP for data** | Real-time access to databases |
| **Workflows for orchestration** | Parallel processing at scale |
| **Agents for complexity** | Multi-step reasoning |
| **Headless for CI/CD** | Automated pipelines |

---

## Conclusion

Claude Code transforms software development by:
1. **Automating boilerplate** — CLAUDE.md + Skills reduce repetitive work
2. **Ensuring quality** — Hooks + Code Review catch issues early
3. **Scaling processes** — Workflows orchestrate complex tasks
4. **Accessing data** — MCP connects to your systems
5. **Enabling collaboration** — Agents work alongside developers

The key is starting with a solid CLAUDE.md, building reusable Skills, and gradually automating more of your workflow through Hooks and Workflows.

---

**Further Reading:**
- [Claude Code Official Docs](https://claude.ai/docs)
- [CLAUDE.md Format Guide](https://blog.vibecoder.me/claude-md-file-format-guide)
- [Agent SDK Documentation](https://anthropic.com/docs/agents)
- [MCP Specification](https://anthropic.com/mcp)






