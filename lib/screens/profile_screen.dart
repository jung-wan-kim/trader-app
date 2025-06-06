import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import 'subscription_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final subscription = subscriptionProvider.currentSubscription;

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 설정 화면으로 이동
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 프로필 헤더
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '트레이더',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'trader@example.com',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 구독 상태
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: subscription?.isActive == true
                          ? Colors.amber.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      subscription?.isActive == true
                          ? '${subscription!.planName} 구독 중'
                          : '무료 플랜',
                      style: TextStyle(
                        color: subscription?.isActive == true
                            ? Colors.amber[700]
                            : Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // 메뉴 리스트
            _buildMenuItem(
              context,
              icon: Icons.card_membership,
              title: '구독 관리',
              subtitle: subscription?.isActive == true
                  ? '${subscription!.endDate.difference(DateTime.now()).inDays}일 남음'
                  : '프리미엄으로 업그레이드',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.analytics,
              title: '투자 성과',
              subtitle: '수익률 및 거래 내역 확인',
              onTap: () {
                // 투자 성과 화면으로 이동
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.bookmark,
              title: '관심 종목',
              subtitle: '저장한 종목 관리',
              onTap: () {
                // 관심 종목 화면으로 이동
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.notifications,
              title: '알림 설정',
              subtitle: '추천 및 시장 알림 관리',
              onTap: () {
                // 알림 설정 화면으로 이동
              },
            ),
            const Divider(),
            // 법적 정보 섹션
            _buildSectionTitle('법적 정보'),
            _buildMenuItem(
              context,
              icon: Icons.privacy_tip,
              title: '개인정보처리방침',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.description,
              title: '이용약관',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsOfServiceScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.help,
              title: '고객 지원',
              subtitle: 'support@traderapp.com',
              onTap: () {
                // 고객 지원 화면으로 이동
              },
            ),
            const Divider(),
            // 앱 정보
            _buildSectionTitle('앱 정보'),
            _buildMenuItem(
              context,
              icon: Icons.info,
              title: '버전 정보',
              subtitle: 'v1.0.0',
              onTap: null,
            ),
            const SizedBox(height: 20),
            // 로그아웃 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // 로그아웃 처리
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text(
                  '로그아웃',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // 투자 경고 문구
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.amber[700]),
                      const SizedBox(width: 8),
                      Text(
                        '투자 위험 경고',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '본 앱에서 제공하는 모든 정보는 투자 참고 자료이며, 투자 권유나 투자 자문에 해당하지 않습니다. 모든 투자 결정은 본인의 판단과 책임 하에 이루어져야 합니다.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}