# Resume · Acme Corp

**Acme Corp** · Software Engineer · Remote · Aug 2026 – Present

- Rebuilt invoice webhook handling with idempotency keys, eliminating duplicate invoices (~40/month to 0) and writing the on-call retry runbook.
- Cut month-end shipment sync for a logistics client from ~3h to ~20 min by batching requests with backoff, and demoed the new sync dashboard to their ops team.
- Moved invoice PDF rendering to a background queue, reducing p95 latency from ~6s to ~1.5s, and migrated invoice tables to a new schema with zero downtime.
- Shipped 23 PRs across billing, integrations, and CI, including test sharding that cut CI time from ~14 min to ~6 min.

## Why these bullets (private)

1. From log/2026-W44 "Stopped duplicate invoices…" (confirmed ~40/month → 0) and "Wrote the webhook retry runbook".
2. From log/2026-W44 "Fixed month-end sync lag for Globex…" (confirmed ~3h → ~20 min). Redacted: "Globex" → "a logistics client".
3. From log/2026-W39 "Moved invoice PDF rendering…" (confirmed ~6s → ~1.5s) and log/2026-W41 "Migrated invoice tables…".
4. Count of `merged` items in raw/ from Aug 3 to Oct 31 (23). CI number from log/2026-W38 (confirmed).

Redaction check: no people, channels, private repos or internal links found after applying `redact`.
