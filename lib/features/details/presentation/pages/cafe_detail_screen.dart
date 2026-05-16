import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/cafe_model.dart';

class CafeDetailScreen extends StatelessWidget {
  final Cafe cafe;
  const CafeDetailScreen({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(),
                      const SizedBox(height: 25),
                      _buildQuickMetrics(),
                      const SizedBox(height: 30),
                      _buildSpecialMenus(),
                      const SizedBox(height: 30),
                      _buildFacilities(),
                      const SizedBox(height: 30),
                      _buildReviews(),
                      const SizedBox(height: 100), // Space for sticky button
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildStickyFooter(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.arrow_back, color: Colors.black)),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(icon: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.share_outlined, color: Colors.black)), onPressed: () {}),
        IconButton(icon: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.favorite_border, color: Colors.black)), onPressed: () {}),
        const SizedBox(width: 10),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(cafe.imageUrl, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: Colors.blue.withAlpha(25), borderRadius: BorderRadius.circular(8)),
          child: const Text('TOP RATED', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 10)),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 5),
            Text(cafe.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(' (${cafe.reviewsCount ~/ 1000}k reviews)', style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 5),
        Text(cafe.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.grey, size: 14),
            const SizedBox(width: 5),
            Text(cafe.location, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(IconData icon, String label, String value, {Color? valueColor}) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: valueColor)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuickMetrics() {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: [
        _buildMetricCard(Icons.payments_outlined, 'HARGA', cafe.priceRange),
        _buildMetricCard(Icons.wifi, 'WI-FI SPEED', '${cafe.wifiSpeed} Mbps'),
        _buildMetricCard(Icons.restaurant_menu, 'RASA', cafe.tasteRating),
        _buildMetricCard(Icons.groups, 'CROWD', '${(cafe.crowdLevel * 100).toInt()}%'),
      ],
    );
  }

  Widget _buildSpecialMenus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Menu Spesialis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('LIHAT SEMUA', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold))),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cafe.specialMenus.length,
            itemBuilder: (context, index) {
              final menu = cafe.specialMenus[index];
              return Container(
                width: 250,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                      child: Image.network(menu.imageUrl, width: 100, height: 120, fit: BoxFit.cover),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(menu.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(menu.description, style: const TextStyle(color: Colors.grey, fontSize: 10), maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 5),
                            Text(menu.price, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildFacilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Fasilitas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: cafe.facilities.map((f) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline, size: 14, color: Colors.grey),
                const SizedBox(width: 8),
                Text(f, style: const TextStyle(fontSize: 12, color: Colors.black87)),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ulasan Jujur', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('${cafe.reviewsCount ~/ 1000}k ULASAN', style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 15),
        ...cafe.reviews.map((review) => Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(review.userAvatar), radius: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Row(
                          children: [
                            ...List.generate(5, (i) => Icon(Icons.star, size: 12, color: i < review.rating ? Colors.amber : Colors.grey)),
                            const SizedBox(width: 8),
                            Text(review.date, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(review.comment, style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.5)),
            ],
          ),
        )),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 12)),
            child: const Text('Tulis Ulasan Kamu', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }

  Widget _buildStickyFooter() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('JAM OPERASIONAL', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold)),
                Text(cafe.operatingHours, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () async {
                const url = 'https://www.google.com/maps/search/?api=1&query=Seroja+Bake+Bandung';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                }
              },
              icon: const Icon(Icons.directions),
              label: const Text('Rute Sekarang'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E2723),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
