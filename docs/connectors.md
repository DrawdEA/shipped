# Connectors

Shipped uses the Claude Code connectors (MCP servers) you already have, plus the `gh` CLI. Every source is optional. Turn sources on or off in `config.yaml → sources`. `/shipped setup` makes one test call per source and shows a ✓/✗ table.

| Source | How to connect | What Shipped reads | What becomes a win |
|---|---|---|---|
| **GitHub** | `gh auth login` | PRs you authored or reviewed, and commits, in `sources.github.orgs` only | Merged PRs, plus reviews as supporting evidence |
| **Linear** | Linear connector | Issues assigned to you or created by you | Issues closed with real scope |
| **Slack** | Slack connector | Your messages, mentions of you, thanks or praise aimed at you. DMs too unless `include_dms: false` | Answers that unblocked someone, announcements, praise |
| **Fireflies** | Fireflies connector | Meetings you were in: summaries, your action items, speaker share | Meetings you led or demoed in, action items you completed |
| **Notion** | Notion connector | Pages you created or substantially edited | Docs you authored |
| **Gmail** | Gmail connector | Threads where you replied to clients or external people (subject + id only) | Never on its own. Supporting evidence only |
| **Calendar** | Google Calendar or Notion Calendar | Events you organized or presented at | Never on its own. Supporting evidence only |

## Notes

- **Tool names vary** between installs. Shipped finds tools with ToolSearch using keywords, so it works whatever your connectors' internal IDs are.
- **Google Meet** is covered through Fireflies (or any recorder that writes summaries). Meet has no source of its own.
- **Missing a source?** Each one is a short recipe in `skills/shipped/references/sources.md`. Adding Jira, GitLab or Google Docs means writing one more recipe. PRs welcome.
- **When a connector fails**, its login expired or it's rate-limited, the run writes a `⚠️` gap line for that day and retries on the next run. Review shows gaps at the top, so you know which wins might be missing.
