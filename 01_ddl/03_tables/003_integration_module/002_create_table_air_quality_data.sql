CREATE TABLE integrations.air_quality_data (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    location       GEOGRAPHY(POINT, 4326) NOT NULL,
    city           VARCHAR(100),
    pm25           NUMERIC(8,2),
    pm10           NUMERIC(8,2),
    co2_ppm        NUMERIC(8,2),
    aqi            INT,
    source         VARCHAR(100),
    raw_data       JSONB,
    measured_at    TIMESTAMPTZ NOT NULL,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (raw_data IS NULL OR jsonb_typeof(raw_data) = 'object')
);