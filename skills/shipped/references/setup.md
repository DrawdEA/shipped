# setup and backfill

## setup (first run)

Goal: in about 5 minutes, end up with a working data repo, a valid config, connectors checked, and scheduled tasks created. Then offer a backfill.

1. **Data repo path.** Ask where to keep it (default `~/shipped-log`). Create it if needed, run `git init -b main`, and write `.gitignore` (`out/*.pdf`, `.DS_Store`). Write the path to `~/.config/shipped/home`.
2. **Config.** Copy `config.example.yaml` from the Shipped repo (the parent of this skill's real path; `readlink -f ~/.claude/skills/shipped`). Then fill in as much as you can **without asking**:
   - Linear `whoami` → name, email
   - Slack: search `from:me` or read your own profile → `slack_user_id`
   - `gh api user` → `github_login`. `gh api user/orgs` → candidate orgs.
   - The earliest Slack message from the user in the employer workspace → candidate `start_date`
3. **Interview.** Use one AskUserQuestion round to confirm the guesses and fill the gaps: employer name, role title, which GitHub orgs count as work, which sources to turn on, and the main projects (offer the top repos, Linear projects and channels as options). Write `projects` with `match` hints and `public_name`, and `redact` entries for client names.
4. **Connector check.** Make one cheap call per enabled source. Report a ✓/✗ table. For each ✗, say what to connect (see docs/connectors.md in the repo) and set `enabled: false` until it's fixed. Don't stop setup because of a failed source.
5. **CV.** If the user has a CV repo, set `resume.cv_repo` and `cv_file`, and copy 3–4 of their existing bullets into `resume.style_examples`.
6. **Remote (optional).** Ask whether to push to a private remote. Only on a yes: `gh repo create <name> --private --source <path> --push`. Set `git.push: true`.
7. **Schedule.** If the `create_scheduled_task` tool is available, create the two tasks from `scheduled/` in the Shipped repo: daily collect at 23:00, and Sunday candidates at 19:00, both in local time. Otherwise, print the prompts and how to schedule them. Tell the user that tasks only run while the Claude app is open, and that missed runs catch up on the next launch.
8. **Commit** `shipped: setup`. Then ask: "Backfill from <start_date>?"

## backfill

Goal: turn the whole tenure into a reviewed log, one month at a time, without making the user sit through 20 weekly reviews in a row.

1. Range: `--since`, or `config.person.start_date` → the start of the current week. Save `state.backfill`.
2. **Collect each month**, oldest first. Use parallel subagents, one per source per month. Each one gets: the source recipe from `sources.md`, the window, the identities, and the raw grammar from `formats.md`. It returns items and doesn't write files. The main agent writes `raw/`, dedupes, and records gaps. After each month, commit (`shipped: backfill collect <YYYY-MM>`) and update `state.backfill.done_through`.
3. **Candidates per week** for the whole range.
4. **Review month by month,** with stricter batching: for older months, show the top 5 candidates per week and auto-reject the "smaller wins" bundle, unless the user asks to see it. Ask the metric questions only for headline-worthy candidates; older numbers are harder to remember and verify.
5. At the end, run `statement` for the full tenure and `resume`. Show both paths.

The user can stop at any point. `state.backfill` lets `/shipped backfill` pick up where it left off.
