import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보처리방침'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trader App 개인정보처리방침',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '시행일: 2025년 2월 21일',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 24),
            _SectionTitle('1. 개인정보의 수집 및 이용목적'),
            _SectionContent('''
Trader App은 다음의 목적을 위하여 개인정보를 수집하고 있습니다:
• 회원 가입 및 관리
• 맞춤형 투자 정보 제공
• 서비스 개선 및 신규 서비스 개발
• 고객 문의 대응
            '''),
            _SectionTitle('2. 수집하는 개인정보의 항목'),
            _SectionContent('''
• 필수항목: 이메일, 비밀번호
• 선택항목: 이름, 전화번호, 투자 관심사
• 자동수집항목: 기기정보, 앱 사용 기록, IP 주소
            '''),
            _SectionTitle('3. 개인정보의 보유 및 이용기간'),
            _SectionContent('''
• 회원 탈퇴 시까지
• 단, 관련 법령에 따라 보존이 필요한 경우 해당 기간 동안 보관
• 전자상거래법에 따른 계약 또는 청약철회 기록: 5년
• 소비자 불만 또는 분쟁처리 기록: 3년
            '''),
            _SectionTitle('4. 개인정보의 제3자 제공'),
            _SectionContent('''
Trader App은 원칙적으로 이용자의 개인정보를 제3자에게 제공하지 않습니다. 
다만, 다음의 경우에는 예외로 합니다:
• 이용자의 동의가 있는 경우
• 법령의 규정에 의한 경우
            '''),
            _SectionTitle('5. 개인정보의 보호조치'),
            _SectionContent('''
• 개인정보 암호화
• 해킹 등에 대비한 기술적 대책
• 개인정보 접근 권한 제한
• 개인정보 취급 직원의 최소화 및 교육
            '''),
            _SectionTitle('6. 이용자의 권리'),
            _SectionContent('''
이용자는 언제든지 다음의 권리를 행사할 수 있습니다:
• 개인정보 열람 요구
• 개인정보 정정·삭제 요구
• 개인정보 처리정지 요구
• 개인정보 이동 요구
            '''),
            _SectionTitle('7. 개인정보보호책임자'),
            _SectionContent('''
개인정보보호책임자: 홍길동
이메일: privacy@traderapp.com
전화: 02-1234-5678
            '''),
            _SectionTitle('8. 개인정보처리방침의 변경'),
            _SectionContent('''
이 개인정보처리방침은 법령 및 서비스 변경사항을 반영하기 위해 수정될 수 있습니다.
변경사항은 앱 내 공지사항을 통해 안내드립니다.
            '''),
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