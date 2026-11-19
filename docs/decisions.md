# Decisions

1. **n8n** as automation engine. Triggers, retries, OAuth, scheduling for free. Not Zapier (closed, no self-host), not pure Python (rebuilding plumbing).
2. **Docker Compose from day 1**. Multi-service, reproducible on any server.
3. **Postgres 17 instead of SQLite** (migrated from 16 via pg_dumpall, n8n dropped 16 support). One real DB for n8n + app data, proper backups.
4. **Separate `app` database**. Our data isolated from n8n internals.
5. **Pinned image versions (n8n 2.49.1)**. No silent breaking updates. 3.x stays off until stable + migration report checked.
6. **n8n bound to 127.0.0.1**. Never public; Postgres has no published port.
7. **Own N8N_ENCRYPTION_KEY**. Credentials recoverable; key kept in password manager.
8. **Secrets in .env (gitignored, chmod 600) + .env.example committed**. No secrets in git.
9. **Telegram as the interface**. Free bot API, inline buttons for approvals, already on my phone, no frontend to build. Not email (would pollute the inbox we triage), not WhatsApp (paid business API).
10. **Credentials referenced, never embedded**. Token encrypted in n8n DB; exported workflows hold only a credential ID, safe for git.
11. **Pin n8n behavior explicitly**: unverified community packages off (supply-chain risk), safer timeout/compression limits set now instead of changing silently on upgrade.
12. **Gmail scope = gmail.readonly only** (custom scopes). Default n8n Gmail credential requests full mailbox incl. permanent delete; we grant read-only and add modify/send later only when a phase needs it. Credential restricted to googleapis.com.
13. **Execution data retention 7 days / 5000 runs**. Executions store full email content in Postgres; keep enough for debugging, not a permanent copy of my inbox (data minimization, GDPR mindset).
14. **Gemini via AI Studio, Tier 1 prepaid (5 EUR, no auto-reload)**. Paid tier = prompts not used for training/human review. Prepaid with no auto-reload = hard spending cap. Key restricted to Gemini API + bound to service account. TODO Phase 8: add IP restriction to VPS IP.
15. **LLM classifier with defense in depth**: untrusted email in delimiters + system rules + explicit suspicious path + strict JSON Schema (enums, maxLength, no extra fields) + LLM has no tools. Prompt alone is never the security boundary. Test set includes injection attempts. Temperature 0. Model: gemini-3.5-flash (2.5 retired for new users).
16. **Dedup before LLM** (Seen IDs + filter) + UNIQUE gmail_id in DB as safety net = idempotent runs (2nd run: 0 LLM calls, 35s -> 11s). Secrets masked + zero-width chars stripped before leaving the server. No email body/subject stored. Gmail fetch capped at 20/run.
17. **Prompt v2 from real-data evaluation**: v1 over-flagged self-triggered account notifications as urgent (7/20 = alert fatigue). Every prompt change is regression-tested against the fixed test set.
18. **Digest decoupled from Gmail**: reads only Postgres (triage and digest communicate via DB). Mark notified AFTER Telegram succeeds, so a failed send never loses emails (at-least-once). Plain-text Telegram (no parse mode) so AI/email content cannot inject markup. Parameterized SQL, never string-built. 3900-char cap for Telegram limit.
