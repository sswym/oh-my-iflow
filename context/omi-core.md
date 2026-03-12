# omi Core Context

This extension provides a multi-agent workflow layer for iFLOW CLI.

## Core Principles

1. Keep prefixes stable.
- Avoid rewriting static instructions during a session.
- Put changing details in the latest user message.

2. Plan before coding on non-trivial tasks.
- Use planning first, then execution, then review.
- Keep each phase explicit and verifiable.

3. Delegate by role.
- Use `omi-director` for team-level orchestration and conflict resolution.
- Use `omi-architect` for design and tradeoffs.
- Use `omi-planner` for task decomposition.
- Use `omi-product` for PRD-quality scope and acceptance criteria.
- Use `omi-consultant` for strategic criteria and recommendation framing.
- Use `omi-executor` for implementation.
- Use `omi-reviewer`, `omi-verifier`, and `omi-debugger` for quality and recovery.
- Use `omi-editor` for final output packaging.

4. Minimize context load.
- Read only files needed for the current step.
- Summarize before handing off to another agent.

5. Always finish with validation.
- Run relevant tests and checks when possible.
- Report changed files, known risks, and next actions.

6. Gate intent before execution when scope is unclear.
- Use `intent` to classify whether the task should go to planning, PRD, execution, verification, or research.
- Do not jump to implementation if acceptance criteria are missing.

7. Assemble a fit-for-task team before stage execution when needed.
- Use `team-assemble` to map domain specialists and format specialists.
- Require explicit approval before starting autonomous team execution.

8. Keep loop discipline for incomplete work.
- Use `loop` to continue `team-exec -> team-verify -> team-fix` cycles.
- Do not mark done while blocker/major items remain.

## Team Pipeline Stages

Use this stage order for complex work:

0. `team-assemble` - build and confirm a task-fit multi-role roster
1. `team-plan` - decompose and map dependencies
2. `team-prd` - lock scope, constraints, and acceptance criteria
3. `team-exec` - implement one validated slice at a time
4. `team-verify` - run correctness/regression checks
5. `team-fix` - patch only issues found in verification

Repeat `team-exec -> team-verify -> team-fix` until acceptance criteria pass or a blocker is escalated.

## Intake and Rule Controls

- `intent`: request-intent gate and stage routing.
- `team-assemble`: dynamic roster planning with approval gate before execution.
- `rules`: conditional rule-pack activation (`tests-required`, `migration-safety`, `security-review`, `docs-sync`, `perf-watch`).
- `memory`: maintain durable memory index (`MEMORY.md`) and modular rule packs (`.omi/rules/*.md`).
- `deep-init`: one-time deep repository mapping before long sessions.
- `loop`: strict continuation loop for unresolved acceptance criteria.
- `hud`: visual status profile control (`normal`, `compact`, `hidden`) for `/omi:status`.
- `hooks`: extension-native hook trigger/policy control for deterministic lanes and safer autonomous loops.
- `reasoning`: reasoning effort profile (`low`, `medium`, `high`, `xhigh`) to tune depth/cost posture.
- `approval`: approval posture (`suggest`, `auto`, `full-auto`) for autonomous action confirmation policy.
- `doctor`: readiness diagnostics for command/skill/state integrity and team safety posture.
- `cancel`: alias lifecycle stop path with resume-ready handoff.

## Operating Modes

- `balanced` (default): stable quality/speed mix.
- `speed`: favor short cycles and narrower diffs.
- `deep`: favor design depth and stricter verification.
- `autopilot`: iterative multi-stage execution until done/blocker.
- `ralph`: strict quality-gated orchestration with no skipped verify gate.
- `ultrawork`: throughput mode for many independent or batchable tasks.

## Runtime State Conventions

When filesystem tools are available, persist current workflow state:

- `.omi/state/mode.json`
- `.omi/state/workflow.md`
- `.omi/state/checkpoint.md`
- `MEMORY.md`
- `.omi/memory/*.md`
- `.omi/rules/*.md`
- `.omi/state/intent.md`
- `.omi/state/team-assembly.md`
- `.omi/state/rules.md`
- `.omi/state/deep-init.md`
- `.omi/state/project-map.md`
- `.omi/state/validation.md`
- `.omi/state/hud.json`
- `.omi/state/hooks.json`
- `.omi/state/hooks-validation.md`
- `.omi/state/hooks-last-test.md`
- `.omi/state/reasoning.json`
- `.omi/state/approval.json`
- `.omi/state/doctor.md`
- `.omi/hooks/*.md`

If these files do not exist, create them only when a mode/lifecycle command is explicitly requested.

## Global Configuration

Centralized configuration for omi runtime behavior. Persist in `.omi/state/config.json`:

```json
{
  "loopLimits": {
    "default": 5,
    "speed": 3,
    "deep": 10,
    "autopilot": 5,
    "ralph": -1
  },
  "stateDir": ".omi/state",
  "memoryDir": ".omi/memory",
  "rulesDir": ".omi/rules",
  "hooksDir": ".omi/hooks"
}
```

### Loop Limit Configuration

| Mode | Max Cycles | Description |
|------|------------|-------------|
| `default` | 5 | Standard iteration limit |
| `speed` | 3 | Faster cycles for simple tasks |
| `deep` | 10 | Extended for complex analysis |
| `autopilot` | 5 | Autonomous execution limit |
| `ralph` | -1 | Unlimited until validation passes |

### State Directory Structure

```
.omi/
├── state/
│   ├── config.json      # Global configuration
│   ├── mode.json        # Current operating mode
│   ├── workflow.md      # Workflow state
│   ├── checkpoint.md    # Checkpoint records
│   ├── intent.md        # Intent classification
│   ├── hud.json         # HUD visibility profile
│   ├── hooks.json       # Hook configuration
│   ├── reasoning.json   # Reasoning effort profile
│   └── approval.json    # Approval posture
├── memory/              # Topic memory files
├── rules/               # Rule packs
└── hooks/               # Hook records
```

## Safety Rails

- Never claim completion without listing what was validated.
- Never claim completion while `loop` status is `continue` or unresolved blockers remain.
- Stop autonomous loops when blocked by missing requirements, missing permissions, or repeated failures.
- Default maximum autonomous cycles: 5 unless user requests a different limit.
- Keep side-effect hooks disabled in delegated worker sessions unless user explicitly opts in.