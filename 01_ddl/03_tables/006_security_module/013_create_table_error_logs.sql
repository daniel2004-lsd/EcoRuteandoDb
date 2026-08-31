CREATE TABLE security.error_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    user_id UUID,

    error_level security.error_level NOT NULL DEFAULT 'ERROR',

    source VARCHAR(100),

    message TEXT NOT NULL,

    stack_trace TEXT,

    context_data JSONB,

    updated_at TIMESTAMPTZ  NULL ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now()


);