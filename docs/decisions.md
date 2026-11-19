# Decisions

1. **n8n** as automation engine. Triggers, retries, OAuth, scheduling for free. Not Zapier (closed, no self-host), not pure Python (rebuilding plumbing).
2. **Docker Compose from day 1**. Multi-service, reproducible on any server.
3. **Postgres instead of SQLite**. One real DB for n8n + app data, proper backups.
4. **Separate `app` database**. Our data isolated from n8n internals.
5. **Pinned image versions (n8n 2.49.1)**. No silent breaking updates. 3.x stays off until stable + migration report checked.
6. **n8n bound to 127.0.0.1**. Never public; Postgres has no published port.
7. **Own N8N_ENCRYPTION_KEY**. Credentials recoverable; key kept in password manager.
8. **Secrets in .env (gitignored, chmod 600) + .env.example committed**. No secrets in git.
9. **Telegram as the interface**. Free bot API, inline buttons for approvals, already on my phone, no frontend to build. Not email (would pollute the inbox we triage), not WhatsApp (paid business API).
10. **Credentials referenced, never embedded**. Token encrypted in n8n DB; exported workflows hold only a credential ID, safe for git.
