-- Performance optimization indexes

-- Users table indexes
CREATE INDEX CONCURRENTLY idx_users_stripe_customer ON users(stripe_customer_id) WHERE stripe_customer_id IS NOT NULL;
CREATE INDEX CONCURRENTLY idx_users_created_at ON users(created_at);
CREATE INDEX CONCURRENTLY idx_users_last_login ON users(last_login_at) WHERE last_login_at IS NOT NULL;

-- Recommendations indexes for filtering and sorting
CREATE INDEX CONCURRENTLY idx_recommendations_ticker ON recommendations(ticker);
CREATE INDEX CONCURRENTLY idx_recommendations_created ON recommendations(created_at);
CREATE INDEX CONCURRENTLY idx_recommendations_expires ON recommendations(expires_at) WHERE is_active = true;
CREATE INDEX CONCURRENTLY idx_recommendations_confidence ON recommendations(confidence_score) WHERE is_active = true;
CREATE INDEX CONCURRENTLY idx_recommendations_composite ON recommendations(trader_strategy_id, is_active, created_at DESC);

-- Positions indexes for performance queries
CREATE INDEX CONCURRENTLY idx_positions_ticker ON positions(ticker);
CREATE INDEX CONCURRENTLY idx_positions_opened ON positions(opened_at);
CREATE INDEX CONCURRENTLY idx_positions_closed ON positions(closed_at) WHERE status = 'closed';
CREATE INDEX CONCURRENTLY idx_positions_portfolio_status ON positions(portfolio_id, status);
CREATE INDEX CONCURRENTLY idx_positions_pnl ON positions(realized_pnl_percentage) WHERE status = 'closed';

-- Transactions indexes
CREATE INDEX CONCURRENTLY idx_transactions_ticker ON transactions(ticker);
CREATE INDEX CONCURRENTLY idx_transactions_executed ON transactions(executed_at);
CREATE INDEX CONCURRENTLY idx_transactions_portfolio_date ON transactions(portfolio_id, executed_at DESC);

-- Notifications indexes
CREATE INDEX CONCURRENTLY idx_notifications_created ON notifications(created_at);
CREATE INDEX CONCURRENTLY idx_notifications_type ON notifications(type);
CREATE INDEX CONCURRENTLY idx_notifications_user_unread ON notifications(user_id, created_at DESC) WHERE is_read = false;

-- Position snapshots indexes for historical analysis
CREATE INDEX CONCURRENTLY idx_snapshots_position ON position_snapshots(position_id);
CREATE INDEX CONCURRENTLY idx_snapshots_time ON position_snapshots(snapshot_at);
CREATE INDEX CONCURRENTLY idx_snapshots_position_time ON position_snapshots(position_id, snapshot_at DESC);

-- Strategy subscriptions indexes
CREATE INDEX CONCURRENTLY idx_strategy_subs_strategy ON strategy_subscriptions(strategy_id) WHERE is_active = true;
CREATE INDEX CONCURRENTLY idx_strategy_subs_user ON strategy_subscriptions(user_id) WHERE is_active = true;

-- Subscription events indexes
CREATE INDEX CONCURRENTLY idx_sub_events_user ON subscription_events(user_id);
CREATE INDEX CONCURRENTLY idx_sub_events_type ON subscription_events(event_type);
CREATE INDEX CONCURRENTLY idx_sub_events_created ON subscription_events(created_at);

-- Email queue indexes
CREATE INDEX CONCURRENTLY idx_email_queue_scheduled ON email_queue(scheduled_at) WHERE sent_at IS NULL;
CREATE INDEX CONCURRENTLY idx_email_queue_template ON email_queue(template);

-- Refresh tokens indexes
CREATE INDEX CONCURRENTLY idx_refresh_tokens_expires ON refresh_tokens(expires_at);
CREATE INDEX CONCURRENTLY idx_refresh_tokens_user ON refresh_tokens(user_id);

-- API usage indexes
CREATE INDEX CONCURRENTLY idx_api_usage_date ON api_usage(created_at);

-- Partial indexes for common queries
CREATE INDEX CONCURRENTLY idx_active_recommendations ON recommendations(created_at DESC) 
    WHERE is_active = true AND expires_at > CURRENT_TIMESTAMP;

CREATE INDEX CONCURRENTLY idx_open_positions_value ON positions(portfolio_id, entry_price, quantity) 
    WHERE status = 'open';

CREATE INDEX CONCURRENTLY idx_premium_strategies ON trader_strategies(type, risk_level) 
    WHERE is_active = true AND premium_only = true;

-- Composite indexes for complex queries
CREATE INDEX CONCURRENTLY idx_portfolio_performance ON positions(portfolio_id, status, realized_pnl_percentage) 
    WHERE status = 'closed';

