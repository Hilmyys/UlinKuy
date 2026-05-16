import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/cafe_model.dart';
import '../../../../data/repositories/cafe_repository.dart';
import '../../../../features/details/presentation/pages/cafe_detail_screen.dart';
import '../../../common/presentation/providers/auth_provider.dart';

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
      
      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        allCafes = allCafes.where((c) => 
          c.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
          c.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()))
        ).toList();
      }

      // Filter by mood
      if (_selectedMood.isNotEmpty) {
        String tagToMatch = '';
        if (_selectedMood == 'WFC') tagToMatch = 'WORK-FRIENDLY';
        if (_selectedMood == 'Romantic') tagToMatch = 'BEST VIBE';
        if (_selectedMood == 'Family') tagToMatch = 'AESTHETIC'; // Mapping to existing mock tags
        
        if (tagToMatch.isNotEmpty) {
          allCafes = allCafes.where((c) => c.tags.contains(tagToMatch)).toList();
        }
      }

      _filteredCafes = allCafes;
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _onMoodSelected(String mood) {
    setState(() {
      if (_selectedMood == mood) {
        _selectedMood = ''; // Deselect if same mood is clicked
      } else {
        _selectedMood = mood;
      }
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final popularCafes = _filteredCafes.take(2).toList();
    final hiddenGems = _filteredCafes.skip(2).take(2).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 25),
              _buildSearchBar(),
              const SizedBox(height: 25),
              _buildMoodMatcherSection(),
              const SizedBox(height: 30),
              if (_searchQuery.isEmpty) ...[
                _buildSectionTitle('Cafe Terpopuler Minggu Ini'),
                const SizedBox(height: 15),
                _buildPopularList(context, popularCafes),
                const SizedBox(height: 30),
                _buildSectionTitle('Explore Hidden Gems'),
                const SizedBox(height: 15),
                _buildHiddenGemsGrid(context, hiddenGems),
              ] else ...[
                _buildSectionTitle('Hasil Pencarian untuk "$_searchQuery"'),
                const SizedBox(height: 15),
                _buildSearchResultsGrid(context, _filteredCafes),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultsGrid(BuildContext context, List<Cafe> cafes) {
    if (cafes.isEmpty) {
      return const Center(child: Text('Tidak ada cafe ditemukan.'));
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.8,
      ),
      itemCount: cafes.length,
      itemBuilder: (context, index) {
        final cafe = cafes[index];
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: cafe))),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(image: NetworkImage(cafe.imageUrl), fit: BoxFit.cover),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withAlpha(179)]),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cafe.tags.isNotEmpty)
                    Text(cafe.tags.first, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                  Text(cafe.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    final user = Provider.of<AuthProvider>(context).currentUser;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(user?.avatarUrl ?? 'https://i.pravatar.cc/150?u=hilmi'),
                ),
                const SizedBox(width: 10),
                Text('UlinKuy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 15),
            Text('Halo, ${user?.name ?? 'Akang Teteh'}!', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const Text(
              'Cari tempat ulin di\nmana hari ini?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Apakah Anda yakin ingin keluar?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Provider.of<AuthProvider>(context, listen: false).logout();
                    },
                    child: const Text('Keluar', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.logout, size: 24),
        )
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: TextField(
        onChanged: _onSearchChanged,
        decoration: const InputDecoration(
          hintText: 'Cari kopi, suasana, atau lokasi...',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildMoodMatcherSection() {
    final moods = [
      {'icon': Icons.laptop, 'label': 'WFC', 'color': const Color(0xFF4A4A4A)},
      {'icon': Icons.favorite_border, 'label': 'Romantic', 'color': const Color(0xFFD4A373)},
      {'icon': Icons.groups_outlined, 'label': 'Family', 'color': const Color(0xFF8E8E8E)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Mood Matcher', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedMood = '';
                  _applyFilters();
                });
              }, 
              child: const Text('Lihat Semua', style: TextStyle(color: AppColors.accent, fontSize: 12))
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: moods.map((mood) {
            final label = mood['label'] as String;
            final isSelected = _selectedMood == label;
            return GestureDetector(
              onTap: () => _onMoodSelected(label),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? (mood['color'] as Color).withAlpha(25) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? (mood['color'] as Color) : Colors.grey.shade200,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      mood['icon'] as IconData, 
                      size: 16, 
                      color: isSelected ? (mood['color'] as Color) : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label, 
                      style: TextStyle(
                        fontSize: 12, 
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? (mood['color'] as Color) : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildPopularList(BuildContext context, List<Cafe> cafes) {
    if (cafes.isEmpty) return const SizedBox.shrink();
    
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cafes.length,
        itemBuilder: (context, index) {
          final cafe = cafes[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: cafe))),
            child: Container(
              width: 180,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(cafe.imageUrl, height: 140, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cafe.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(child: Text(cafe.location, style: const TextStyle(color: Colors.grey, fontSize: 11), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: cafe.tags.take(2).map((tag) => Container(
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                            child: Text(tag, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey)),
                          )).toList(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHiddenGemsGrid(BuildContext context, List<Cafe> cafes) {
    if (cafes.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.8,
      ),
      itemCount: cafes.length,
      itemBuilder: (context, index) {
        final cafe = cafes[index];
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: cafe))),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(image: NetworkImage(cafe.imageUrl), fit: BoxFit.cover),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withAlpha(179)]),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cafe.tags.first, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                  Text(cafe.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
