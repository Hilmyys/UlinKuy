import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/favorite_provider.dart';
import '../../../details/presentation/pages/cafe_detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Favorit Saya'),
        centerTitle: true,
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, child) {
          final favorites = provider.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(color: const Color(0xFFF2EBE4), shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_rounded, size: 80, color: AppColors.accent),
                  ),
                  const SizedBox(height: 30),
                  const Text('Belum ada favorit', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  const Text('Jelajahi Bandung dan simpan tempat\nyang bikin kamu jatuh cinta.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final cafe = favorites[index];
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: cafe))),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 15, offset: const Offset(0, 8))]),
                  child: Row(
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(cafe.imageUrl, width: 85, height: 85, fit: BoxFit.cover)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cafe.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                            const SizedBox(height: 6),
                            Row(children: [const Icon(Icons.location_on_rounded, size: 14, color: Colors.grey), const SizedBox(width: 4), Expanded(child: Text(cafe.location, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis))]),
                            const SizedBox(height: 10),
                            Row(children: [const Icon(Icons.star_rounded, color: Colors.amber, size: 18), const SizedBox(width: 4), Text(cafe.rating.toString(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13))]),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.favorite_rounded, color: Colors.red, size: 28), onPressed: () => provider.toggleFavorite(cafe)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
