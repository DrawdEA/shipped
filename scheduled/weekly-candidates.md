Run Shipped's weekly candidates step. This is an unattended run: ask no questions and write nothing outside the Shipped data repo.

1. Read `~/.claude/skills/shipped/SKILL.md`, then `references/review.md` and `references/formats.md` in that skill folder.
2. Find the data repo as SKILL.md describes (`~/.config/shipped/home`). If it's missing, finish with "Shipped: not set up. Run /shipped setup." and stop.
3. First run `collect` (see `references/collect.md` and `references/sources.md`) with no arguments, so today is included.
4. Then run the **candidates** step for the current ISO week (Mon–Sun, ending today). Do **not** run review. Review is interactive and needs the user.
5. Everything is read-only in external tools. Commit to the data repo (and push only if config says `git.push: true`).
6. Notify the user: "Shipped: <n> wins ready to review for <week>. Run /shipped review." Use PushNotification if it's available, and also make it the final message. Mention any gaps from that week in one line.
