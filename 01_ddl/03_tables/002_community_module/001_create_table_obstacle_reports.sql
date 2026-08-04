CREATE TABLE community.obstacle_reports (
    id        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id          UUID NOT NULL,
    report_type      VARCHAR(100) NOT NULL,
    description      TEXT NOT NULL,
    location         GEOGRAPHY(POINT, 4326) NOT NULL,
    address_text     VARCHAR(300),
    photo_url        VARCHAR(500),
status           community.report_status NOT NULL DEFAULT 'pending',
    validator_id     UUID,
    validation_note  TEXT,
    validated_at     TIMESTAMPTZ,
    is_active        BOOLEAN NOT NULL DEFAULT TRUE,
    expires_at       TIMESTAMPTZ,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (validator_id IS NULL OR validator_id <> user_id)
);