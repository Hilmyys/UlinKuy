import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/cafe_model.dart';
import '../../../../data/repositories/cafe_repository.dart';
import '../../../../features/details/presentation/pages/cafe_detail_screen.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  String _selectedFilter = 'Ranking';
  List<Cafe> _cafes = [];

  @override
  void initState() {
    super.initState();
    _cafes = CafeRepository.getMockCafes();
    _applySorting();
  }

  void _applySorting() {
    setState(() {
      if (_selectedFilter == 'Ranking') {
        _cafes.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (_selectedFilter == 'Terdekat') {
        _cafes.shuffle(); // Mocking "nearest"
      } else if (_selectedFilter == 'Termurah') {
        _cafes.sort((a, b) => a.priceRange.length.compareTo(b.priceRange.length));
      } else if (_selectedFilter == 'Paling Instagrammable') {
        _cafes = _cafes.where((c) => c.tags.contains('AESTHETIC') || c.tags.contains('BEST VIBE')).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UlinKuy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Top Rated Cafes', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text('Discover Bandung\'s finest coffee spots, ranked by local coffee enthusiasts.', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 25),
            _buildFilterChips(),
            const SizedBox(height: 30),
            if (_cafes.isNotEmpty) ...[
              _buildRankCard(context, _cafes[0], 1, isTop: true),
              const SizedBox(height: 20),
              ...List.generate(_cafes.length - 1, (i) => _buildRankCard(context, _cafes[i + 1], i + 2)),
            ] else 
              const Center(child: Text('Tidak ada cafe yang sesuai.')),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Ranking', 'Terdekat', 'Termurah', 'Paling Instagrammable'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = f == _selectedFilter;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedFilter = f);
              _applySorting();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xFFF2EBE4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                f,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRankCard(BuildContext context, Cafe cafe, int rank, {bool isTop = false}) {
    if (isTop) {
      return GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: cafe))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.network(cafe.imageUrl, height: 220, width: double.infinity, fit: BoxFit.cover)),
                Positioned(top: 15, left: 15, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.black.withAlpha(200), borderRadius: BorderRadius.circular(8)), child: Text('RANK #$rank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)))),
                Positioned(top: 15, right: 15, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: Row(children: [const Icon(Icons.star_rounded, color: Colors.amber, size: 16), const SizedBox(width: 4), Text(cafe.rating.toString(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13))]))),
              ],
            ),
            const SizedBox(height: 16),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFE0F2F1), borderRadius: BorderRadius.circular(6)), child: const Text('KOPI TERBAIK 2024', style: TextStyle(color: Color(0xFF00695C), fontWeight: FontWeight.bold, fontSize: 10))),
            const SizedBox(height: 10),
            Text(cafe.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text('Modern organic sanctuary with artisanal coffee brewing...', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: cafe))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFFFBF9F8), borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(cafe.imageUrl, width: 80, height: 80, fit: BoxFit.cover)),
                Positioned(top: -5, left: -5, child: CircleAvatar(radius: 14, backgroundColor: Colors.grey.shade700, child: Text('#$rank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)))),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cafe.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFFCECD9), borderRadius: BorderRadius.circular(4)), child: Text(cafe.tags.first, style: const TextStyle(color: Color(0xFF8B5E3C), fontWeight: FontWeight.bold, fontSize: 9))),
                      const SizedBox(width: 8),
                      const Icon(Icons.verified, color: Colors.green, size: 14),
                      const SizedBox(width: 4),
                      const Text('Verified', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.w600)),
                    ],
                  )
                ],
              ),
            ),
            Row(children: [const Icon(Icons.star_rounded, color: Colors.amber, size: 16), const SizedBox(width: 4), Text(cafe.rating.toString(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13))]),
          ],
        ),
      ),
    );
  }
}