CREATE INDEX CONCURRENTLY idx_user_activity ON users(subscription_type, last_login_at) 
    WHERE is_verified = true;

-- BRIN indexes for time-series data (more efficient for large tables)
CREATE INDEX CONCURRENTLY idx_positions_snapshots_brin ON position_snapshots USING BRIN(snapshot_at);
CREATE INDEX CONCURRENTLY idx_notifications_brin ON notifications USING BRIN(created_at);
CREATE INDEX CONCURRENTLY idx_transactions_brin ON transactions USING BRIN(executed_at);

-- GIN indexes for JSONB columns
CREATE INDEX CONCURRENTLY idx_users_preferences_gin ON users USING GIN(notification_preferences);
CREATE INDEX CONCURRENTLY idx_users_devices_gin ON users USING GIN(device_tokens);
CREATE INDEX CONCURRENTLY idx_recommendations_conditions_gin ON recommendations USING GIN(market_conditions);
CREATE INDEX CONCURRENTLY idx_notifications_data_gin ON notifications USING GIN(data);

-- Function-based indexes
CREATE INDEX CONCURRENTLY idx_positions_current_value ON positions((entry_price * quantity)) 
    WHERE status = 'open';

CREATE INDEX CONCURRENTLY idx_recommendations_risk_reward ON recommendations((target_price - entry_price) / (entry_price - stop_loss)) 
    WHERE stop_loss IS NOT NULL AND is_active = true;

-- Covering indexes (includes all needed columns to avoid table lookups)
CREATE INDEX CONCURRENTLY idx_positions_covering ON positions(portfolio_id, status) 
    INCLUDE (ticker, quantity, entry_price, opened_at) 
    WHERE status = 'open';

CREATE INDEX CONCURRENTLY idx_recommendations_covering ON recommendations(trader_strategy_id, is_active) 
    INCLUDE (ticker, action, confidence_score, created_at) 
    WHERE is_active = true;

-- Statistics for query optimization
ANALYZE users;
ANALYZE trader_strategies;
ANALYZE recommendations;
ANALYZE portfolios;
ANALYZE positions;
ANALYZE transactions;
ANALYZE notifications;
ANALYZE position_snapshots;

-- Create materialized view for strategy performance
CREATE MATERIALIZED VIEW mv_strategy_performance AS
SELECT 
    s.id as strategy_id,
    s.name as strategy_name,
    s.type,
    s.risk_level,
    COUNT(DISTINCT p.id) as total_positions,
    COUNT(DISTINCT CASE WHEN p.realized_pnl > 0 THEN p.id END) as winning_positions,
    AVG(p.realized_pnl_percentage) as avg_return,
    STDDEV(p.realized_pnl_percentage) as return_volatility,
    MAX(p.realized_pnl_percentage) as max_return,
    MIN(p.realized_pnl_percentage) as max_loss,
    SUM(p.realized_pnl) as total_pnl
FROM trader_strategies s
LEFT JOIN recommendations r ON s.id = r.trader_strategy_id
LEFT JOIN positions p ON r.id = p.recommendation_id AND p.status = 'closed'
GROUP BY s.id, s.name, s.type, s.risk_level;

CREATE UNIQUE INDEX ON mv_strategy_performance(strategy_id);

-- Create view for user portfolio summary
CREATE OR REPLACE VIEW v_user_portfolio_summary AS
SELECT 
    u.id as user_id,
    u.email,
    u.subscription_type,
    COUNT(DISTINCT p.id) as portfolio_count,
    SUM(p.current_value) as total_value,
    COUNT(DISTINCT pos.id) FILTER (WHERE pos.status = 'open') as open_positions,
    COUNT(DISTINCT pos.id) FILTER (WHERE pos.status = 'closed') as closed_positions,
    AVG(pos.realized_pnl_percentage) FILTER (WHERE pos.status = 'closed') as avg_return,
    COUNT(DISTINCT pos.id) FILTER (WHERE pos.status = 'closed' AND pos.realized_pnl > 0) * 100.0 / 
        NULLIF(COUNT(DISTINCT pos.id) FILTER (WHERE pos.status = 'closed'), 0) as win_rate
FROM users u
LEFT JOIN portfolios p ON u.id = p.user_id
LEFT JOIN positions pos ON p.id = pos.portfolio_id
GROUP BY u.id, u.email, u.subscription_type;

-- Maintenance: Update statistics regularly
CREATE OR REPLACE FUNCTION update_table_statistics()
RETURNS void AS $$
BEGIN
    ANALYZE users;
    ANALYZE recommendations;
    ANALYZE positions;
    ANALYZE transactions;
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_strategy_performance;
END;
$$ LANGUAGE plpgsql;

-- Schedule regular statistics updates (requires pg_cron extension)
-- SELECT cron.schedule('update-statistics', '0 */6 * * *', 'SELECT update_table_statistics();');