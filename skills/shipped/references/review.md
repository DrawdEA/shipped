# candidates and review

There are two steps. **candidates** (unattended, Sunday task) picks the notable items out of a week of raw. **review** (interactive) has the user accept, edit or reject each one and confirm numbers. Only review writes to `log/` and `projects/`.

## Notability rubric (candidates)

An item can become a candidate if it's any of these:
- **shipped:** a merged PR, or a closed Linear issue with real scope (not a typo fix, not a label change)
- **doc:** a Notion page or doc the user authored, or a substantial rewrite
- **decision:** the user proposed or drove a decision (Slack thread or meeting) that the team adopted
- **client:** the user led, demoed or presented to a client, or replied substantively to a client thread
- **unblocked:** the user's answer resolved someone else's question or blocker. This is DMs included. It's the work that goes unseen, so don't skip it.
- **praise:** someone thanked or credited the user for something specific
- **action-done:** a Fireflies action item assigned to the user, with evidence that it's done
- **process:** automation or tooling that saves the team time

These **never** become candidates on their own: attend-only meetings, emoji or acknowledgement messages, scheduling, opened PRs that weren't merged this week, minor edits, and Gmail or Calendar `context` items. Context items can only be supporting evidence.

### Grouping

- Merge related raw items into one candidate: the PR, its Linear issue, the Slack announcement and the praise all become one candidate with several pieces of evidence.
- Each candidate gets one `kind` (the strongest one) and one `project`.
- Aim for 3–10 candidates a week. If more qualify, rank them by impact × how clear the user's ownership is, keep the top 10, and fold the rest into a single `c99 · pending` "smaller wins" bundle.

### Metric questions

For each candidate, ask a specific `metric_question` when a number is plausible: time saved, error rate, people affected, money, latency, adoption, or count of X. Put any figure you can see in the evidence into the question, e.g. "PR says query time 4.2s → 0.9s. Use that?" **Never** put a number into `what`, `why` or `title`.

## candidates steps

1. Week = `--week`, or else the ISO week that ended most recently. On Sunday that means the current week.
2. Read `raw/` for the week's 7 days, plus the 3 days after it, in case action items were completed then.
3. Apply the rubric, grouping, and metric questions. Write `candidates/<week>.md` (format in `formats.md`). Copy every gap line from the week into the frontmatter `gaps`.
4. If the file already exists, keep the statuses that have already been reviewed. Only add new candidates, numbered after the last one.
5. Commit: `shipped: candidates <week> (<n>)`.
6. Notify: "Shipped: <n> wins ready to review for <week>. Run /shipped review." Use PushNotification if it's available. Otherwise make that the task's final message.

## review steps

1. Week = `--week`, or else the oldest week whose candidates are `pending`. If no candidates file exists for the week yet, run the candidates step first.
2. Show a header: week, the number of candidates, any gaps ("Slack was down Nov 4, so wins from that day may be missing"), and any `unsorted` items that need a project.
3. Go through the candidates with AskUserQuestion, **4 per call**. For each one, the question is `<title>: <what>`, and the evidence is listed in the question text. Options:
   - **Accept**: it goes in as written. Any metric is left out unless the user answered the question.
   - **Accept + number**: the user types the number in Other. If they did, treat it as the metric answer.
   - **Reject**
   - Typing in **Other** means an edit: apply the user's text as a correction to the title, what or outcome, or as the number.
   If a candidate has a `metric_question`, put it in that candidate's question text so the user can answer it inline.
4. Ask one last question: "Anything this week that Shipped missed?" The user can type it in Other. Add those as `edited` entries. If the user gives no link, try to find one with a quick source search. If you still can't find one, write `Receipts: (self-reported)`.
5. Update the candidate statuses. Write or merge `log/<week>.md`: accepted and edited entries only, grouped by project, with `## Unblocked & helped` last. Write numbers only as the user gave them, with ` (confirmed)` after.
6. Update each project that was touched in `projects/<slug>.md`: rewrite the Summary, add confirmed Outcomes, add a Timeline line for the week, and update the Skills counts. Create a new project file if the user named one, and add its match hints to `config.yaml`.
7. Commit: `shipped: review <week> (<accepted>/<total>)`. Push if configured.
8. If more weeks are pending, offer the next one. Otherwise finish with one line: what's now in the log.

Keep the review under about 10 minutes. Keep the text short and don't add commentary between batches.
