# Agent Instructions (Global)

Last updated: 03/02/2026

This file defines baseline guidance for AI coding assistants working in this workspace. It is intentionally broad; projects may add stricter, more specific rules in their own `AGENTS.md`.

This file is global, as such it should be kept generic. It is also a living document and should be updated over time as you gain a more detailed understanding and workflow,

## Instruction Precedence

1. System/tool instructions (e.g., the runtime harness you are operating under)
2. The closest project/directory `AGENTS.md` to the files you will change
3. This file

If instructions conflict, ask for clarification and proceed conservatively.

If the user/prompt directly conflicts with any of these clarify, and offer to add an exception/clarification to the closest `AGENTS.md`

When given feed

## Working Method (Default)

- **Discover**: identify the project root and read `AGENTS.md`, `README.md`, and the primary build/test entry points (e.g., `Makefile`, `CMakeLists.txt`, `go.mod`, `pyproject.toml`, CI config).
- **Clarify**: confirm requirements, constraints, and acceptance criteria before making broad changes.
- **Implement**: prefer the smallest change that fixes the root cause; avoid drive-by refactors.
- **Validate**: run the most relevant formatter/linter/tests/build steps; record the exact commands and results.
- **Communicate**: summarise what changed, why, and any risks or follow-ups.

## Language and Communication

- **British English only** for all prose: docs, comments, commit messages, PR text, user-facing strings.
- Date format: **DD/MM/YYYY** (e.g., 03/02/2026). Use 24-hour time where relevant (e.g., 15:37).
- Keep communication professional and concise; avoid slang and emojis.
- Use SI units unless a project explicitly uses alternatives.

## Safety, Security, and Compliance

- Never add or commit secrets (API keys, tokens, credentials). Use environment variables or approved secret stores.
- Do not run privileged or destructive operations without explicit confirmation (e.g., `sudo`, flashing, `rm -rf`, force pushes, `git reset --hard`).
- Treat hardware interaction as safety-critical: confirm target device, configuration, and rollback steps before flashing or applying power.
- Validate all external inputs (files, network payloads, CAN frames, serial, config) and avoid logging sensitive data.

## Repository Hygiene

- Follow existing code style and project conventions; do not introduce new tooling/dependencies unless necessary and justified.
- Keep generated artefacts out of git; follow `.gitignore` and existing patterns (`build/`, `bin/`, `.venv/`, etc.).
- Generated code: do not hand-edit. Modify the source (schemas/YAML/templates), regenerate using the project’s documented process, and commit regenerated outputs only if the repo expects them.
- Git submodules: treat as pinned dependencies. Avoid editing submodule contents unless asked; prefer updating via a submodule revision bump.
  - The exception to this is `aq-standard-definitions` this reporistory is used frequently as a submodule and can be updated whenever necessary (following generated code guidelines).

## Version Control

- Commit messages: imperative mood and consistent with the project’s existing convention (e.g., Conventional Commits if already used).
- Keep commits atomic and scoped; explain *why* as well as *what*.
- Keep commits concise. A oneline is fine for simple/obvious changes
- Reference issue/ticket numbers when applicable.

## Builds, Tests, and Timeouts

- Prefer the project’s own entry points (`make`, `just`, `task`, `scripts/…`) over ad-hoc commands.
  - Always check for a `Makefile`, if it exists use it. If you are, or will be, frequently using a command, offer to add it to `Makefile`
- Never cancel a build/test simply because it is slow. If a command may take time, state an expected duration and set a generous timeout (2–5× normal).
- If tests do not exist, perform a reasonable manual verification and document what you ran/observed.
- `aq-*` Are all Aquila projects. These will frequently use git submodules and Python-based code generation (notably `aq-standard-definitions`). Prefer the repo-provided targets (commonly `make deps` / `make generate`) rather than running scripts manually.

## Technology-Specific Guidance (High Level)

### Embedded C/C++ / Firmware

- Follow the project’s chosen standard (often C++23). Use RAII, and keep allocation and blocking operations out of hot paths/ISRs unless the project explicitly permits it.
- Look for clang dotfiles (`.clang-tidy`, `.clang-format`, `.clangd`) and follow their guidelines.
- Be careful with interrupt context, DMA/volatile semantics, timing, and numerical stability.
- Prefer conservative safety limits; document and justify any changes to limits, calibration, or protection behaviour.
- STM32 Projects should *ALWAYS* use CubeMX generation, respect this.

### Go

- If a Makefile doesn't exist, format with `gofmt`/`go fmt`. Validate with `go test ./...` and `go vet ./...` (or project Makefile targets).
- Use `context.Context` for cancellation and timeouts. Avoid global mutable state unless unavoidable and well-encapsulated.

### Python

- Use virtual environments where appropriate (`python3 -m venv venv`).
- Prefer type hints for non-trivial logic and run the project’s formatter/linter/test suite if configured.

### Services / System Integration

- Keep services least-privilege. Document install/enable steps (e.g., systemd), required env vars, and logging/metrics configuration.
- Avoid hard-coded absolute paths; use config files and standard locations.

## Project-Level `AGENTS.md` Template

Create a project-level `AGENTS.md` in the repo root and include only what is true for that project below are some steps to follow and a template:

- Always start by listing the directory and exploring tools
  - Check programming languages, attempt to use `tokei` to analyse the repository
  - Check for submodules
  - Check README.md files

```markdown
# <Project Name> Agent Instructions

> Project overrides for the global `AGENTS.md`. This project is modular and optimised for rapid iteration.

## 1) Context
**Purpose:** [1–2 sentences]
**Target:** STM32 [family/part], board [name]
**Stack:** CubeMX + [CubeIDE/GCC ARM/CMake/Make], C++[20/23], [Go/Python tools]

## 2) Clarify-First (Stop and ask before proceeding)
Ask the user before changes that involve:
- clock tree / power modes / RCC
- linker script / memory layout / sections
- bootloader/DFU/OTA/flash erase/write routines
- interrupt priorities, DMA setup, timing-critical paths
- protocol changes that affect compatibility

If acceptance criteria are unclear, propose 2 options with trade-offs.

## 3) CubeMX Rules (Non-negotiable)
- If a project has a `hal.c` file, then this is a replacement of the generated `main.c` this is to allow a `main.cpp` entrypoint, generated files should be pointed to this rather than `hal.c/.h`
- Treat generated code as **read-only**.
- Only modify within approved extension points: [USER CODE blocks / wrappers in `<path>`].
- Source of truth: `<project>.ioc`
- Regeneration should always be done by the user. provide clear reasoning when this should be done.
- After regen: review `git diff` and ensure only expected files changed.

## 4) Repo Map (Where to edit)
- App code (C++): `<path>`
- HAL wrappers/adapters: `<path>`
- CubeMX generated: `<path>`
- Protocol defs: `<path>`
- Tooling (Go): `<path>`
- Tooling (Python): `<path>`
- Build entrypoint: `<path>` (Makefile/CMake/etc.)

## 5) Build / Flash / Run (Copy-paste)
```bash
# Build
<exact command>

# Flash (confirm board/debugger first)
<exact command>

# Serial monitor
<exact command>
````

## 6) Verification (Realistic)

- Go (if applicable):

```bash
go test ./...
go vet ./...
```

- Firmware: build must succeed.
- If no tests cover the change: record a manual smoke check (what you did + observed output).

## 7) Never

- Don’t commit secrets.
- Don’t disable safety checks/watchdogs to “fix” behaviour.
- Don’t hand-edit CubeMX output outside approved extension points.

```
