CREATE INDEX IF NOT EXISTS idx_routes_status_transport
    ON mobility.routes (status, transport_type);

CREATE INDEX IF NOT EXISTS idx_routes_created_by
    ON mobility.routes (created_by);

CREATE INDEX IF NOT EXISTS idx_obstacle_reports_active_filter
    ON community.obstacle_reports (is_active, status, confidence_score);

CREATE INDEX IF NOT EXISTS idx_obstacle_reports_user_id
    ON community.obstacle_reports (user_id);

CREATE INDEX IF NOT EXISTS idx_route_usage_user_id
    ON mobility.route_usage (user_id);

CREATE INDEX IF NOT EXISTS idx_route_usage_route_id
    ON mobility.route_usage (route_id);

CREATE INDEX IF NOT EXISTS idx_users_status
    ON security.users (status);

CREATE INDEX IF NOT EXISTS idx_ratings_route_id
    ON mobility.ratings (route_id);

CREATE INDEX IF NOT EXISTS idx_points_of_interest_active_type
    ON mobility.points_of_interest (is_active, poi_type);

CREATE INDEX IF NOT EXISTS idx_support_tickets_user_id
    ON admin.support_tickets (user_id);

CREATE INDEX IF NOT EXISTS idx_support_tickets_status_priority
    ON admin.support_tickets (status, priority);
