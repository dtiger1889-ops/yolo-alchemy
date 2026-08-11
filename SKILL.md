# yolo-alchemy -- overnight usage-surplus speculative research run

You are an UNATTENDED scheduled run (nights chosen to sit just before the weekly
usage reset -- see the gate below). Nobody is watching; never wait for a human
click. Finish with ONE Telegram message.

Concept (adapted from a community overnight-research setup shared on r/ClaudeAI):
burn OTHERWISE-UNUSED weekly quota on cross-domain research paired against your
real projects, and deliver a short morning brief. The idea does not need to be
perfect; it needs to make the owner see a project from a new angle.

## Step 0 -- THE GATE (never skip)
Run: `pwsh -File "<WORKSPACE>/yolo-alchemy/usage_gate.ps1"` (or your port of it --
the script header documents the logic).
- `VERDICT=SKIP` -> send NO Telegram, end the run silently. (A skipped night is the
  system working.)
- `VERDICT=RUN UTIL=<n> STOPAT=<n>` -> proceed. Remember STOPAT.
- Mid-run discipline: re-run the gate script between phases; if UTIL >= STOPAT (or
  any session-limit error appears), jump straight to Step 4 with whatever exists.

## Step 0.5 -- CLOSE OUT prior runs (~2 min; only reached on a RUN verdict)
If you created triage items for prior runs (see Step 4), sweep them: an item
untriaged after 7+ days earns ONE line in tonight's notification ("N ideas
untriaged >1wk"), never a per-item nag. This step never deletes anything --
closing items belongs to the owner's own triage flow.

## Step 1 -- PICK a target project (~5 min)
Read your workspace's project index (the root CLAUDE.md table, or wherever your
projects are enumerated), then the CHECKPOINT/state file of ONE project chosen
like this: prefer a project not hit by a recent run (check
`<WORKSPACE>/yolo-alchemy/runs/` for prior run folders), skip meta/infrastructure
projects and archived ones. Its goals + open threads are tonight's canvas.

## Step 2 -- RESEARCH a foreign domain (~30-45 min)
Pick ONE domain genuinely unrelated to the project (biology, logistics,
psychology, game design, materials science, urban planning...). Vary by night;
note the choice.
- WebSearch/WebFetch for 2-4 substantive sources (papers, engineering writeups).
- Optional idea seed: browse a relevant technical subreddit's hot posts.
Extract MECHANISMS (how the domain solves its problems), not trivia.
PERSIST AS YOU GO (research survives even when unused): write `research.md` in
tonight's run folder DURING this step, not after -- domain, each source URL,
and the mechanisms extracted. If the run dies or STOPAT cuts it here, that file
is still the night's yield.

## Step 3 -- PAIR + (maybe) PROTOTYPE (~30-60 min)
Force 2-3 pairings: <domain mechanism> applied to <project's open thread or goal>.
For the single most promising one, IF it is prototypable in under an hour, build a
throwaway sketch in `<WORKSPACE>/yolo-alchemy/runs/<YYYY-MM-DD>_<project>/`
(create the folder; everything disposable lives there).
HARD RULES: never write inside the target project's folder; never git commit,
branch, or push anywhere; probes against project data open it READ-ONLY; route
bulk/mechanical subagent work to a cheaper model, keep synthesis in-session.

## Step 4 -- MORNING BRIEF (always reached on a RUN)
Write `brief.md` in tonight's run folder: project + domain, the 2-3 pairings
(one paragraph each, mechanism-first), what got prototyped and where, and ONE
next action the owner could take if an idea lands. Then send ONE Telegram: 3-6
lines -- project, domain, best idea in plain words, prototype path if any,
closing with "Brief: <path>". If the run was cut by STOPAT, say so in one clause.
Do NOT update any project state file (the brief is speculative until the owner
adopts it).
LEDGER LINE (the research corpus index): APPEND one JSON line to
`<WORKSPACE>/yolo-alchemy/runs/ledger.jsonl` -- date, project, domain, folder,
mechanisms[] (one clause each), pairings[] (title / one_line / status
"proposed"), verified[] (anything actually measured), sources[] (the research
URLs), cost. Append-only; when a later session adopts or kills a proposal it
appends a status event line (`event: "adopted"|"killed"`, folder, one-line what)
rather than editing history. This is what makes a month of runs ANALYZABLE:
"what has the research turned up across my projects?" reads one ~10k-token
ledger instead of re-reading every brief.
OPTIONAL TRIAGE HANDLE: if you keep a task queue the agent can write to
(Obsidian base, kanban file, etc.), also create ONE item there per run
pointing at the brief -- your morning close is then a one-word verdict on that
item, and the run's own session (reopenable, including from mobile) is the
warmest place to say "do it".

## POST-RUN CONTINUATION (if the owner replies in THIS session later)
This run shows up as a reopenable session (including on mobile), and it is the
warmest context available for acting on the brief. A reply like "do it" / "fix
that" / "build pairing 2" is ADOPTION: re-orient first (read the target project's
state files properly -- the run deliberately skimmed), then execute inside that
project under its normal rules. On completion: record the outcome where that
project records outcomes, append an `event: "adopted"` line to the ledger, and
close the triage item. The speculative-run restrictions (no project writes, no
git) DISSOLVE on adoption -- they protected the unattended phase, not the owner's
directed work.

## Cost posture
This task exists to spend surplus; it must never CREATE scarcity: obey the gate,
obey STOPAT, prefer cheap-model subagents for volume, and on any
rate-limit/session-limit error abort to Step 4 immediately. A run on the final
pre-reset evening has a hard clock -- scope Steps 2-3 down to fit, and send the
brief before the reset even if unfinished.
