ALTER TABLE security.role_permissions
DROP CONSTRAINT fk_role_permissions_role,
DROP CONSTRAINT fk_role_permissions_permission;

ALTER TABLE security.users
DROP CONSTRAINT fk_users_primary_role;

ALTER TABLE security.user_roles
DROP CONSTRAINT fk_user_roles_user,
DROP CONSTRAINT fk_user_roles_role;

ALTER TABLE security.oauth_accounts
DROP CONSTRAINT fk_oauth_accounts_user;

ALTER TABLE security.sessions
DROP CONSTRAINT fk_sessions_user;

ALTER TABLE security.email_verifications
DROP CONSTRAINT fk_email_verifications_user;

ALTER TABLE security.password_recovery
DROP CONSTRAINT fk_password_recovery_user;

ALTER TABLE security.two_factor_auth
DROP CONSTRAINT fk_two_factor_auth_user;

ALTER TABLE security.audit_logs
DROP CONSTRAINT fk_audit_logs_user;

ALTER TABLE security.error_logs
DROP CONSTRAINT fk_error_logs_user;

ALTER TABLE mobility.points_of_interest
DROP CONSTRAINT fk_points_of_interest_created_by;

ALTER TABLE mobility.routes
DROP CONSTRAINT fk_routes_created_by;

ALTER TABLE mobility.route_poi
DROP CONSTRAINT fk_route_poi_route,
DROP CONSTRAINT fk_route_poi_poi;

ALTER TABLE mobility.route_usage
DROP CONSTRAINT fk_route_usage_user,
DROP CONSTRAINT fk_route_usage_route;

ALTER TABLE mobility.address_history
DROP CONSTRAINT fk_address_history_user;

ALTER TABLE mobility.favorite_routes
DROP CONSTRAINT fk_favorite_routes_user,
DROP CONSTRAINT fk_favorite_routes_route;

ALTER TABLE mobility.ratings
DROP CONSTRAINT fk_ratings_user,
DROP CONSTRAINT fk_ratings_route;

ALTER TABLE mobility.rating_votes
DROP CONSTRAINT fk_rating_votes_user,
DROP CONSTRAINT fk_rating_votes_rating;

ALTER TABLE mobility.shared_routes
DROP CONSTRAINT fk_shared_routes_user;

ALTER TABLE community.obstacle_reports
DROP CONSTRAINT fk_obstacle_reports_user,
DROP CONSTRAINT fk_obstacle_reports_validator;

ALTER TABLE community.report_votes
DROP CONSTRAINT fk_report_votes_user,
DROP CONSTRAINT fk_report_votes_report;

ALTER TABLE community.route_reports
DROP CONSTRAINT fk_route_reports_route,
DROP CONSTRAINT fk_route_reports_report;

ALTER TABLE community.alerts
DROP CONSTRAINT fk_alerts_created_by,
DROP CONSTRAINT fk_alerts_report,
DROP CONSTRAINT fk_alerts_weather;

ALTER TABLE community.alert_route
DROP CONSTRAINT fk_alert_route_alert,
DROP CONSTRAINT fk_alert_route_route;

ALTER TABLE notifications.notifications
DROP CONSTRAINT fk_notifications_user,
DROP CONSTRAINT fk_notifications_template;

ALTER TABLE admin.support_tickets
DROP CONSTRAINT fk_support_tickets_user,
DROP CONSTRAINT fk_support_tickets_admin;

ALTER TABLE admin.support_messages
DROP CONSTRAINT fk_support_messages_ticket,
DROP CONSTRAINT fk_support_messages_sender;

ALTER TABLE admin.exports
DROP CONSTRAINT fk_exports_user;

ALTER TABLE admin.system_configuration
DROP CONSTRAINT fk_system_configuration_updated_by;

ALTER TABLE security.security_policies
DROP CONSTRAINT chk_security_policies_singleton;

ALTER TABLE admin.support_tickets
DROP CONSTRAINT chk_support_tickets_admin_diff;