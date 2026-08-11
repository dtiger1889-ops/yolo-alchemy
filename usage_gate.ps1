# usage_gate.ps1 -- weekly-usage gate for the yolo-alchemy scheduled task.
# PowerShell, but not Windows-only: runs anywhere `pwsh` does (macOS/Linux
# included), and at ~40 lines it ports trivially to your shell of choice.
#
# Queries the UNDOCUMENTED (community-standard) Claude oauth/usage endpoint and
# decides whether tonight's speculative run may fire. Undocumented means it can
# change without notice -- which is why the gate fails SAFE: any error means SKIP,
# never a blind run.
#
# ADAPT BEFORE USING -- two things are personal to the source fleet:
# 1. The RESET ANCHOR. These day-indexed thresholds assume the account's weekly
#    limit resets Wednesday ~11pm local. Run the probe once, read
#    seven_day.resets_at, and re-key the $thresholds table to YOUR reset: the
#    final pre-reset evening is the "free burn" slot (unused quota expires), and
#    earlier nights should require utilization well BELOW your own typical curve.
# 2. The CURVE. Sun 40 / Mon 60 / Tue 70 here came from auditing the source
#    fleet's own six weeks of session transcripts (by the reset-anchored week,
#    ~55% was typically spent by Sunday night, ~76% by Monday, ~83% by Tuesday --
#    thresholds sit ~15 points below the curve so the run only fires on genuine
#    surplus). Derive yours the same way or start conservative and tune.
#
# TOKEN: reads the OAuth token Claude Code stores in ~/.claude/.credentials.json.
# Run `claude setup-token` once (interactive) to mint a long-lived one.
#
# Output contract (parsed by the SKILL): one line, either
#   VERDICT=RUN UTIL=<n> STOPAT=<n> RESETS=<iso>
#   VERDICT=SKIP UTIL=<n> REASON=<text>

$thresholds = @{
    0 = @{ run = 40; stop = 90 }   # Sunday night
    1 = @{ run = 60; stop = 90 }   # Monday night
    2 = @{ run = 70; stop = 92 }   # Tuesday night
    3 = @{ run = 85; stop = 97 }   # Wednesday evening (pre-reset burn: surplus expires)
    4 = @{ run = 10; stop = 88 }   # Thursday (fresh week: surplus rarely provable; usually SKIP)
    5 = @{ run = 20; stop = 88 }   # Friday
    6 = @{ run = 30; stop = 90 }   # Saturday
}
# Schedule the task NIGHTLY and let the gate own the calendar: early-week
# thresholds sit far below a typical spend curve, so those nights only fire in
# unusually light weeks. A skipped night costs one API call and sends nothing.

try {
    $credPath = Join-Path (Join-Path $HOME ".claude") ".credentials.json"
    $cred = Get-Content $credPath -Raw -ErrorAction Stop | ConvertFrom-Json
    $tok = $cred.claudeAiOauth.accessToken
    if (-not $tok) { Write-Output "VERDICT=SKIP UTIL=? REASON=no-token"; exit 0 }

    $r = Invoke-RestMethod -Uri 'https://api.anthropic.com/api/oauth/usage' `
        -Headers @{ 'Authorization' = "Bearer $tok"; 'anthropic-beta' = 'oauth-2025-04-20' } `
        -TimeoutSec 30 -ErrorAction Stop

    $util = [double]$r.seven_day.utilization
    $resets = "$($r.seven_day.resets_at)"
    $dow = [int](Get-Date).DayOfWeek.value__   # 0=Sun .. 6=Sat

    if (-not $thresholds.ContainsKey($dow)) {
        Write-Output "VERDICT=SKIP UTIL=$util REASON=not-a-run-night"
        exit 0
    }
    $t = $thresholds[$dow]
    if ($util -le $t.run) {
        Write-Output "VERDICT=RUN UTIL=$util STOPAT=$($t.stop) RESETS=$resets"
    } else {
        Write-Output "VERDICT=SKIP UTIL=$util REASON=over-threshold-$($t.run)"
    }
    exit 0
}
catch {
    Write-Output "VERDICT=SKIP UTIL=? REASON=gate-error $($_.Exception.Message -replace '\s+',' ')"
    exit 0
}
