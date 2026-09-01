CREATE TABLE mobility.shared_routes (
    id        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usage_id         UUID NOT NULL,
    user_id          UUID NOT NULL,
    social_network   VARCHAR(50),
    shared_data      JSONB,
    confirmed        BOOLEAN NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (shared_data IS NULL OR jsonb_typeof(shared_data) = 'object')
);