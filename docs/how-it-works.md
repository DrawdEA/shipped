# How it works

## Three layers

1. **Raw** (`raw/YYYY-MM-DD.md`): everything, collected daily, append-only. One line plus a link per item, keyed by a stable source id so re-runs never duplicate. You don't read this. It's the safety net.
2. **Log** (`log/YYYY-Www.md`): the wins you confirmed that week, grouped by project. Each has what / why / outcome / kind / skills / receipts.
3. **Projects** (`projects/<slug>.md`): a running story per project, with a summary, confirmed outcomes, a timeline and skills. Resume bullets come from here.

The views (statement, resume) are built only from layers 2 and 3. Nothing reaches a view without your review.

## Schedule

| When | Task | Does |
|---|---|---|
| Daily 23:00 | `shipped-daily-collect` | Catches up raw from the last run to now. If the laptop was asleep, the next run covers the missed days |
| Sunday 19:00 | `shipped-weekly-candidates` | Final collect for the day, then picks the week's candidates and notifies you |
| When you want | `/shipped review` | About 10 minutes of accept / edit / reject and number questions |

Scheduled tasks run while the Claude desktop app is open. Missed runs happen the next time it launches.

## What counts as a win

Candidates: merged PRs, closed issues with real scope, docs you wrote, decisions you drove, client sessions you led, answers that unblocked someone, praise aimed at you, completed meeting action items, and automation that saves the team time.

Not candidates: meetings you only attended, acknowledgements and emoji, scheduling, small edits, unmerged PRs. Gmail and Calendar items are only ever supporting evidence.

Related items are grouped: a PR, its issue, the Slack announcement and the thank-you become one candidate with four receipts. Shipped aims for 3–10 candidates a week.

## Numbers

A candidate can include a question like *"PR says query time 4.2s → 0.9s. Use that?"* or *"Roughly how many hours a week does this save the team?"* You answer it in review, or skip it. Numbers you confirm are marked `(confirmed)` in the log. No other numbers are allowed.

## Backfill

`/shipped backfill` collects your whole tenure month by month (parallel per source), generates candidates per week, and has you review month by month with tighter batches for older months. You can stop at any point and pick up again later.
