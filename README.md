# yolo-alchemy

Transmute expiring AI quota into cross-domain gold. An overnight scheduled agent run that **burns surplus weekly quota on speculative cross-domain research** paired against your real projects — and only fires when a utilization gate proves the quota would otherwise go unused.

The loop, nightly:

1. [`usage_gate.ps1`](usage_gate.ps1) reads live account utilization and compares it against day-of-week thresholds keyed to your weekly reset. Under the curve → `RUN` with a stop ceiling; over → silent `SKIP` (a skipped night is the system working). The gate fails safe: any error means SKIP, never a blind run.
2. On a RUN, the agent ([`SKILL.md`](SKILL.md)) picks one of your projects, researches one genuinely unrelated domain (biology, logistics, urban planning…), extracts *mechanisms*, and forces 2–3 pairings onto the project's open threads — prototyping the best one if it fits in an hour.
3. Morning delivery: a short brief on disk, one JSON line in an append-only research ledger (so a month of runs stays analyzable in one read), and a 3–6 line Telegram.

Hard rules baked into the spec: never write inside the target project, never touch git, read project data read-only, abort to the brief on any rate-limit error. The run's own session doubles as the warmest place to say "do it" — adoption dissolves the speculative-phase restrictions and hands the work to the project's normal rules.

Its first live run found a real, measurable pricing bug in the target project.

## Adapt before using

The gate is PowerShell but not Windows-only — it runs anywhere [`pwsh`](https://github.com/PowerShell/PowerShell) does, and at ~40 lines it ports trivially to your shell of choice. Two things in it are personal to the source fleet (documented in the script headers): the **reset anchor** (re-key the thresholds to your own weekly reset time) and the **threshold curve** (derive from your own typical spend, or start conservative). The gate reads the OAuth token your agent CLI already stores locally; nothing is committed.

Extracted from a live personal automation fleet; placeholders like `<WORKSPACE>` mark where your values go. Companion tasks from the same fleet: [claude-scheduled-tasks-toolbox](https://github.com/dtiger1889-ops/claude-scheduled-tasks-toolbox).

## License

MIT. See [LICENSE](LICENSE).
