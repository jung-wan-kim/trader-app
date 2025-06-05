-- Enable Row Level Security (RLS) on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE trader_strategies ENABLE ROW LEVEL SECURITY;
ALTER TABLE recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE portfolios ENABLE ROW LEVEL SECURITY;
ALTER TABLE positions ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE strategy_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE push_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE position_snapshots ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_usage ENABLE ROW LEVEL SECURITY;
ALTER TABLE refresh_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE recommendation_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscription_events ENABLE ROW LEVEL SECURITY;

-- Users table policies
CREATE POLICY "Users can view own profile" ON users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- Trader strategies policies
CREATE POLICY "Anyone can view active strategies" ON trader_strategies
    FOR SELECT USING (is_active = true);

CREATE POLICY "Only admins can manage strategies" ON trader_strategies
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = auth.uid() 
            AND users.subscription_type = 'vip'
        )
    );

-- Recommendations policies
CREATE POLICY "View recommendations based on subscription" ON recommendations
    FOR SELECT USING (
        CASE 
            WHEN premium_only = false THEN true
            ELSE EXISTS (
                SELECT 1 FROM users 
                WHERE users.id = auth.uid() 
                AND users.subscription_type IN ('premium', 'vip')
            )
        END
    );

-- Portfolios policies
CREATE POLICY "Users can view own portfolios" ON portfolios
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can create portfolios" ON portfolios
    FOR INSERT WITH CHECK (
        user_id = auth.uid() AND
        (
            SELECT COUNT(*) FROM portfolios WHERE user_id = auth.uid()
        ) < CASE 
            WHEN (SELECT subscription_type FROM users WHERE id = auth.uid()) = 'free' THEN 1
            WHEN (SELECT subscription_type FROM users WHERE id = auth.uid()) = 'basic' THEN 3
            WHEN (SELECT subscription_type FROM users WHERE id = auth.uid()) = 'premium' THEN 10
            ELSE 999
        END
    );

CREATE POLICY "Users can update own portfolios" ON portfolios
    FOR UPDATE USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own portfolios" ON portfolios
    FOR DELETE USING (user_id = auth.uid());

-- Positions policies
CREATE POLICY "Users can view own positions" ON positions
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM portfolios 
            WHERE portfolios.id = positions.portfolio_id 
            AND portfolios.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can create positions in own portfolios" ON positions
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM portfolios 
            WHERE portfolios.id = portfolio_id 
            AND portfolios.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update own positions" ON positions
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM portfolios 
            WHERE portfolios.id = positions.portfolio_id 
            AND portfolios.user_id = auth.uid()
        )
    );

-- Transactions policies
CREATE POLICY "Users can view own transactions" ON transactions
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM portfolios 
            WHERE portfolios.id = transactions.portfolio_id 
            AND portfolios.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can create transactions" ON transactions
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM portfolios 
            WHERE portfolios.id = portfolio_id 
            AND portfolios.user_id = auth.uid()
        )
    );

-- Subscriptions policies
CREATE POLICY "Users can view own subscriptions" ON subscriptions
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can create own subscriptions" ON subscriptions
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own subscriptions" ON subscriptions
    FOR UPDATE USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Strategy subscriptions policies
CREATE POLICY "Users can view own strategy subscriptions" ON strategy_subscriptions
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can manage own strategy subscriptions" ON strategy_subscriptions
    FOR ALL USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Notifications policies
CREATE POLICY "Users can view own notifications" ON notifications
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can update own notifications" ON notifications
    FOR UPDATE USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Push notifications policies
CREATE POLICY "Users can view own push notifications" ON push_notifications
    FOR SELECT USING (user_id = auth.uid());

-- Position snapshots policies
CREATE POLICY "Users can view own position snapshots" ON position_snapshots
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM positions
            JOIN portfolios ON positions.portfolio_id = portfolios.id
            WHERE positions.id = position_snapshots.position_id
            AND portfolios.user_id = auth.uid()
        )
    );

-- API usage policies
CREATE POLICY "Users can view own API usage" ON api_usage
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "System can track API usage" ON api_usage
    FOR INSERT WITH CHECK (true);

-- Refresh tokens policies
CREATE POLICY "Users can manage own refresh tokens" ON refresh_tokens
    FOR ALL USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Recommendation views policies
CREATE POLICY "Users can view own recommendation views" ON recommendation_views
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can track recommendation views" ON recommendation_views
    FOR INSERT WITH CHECK (user_id = auth.uid());

-- Subscription events policies
CREATE POLICY "Users can view own subscription events" ON subscription_events
    FOR SELECT USING (user_id = auth.uid());

-- Create functions for complex RLS policies
CREATE OR REPLACE FUNCTION can_access_premium_content()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM users 
        WHERE id = auth.uid() 
        AND subscription_type IN ('premium', 'vip')
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION get_user_subscription_type()
RETURNS subscription_type AS $$
BEGIN
    RETURN (
        SELECT subscription_type 
        FROM users 
        WHERE id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO authenticated;