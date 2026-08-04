CREATE TABLE mobility.points_of_interest (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name            VARCHAR(150) NOT NULL,
    poi_type        VARCHAR(80)  NOT NULL,
    description     TEXT,
    location        GEOGRAPHY(POINT, 4326) NOT NULL,
    address         VARCHAR(255),
    icon_url        VARCHAR(500),
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    source          VARCHAR(100),
    external_data   JSONB,
    created_by      UUID,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (external_data IS NULL OR jsonb_typeof(external_data) = 'object')
);
