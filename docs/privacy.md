# Privacy model

Shipped reads a lot of sensitive data: DMs, meeting transcripts, client threads. This page covers what happens to it.

## Where data lives

| What | Where | Contains |
|---|---|---|
| Skill code | this public repo | Instructions and templates only. No data. |
| `config.yaml` | your data repo | Your IDs, project names, client names, redaction map |
| `raw/`, `candidates/`, `log/`, `projects/` | your data repo | One-line summaries, links, short praise quotes |
| `out/statement.*` | your data repo | Real names and links. **Private.** |
| `out/resume.*`, `out/role.tex` | your data repo | Redacted text, safe to make public once you approve it |

The data repo is a local git repo. A remote is opt-in (`git.push: true`). If you add one, make it **private**, and think about whether your employer is OK with work data in a personal account.

## What is stored

- **One line plus a link per item.** Shipped never copies whole DMs, transcripts, emails or docs.
- **Short quotes (25 words max)** only for praise or impact aimed at you ("this saved us a day"). Those are evidence.
- **Gmail:** subject plus thread id, never the body.
- **Links** point back to the source tool, so viewing the evidence still requires your access to that tool.

## What leaves your machine

1. **Calls to the model.** Like any Claude Code skill, the content Shipped reads is processed by Claude during the run, under your Claude plan's data terms.
2. **Your private remote**, only if you turned it on.
3. **Public output**, only when you explicitly run `/shipped resume --pr` and approve the diff, or paste something yourself.

Nothing is posted, sent or published automatically. Every external tool is used read-only.

## Redaction (public output only)

1. Your `redact:` map is applied (e.g. `"Globex": "a logistics client"`).
2. Shipped then scans for anything that's left: client or company names, people's names, channels, private repo names, internal URLs, contract dollar figures, and anything marked confidential.
3. It **flags** those for you and never rewrites them on its own. You either add a redaction or approve the item.
4. Public output contains no internal links.

## Honesty guardrails

These protect you as well as the data. A claim your manager can disprove does more damage than a missing claim.

- No number is written to the log unless you've confirmed it.
- Meetings you attended don't count as wins.
- Team outcomes are written as "with X" or "contributed to".
