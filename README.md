# Shipped

**Your work, with receipts.** Shipped is a Claude Code skill that quietly logs what you do at work (PRs, closed issues, docs, client demos, the people you unblocked in DMs), has you confirm the wins once a week, and turns them into:

- a **statement**: a sourced list of bullets you can bring to your manager for a 1:1, a raise conversation or a performance review
- **resume bullets** in your CV's own style, redacted for the public, as a LaTeX block ready to drop in

It's the brag doc you meant to keep, written for you, with a link behind every line.

```
 GitHub · Linear · Slack · Fireflies · Notion · (Gmail · Calendar)
                         │  daily, 11pm
                         ▼
   raw/2026-11-07.md      everything, one line + link each, append-only
                         │  Sunday
                         ▼
   candidates/2026-W45.md the notable stuff, with "how big was it?" questions
                         │  /shipped review  (10 min, you confirm)
                         ▼
   log/2026-W45.md        curated, confirmed wins by project
   projects/<slug>.md     running story per project
                         │
             ┌───────────┴────────────┐
             ▼                        ▼
   out/statement.html          out/resume.html + role.tex
   private, real names         redacted, public-safe
```

## Why

Most real work disappears: it was a DM, a call, a two-line fix that saved someone a day. When it's time for a review, or to update your CV, you remember maybe a third of it, and none of the numbers. Shipped writes everything down while it's still fresh, and makes you confirm every claim, so nothing in it is made up.

## Principles

- **Receipts or it didn't happen.** Every entry links back to its source.
- **No made-up numbers.** Shipped *asks* "how much time did this save?" A number only goes in after you confirm it.
- **Attendance isn't contribution.** Meetings you sat in on stay in raw. They never become wins.
- **Private by default.** Your data lives in your own git repo. The public resume output goes through redaction and your approval. See [docs/privacy.md](docs/privacy.md).
- **Read-only.** Shipped never posts, sends or edits anything in your tools.

## Quickstart

Requirements: [Claude Code](https://claude.com/claude-code) (the desktop app, for scheduled tasks), the `gh` CLI, and the connectors you want: Slack, Linear, Fireflies, Notion, and optionally Gmail and Google Calendar. See [docs/connectors.md](docs/connectors.md).

```bash
git clone https://github.com/DrawdEA/shipped.git
cd shipped
./install.sh ~/shipped-log      # links the skill, scaffolds your private data repo
```

Then, in Claude Code:

```
/shipped setup      # fills config from your connectors, checks sources, schedules tasks
/shipped backfill   # optional: log your whole tenure, month by month
```

After that, it runs on its own. Every Sunday you get a notification and run `/shipped review`.

## Commands

| Command | What it does |
|---|---|
| `/shipped` | Status: last run, gaps, what's waiting for review |
| `/shipped setup` | First-run interview + scheduling |
| `/shipped collect [--date D \| --since D]` | Gather raw activity (the daily task runs this) |
| `/shipped candidates [--week W]` | Pick the week's notable items (the Sunday task runs this) |
| `/shipped review [--week W]` | Accept, edit or reject wins and add numbers, with quick buttons |
| `/shipped statement [--since D --until D]` | Private statement, HTML + markdown |
| `/shipped resume [--pr]` | Redacted CV bullets + LaTeX block. `--pr` opens a PR to your CV repo after you approve it |
| `/shipped backfill [--since D]` | Collect and review history month by month |

## What it looks like

See [`examples/`](examples/): a fake engineer at a fake company, with a raw day, a week of candidates, the reviewed log, a project file, and the rendered [statement](examples/out/statement.html) and [resume](examples/out/resume.html).

## Docs

- [How it works](docs/how-it-works.md): the layers, the notability rules, the review flow
- [Connectors](docs/connectors.md): what each source needs, and what it reads
- [Privacy model](docs/privacy.md): what's stored, what's redacted, what leaves your machine

## Repo layout

```
skills/shipped/          the skill (SKILL.md, references/, templates/)
scheduled/               prompts for the daily + weekly scheduled tasks
config.example.yaml      copied into your data repo by install.sh
install.sh               symlinks the skill, scaffolds the data repo
docs/  examples/
```

The skill is a symlink, so `git pull` updates it.

## License

MIT
