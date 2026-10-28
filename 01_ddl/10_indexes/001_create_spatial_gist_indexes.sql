CREATE INDEX IF NOT EXISTS idx_obstacle_reports_location
    ON community.obstacle_reports USING GIST (location);

CREATE INDEX IF NOT EXISTS idx_alerts_impact_area
    ON community.alerts USING GIST (impact_area);

CREATE INDEX IF NOT EXISTS idx_air_quality_data_location
    ON integrations.air_quality_data USING GIST (location);

CREATE INDEX IF NOT EXISTS idx_weather_data_location
    ON integrations.weather_data USING GIST (location);

CREATE INDEX IF NOT EXISTS idx_points_of_interest_location
    ON mobility.points_of_interest USING GIST (location);

CREATE INDEX IF NOT EXISTS idx_routes_start_location
    ON mobility.routes USING GIST (start_location);

CREATE INDEX IF NOT EXISTS idx_routes_end_location
    ON mobility.routes USING GIST (end_location);

CREATE INDEX IF NOT EXISTS idx_routes_geometry
    ON mobility.routes USING GIST (route_geometry);

CREATE INDEX IF NOT EXISTS idx_route_usage_actual_route
    ON mobility.route_usage USING GIST (actual_route);

CREATE INDEX IF NOT EXISTS idx_address_history_location
    ON mobility.address_history USING GIST (location);
