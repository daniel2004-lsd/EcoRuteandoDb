CREATE TABLE mobility.address_history (
    history_id   BIGSERIAL PRIMARY KEY,
    user_id      UUID NOT NULL,
    search_text  VARCHAR(300) NOT NULL,
    place_id     VARCHAR(255),
    location     GEOGRAPHY(POINT, 4326),
    search_type  mobility.search_type NOT NULL DEFAULT 'search',
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
