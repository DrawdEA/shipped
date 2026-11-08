# Data repo formats

```
<data repo>/
  config.yaml            # identities, sources, projects, redactions (private)
  state.json             # collection cursor
  raw/YYYY-MM-DD.md      # layer 1: everything, append-only
  candidates/YYYY-Www.md # weekly review queue
  log/YYYY-Www.md        # layer 2: curated, confirmed entries
  projects/<slug>.md     # layer 3: running story per project
  out/                   # rendered views (statement, resume)
```

Weeks are ISO weeks (Mon–Sun) in the config timezone, e.g. `2026-W45`.

## state.json

```json
{
  "last_collected_through": "2026-11-07T23:00:00+08:00",
  "last_run": "2026-11-07T23:04:12+08:00",
  "backfill": { "from": "2026-08-31", "done_through": "2026-10-31" }
}
```

`collect` with no args collects from `last_collected_through` to now. Update the cursor only after the raw files are written.

## raw/YYYY-MM-DD.md

Each day gets one file. Every item goes in the file for the day it **happened**, not the day it was collected, so a catch-up run may write to several files.

```markdown
---
date: 2026-11-07
runs:
  - at: 2026-11-07T23:04+08:00
    sources: { github: ok, linear: ok, slack: ok, fireflies: ok, notion: ok, gmail: ok, calendar: ok }
---

## github
- [gh:acme-corp/telemetry#42] merged · Merged PR "Dashboards on exact data only" (+312/−88, 2 reviewers) · https://github.com/acme-corp/telemetry/pull/42

## linear
- [lin:ACM-311] closed · Closed "Backfill OTLP spans for October" (Globex Telemetry project) · https://linear.app/acme/issue/ACM-311

## slack
- [slack:C0PROJTELEM/1762520000.123456] answered · Explained to Sam why token counts differ between the dashboard and the admin export, in #proj-telemetry · <permalink>
  > "ahh that makes sense, thank you!! sending this to the client" (Sam, praise)

## fireflies
- [ff:01K9ABC/action-2] action-done · Action item "Send Priya the retention query" from "Telemetry daily sync" (Nov 5). Evidence: Slack msg Nov 6 · https://app.fireflies.ai/view/01K9ABC?t=812
- [ff:01K9XYZ] led · Presented the telemetry dashboard to Globex (demo, ~15 min of speaking time) · https://app.fireflies.ai/view/01K9XYZ

## notion
- [notion:2a1f...] authored · Created "OTel Collector runbook" (1,200 words) · https://www.notion.so/...

## gmail
- [gmail:18c2...] context · Client thread "Dashboard access for compliance" with Globex: you replied with the access steps · (thread id only)

## calendar
- [cal:abc123] context · Organized "Telemetry dashboard walkthrough" (5 attendees, 45 min)

## gaps
- ⚠️ gmail: connector not authorized (2026-11-07T23:04+08:00)
```

Item grammar: `- [<source>:<stable id>] <verb> · <one-line summary> · <link>`
- The **stable id** is the dedupe key. Before appending, grep `raw/` across the last 30 days for `[<source>:<id>]`. If it's already there, skip it, unless the state changed (for example opened → merged). Then add it again with the new verb.
- **Verbs:** `merged`, `opened`, `committed`, `reviewed`, `closed`, `created-issue`, `authored`, `edited`, `answered`, `asked`, `announced`, `led`, `attended`, `action-assigned`, `action-done`, `praise`, `context`.
- Optional quote line: `  > "<≤25 words verbatim>" (<speaker>, praise|impact)`.
- Leave out empty source sections. Always write the frontmatter `runs` entry, even when nothing was found, so "quiet day" and "didn't run" look different.

## candidates/YYYY-Www.md

```markdown
---
week: 2026-W45
range: 2026-11-02..2026-11-08
generated: 2026-11-08T19:02+08:00
gaps: ["2026-11-04 slack: auth failed"]
---

## c1 · pending
project: globex-telemetry
kind: shipped
title: Shipped exact-data telemetry dashboards
what: Rebuilt the Globex dashboards to query exact OTLP data only, removing sampled estimates.
why: Client compliance needed numbers that match the Anthropic admin export.
metric_question: Did this remove a known discrepancy? How big was it (e.g. "~8% token undercount → 0")?
skills: [OpenTelemetry, KQL, Azure Data Explorer, Grafana]
evidence:
  - [gh:acme-corp/telemetry#42](https://github.com/...)
  - [slack:C0PROJTELEM/1762520000.123456](<permalink>)
```

Status is one of `pending`, `accepted`, `edited`, `rejected`, or `merged-into:cN`. Review updates the status in place.

## log/YYYY-Www.md

Only accepted or edited candidates go here, grouped by project.

```markdown
# 2026-W45 · Nov 2 – Nov 8, 2026

## Globex telemetry

### Shipped exact-data telemetry dashboards
- **What:** Rebuilt the dashboards to query exact OTLP data only, removing sampled estimates.
- **Why:** Client compliance needed numbers matching the Anthropic admin export.
- **Outcome:** Closed an ~8% token undercount between dashboard and admin export (confirmed).
- **Kind:** shipped
- **Skills:** OpenTelemetry, KQL, Azure Data Explorer
- **Receipts:** [PR #42](https://github.com/...) · [Sam in #proj-telemetry](<permalink>)

## Unblocked & helped
### Explained token-count mismatch to Sam before a client call
- ...
```

**Kinds:** `shipped`, `doc`, `decision`, `client`, `unblocked`, `praise`, `process`, `growth` (certifications, training, new scope). `Outcome:` is either a number marked `(confirmed)` or a plain qualitative outcome. Never write an unconfirmed number.

## projects/<slug>.md

```markdown
---
slug: globex-telemetry
name: Globex telemetry
public_name: Enterprise AI usage telemetry
client: Globex Corporation
started: 2026-09-15
status: active
---

## Summary
2–4 sentences, rewritten each review: what the project is, the user's role, the strongest outcomes so far.

## Outcomes (confirmed)
- Closed an ~8% token undercount… (2026-W45)

## Timeline
- 2026-W45 · Shipped exact-data dashboards; explained export mismatch to PM
- 2026-W44 · …

## Skills
OpenTelemetry (6 weeks) · KQL (4) · Azure (4) · Client demos (2)
```
