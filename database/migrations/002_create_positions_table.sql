-- positions 테이블 생성
CREATE TABLE IF NOT EXISTS positions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    stock_code VARCHAR(10) NOT NULL,
    stock_name VARCHAR(255) NOT NULL,
    entry_price DECIMAL(10, 2) NOT NULL,
    current_price DECIMAL(10, 2) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    side VARCHAR(10) NOT NULL CHECK (side IN ('LONG', 'SHORT')),
    opened_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    closed_at TIMESTAMP WITH TIME ZONE,
    stop_loss DECIMAL(10, 2),
    take_profit DECIMAL(10, 2),
    recommendation_id VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'CLOSED', 'PENDING')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 인덱스 생성
CREATE INDEX idx_positions_user_id ON positions(user_id);
CREATE INDEX idx_positions_status ON positions(status);
CREATE INDEX idx_positions_stock_code ON positions(stock_code);
CREATE INDEX idx_positions_opened_at ON positions(opened_at);

-- Row Level Security (RLS) 활성화
ALTER TABLE positions ENABLE ROW LEVEL SECURITY;

-- RLS 정책: 사용자는 자신의 포지션만 볼 수 있음
CREATE POLICY "Users can view own positions" ON positions
    FOR SELECT USING (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 포지션만 생성할 수 있음
CREATE POLICY "Users can create own positions" ON positions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 포지션만 업데이트할 수 있음
CREATE POLICY "Users can update own positions" ON positions
    FOR UPDATE USING (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 포지션만 삭제할 수 있음
CREATE POLICY "Users can delete own positions" ON positions
    FOR DELETE USING (auth.uid() = user_id);

-- updated_at 자동 업데이트 트리거
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_positions_updated_at BEFORE UPDATE
    ON positions FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();