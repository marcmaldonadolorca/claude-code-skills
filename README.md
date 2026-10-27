# Claude Code Skills

My working library of **agent skills for Claude Code**: 25 skills I use daily on my own
projects for session start-up, documentation, debugging, minimal code, model choice, web work
and for auditing and building other skills. They are written in Spanish, my working language.

This repo is the practical side of my **Anthropic Academy** credentials (21 certificates,
July 2026, including *Claude Code in Action*, *Introduction to agent skills*, *Introduction to
subagents*, *Building with the Claude API* and both *Model Context Protocol* courses).
Verify them on [LinkedIn](https://www.linkedin.com/in/marc-maldonado-lorca/details/certifications/);
the course catalogue is at [anthropic.skilljar.com](https://anthropic.skilljar.com/).

## What an agent skill is

A skill is a folder with a `SKILL.md` file: YAML front matter (`name`, `description`) plus
Markdown instructions, and optionally `references/` or `scripts/`.

- At session start Claude Code reads **only the `name` and `description`** of every installed
  skill. The description is the trigger, so it says *when* to use the skill, in the words a
  real request would use.
- When a request matches, Claude loads the body. You can also call a skill by typing `/name`.
- The body links to reference files that are read only when needed (progressive disclosure),
  so a long design guide costs nothing until it is used.

## Highlights

Usage numbers are explicit invocations of each skill found in the ~1,500 Claude Code session
transcripts kept on my machine (21 Sep – 27 Oct 2026), deduplicated by tool-call id. They
undercount: a skill that is active by default or read as a file is not always an invocation.

| Skill | Description (translated) | Problem it solves | Evidence |
|---|---|---|---|
| [`orquestador`](skills/orquestador/SKILL.md) | Loads on demand the library skills (not listed) that a task needs. | Every listed skill costs context on every turn, and tool choice gets worse as the list grows. In this repo's example config only 11 skills stay listed; the rest are loaded by reading their file. A script regenerates its table from `settings.json`. | In my full setup (46 skills), the skill listing went from ≈5.9k to ≈1.5k tokens per turn, measured with `/skill-doctor` (Oct 2026). |
| [`skill-auditor`](skills/skill-auditor/SKILL.md) | Audit an external skill, plugin or agent before adopting it: permissions, scripts, prompt injection, secrets, real value. | Community skills are a supply-chain risk, and the usual attack is plain instructions hidden in `SKILL.md`. It ends in one of four verdicts: adopt, adapt, recreate or reject. | Third-party skills I installed went through it first, for example Cloudflare's security audit, GreenSock's official GSAP skills, and the design and Obsidian skills by Emil Kowalski and kepano. |
| [`skill-builder`](skills/skill-builder/SKILL.md) | Turn a recurring need into a new skill: template, a description that triggers, progressive disclosure, activation test. | Skills that never trigger, or that teach what the model already does. It starts from a baseline run without the skill, TDD-style. | 2 invocations. The library itself follows its template. |
| [`arrancar-sesion`](skills/arrancar-sesion/SKILL.md) | Start a session without re-explaining context: a briefing from the source of truth plus live state. | Each new chat starts from zero. It routes to the right project, reads only the live fields, checks git and processes only when relevant, and returns a briefing of at most 15 lines. | My most used skill: 23 invocations. |
| [`documentar-cambio`](skills/documentar-cambio/SKILL.md) | Update the source of truth after an accepted change: state, history, tasks, decisions, services, report. | Docs drift away from reality. A ticket can only be ticked with evidence, STATE and TASKS are fixed in the same pass, and each lesson gets a guard (test, check or hook) before it gets a note. | 14 invocations and 18 direct loads. In my setup a Stop hook blocks the session end once if the close-out is missing. |
| [`debug-sistematico`](skills/debug-sistematico/SKILL.md) | Debugging with a mandatory root cause before any fix. | Patch-on-patch debugging. One hypothesis at a time, a failing reproduction before the fix, and a hard stop after 3 failed fixes to question the design. | 3 invocations. Recreated from obra/superpowers. |
| [`codigo-minimo`](skills/codigo-minimo/SKILL.md) | Minimal-code discipline when writing, refactoring or reviewing: does it need to exist (YAGNI)? stdlib and native features before dependencies. | Over-engineering by default. It climbs a 7-step ladder and has a one-line-per-finding review mode (`borrar:` / `stdlib:` / `nativo:` / `yagni:` / `encoger:`, meaning delete, stdlib, native, yagni, shrink). | 4 invocations. Adapted from ponytail (MIT). |
| [`elegir-modelo`](skills/elegir-modelo/SKILL.md) | Recommends which model (Opus, Sonnet or Haiku) and effort level a task deserves, and warns when to switch mid-task. | Session limits and cost. Cheap models gather, Opus verifies; anything involving money or irreversible changes never goes below Opus. | Written after a 20-agent workflow lost 7 agents to the session limit. |

## Catalogue

**Always listed** (description loaded every turn): `arrancar-sesion`, `documentar-cambio`,
`nuevo-proyecto`, `skill-auditor`, `skill-builder`, `debug-sistematico`, `codigo-minimo`,
`diseno-fundamentos`, `portfolio-tecnico`, `caveman-token-economy`, `orquestador`.
**Library** (loaded on demand through `orquestador` or `/name`): the rest.

| Area | Skill | What it does |
|---|---|---|
| Workflow | `arrancar-sesion` | Session briefing from the project's source of truth |
| | `documentar-cambio` | Close-out: state, tasks, decisions, history, lessons |
| | `nuevo-proyecto` | Standard project skeleton, registered in a workspace index |
| | `project-memory` | Decides where a piece of information should live (CLAUDE.md, skill, docs, ADR, nowhere) |
| | `decision-log` | Lightweight ADRs with an explicit rollback |
| | `context-compressor` | Compresses long input (chats, logs, docs) without losing decisions or errors |
| | `caveman-token-economy` | Compressed output modes and hand-off summaries (adapted from caveman) |
| | `prompt-improver` | Turns a vague prompt into a complete brief, tuned per engine (Claude, Codex, local 14B) |
| | `elegir-modelo` | Model and effort choice per task |
| Skills about skills | `orquestador` | Tiered loading of the library |
| | `skill-auditor` | Security and value audit of third-party skills |
| | `skill-builder` | Writing a new skill, baseline first |
| | `skill-refiner` | Symptom-to-fix table for skills that misfire or bloat |
| | `skill-finder` | Finding and grading candidate skills in the ecosystem |
| | `repo-intake` | Read-only analysis of an unknown repo before running anything |
| Code | `debug-sistematico` | Root cause before fix |
| | `codigo-minimo` | Minimal code and anti-complexity review |
| | `portfolio-tecnico` | Turning a project into a clean public repo |
| Web | `diseno-fundamentos` | Typography, colour, layout, interaction and "looks AI-made" bans (adapted from impeccable, Apache-2.0) |
| | `web-proyecto-nextjs` | Next.js + strict TypeScript + Tailwind + shadcn/ui conventions |
| | `web-landing-cliente` | Client brief to a converting landing page, no invented content |
| | `web-auditoria` | Accessibility, technical SEO, performance and pre-launch audit |
| | `web-motion` | Reference to motion spec to scroll-driven animation, with reduced-motion fallbacks |
| ML | `dl-rag-agentes` | Local RAG and agents (Qdrant + Ollama): chunking, citation, recall@k evaluation |
| | `dl-entrenamiento-gpu` | Reproducible training and LoRA fine-tuning on a 16 GB GPU |

## Install

Requires Claude Code. The installer is Bash and uses GNU `find`; it was tested on Linux. On
macOS, copy the folders by hand.

```bash
git clone https://github.com/marcmaldonadolorca/claude-code-skills
cd claude-code-skills
./install.sh list                                        # catalogue
./install.sh install --global all                        # symlinks into ~/.claude/skills
./install.sh install --project ../my-app debug-sistematico codigo-minimo
./install.sh status                                      # what is installed, broken links
```

It creates symlinks, never copies, so editing the repo updates every installation. It refuses
to overwrite anything that is not its own link. Without the script, copy a skill folder into
`~/.claude/skills/` (global) or `<project>/.claude/skills/` (per project).

**Optional tiering:** merge `examples/settings.skillOverrides.json` into
`~/.claude/settings.json`. Library skills then stop appearing in the listing, and
`orquestador` loads them on demand. If you change the tiers, regenerate its table:

```bash
tools/gen-orquestador.py            # rewrites the table in skills/orquestador/SKILL.md
tools/gen-orquestador.py --check    # exit 1 if the table is stale (for CI)
```

## How the skills are written

- The `description` says **when** to use the skill, using the words of real requests.
- Body order: purpose → inputs (stop if a critical one is missing) → rules →
  steps (*read → dry-run → mutate*) → checks/evidence → rollback → what to document.
- Bodies stay under 150 lines where possible and never above 500. Long material goes to
  `references/`. A template is in [`templates/SKILL.template.md`](templates/SKILL.template.md).
- Evidence over claims: a step is done when there is output to show for it.

Several skills assume a simple workspace convention: a `PROJECTS.md` index, and in each repo
`PROJECT_STATE.md`, `TASKS.md`, `DECISIONS.md`, `reports/`, plus `CLAUDE.md` and
`SAFETY_RULES.md` for hard rules. Adapt the names to your own setup.

## What is not here, and limitations

- **Private skills stay private.** 21 skills from my library are left out: the ones that
  operate my own servers, backups, credentials, personal finances and personal content
  pipelines, plus unmodified third-party skills (credited and linked in
  [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md)).
- **Generalised for publication.** Personal paths, host names and private tooling were removed
  from the published versions. The procedures are the same; steps that relied on private tools
  are written in generic form. The usage numbers above were measured on my private copies.
- **Spanish.** The skills are in Spanish, my working language. Descriptions of the highlights
  are translated above.
- **No automated activation tests** in this repo. `skill-builder` describes the manual check
  I run.

## Licence

MIT, see [`LICENSE`](LICENSE). The exception is `skills/diseno-fundamentos/`, which adapts
Apache-2.0 material and ships its own `LICENSE` and `NOTICE.md`. Third-party credits are in
[`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).
