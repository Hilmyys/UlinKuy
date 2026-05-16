import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/common/presentation/providers/loyalty_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UlinKuy', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_outlined))],
      ),
      body: Consumer<LoyaltyProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLoyaltyCard(context, provider),
                const SizedBox(height: 25),
                _buildDailyQuestsHeader(),
                const SizedBox(height: 15),
                _buildQuestItem('Cafe Explorer', 'Visit 3 new cafes this week', 150, true),
                _buildQuestItem('Connoisseur Tip', 'Write a review for Blue Doors', 50, false),
                const SizedBox(height: 30),
                _buildRedeemSection(context),
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
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF3E2723),
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'),
          opacity: 0.1,
          repeat: ImageRepeat.repeat,
        ),
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
                  const Text('CURRENT STATUS', style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
                  Text(provider.rank, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  children: [
                    Icon(Icons.stars, color: Colors.amber, size: 14),
                    SizedBox(width: 4),
                    Text('Pro Tier', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 30),
          Text(provider.points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
          const Text('Total KuyPoints', style: TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${provider.nextTierPoints} pts to ${provider.nextReward}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
              TextButton(
                onPressed: () {
                  final success = provider.redeemPoints(500);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Poin berhasil ditukar!' : 'Poin tidak cukup.'),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                },
                style: TextButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, minimumSize: const Size(80, 30), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Tukar Poin', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDailyQuestsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Daily Quests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))),
      ],
    );
  }

  Widget _childIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color.withAlpha(25), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildQuestItem(String title, String desc, int points, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
      child: Row(
        children: [
          _childIcon(title.contains('Explorer') ? Icons.map_outlined : Icons.edit_note, Colors.blue),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          if (isCompleted)
            Text('+$points', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))
          else
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0), minimumSize: const Size(60, 25), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('Review', style: TextStyle(fontSize: 10)),
            )
        ],
      ),
    );
  }

  Widget _buildRedeemSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Redeem Rewards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd'), fit: BoxFit.cover),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.black.withAlpha(204), Colors.transparent]),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('NEW!', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold)),
                const Text('Free V60 Manual Brew', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)), child: const Text('500 Points', style: TextStyle(color: Colors.white, fontSize: 10))),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        final provider = Provider.of<LoyaltyProvider>(context, listen: false);
                        final success = provider.redeemPoints(500);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success ? 'Klaim Reward Berhasil!' : 'Poin tidak cukup.'),
                            backgroundColor: success ? Colors.green : Colors.red,
                          ),
                        );
                      }, 
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, minimumSize: const Size(80, 30), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), 
                      child: const Text('Claim Now', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
