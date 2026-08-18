CREATE TABLE security.audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    user_id UUID,

    action VARCHAR(100) NOT NULL,

    entity_name VARCHAR(80),

    entity_id VARCHAR(100),

    before_data JSONB,

    after_data JSONB,

    source_ip INET,

    user_agent TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    updated_at  TIMESTAMPTZ  NULL
);