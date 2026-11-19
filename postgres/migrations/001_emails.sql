SELECT 'CREATE ROLE ai_app LOGIN' WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'ai_app')\gexec
ALTER ROLE ai_app WITH PASSWORD :'app_pw';

CREATE TABLE IF NOT EXISTS emails (
  id            BIGSERIAL PRIMARY KEY,
  gmail_id      TEXT NOT NULL UNIQUE,
  thread_id     TEXT,
  from_addr     TEXT,
  received_at   TIMESTAMPTZ,
  category      TEXT NOT NULL CHECK (category IN ('job','urgent','admin','social','newsletter')),
  priority      SMALLINT NOT NULL CHECK (priority BETWEEN 1 AND 3),
  summary       TEXT,
  action_needed BOOLEAN NOT NULL DEFAULT false,
  suspicious    BOOLEAN NOT NULL DEFAULT false,
  model         TEXT,
  processed_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  notified_at   TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS emails_processed_at_idx ON emails (processed_at);

REVOKE CONNECT ON DATABASE n8n FROM PUBLIC;
GRANT CONNECT ON DATABASE app TO ai_app;
GRANT USAGE ON SCHEMA public TO ai_app;
GRANT SELECT, INSERT, UPDATE ON emails TO ai_app;
GRANT USAGE, SELECT ON SEQUENCE emails_id_seq TO ai_app;
