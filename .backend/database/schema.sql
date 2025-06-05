-- Trader App Database Schema

-- 사용자 테이블
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255),
    subscription_tier VARCHAR(50) DEFAULT 'free',
    subscription_expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 구독 플랜 테이블
CREATE TABLE subscription_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    tier VARCHAR(50) NOT NULL, -- 'basic', 'premium', 'professional'
    price DECIMAL(10, 2) NOT NULL,
    features JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 트레이딩 전략 테이블
CREATE TABLE trading_strategies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL, -- 'livermore', 'williams', 'weinstein'
    name VARCHAR(100) NOT NULL,
    description TEXT,
    rules JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 주식 추천 테이블
CREATE TABLE stock_recommendations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    strategy_id UUID REFERENCES trading_strategies(id),
    symbol VARCHAR(10) NOT NULL,
    company_name VARCHAR(255),
    recommendation_type VARCHAR(20) NOT NULL, -- 'BUY', 'SELL', 'HOLD'
    current_price DECIMAL(10, 2),
    target_price DECIMAL(10, 2),
    stop_loss DECIMAL(10, 2),
    position_size DECIMAL(5, 2), -- 포지션 크기 (%)
    risk_ratio DECIMAL(5, 2),
    confidence_score DECIMAL(3, 2), -- 0.00 ~ 1.00
    reason TEXT,
    technical_analysis JSONB,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP
);

-- 사용자 포트폴리오 테이블
CREATE TABLE user_portfolios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    recommendation_id UUID REFERENCES stock_recommendations(id),
    entry_price DECIMAL(10, 2),
    exit_price DECIMAL(10, 2),
    shares INTEGER,
    status VARCHAR(20) DEFAULT 'open', -- 'open', 'closed'
    profit_loss DECIMAL(10, 2),
    entered_at TIMESTAMP DEFAULT NOW(),
    exited_at TIMESTAMP,
    notes TEXT
);

-- 알림 설정 테이블
CREATE TABLE notification_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    strategy_id UUID REFERENCES trading_strategies(id),
    email_enabled BOOLEAN DEFAULT true,
    push_enabled BOOLEAN DEFAULT true,
    frequency VARCHAR(20) DEFAULT 'realtime', -- 'realtime', 'daily', 'weekly'
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 거래 히스토리 테이블
CREATE TABLE trading_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    portfolio_id UUID REFERENCES user_portfolios(id),
    action VARCHAR(20) NOT NULL, -- 'BUY', 'SELL'
    symbol VARCHAR(10) NOT NULL,
    price DECIMAL(10, 2),
    shares INTEGER,
    total_amount DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT NOW()
);

-- 시장 데이터 캐시 테이블 (성능 최적화용)
CREATE TABLE market_data_cache (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    symbol VARCHAR(10) NOT NULL,
    data_type VARCHAR(50) NOT NULL, -- 'price', 'volume', 'technical_indicators'
    data JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP,
    UNIQUE(symbol, data_type)
);

-- 인덱스 생성
CREATE INDEX idx_recommendations_strategy ON stock_recommendations(strategy_id);
CREATE INDEX idx_recommendations_active ON stock_recommendations(is_active);
CREATE INDEX idx_portfolios_user ON user_portfolios(user_id);
CREATE INDEX idx_portfolios_status ON user_portfolios(status);
CREATE INDEX idx_market_cache_symbol ON market_data_cache(symbol);
CREATE INDEX idx_market_cache_expires ON market_data_cache(expires_at);