CREATE TABLE security.error_logs (
    error_id     BIGSERIAL,
    user_id      UUID,
    error_level  security.error_level NOT NULL DEFAULT 'ERROR',
    source       VARCHAR(100),
    message      TEXT NOT NULL,
    stack_trace  TEXT,
    context_data JSONB,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (error_id, created_at)
) PARTITION BY RANGE (created_at);
