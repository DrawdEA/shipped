Run Shipped's daily collection. This is an unattended run: ask no questions and write nothing outside the Shipped data repo.

1. Read `~/.claude/skills/shipped/SKILL.md`, then `references/collect.md`, `references/sources.md` and `references/formats.md` in that skill folder.
2. Find the data repo as SKILL.md describes (`~/.config/shipped/home`). If it's missing, finish with "Shipped: not set up. Run /shipped setup." and stop.
3. Run `collect` with no arguments: catch up from `state.json` to now, capped at 14 days.
4. All tools are read-only. Never send, post, react, draft, label or edit anything in Slack, Gmail, Notion, Linear, Fireflies or GitHub.
5. If a source fails, write the gap line and keep going. Never stop the run because one source failed.
6. Commit to the data repo (and push only if config says `git.push: true`).
7. Final message, at most 4 lines: item counts per source, any gaps, and the 1–2 most notable items.
