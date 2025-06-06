import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이용약관'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trader App 이용약관',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '시행일: 2025년 2월 21일',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 24),
            _SectionTitle('제1조 (목적)'),
            _SectionContent('''
이 약관은 Trader App(이하 "회사")이 제공하는 모바일 애플리케이션 서비스(이하 "서비스")의 이용과 관련하여 회사와 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.
            '''),
            _SectionTitle('제2조 (정의)'),
            _SectionContent('''
1. "서비스"란 회사가 제공하는 AI 기반 주식 추천 및 투자 정보 제공 서비스를 의미합니다.
2. "이용자"란 이 약관에 따라 회사가 제공하는 서비스를 받는 회원 및 비회원을 말합니다.
3. "회원"이란 회사에 개인정보를 제공하여 회원등록을 한 자로서, 회사의 정보를 지속적으로 제공받으며 서비스를 계속적으로 이용할 수 있는 자를 말합니다.
            '''),
            _SectionTitle('제3조 (약관의 효력 및 변경)'),
            _SectionContent('''
1. 이 약관은 서비스 화면에 게시하거나 기타의 방법으로 이용자에게 공지함으로써 효력을 발생합니다.
2. 회사는 필요하다고 인정되는 경우 이 약관을 변경할 수 있으며, 변경된 약관은 적용일 7일 전에 공지합니다.
            '''),
            _SectionTitle('제4조 (서비스의 제공)'),
            _SectionContent('''
1. 회사는 다음과 같은 서비스를 제공합니다:
   • AI 기반 주식 추천 서비스
   • 전설적 트레이더 전략 정보 제공
   • 실시간 주식 시세 정보
   • 포트폴리오 관리 도구
   • 리스크 계산기

2. 서비스는 연중무휴, 1일 24시간 제공함을 원칙으로 합니다. 단, 시스템 점검 등의 필요에 의해 일시적으로 중단될 수 있습니다.
            '''),
            _FinancialDisclaimer(),
            _SectionTitle('제5조 (회원가입)'),
            _SectionContent('''
1. 회원가입은 이용자가 약관의 내용에 대하여 동의를 하고 회원가입신청을 한 후 회사가 이러한 신청에 대하여 승낙함으로써 체결됩니다.
2. 회사는 다음 각 호에 해당하는 신청에 대하여는 승낙을 하지 않거나 사후에 이용계약을 해지할 수 있습니다:
   • 실명이 아니거나 타인의 명의를 이용한 경우
   • 허위의 정보를 기재하거나, 회사가 제시하는 내용을 기재하지 않은 경우
   • 기타 이용신청 요건을 충족하지 못한 경우
            '''),
            _SectionTitle('제6조 (이용자의 의무)'),
            _SectionContent('''
이용자는 다음 행위를 하여서는 안 됩니다:
1. 타인의 정보를 도용하는 행위
2. 회사의 지적재산권을 침해하는 행위
3. 서비스의 운영을 고의로 방해하는 행위
4. 기타 관계법령에 위배되는 행위
            '''),
            _SectionTitle('제7조 (서비스 이용요금)'),
            _SectionContent('''
1. 기본 서비스는 무료로 제공됩니다.
2. 프리미엄 서비스는 별도의 이용요금을 지불하여야 합니다.
3. 유료서비스의 이용요금은 서비스 내에 명시된 요금정책에 따릅니다.
4. 회사는 유료서비스 이용요금을 변경할 수 있으며, 변경 시 30일 전에 공지합니다.
            '''),
            _SectionTitle('제8조 (면책조항)'),
            _SectionContent('''
1. 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다.
2. 회사는 이용자의 귀책사유로 인한 서비스 이용의 장애에 대하여는 책임을 지지 않습니다.
3. 회사가 제공하는 모든 투자 정보는 참고 자료일 뿐이며, 투자 결정에 따른 책임은 전적으로 이용자에게 있습니다.
            '''),
            _SectionTitle('제9조 (개인정보보호)'),
            _SectionContent('''
회사는 이용자의 개인정보를 보호하기 위하여 개인정보처리방침을 수립하고 이를 준수합니다. 자세한 내용은 개인정보처리방침을 참고하시기 바랍니다.
            '''),
            _SectionTitle('제10조 (분쟁해결)'),
            _SectionContent('''
1. 회사와 이용자 간에 발생한 분쟁은 상호 협의하여 해결하는 것을 원칙으로 합니다.
2. 협의가 이루어지지 않을 경우, 관련 법령에 따른 관할 법원에서 해결합니다.
            '''),
            SizedBox(height: 40),
            Text(
              '부칙',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '이 약관은 2025년 2월 21일부터 시행합니다.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  final String content;
  const _SectionContent(this.content);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(fontSize: 14, height: 1.5),
    );
  }
}

class _FinancialDisclaimer extends StatelessWidget {
  const _FinancialDisclaimer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                '투자 위험 경고',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '''본 서비스에서 제공하는 모든 정보는 투자 참고 자료이며, 투자 권유나 투자 자문에 해당하지 않습니다.

• 모든 투자 결정은 이용자 본인의 판단과 책임 하에 이루어져야 합니다.
• 주식 투자는 원금 손실의 위험이 있습니다.
• 과거의 수익률이 미래의 수익을 보장하지 않습니다.
• 회사는 제공된 정보를 바탕으로 한 투자 결과에 대해 어떠한 책임도 지지 않습니다.''',
            style: TextStyle(fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }
}