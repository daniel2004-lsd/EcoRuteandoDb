ALTER TABLE security.role_permissions
    ADD CONSTRAINT fk_role_permissions_role
        FOREIGN KEY (role_id)
        REFERENCES security.roles(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_role_permissions_permission
        FOREIGN KEY (permission_id)
        REFERENCES security.permissions(id)
        ON DELETE CASCADE;

ALTER TABLE security.users
    ADD CONSTRAINT fk_users_primary_role
        FOREIGN KEY (primary_role_id)
        REFERENCES security.roles(id)
        ON DELETE SET NULL;

ALTER TABLE security.user_roles
    ADD CONSTRAINT fk_user_roles_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_user_roles_role
        FOREIGN KEY (role_id)
        REFERENCES security.roles(id)
        ON DELETE CASCADE;

ALTER TABLE security.oauth_accounts
    ADD CONSTRAINT fk_oauth_accounts_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE;

ALTER TABLE security.sessions
    ADD CONSTRAINT fk_sessions_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE;

ALTER TABLE security.email_verifications
    ADD CONSTRAINT fk_email_verifications_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE;

ALTER TABLE security.password_recovery
    ADD CONSTRAINT fk_password_recovery_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE;

ALTER TABLE security.refresh_tokens
    ADD CONSTRAINT fk_refresh_tokens_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE;

ALTER TABLE security.two_factor_auth
    ADD CONSTRAINT fk_two_factor_auth_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE;

ALTER TABLE security.audit_logs
    ADD CONSTRAINT fk_audit_logs_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE SET NULL;

ALTER TABLE security.error_logs
    ADD CONSTRAINT fk_error_logs_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE SET NULL;

ALTER TABLE mobility.points_of_interest
    ADD CONSTRAINT fk_points_of_interest_created_by
        FOREIGN KEY (created_by)
        REFERENCES security.users(id)
        ON DELETE SET NULL;

ALTER TABLE mobility.routes
    ADD CONSTRAINT fk_routes_created_by
        FOREIGN KEY (created_by)
        REFERENCES security.users(id)
        ON DELETE SET NULL;

ALTER TABLE mobility.route_poi
    ADD CONSTRAINT fk_route_poi_route
        FOREIGN KEY (route_id)
        REFERENCES mobility.routes(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_route_poi_poi
        FOREIGN KEY (poi_id)
        REFERENCES mobility.points_of_interest(id)
        ON DELETE CASCADE;

ALTER TABLE mobility.route_usage
    ADD CONSTRAINT fk_route_usage_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_route_usage_route
        FOREIGN KEY (route_id)
        REFERENCES mobility.routes(id)
        ON DELETE CASCADE;

ALTER TABLE mobility.address_history
    ADD CONSTRAINT fk_address_history_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE;

ALTER TABLE mobility.favorite_routes
    ADD CONSTRAINT fk_favorite_routes_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_favorite_routes_route
        FOREIGN KEY (route_id)
        REFERENCES mobility.routes(id)
        ON DELETE CASCADE;

ALTER TABLE mobility.ratings
    ADD CONSTRAINT fk_ratings_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_ratings_route
        FOREIGN KEY (route_id)
        REFERENCES mobility.routes(id)
        ON DELETE CASCADE;

ALTER TABLE mobility.rating_votes
    ADD CONSTRAINT fk_rating_votes_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_rating_votes_rating
        FOREIGN KEY (rating_id)
        REFERENCES mobility.ratings(id)
        ON DELETE CASCADE;

ALTER TABLE mobility.shared_routes
    ADD CONSTRAINT fk_shared_routes_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE;

ALTER TABLE community.obstacle_reports
    ADD CONSTRAINT fk_obstacle_reports_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_obstacle_reports_validator
        FOREIGN KEY (validator_id)
        REFERENCES security.users(id)
        ON DELETE SET NULL;

ALTER TABLE community.report_votes
    ADD CONSTRAINT fk_report_votes_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_report_votes_report
        FOREIGN KEY (report_id)
        REFERENCES community.obstacle_reports(id)
        ON DELETE CASCADE;

ALTER TABLE community.route_reports
    ADD CONSTRAINT fk_route_reports_route
        FOREIGN KEY (route_id)
        REFERENCES mobility.routes(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_route_reports_report
        FOREIGN KEY (report_id)
        REFERENCES community.obstacle_reports(id)
        ON DELETE CASCADE;

ALTER TABLE community.alerts
    ADD CONSTRAINT fk_alerts_created_by
        FOREIGN KEY (created_by)
        REFERENCES security.users(id)
        ON DELETE SET NULL;

ALTER TABLE community.alerts
    ADD CONSTRAINT fk_alerts_report
        FOREIGN KEY (report_id)
        REFERENCES community.obstacle_reports(id)
        ON DELETE SET NULL;

ALTER TABLE community.alerts
    ADD CONSTRAINT fk_alerts_weather
        FOREIGN KEY (weather_data_id)
        REFERENCES integrations.weather_data(id)
        ON DELETE SET NULL;

ALTER TABLE community.alert_route
    ADD CONSTRAINT fk_alert_route_alert
        FOREIGN KEY (alert_id)
        REFERENCES community.alerts(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_alert_route_route
        FOREIGN KEY (route_id)
        REFERENCES mobility.routes(id)
        ON DELETE CASCADE;

ALTER TABLE notifications.notifications
    ADD CONSTRAINT fk_notifications_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_notifications_template
        FOREIGN KEY (template_id)
        REFERENCES notifications.notification_templates(id)
        ON DELETE SET NULL;

ALTER TABLE admin.support_tickets
    ADD CONSTRAINT fk_support_tickets_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_support_tickets_admin
        FOREIGN KEY (admin_id)
        REFERENCES security.users(id)
        ON DELETE SET NULL;

ALTER TABLE admin.support_messages
    ADD CONSTRAINT fk_support_messages_ticket
        FOREIGN KEY (ticket_id)
        REFERENCES admin.support_tickets(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_support_messages_sender
        FOREIGN KEY (sender_id)
        REFERENCES security.users(id)
        ON DELETE SET NULL;

ALTER TABLE admin.exports
    ADD CONSTRAINT fk_exports_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(id)
        ON DELETE SET NULL;

ALTER TABLE admin.system_configuration
    ADD CONSTRAINT fk_system_configuration_updated_by
        FOREIGN KEY (updated_by)
        REFERENCES security.users(id)
        ON DELETE SET NULL;

ALTER TABLE security.security_policies
    ADD CONSTRAINT chk_security_policies_singleton
        CHECK (id = 1);

ALTER TABLE admin.support_tickets
    ADD CONSTRAINT chk_support_tickets_admin_diff
        CHECK (admin_id IS NULL OR admin_id <> user_id);