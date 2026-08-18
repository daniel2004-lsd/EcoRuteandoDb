CREATE TABLE admin.exports (
    id      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id        UUID,
    export_type    VARCHAR(80) NOT NULL,
    format         admin.export_format NOT NULL,
    filters        JSONB,
    file_url       VARCHAR(500),
    status         admin.export_status NOT NULL DEFAULT 'generating',
    error_message  TEXT,
    size_bytes     BIGINT,
    records_count  INT,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    expires_at     TIMESTAMPTZ,
    CHECK (filters IS NULL OR jsonb_typeof(filters) = 'object')
);