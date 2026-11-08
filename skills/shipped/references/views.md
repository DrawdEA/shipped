# Views: statement and resume

Both views are built **only from `log/` and `projects/`**, the curated layer the user has confirmed. Raw only provides the counts. Write output to `out/`. Commit the changes. Never publish anything.

## Statement (private)

A list of bullets the user can argue from with their current employer: in a 1:1, a raise or scope conversation, or a performance review. It uses real names and links.

Period: `--since`/`--until`, defaulting to the last 3 months, clamped to `config.person.start_date`.

### Structure (`out/statement-<from>_<to>.md`, then HTML)

1. **Header:** name, role, employer, period. One sentence describing what the user owns now.
2. **Headline wins:** the 3 strongest entries. Rank by confirmed outcomes first, then client-facing or shipped work. One bullet each, number included.
3. **By the numbers:** counts from `raw/` for the period: PRs merged, Linear issues closed, docs authored, client sessions led, people unblocked (count of `unblocked` log entries). Only count items with receipts.
4. **By project:** for each project, ordered by number of entries, a 1–2 line summary from `projects/`, then the bullets, newest first. Each bullet has a date and receipt links.
5. **Unblocked & helped:** every `unblocked` and `praise` entry. This is the section that makes visible the work that isn't otherwise.
6. **Growth:** the skills from the period's entries, with how many weeks each appeared, plus new skills that weren't seen before the period.

### Bullet style (statement)

`<Verb past tense> <what> for <who/why>, <outcome>. · <date> · [receipt](…)`
Example: "Rebuilt Globex's telemetry dashboards on exact OTLP data, closing an ~8% token undercount vs the admin export. · Nov 4 · [PR #42](…) · [Sam](…)"

Write it in the first person where that helps when pasting into Slack or a doc. Don't hedge and don't inflate. If the user's role was partial, say "with Priya".

### HTML

Fill `templates/statement.html`, keeping its CSS and structure. Write `out/statement-<from>_<to>.html` and `out/statement.html` (the latest one). Tell the user the path, and the command to open it: `open <path>`.

## Resume (public-facing, redacted)

Resume bullets for the employer role, in the user's CV style, after redaction.

### Inputs

- `projects/*.md` and every `log/` entry across the whole tenure
- `config.resume`: `max_bullets` (default 4), `style_examples` (bullets taken from the user's existing CV), `cv_repo`, `cv_file`, `role_title`, `location`

### Bullet style (resume)

Match `style_examples`. The default, matching autoCV-style CVs: past-tense verb first, then concrete nouns, then scope and counts, in one line of about 20–30 words. No first person. No adjectives like "passionate" or "innovative".
- Use counts from receipts: "Shipped 16 PRs across 4 repos…".
- Use only confirmed numbers.
- One bullet per strongest project or theme. Combine smaller items into a "Built/Maintained …" bullet.
- Ordering: the strongest client outcome first, then shipped systems, then internal tooling and process.

### Outputs

- `out/resume.md`: the role header and bullets, plus a "why these bullets" note listing the log entries behind each bullet (private, for the user).
- `out/role.tex`: a LaTeX block in the CV's own environment. For autoCV:
  ```tex
  \begin{role}{<Employer>}{<Location>}{<Title>}{<Mon YYYY> -- Present}
  \item ...
  \end{role}
  ```
  Escape `& % $ # _ { }` as `\& \% \$ \# \_ \{ \}`. Use `--` for date ranges.
- `out/resume.html`: fill `templates/resume.html`. It previews the role block styled like the CV.

### `--pr`

1. Run redaction (below) on `out/role.tex`. If anything gets flagged, stop and show it.
2. In `config.resume.cv_repo`: `git fetch && git checkout -b shipped/<employer-slug>-<YYYY-MM-DD> origin/main`.
3. If a `\begin{role}{<Employer>}` block exists, replace it. Otherwise insert it as the first role under `\section{Experience}` (newest role first), unless `config.resume.insert_after` names a role.
4. Show the diff. Ask: "Open PR to <repo>? This repo is public." Only after a yes: commit, push, `gh pr create`. Never merge.

## Redaction

Everything that leaves the machine goes through this: resume, the `--pr` change, any text given to build-in-public.

1. Apply `config.redact` (exact string → replacement), longest keys first.
2. Then scan what remains for:
   - client or company names that aren't the employer
   - people's names
   - Slack channel names
   - private repo names
   - internal tool URLs (Slack, Notion, Linear, Fireflies, Gmail)
   - dollar figures that come from client contracts
   - anything marked confidential in a source
3. Never auto-replace what step 2 finds. List each item ("'Sam' in bullet 2") and ask the user to add a redaction or approve it.
4. Public output contains no links except public URLs the user approves.
