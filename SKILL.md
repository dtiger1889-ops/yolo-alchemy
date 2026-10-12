---
name: yolo-alchemy
description: Research an unrelated field, apply its mechanisms to one project, optionally sketch a prototype, and leave a speculative brief. Use when the user invokes /yolo-alchemy, asks to burn leftover usage on research, or an already configured scheduled task invokes it.
---

# yolo-alchemy -- overnight research run on leftover usage

Produce a speculative research brief without changing the target project. During an
unattended run, make routine research choices and record assumptions. If access or an
action requires user approval, skip that action and note the limitation in the brief.

## Settings

Read these from the scheduled task's prompt or the user's own instructions file
(CLAUDE.md, AGENTS.md or similar). Where nothing is set, use the default.

- **Projects folder:** where the user's projects live. Default: the folder the run
  started in.
- **Runs folder:** where every run's files go. Default: `yolo-alchemy/runs/` inside the
  projects folder. Create it if missing.
- **Stop time:** a clock time and timezone by which the brief must be written. Default:
  two hours after the run starts. This is a time budget, not an estimated completion time.
- **Skip list:** projects never to target. Default: none, plus anything that looks
  archived or is only infrastructure (backups, dotfiles, tooling for the agent itself).
- **Delivery channel and triage destination:** optional user-configured notification
  channel and task list. Default: neither; deliver through the brief and final response.

## Budget rules (read before Step 1)

This skill does not check account usage or establish a schedule. Invocation authorizes
this run; scheduling and available usage remain the user's choices.
- On ANY rate-limit or usage-limit error, stop the current step and jump to Step 4 with
  whatever exists.
- Read the clock at start and before each research or prototype step. Reserve time for
  the brief; stop optional work when the remaining budget is insufficient.
- When delegation is available and authorized, use a cheaper suitable model for bulk
  fetching or summaries; keep the pairing and brief in this session.

## Step 0 -- inspect earlier runs

List the earlier run folders in the runs folder. If you also created triage items for
them (see Step 4), count the ones still untriaged after 7 or more days and mention the
count in ONE line of tonight's notification. Never delete, move or edit an earlier run.

## Step 1 -- pick a target project

List the projects in the projects folder (a subfolder with a README, an instructions file
or a status file counts). Choose ONE, preferring a project no recent run targeted (check
the earlier run folders' names) and skipping the skip list. Read its README and any
status or to-do file. Its goals and open problems are tonight's canvas.

## Step 2 -- research a foreign field

Pick ONE field genuinely unrelated to the project: biology, logistics, psychology, game
design, materials science, urban planning, and so on. Vary it from earlier runs.
- Use web search and fetch for substantive sources such as papers or engineering
  write-ups. Start with 2-4; stop when the mechanisms have adequate support.
- Extract MECHANISMS (how the field solves its problems), not trivia.
- Save as you go: write `research.md` in tonight's run folder DURING this step, not
  after: the field, each source URL, and the mechanisms extracted. If the run dies or
  hits a limit here, that file is still the night's yield.

Tonight's run folder is `<runs folder>/<YYYY-MM-DD-HHMM>_<project>/`, using the run's start time.

## Step 3 -- pair and maybe prototype

Aim for 2-3 useful pairings: one mechanism applied to one project problem or goal.
Do not pad the brief if fewer hold up. For the most promising pairing, optionally build
a throwaway sketch inside the run folder, bounded by the remaining time budget.

Hard rules for the unattended run:
- Never write inside the target project's folder. Everything you create lives in the
  run folder.
- Never commit, branch or push in any git repository.
- Open project data read-only.

## Step 4 -- morning brief (always reached)

Write `brief.md` in the run folder: the project and the field, the supported pairings (one
paragraph each, mechanism first), what was prototyped and where, and ONE next action the
user could take if an idea lands. If a limit or the stop time cut the run short, say so
in one clause.

Then append ONE JSON line to `<runs folder>/ledger.jsonl` with: `date`, `project`,
`field`, `folder`, `mechanisms` (one clause each), `pairings` (each with `title`,
`one_line` and `status: "proposed"`), `verified` (anything actually measured), and
`sources` (the research URLs). The file is append-only. Later decisions on a pairing go in
as new lines (`event: "adopted"` or `"killed"`, the folder, one line on what), never as
edits. A month of runs then reads as one small file instead of thirty briefs.

Use the configured delivery channel only when the user authorized it. Tool availability
alone does not authorize sending messages or creating drafts. Keep delivery concise: project, field, the best idea in
everyday words, the prototype path if any, and the path to `brief.md`. With no such
configured channel, the brief and the session's final message are the delivery.

Optional triage item: if the user configured and authorized a task-list destination,
add ONE item per run pointing at the brief, so their morning
review is a one-word verdict on it.

Do not update the target project's own status files. The brief stays speculative until
the user adopts it.

## If the user replies in this session later

The run's session is the warmest context for acting on the brief. A reply like "do it"
or "build pairing 2" is ADOPTION: read the target project properly first (the run only
skimmed it), then do the work inside that project under its normal rules. When done,
record the outcome where that project records outcomes and append an `adopted` line to
the ledger. The unattended-run restrictions (no project writes, no git) end at adoption;
they protected the unattended phase, not work the user directs.
