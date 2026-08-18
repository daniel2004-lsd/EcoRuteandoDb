CREATE TABLE admin.daily_statistics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    statistic_date DATE NOT NULL,

    total_users INT NOT NULL DEFAULT 0,
    new_users INT NOT NULL DEFAULT 0,
    active_users INT NOT NULL DEFAULT 0,

    total_routes INT NOT NULL DEFAULT 0,
    completed_routes INT NOT NULL DEFAULT 0,

    total_communities INT NOT NULL DEFAULT 0,
    total_reports INT NOT NULL DEFAULT 0,

    total_co2_saved NUMERIC(12,2) NOT NULL DEFAULT 0,
    total_distance_km NUMERIC(12,2) NOT NULL DEFAULT 0,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ,

    CONSTRAINT uq_daily_statistics_date
        UNIQUE (statistic_date)
);