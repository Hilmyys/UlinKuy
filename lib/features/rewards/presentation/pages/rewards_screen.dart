import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/common/presentation/providers/loyalty_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  void _showAlert(BuildContext context, String title, String message, {bool isError = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: isError ? Colors.red : Colors.green),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UlinKuy'),
      ),
      body: Consumer<LoyaltyProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLoyaltyCard(context, provider),
                const SizedBox(height: 40),
                _buildSectionHeader('Daily Quests', 'View All'),
                const SizedBox(height: 20),
                _buildQuestItem('Cafe Explorer', 'Visit 3 new cafes this week', 150, true, 0.6),
                _buildQuestItem('Connoisseur Tip', 'Write a review for Blue Doors', 50, false, 0),
                const SizedBox(height: 40),
                _buildSectionHeader('Redeem Rewards', null),
                const SizedBox(height: 20),
                _buildFeaturedReward(context, provider),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _buildSmallRewardCard(context, provider, 'Free Upsize', 'Any espresso drink', '150 Pts', Icons.local_cafe_outlined)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildSmallRewardCard(context, provider, 'Pastry 50% Off', 'Daily selection', '250 Pts', Icons.bakery_dining_outlined)),
                  ],
                ),
                const SizedBox(height: 40),
                const Text('Recent Activity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 20),
                _buildActivityItem('Blue Doors Coffee', 'Purchased Filter Coffee', '+45 Pts', Icons.coffee_maker_outlined),
                _buildActivityItem('Kopi Toko Djawa', 'Check-in Bonus', '+10 Pts', Icons.location_on_outlined),
                _buildActivityItem('Rewards Redeemed', 'Free Pastry', '-250 Pts', Icons.redeem, isNegative: true),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoyaltyCard(BuildContext context, LoyaltyProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(image: NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'), opacity: 0.1, repeat: ImageRepeat.repeat),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CURRENT STATUS', style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(provider.rank.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                ],
              ),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: const Color(0xFFF2EBE4), borderRadius: BorderRadius.circular(15)), child: const Row(children: [Icon(Icons.stars, color: Color(0xFF8B5E3C), size: 16), SizedBox(width: 6), Text('Pro Tier', style: TextStyle(color: Color(0xFF8B5E3C), fontSize: 11, fontWeight: FontWeight.bold))])),
            ],
          ),
          const SizedBox(height: 30),
          Text(provider.points.toString(), style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
          const Text('Total KuyPoints', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 20),
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: 0.7, backgroundColor: Colors.white10, color: const Color(0xFFE9D7C3), minHeight: 8)),
          const SizedBox(height: 12),
          Text('550 pts ke ${provider.nextReward}', style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
        if (action != null) Text(action, style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildQuestItem(String title, String desc, int pts, bool isActive, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFFBF9F8), borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.white, radius: 22, child: Icon(title.contains('Explorer') ? Icons.directions_run : Icons.edit_note, color: Colors.blue, size: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)), Text('+$pts', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))]),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                if (progress > 0) ...[
                  const SizedBox(height: 12),
                  ClipRRect(borderRadius: BorderRadius.circular(2), child: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade200, color: AppColors.primary, minHeight: 4)),
                ]
              ],
            ),
          ),
          if (title.contains('Tip')) ...[
            const SizedBox(width: 16),
            ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(horizontal: 12), minimumSize: const Size(60, 32)), child: const Text('REVIEW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          ]
        ],
      ),
    );
  }

  Widget _buildFeaturedReward(BuildContext context, LoyaltyProvider provider) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&q=80&w=800'), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withAlpha(200), Colors.transparent])),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('FEATURED', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold)),
            const Text('Free V60 Manual Brew', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFF2EBE4), borderRadius: BorderRadius.circular(10)), child: const Text('500 Points', style: TextStyle(color: Color(0xFF8B5E3C), fontSize: 11, fontWeight: FontWeight.bold))),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (provider.redeemPoints(500)) {
                      _showAlert(context, 'Berhasil!', 'V60 Manual Brew gratis siap diklaim.');
                    } else {
                      _showAlert(context, 'Gagal', 'Poin kamu tidak mencukupi.', isError: true);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 20)),
                  child: const Text('Claim Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSmallRewardCard(BuildContext context, LoyaltyProvider provider, String title, String desc, String pts, IconData icon) {
    final int pointsRequired = int.parse(pts.split(' ').first);
    return GestureDetector(
      onTap: () {
        if (provider.redeemPoints(pointsRequired)) {
          _showAlert(context, 'Berhasil!', '$title berhasil diklaim.');
        } else {
          _showAlert(context, 'Gagal', 'Poin kamu tidak mencukupi.', isError: true);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFFFBF9F8), borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
            Text(desc, style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            const SizedBox(height: 12),
            Text(pts, style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String desc, String pts, IconData icon, {bool isNegative = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFFBF9F8), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.primary, size: 20)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)), Text(desc, style: TextStyle(color: AppColors.textSecondary, fontSize: 11))])),
          Text(pts, style: TextStyle(color: isNegative ? Colors.red : AppColors.accent, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
