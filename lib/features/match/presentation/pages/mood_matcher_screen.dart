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
  String _activeChip = 'Dago Area';

  @override
  Widget build(BuildContext context) {
    final allCafes = CafeRepository.getMockCafes();
    
    // Logic filtering
    List<Cafe> filteredCafes = allCafes;
    if (selectedVibe == 'Fokus Kerja') {
      filteredCafes = allCafes.where((c) => c.tags.contains('WORK-FRIENDLY')).toList();
    } else if (selectedVibe == 'Nongkrong Santai') {
      filteredCafes = allCafes.where((c) => c.tags.contains('COZY')).toList();
    } else if (selectedVibe == 'Date Night') {
      filteredCafes = allCafes.where((c) => c.tags.contains('BEST VIBE')).toList();
    } else if (selectedVibe == 'Healing') {
      filteredCafes = allCafes.where((c) => c.tags.contains('AESTHETIC')).toList();
    }

    // Secondary Chip Filter (Mock)
    if (_activeChip == 'Specialty Coffee') {
      filteredCafes = filteredCafes.where((c) => c.priceRange == r'$$$').toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('UlinKuy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('What\'s the vibe?', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text('Match your mood with the perfect Bandung spot.', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 30),
            _buildVibeGrid(),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mood Matches', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFBF9F8), borderRadius: BorderRadius.circular(10)), child: Text('${filteredCafes.length} Spots Found', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 20),
            _buildFilterChips(),
            const SizedBox(height: 25),
            if (filteredCafes.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Tidak ada cafe yang sesuai vibe ini.')))
            else
              ...filteredCafes.map((c) => _buildMatchCard(context, c)),
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 1.8),
      itemCount: vibes.length,
      itemBuilder: (context, i) {
        final isSelected = selectedVibe == vibes[i]['label'];
        return GestureDetector(
          onTap: () => setState(() => selectedVibe = vibes[i]['label'] as String),
          child: Container(
            decoration: BoxDecoration(color: isSelected ? AppColors.primary : const Color(0xFFFBF9F8), borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(vibes[i]['icon'] as IconData, color: isSelected ? Colors.white : Colors.black87, size: 24),
                const SizedBox(height: 10),
                Text(vibes[i]['label'] as String, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChips() {
    final chips = ['Dago Area', 'Outdoor', 'Specialty Coffee'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips.map((c) => GestureDetector(
          onTap: () => setState(() => _activeChip = c),
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: c == _activeChip ? AppColors.primary : const Color(0xFFF2EBE4), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [Text(c, style: TextStyle(color: c == _activeChip ? Colors.white : AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)), const SizedBox(width: 6), Icon(Icons.close, size: 12, color: c == _activeChip ? Colors.white : AppColors.primary)]),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, Cafe cafe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 15)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), child: Image.network(cafe.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover)),
              Positioned(top: 15, right: 15, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF6AB04C), borderRadius: BorderRadius.circular(8)), child: Text(cafe.rating.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(cafe.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), const Text('0.8 km', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 6),
                Text('Perfect for shared stories and vintage vibes at Braga street.', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: cafe))),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    child: const Text('View Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
