---
name: shipped
description: Keep a sourced, always-current record of what the user did at work, collected from GitHub, Linear, Slack, Fireflies, Notion, Gmail and Calendar, and turn it into a statement (bullets to argue from with their employer) and resume bullets. Use when the user runs /shipped or /shipped setup|collect|review|statement|resume|backfill|status, or asks "what did I ship", "log my work", "update my brag doc", "build my statement", "update my resume with my work", "review this week's wins". Also the entry point for the Shipped scheduled tasks.
---

# Shipped

Shipped keeps a work journal backed by receipts: every entry links to its source. Data lives in a private git repo (the **data repo**) that belongs to the user. This skill reads and writes only that repo, and reads from connected tools. It never posts, sends, comments or edits anything in those tools.

## Find the data repo

1. If `~/.config/shipped/home` exists, its first line is the data repo path.
2. Otherwise, use `~/shipped-log`.
3. If neither exists, or there is no `config.yaml` there, run **setup** (`references/setup.md`). Stop there; don't collect.

Read `config.yaml` before anything else. It holds identities, the sources that are on, project hints, redactions and the timezone. Use the config timezone for every date.

## Commands

| Invocation | Do | Reference |
|---|---|---|
| `/shipped setup` | First-run interview, create the data repo, schedule tasks, offer a backfill | `references/setup.md` |
| `/shipped collect [--date YYYY-MM-DD \| --since YYYY-MM-DD]` | Gather raw activity into `raw/`. With no args, catch up from `state.json` to now | `references/collect.md` |
| `/shipped candidates [--week YYYY-Www]` | Turn a week of raw into review candidates | `references/review.md` |
| `/shipped review [--week YYYY-Www]` | Walk the user through candidates, write the curated log | `references/review.md` |
| `/shipped statement [--since DATE] [--until DATE]` | Build the private statement view | `references/views.md` |
| `/shipped resume [--pr]` | Build redacted resume bullets and an autoCV role block. `--pr` proposes the change to the CV repo | `references/views.md` |
| `/shipped backfill [--since DATE]` | Collect and review history month by month | `references/setup.md` |
| `/shipped status` or bare `/shipped` | Last collect, gaps, pending candidates, weeks not reviewed. Suggest the next command | (below) |

Source recipes for every command are in `references/sources.md`. File formats for every file in the data repo are in `references/formats.md`. Read only what the current command needs.

## Rules that apply to every command

- **Receipts or it didn't happen.** Every raw item and log entry has a source link. An entry with no link stays in raw.
- **Never invent numbers.** A metric goes into the curated log only after the user has confirmed it in review, and it's marked `(confirmed)`. In candidates, a guessed metric is a *question*, never a claim.
- **Attribute honestly.** Being present isn't doing the work. Attend-only meetings and threads where the user only reacted stay in raw. When an outcome came from a team, say "with X" or "contributed to".
- **Raw is append-only.** Never rewrite or delete existing raw items. Add corrections as new items.
- **Store summaries, not copies.** One line plus a link per item. Never copy whole transcripts, DMs or emails. The one exception is short verbatim quotes (25 words max) of praise or stated impact aimed at the user. Those are evidence.
- **Make gaps visible.** If a source fails, can't be reached or is skipped, write a `gaps` entry for that day (see formats). Never fail silently, and never treat "no results" from a failed call as "no activity".
- **The private/public line is fixed.** `log/`, `projects/` and the statement keep real names and links. Anything meant to leave the machine (resume, posts, the public PR) goes through redaction (`references/views.md` → Redaction) and the user's approval.
- **Commit after each command** that changes the data repo: `git add -A && git commit -m "shipped: <command> <scope>"`. Push only if `git.push: true` in config and a remote exists.
- **Read only in external tools.** No sending, drafting, reacting, labeling, commenting or editing.

## Status (bare `/shipped`)

Read `state.json`, list `raw/` for the last 14 days, `candidates/`, and `log/`. Report in at most 6 lines:
- last collected date and time
- days in the last 14 with gaps, and which sources
- candidate weeks with `pending` items
- weeks with raw but no log
- the one command to run next
