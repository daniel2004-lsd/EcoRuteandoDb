CREATE TABLE integrations.weather_data (
    id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    location            GEOGRAPHY(POINT, 4326) NOT NULL,
    city                VARCHAR(100),
    temperature_c       NUMERIC(5,2),
    humidity_pct        SMALLINT CHECK (
                            humidity_pct IS NULL
                            OR humidity_pct BETWEEN 0 AND 100
                         ),
    wind_speed_kmh      NUMERIC(6,2),
    condition           VARCHAR(80),
    rain_probability    SMALLINT CHECK (
                            rain_probability IS NULL
                            OR rain_probability BETWEEN 0 AND 100
                         ),
    raw_data            JSONB,
    source              VARCHAR(100),
    valid_from          TIMESTAMPTZ NOT NULL,
    valid_until         TIMESTAMPTZ NOT NULL,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (raw_data IS NULL OR jsonb_typeof(raw_data) = 'object'),
    CHECK (valid_until > valid_from)
);