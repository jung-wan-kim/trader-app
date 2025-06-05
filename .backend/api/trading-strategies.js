// 트레이딩 전략 정의

export const TRADING_STRATEGIES = {
  LIVERMORE: {
    id: 'livermore',
    name: '제시 리버모어',
    description: '추세 추종 및 피라미딩 전략',
    rules: {
      entry: [
        '주요 저항선 돌파 시 진입',
        '거래량 증가 확인',
        '산업 그룹 리더 종목 선택'
      ],
      exit: [
        '주요 지지선 하향 돌파',
        '추세 반전 신호',
        '10% 손실 시 무조건 손절'
      ],
      positionSizing: '초기 포지션 25%, 수익 시 피라미딩'
    }
  },
  
  WILLIAMS: {
    id: 'williams',
    name: '래리 윌리엄스',
    description: '단기 모멘텀 및 변동성 돌파 전략',
    rules: {
      entry: [
        '전일 고점 돌파',
        'Williams %R 과매도 구간 탈출',
        '변동성 돌파 확인'
      ],
      exit: [
        '당일 종가 청산',
        '최대 손실 2% 도달',
        '목표 수익 5% 달성'
      ],
      positionSizing: '켈리 공식 기반 자금 관리'
    }
  },
  
  WEINSTEIN: {
    id: 'weinstein',
    name: '스탠 와인스타인',
    description: '스테이지 분석 기반 중장기 투자',
    stages: {
      1: '바닥 형성 단계 - 관망',
      2: '상승 단계 - 매수',
      3: '천장 형성 단계 - 매도 준비',
      4: '하락 단계 - 공매도 또는 현금 보유'
    },
    rules: {
      entry: [
        'Stage 2 진입 확인',
        '30주 이동평균선 상향 돌파',
        '거래량 급증'
      ],
      exit: [
        'Stage 3 진입 신호',
        '30주 이동평균선 하향 돌파',
        '거래량 감소와 함께 고점 형성'
      ],
      positionSizing: '분할 매수, 평균 단가 관리'
    }
  }
};

/**
 * 전략별 신호 생성
 */
export function generateSignals(strategy, marketData) {
  switch (strategy) {
    case 'livermore':
      return generateLivermoreSignals(marketData);
    case 'williams':
      return generateWilliamsSignals(marketData);
    case 'weinstein':
      return generateWeinsteinSignals(marketData);
    default:
      throw new Error(`Unknown strategy: ${strategy}`);
  }
}

function generateLivermoreSignals(data) {
  // TODO: 리버모어 전략 신호 생성 로직
  return {
    signal: 'BUY',
    strength: 0.8,
    conditions: ['주요 저항선 돌파', '거래량 증가']
  };
}

function generateWilliamsSignals(data) {
  // TODO: 윌리엄스 전략 신호 생성 로직
  return {
    signal: 'BUY',
    strength: 0.7,
    conditions: ['변동성 돌파', 'Williams %R 신호']
  };
}

function generateWeinsteinSignals(data) {
  // TODO: 와인스타인 전략 신호 생성 로직
  return {
    signal: 'HOLD',
    strength: 0.6,
    stage: 2,
    conditions: ['Stage 2 진행 중']
  };
}