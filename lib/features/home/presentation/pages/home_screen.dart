import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/cafe_model.dart';
import '../../../../data/repositories/cafe_repository.dart';
import '../../../../features/details/presentation/pages/cafe_detail_screen.dart';
import '../../../common/presentation/providers/auth_provider.dart';
import '../../../common/presentation/providers/loyalty_provider.dart';
import '../../../auth/presentation/pages/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedMood = '';
  List<Cafe> _filteredCafes = [];

  @override
  void initState() {
    super.initState();
    _filteredCafes = CafeRepository.getMockCafes();
  }

  void _applyFilters() {
    setState(() {
      var allCafes = CafeRepository.getMockCafes();
      if (_searchQuery.isNotEmpty) {
        allCafes = allCafes.where((c) => 
          c.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
          c.location.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();
      }
      if (_selectedMood.isNotEmpty) {
        allCafes = allCafes.where((c) => c.tags.contains(_selectedMood)).toList();
      }
      _filteredCafes = allCafes;
    });
  }

  void _showAlert(String title, String message, {bool isError = false}) {
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
    final user = Provider.of<AuthProvider>(context).currentUser;
    final popularCafes = _filteredCafes.take(2).toList();
    final hiddenGems = _filteredCafes.skip(2).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(user),
              const SizedBox(height: 20),
              _buildWelcomeSection(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildPointsCard(),
              const SizedBox(height: 25),
              _buildMoodMatcher(),
              const SizedBox(height: 30),
              _buildSectionHeader('Cafe Terpopuler Minggu Ini', 'Pilihan warga Bandung paling favorit.'),
              const SizedBox(height: 15),
              _buildPopularList(popularCafes),
              const SizedBox(height: 30),
              _buildSectionHeader('Explore Hidden Gems', null),
              const SizedBox(height: 15),
              _buildHiddenGemsGrid(hiddenGems),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
                child: user?.avatarUrl == null ? const Icon(Icons.person, size: 20, color: AppColors.primary) : null,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'UlinKuy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Halo, Akang Teteh!', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 4),
        const Text(
          'Cari tempat ulin di\nmana hari ini?',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1.1),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF5F0EB), borderRadius: BorderRadius.circular(15)),
      child: TextField(
        onChanged: (v) { _searchQuery = v; _applyFilters(); },
        decoration: InputDecoration(hintText: 'Cari kopi, suasana, atau lokasi...', hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14), prefixIcon: Icon(Icons.search, color: Colors.grey.shade500), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  Widget _buildPointsCard() {
    return Consumer<LoyaltyProvider>(
      builder: (context, provider, _) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            const Icon(Icons.credit_card, color: Colors.white70, size: 40),
            const SizedBox(width: 15),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Poin Kamu', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)), Text('${provider.points} Poin', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))])),
            ElevatedButton(
              onPressed: () {
                if (provider.redeemPoints(500)) {
                  _showAlert('Berhasil!', 'Poin kamu berhasil ditukar dengan Voucher Kopi.');
                } else {
                  _showAlert('Gagal', 'Poin kamu tidak mencukupi (Min. 500 PTS).', isError: true);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A3427), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              child: const Text('Tukar Poin', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodMatcher() {
    final moods = [
      {'icon': Icons.laptop, 'label': 'WFH', 'tag': 'WORK-FRIENDLY'},
      {'icon': Icons.favorite_border, 'label': 'Romantic', 'tag': 'BEST VIBE'},
      {'icon': Icons.groups_outlined, 'label': 'Family', 'tag': 'AESTHETIC'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Mood Matcher', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text('Lihat Semua', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))]),
        const SizedBox(height: 12),
        Row(children: moods.map((m) {
          final isSelected = _selectedMood == m['tag'];
          return Expanded(child: GestureDetector(
            onTap: () { setState(() { _selectedMood = isSelected ? '' : m['tag'] as String; _applyFilters(); }); },
            child: Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: isSelected ? AppColors.primary : const Color(0xFFF2EBE4), borderRadius: BorderRadius.circular(15)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(m['icon'] as IconData, color: isSelected ? Colors.white : Colors.black87, size: 18), const SizedBox(width: 8), Text(m['label'] as String, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 12))])),
          ));
        }).toList()),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String? sub) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), if (sub != null) ...[const SizedBox(height: 2), Text(sub, style: TextStyle(color: AppColors.textSecondary, fontSize: 13))]]);
  }

  Widget _buildPopularList(List<Cafe> cafes) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cafes.length,
        itemBuilder: (context, index) {
          final cafe = cafes[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: cafe))),
            child: Container(width: 240, margin: const EdgeInsets.only(right: 15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 5))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Stack(children: [ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: Image.network(cafe.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover)), Positioned(top: 10, right: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF6AB04C), borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.star, color: Colors.white, size: 12), const SizedBox(width: 4), Text(cafe.rating.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))]))), Positioned(bottom: 10, left: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black.withAlpha(150), borderRadius: BorderRadius.circular(10)), child: Row(children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle)), const SizedBox(width: 6), const Text('Sedikit Ramai', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))])))]), Padding(padding: const EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(cafe.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)), const SizedBox(height: 4), Row(children: [const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey), const SizedBox(width: 4), Text(cafe.location, style: const TextStyle(color: Colors.grey, fontSize: 12))]), const SizedBox(height: 10), Row(children: [_buildTag('PASTRY'), const SizedBox(width: 8), _buildTag('COZY')])]))])),
          );
        },
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFF5F0EB), borderRadius: BorderRadius.circular(6)), child: Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)));
  }

  Widget _buildHiddenGemsGrid(List<Cafe> cafes) {
    return GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.8), itemCount: cafes.length, itemBuilder: (context, index) {
      final cafe = cafes[index];
      return GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: cafe))),
        child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Stack(children: [Image.network(cafe.imageUrl, height: double.infinity, width: double.infinity, fit: BoxFit.cover), Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withAlpha(180)]))), Padding(padding: const EdgeInsets.all(12), child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(cafe.tags.first, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)), const SizedBox(height: 2), Text(cafe.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14))]))])),
      );
    });
  }
}
