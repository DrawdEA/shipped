# collect

Goal: write everything the user did in a window to `raw/`, deduped, with a gap line for anything that couldn't be checked. This step does no judging. Notability is decided in `review.md`.

## Window

- `--date D`: collects `[D 00:00, D+1 00:00)`.
- `--since D`: collects `[D 00:00, now)`.
- No args: collects `[state.last_collected_through, now)`. If `state.json` is missing, use the last 24 hours.
- Cap at 14 days per run. For anything longer, tell the user to run `/shipped backfill`, and stop. Scheduled runs never prompt; they just cap.

## Steps

1. Read `config.yaml` and `state.json`. Load the tools for every enabled source in one ToolSearch call, using the keywords from `sources.md`.
2. Run every enabled source in parallel for the window (recipes in `sources.md`). Record each source as `ok`, `empty`, `skipped` (disabled), or `failed: <reason>`.
3. Put each item in the right day file using its own timestamp. Create the file with frontmatter if it doesn't exist.
4. Dedupe against the last 30 days of raw by `[source:id]` (rules in `formats.md`).
5. Append items under their source heading, and add this run to the frontmatter `runs` list of **every** day the window touched, including days with no items.
6. For each `failed` source, add `- ⚠️ <source>: <reason> (<run time>)` under `## gaps` in every day the window touched.
7. Update `state.json`:
   - If every enabled source is `ok` or `empty`, set `last_collected_through = to`.
   - If any source failed, still set the cursor to `to`, but list the failed `source + window` under `state.retry`. The next run retries those first, writes the recovered items, and adds `- ✅ <source>: recovered <time>` under that day's gaps. Never delete the ⚠️ line.
8. Commit: `shipped: collect <from>..<to> (<n> items, <k> gaps)`. Push if configured.

## Output

- Interactive run: give a 3–5 line summary with item counts per source, any gaps, and anything that looks notable ("merged 2 PRs, Sam thanked you in #proj-telemetry").
- Scheduled run: the same summary, as the task's final message.
