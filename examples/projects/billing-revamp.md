---
slug: billing-revamp
name: Billing revamp
public_name: Payments platform rewrite
client: null
started: 2026-08-10
status: active
---

## Summary
Acme's rewrite of invoicing and Stripe webhook handling. Ada owns the webhook pipeline end to end: ingestion, idempotency, and the on-call runbook. Strongest outcome so far: duplicate invoices went from ~40/month to zero.

## Outcomes (confirmed)
- Duplicate invoices went from ~40/month to 0 after adding webhook idempotency keys (2026-W44)
- Invoice PDF generation went from ~6s to ~1.5s p95 by moving rendering off the request path (2026-W39)

## Timeline
- 2026-W44 · Shipped webhook idempotency; wrote the webhook retry runbook
- 2026-W41 · Migrated invoice tables to the new schema with zero downtime (with Priya)
- 2026-W39 · Moved invoice PDF rendering to a background queue
- 2026-W36 · Mapped legacy billing flows; proposed the webhook-first design (adopted)
- 2026-W33 · Onboarded; first PR: invoice list pagination

## Skills
TypeScript (9 weeks) · Postgres (7) · Stripe (5) · Queues (3) · Technical writing (2)
