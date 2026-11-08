# Source recipes

Tool names differ between installs. Load each source's tools with ToolSearch, using the keywords below, and load everything a run needs in one call where you can. Skip any source with `enabled: false` in config. If a tool can't be loaded or a call errors, write a `gaps` line and move on.

Identity values (`identities.*`) and source options (`sources.<name>.*`) come from `config.yaml`. Every window is `[from, to)` in the config timezone.

Run the sources in parallel. For long windows (backfill), split by month and use subagents, one per source per month, each returning raw items in the formats.md grammar.

## github

Use the `gh` CLI. Run `gh auth status` first. If that fails, record the gap.

```bash
# PRs authored, created or merged in the window, limited to configured orgs
gh search prs --author <github_login> --owner <org> --updated "<from>..<to>" --limit 100 \
  --json repository,number,title,state,createdAt,closedAt,url
# merged state and size for each candidate PR
gh pr view <n> -R <owner/repo> --json mergedAt,additions,deletions,reviews,title,url
# reviews you gave
gh search prs --reviewed-by <github_login> --owner <org> --updated "<from>..<to>" --json repository,number,title,url
# direct commits (not part of a PR), only if there are no PRs that day
gh search commits --author <github_login> --owner <org> --author-date "<from>..<to>" --json repository,sha,commit,url
```
Verbs: `opened`, `merged` (only if `mergedAt` falls in the window), `reviewed`. Include additions and deletions. Leave out bot PRs and draft PRs that were closed without merging.

## linear

ToolSearch: `list_issues get_issue list_comments`.
- Closed: `list_issues` with `assignee: me` and `completedAt: <from>` (this means completed *after* from). Keep issues whose `completedAt` falls before `to` → `closed`.
- Created: `list_issues` with `creator: me` and `createdAt: <from>` → `created-issue`.
- Ask for `fields: [id, title, url, statusType, completedAt, createdAt, project]` to keep responses small.
- Skip test or fixture issues: titles starting with `Test:`, and projects with "test" in the name.
- Use the project name for project mapping.

## slack

ToolSearch: `slack_search slack_read_thread`.
1. The user's own messages: filters `from:<@slack_user_id> after:<from-1d> before:<to+1d>`, sort timestamp, concise, paginated. Filter to the exact window by message time.
2. Mentions: filters `with:<@slack_user_id>` or keyword `<@slack_user_id>`, same window. Use these to find asks directed at the user and praise.
3. Thanks or praise: keywords like `thanks`, `thank you`, `amazing`, `lifesaver`, `great work`, `nice` together with a mention of the user.

Classify each of the user's messages:
- `answered`: a reply in a thread or DM that resolves someone else's question. Read the thread only if it isn't clear.
- `announced`: posts in public or project channels saying something shipped, a demo, or a doc.
- `asked`: only if the question unblocked a decision.
- Drop small talk, emoji-only messages, "ok", and scheduling chatter.

If `include_dms: false`, leave out `im` and `mpim` channel types. DMs are where help that nobody else sees happens, so the default is to include them, summarized and never copied.

Permalinks and `Message_ts` are only returned with `response_format: detailed`. Run the first pass `concise` to triage, then re-query the kept messages `detailed` with `include_context: false` (narrow it with `in:<#channel>` + `on:<date>`). The stable id is `<channel_id>/<Message_ts>`. Displayed times are in the user's Slack timezone, which may be labeled with an ambiguous abbreviation like "CST", so take dates from `Message_ts` (unix time) converted to the config timezone.

## fireflies

ToolSearch: `fireflies_get_transcripts fireflies_get_summary fireflies_get_transcript`.
- `fireflies_get_transcripts` with `participants: [<emails>]` and `fromDate`/`toDate` set to the window.
- Skip meetings where the user is the only participant (solo recordings, accidental notetaker joins) and meetings whose summary is clearly not about work.
- From each summary's `action_items`, take items under the user's name → `action-assigned`. Later runs check for evidence that the item is done (a merged PR, a Slack message, a closed issue) and then add `action-done`.
- If the user led, presented or demoed (from the title, the summary, or speaker share in `fireflies_get_transcript`, when it's cheap to check) → `led`. Otherwise → `attended`. `attended` stays in raw and never becomes a candidate on its own.
- Praise or impact said *about the user* in a meeting can get a quote line, with a timestamp link `https://app.fireflies.ai/view/{id}?t={seconds}`. Speaker labels are unreliable, so mark the speaker as "likely" when unsure.

## notion

ToolSearch: `notion-search notion-fetch`.
- On a Business or Enterprise plan: `query: ""`, `filters: {edited_by_user_ids: ["me"], last_edited_date_range: {start_date, end_date}}`, `sort: last_edited`.
- On other plans those filters are silently dropped, and an empty query returns nothing. The fallback: for each project's name plus its top 2 `match` keywords, `query: <keyword>`, `filters: {created_by_user_ids: ["me"]}` (that filter works on every plan), then keep the results whose `timestamp` (last edited) falls in the window. Dedupe by page id across keywords. If the result says filters were dropped, note `notion: limited (non-Business plan)` in the run's sources rather than treating it as a gap.
- `authored`: pages the user created. `edited`: substantial edits to pages someone else created, where you can see them.
- Record the page title and an approximate length. Don't copy the content.

## gmail (context only)

ToolSearch: `search_threads get_thread`.
- Query: `newer_than` or `after:` for the window, `from:me` OR threads with configured client domains, plus `sources.gmail.query_extra`.
- Record a `context` item only for threads where the user replied to a client or external party with something substantive. Record the subject and one line of what the user did. Store the thread id, never the body.

## calendar (context only)

ToolSearch: `list_events` (Google Calendar or Notion Calendar).
- Events in the window that the user **organized**, or where they're listed as presenter → `context`, with attendee count and duration. Ignore recurring standups unless the user organizes them.
- Check that it's the **work** calendar: the organizer or creator email should be one of `identities.emails`. If the connected calendar is personal (gym, classes, travel), record nothing and add a one-time note recommending `calendar.enabled: false`. Never write personal events to raw.

## Mapping items to projects

Match each item against `projects[].match` (case-insensitive substrings of repo, channel, Linear project, meeting title or text). If nothing matches, use `project: unsorted`. Review asks the user to assign it, and suggests adding a new project to config.
