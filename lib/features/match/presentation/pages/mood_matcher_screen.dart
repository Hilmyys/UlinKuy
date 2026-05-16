import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/cafe_model.dart';
import '../../../../data/repositories/cafe_repository.dart';
import '../../../../features/details/presentation/pages/cafe_detail_screen.dart';

class MoodMatcherScreen extends StatefulWidget {
  const MoodMatcherScreen({super.key});

  @override
  State<MoodMatcherScreen> createState() => _MoodMatcherScreenState();
}

class _MoodMatcherScreenState extends State<MoodMatcherScreen> {
  String selectedVibe = 'Fokus Kerja';

  @override
  Widget build(BuildContext context) {
    final allCafes = CafeRepository.getMockCafes();
    // Simplified filtering logic for demo
    final filteredCafes = selectedVibe == 'Fokus Kerja'
        ? allCafes.where((c) => c.tags.contains('WORK-FRIENDLY')).toList()
        : allCafes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UlinKuy', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_outlined))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('What\'s the vibe?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('Match your mood with the perfect Bandung spot.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 25),
            _buildVibeGrid(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mood Matches', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${filteredCafes.length} Spots Found', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 15),
            _buildFilterChips(),
            const SizedBox(height: 20),
            ...filteredCafes.map((cafe) => _buildMatchCard(context, cafe)),
          ],
        ),
      ),
    );
  }

  Widget _buildVibeGrid() {
    final vibes = [
      {'label': 'Fokus Kerja', 'icon': Icons.laptop_mac},
      {'label': 'Nongkrong Santai', 'icon': Icons.coffee},
      {'label': 'Date Night', 'icon': Icons.favorite_border},
      {'label': 'Healing', 'icon': Icons.spa_outlined},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 2.2,
      ),
      itemCount: vibes.length,
      itemBuilder: (context, index) {
        final vibe = vibes[index];
        final isSelected = selectedVibe == vibe['label'];
        return GestureDetector(
          onTap: () => setState(() => selectedVibe = vibe['label'] as String),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF3E2723) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(vibe['icon'] as IconData, color: isSelected ? Colors.white : Colors.black87, size: 20),
                const SizedBox(width: 8),
                Text(
                  vibe['label'] as String,
                  style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChips() {
    final subFilters = ['Dago Area', 'Outdoor', 'Specialty Coffee'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: subFilters.map((filter) => Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(filter, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              const Icon(Icons.close, color: Colors.white, size: 10),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, Cafe cafe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 15)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(cafe.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                  child: Text(cafe.rating.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cafe.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Text('0.8 km', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Perfect for shared stories and vintage vibes at Braga street.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: cafe))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E2723),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('View Details', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
