CREATE TABLE security.audit_logs (
    audit_id      BIGSERIAL,
    user_id       UUID,
    action        VARCHAR(100) NOT NULL,
    entity_name   VARCHAR(80),
    entity_id     VARCHAR(100),
    before_data   JSONB,
    after_data    JSONB,
    source_ip     INET,
    user_agent    TEXT,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (audit_id, created_at)
) PARTITION BY RANGE (created_at);
