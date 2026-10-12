---
name: yolo-alchemy
description: Overnight speculative research run that spends usage you would otherwise lose at your weekly reset. Picks one of your projects, researches one unrelated field, pairs that field's mechanisms with the project's open problems, optionally builds a throwaway prototype, and leaves a short morning brief. Built to run unattended from a scheduled task on the evening before your usage limit resets. Use when a scheduled run invokes it, or when the user types /yolo-alchemy or says "run yolo alchemy" / "burn my leftover usage on research".
---

# yolo-alchemy -- overnight research run on leftover usage

You may be running UNATTENDED from a scheduled task. If nobody is watching, never wait
for a reply or a click: make the reasonable call, note it in the brief, and keep going.

The idea: weekly usage that is still unspent when the limit resets is simply lost.
Spend it on cross-field research paired against the user's real projects, and leave a
short brief for the morning. The idea does not need to be perfect; it needs to show the
user one of their projects from a new angle.

## Settings

Read these from the scheduled task's prompt or the user's own instructions file
(CLAUDE.md, AGENTS.md or similar). Where nothing is set, use the default.

- **Projects folder:** where the user's projects live. Default: the folder the run
  started in.
- **Runs folder:** where every run's files go. Default: `yolo-alchemy/runs/` inside the
  projects folder. Create it if missing.
- **Stop time:** a clock time by which the brief must be written (for example, shortly
  before the weekly reset). Default: none; budget the run to about two hours.
- **Skip list:** projects never to target. Default: none, plus anything that looks
  archived or is only infrastructure (backups, dotfiles, tooling for the agent itself).

## Budget rules (read before Step 1)

This run exists to spend surplus; it must never create a shortage.
- The schedule is the budget control: it should fire on the evening before the user's
  weekly reset, when unspent usage is about to expire. Nothing in this skill reads the
  account's usage.
- On ANY rate-limit or usage-limit error, stop the current step and jump to Step 4 with
  whatever exists.
- When a stop time is set, leave enough room to write the brief before it, and scope
  Steps 2-3 down to fit.
- Send bulk, mechanical sub-agent work (fetching, summarizing sources) to a cheaper
  model; keep the pairing and the brief in this session.

## Step 0 -- close out earlier runs (about 2 minutes)

List the earlier run folders in the runs folder. If you also created triage items for
them (see Step 4), count the ones still untriaged after 7 or more days and mention the
count in ONE line of tonight's notification. Never delete, move or edit an earlier run.

## Step 1 -- pick a target project (about 5 minutes)

List the projects in the projects folder (a subfolder with a README, an instructions file
or a status file counts). Choose ONE, preferring a project no recent run targeted (check
the earlier run folders' names) and skipping the skip list. Read its README and any
status or to-do file. Its goals and open problems are tonight's canvas.

## Step 2 -- research a foreign field (30-45 minutes)

Pick ONE field genuinely unrelated to the project: biology, logistics, psychology, game
design, materials science, urban planning, and so on. Vary it from earlier runs.
- Use web search and fetch for 2-4 substantive sources (papers, engineering write-ups).
- Extract MECHANISMS (how the field solves its problems), not trivia.
- Save as you go: write `research.md` in tonight's run folder DURING this step, not
  after: the field, each source URL, and the mechanisms extracted. If the run dies or
  hits a limit here, that file is still the night's yield.

Tonight's run folder is `<runs folder>/<YYYY-MM-DD>_<project>/`.

## Step 3 -- pair and maybe prototype (30-60 minutes)

Force 2-3 pairings: one mechanism from the field applied to one of the project's open
problems or goals. For the single most promising pairing, IF it can be prototyped in
under an hour, build a throwaway sketch inside tonight's run folder.

Hard rules for the unattended run:
- Never write inside the target project's folder. Everything you create lives in the
  run folder.
- Never commit, branch or push in any git repository.
- Open project data read-only.

## Step 4 -- morning brief (always reached)

Write `brief.md` in the run folder: the project and the field, the 2-3 pairings (one
paragraph each, mechanism first), what was prototyped and where, and ONE next action the
user could take if an idea lands. If a limit or the stop time cut the run short, say so
in one clause.

Then append ONE JSON line to `<runs folder>/ledger.jsonl` with: `date`, `project`,
`field`, `folder`, `mechanisms` (one clause each), `pairings` (each with `title`,
`one_line` and `status: "proposed"`), `verified` (anything actually measured), and
`sources` (the research URLs). The file is append-only. Later decisions on a pairing go in
as new lines (`event: "adopted"` or `"killed"`, the folder, one line on what), never as
edits. A month of runs then reads as one small file instead of thirty briefs.

Notify the user if the session has a way to: a messaging or notification tool, an email
draft, or a task-queue item. Keep it to 3-6 plain lines: project, field, the best idea in
everyday words, the prototype path if any, and the path to `brief.md`. With no such
tool, the brief and the session's final message are the delivery.

Optional triage item: if the user keeps a task list the agent can write to (a kanban
file, a notes database), add ONE item per run pointing at the brief, so their morning
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
