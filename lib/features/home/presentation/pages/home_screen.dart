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
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 14)),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(user),
              const SizedBox(height: 25),
              _buildWelcomeSection(user?.name),
              const SizedBox(height: 25),
              _buildSearchBar(),
              const SizedBox(height: 25),
              _buildPointsCard(),
              const SizedBox(height: 35),
              _buildMoodMatcher(),
              const SizedBox(height: 40),
              _buildSectionHeader('Cafe Terpopuler Minggu Ini', 'Pilihan warga Bandung paling favorit.'),
              const SizedBox(height: 15),
              _buildPopularList(popularCafes),
              const SizedBox(height: 40),
              _buildSectionHeader('Explore Hidden Gems', null),
              const SizedBox(height: 15),
              _buildHiddenGemsGrid(hiddenGems),
              const SizedBox(height: 30),
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
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary.withOpacity(0.2))),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
                  child: user?.avatarUrl == null ? const Icon(Icons.person, size: 20, color: AppColors.primary) : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'UlinKuy',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: -1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(String? userName) {
    final firstName = userName?.split(' ').first ?? 'Akang Teteh';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Halo, $firstName!', style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        const Text(
          'Cari tempat ulin di\nmana hari ini?',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -0.5),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF2EBE4), borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (v) { _searchQuery = v; _applyFilters(); },
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        decoration: InputDecoration(hintText: 'Cari kopi, suasana, atau lokasi...', hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.normal), prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade600, size: 22), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 18)),
      ),
    );
  }

  Widget _buildPointsCard() {
    return Consumer<LoyaltyProvider>(
      builder: (context, provider, _) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.credit_card_rounded, color: Colors.white, size: 30)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('POIN KAMU', style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)), const SizedBox(height: 4), Text('${provider.points} Pts', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900))])),
            ElevatedButton(
              onPressed: () {
                if (provider.redeemPoints(500)) {
                  _showAlert('Berhasil!', 'Voucher Kopi Anda siap digunakan.');
                } else {
                  _showAlert('Poin Kurang', 'Kamu butuh minimal 500 PTS untuk menukar.', isError: true);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE9D7C3), foregroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), elevation: 0),
              child: const Text('Tukar Poin', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodMatcher() {
    final moods = [
      {'icon': Icons.laptop_mac_rounded, 'label': 'WFH', 'tag': 'WORK-FRIENDLY'},
      {'icon': Icons.favorite_rounded, 'label': 'Romantic', 'tag': 'BEST VIBE'},
      {'icon': Icons.groups_rounded, 'label': 'Family', 'tag': 'AESTHETIC'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Mood Matcher', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), Text('Lihat Semua', style: TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 16),
        Row(children: moods.map((m) {
          final isSelected = _selectedMood == m['tag'];
          return Expanded(child: GestureDetector(
            onTap: () { setState(() { _selectedMood = isSelected ? '' : m['tag'] as String; _applyFilters(); }); },
            child: Container(margin: const EdgeInsets.only(right: 12), padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: isSelected ? AppColors.primary : const Color(0xFFFBF9F8), borderRadius: BorderRadius.circular(20), border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(m['icon'] as IconData, color: isSelected ? Colors.white : Colors.black87, size: 18), const SizedBox(width: 8), Text(m['label'] as String, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w700, fontSize: 13))])),
          ));
        }).toList()),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String? sub) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)), if (sub != null) ...[const SizedBox(height: 4), Text(sub, style: TextStyle(color: AppColors.textSecondary, fontSize: 14))]]);
  }

  Widget _buildPopularList(List<Cafe> cafes) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cafes.length,
        itemBuilder: (context, index) {
          final cafe = cafes[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: cafe))),
            child: Container(width: 260, margin: const EdgeInsets.only(right: 20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 15, offset: const Offset(0, 8))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Stack(children: [ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), child: Image.network(cafe.imageUrl, height: 170, width: double.infinity, fit: BoxFit.cover)), Positioned(top: 12, right: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF6AB04C), borderRadius: BorderRadius.circular(10)), child: Row(children: [const Icon(Icons.star_rounded, color: Colors.white, size: 14), const SizedBox(width: 4), Text(cafe.rating.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12))]))), Positioned(bottom: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.black.withAlpha(180), borderRadius: BorderRadius.circular(12)), child: Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle)), const SizedBox(width: 8), const Text('Sedikit Ramai', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800))])))]), Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(cafe.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)), const SizedBox(height: 6), Row(children: [const Icon(Icons.location_on_rounded, size: 16, color: Colors.grey), const SizedBox(width: 4), Text(cafe.location, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500))]), const SizedBox(height: 12), Row(children: [_buildTag('PASTRY'), const SizedBox(width: 10), _buildTag('COZY')])]))])),
          );
        },
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFF5F0EB), borderRadius: BorderRadius.circular(8)), child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF8B5E3C))));
  }

  Widget _buildHiddenGemsGrid(List<Cafe> cafes) {
    return GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.8), itemCount: cafes.length, itemBuilder: (context, index) {
      final cafe = cafes[index];
      return GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: cafe))),
        child: ClipRRect(borderRadius: BorderRadius.circular(24), child: Stack(children: [Image.network(cafe.imageUrl, height: double.infinity, width: double.infinity, fit: BoxFit.cover), Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withAlpha(200)]))), Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(cafe.tags.first, style: TextStyle(color: AppColors.accentLight.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5)), const SizedBox(height: 4), Text(cafe.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15))]))])),
      );
    });
  }
}
