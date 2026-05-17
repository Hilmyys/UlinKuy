import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/cafe_model.dart';
import '../../../common/presentation/providers/favorite_provider.dart';
import '../../../common/presentation/providers/loyalty_provider.dart';

class CafeDetailScreen extends StatefulWidget {
  final Cafe cafe;
  const CafeDetailScreen({super.key, required this.cafe});

  @override
  State<CafeDetailScreen> createState() => _CafeDetailScreenState();
}

class _CafeDetailScreenState extends State<CafeDetailScreen> {
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

  void _showReviewDialog() {
    final reviewController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Tulis Ulasan Kamu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bagikan pengalamanmu untuk mendapatkan +50 PTS!', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 15),
            TextField(
              controller: reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tulis di sini...',
                filled: true,
                fillColor: const Color(0xFFFBF9F8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<LoyaltyProvider>(context, listen: false).addPoints(50);
              _showAlert('Ulasan Terkirim!', 'Selamat! Kamu mendapatkan +50 KuyPoints.');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Kirim Ulasan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderInfo(),
                      const SizedBox(height: 25),
                      _buildMetricsGrid(),
                      const SizedBox(height: 35),
                      _buildMenuSection(),
                      const SizedBox(height: 35),
                      _buildFacilitiesGrid(),
                      const SizedBox(height: 35),
                      _buildReviewSection(),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildFloatingFooter(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const CircleAvatar(backgroundColor: Colors.white70, child: Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black)),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Consumer<FavoriteProvider>(
          builder: (context, fav, _) {
            final isFav = fav.isFavorite(widget.cafe.id);
            return CircleAvatar(
              backgroundColor: Colors.white70,
              child: IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, size: 18, color: isFav ? Colors.red : Colors.black),
                onPressed: () => fav.toggleFavorite(widget.cafe),
              ),
            );
          },
        ),
        const SizedBox(width: 24),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(widget.cafe.imageUrl, fit: BoxFit.cover),
            Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withAlpha(100), Colors.transparent, Colors.black.withAlpha(50)]))),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(8)), child: const Text('TOP RATED', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 10))),
            const SizedBox(width: 12),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.star, color: Colors.amber, size: 14), const SizedBox(width: 4), Text('${widget.cafe.rating} (${widget.cafe.reviewsCount ~/ 1000}k ulasan)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10))])),
          ],
        ),
        const SizedBox(height: 16),
        Text(widget.cafe.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(widget.cafe.location, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 2.2,
      children: [
        _buildMetricItem(Icons.payments_outlined, 'HARGA', widget.cafe.priceRange),
        _buildMetricItem(Icons.wifi, 'WI-FI SPEED', '${widget.cafe.wifiSpeed} Mbps'),
        _buildMetricItem(Icons.restaurant_menu, 'RASA', widget.cafe.tasteRating),
        _buildMetricItem(Icons.groups_outlined, 'CROWD', '${(widget.cafe.crowdLevel * 100).toInt()}%', showProgress: true),
      ],
    );
  }

  Widget _buildMetricItem(IconData icon, String label, String value, {bool showProgress = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                if (showProgress) ...[
                  const SizedBox(height: 4),
                  Row(children: [Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2), child: LinearProgressIndicator(value: widget.cafe.crowdLevel, backgroundColor: Colors.grey.shade100, color: AppColors.accent, minHeight: 4))), const SizedBox(width: 8), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))])
                ] else ...[
                  Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ]
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Menu Spesialis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text('LIHAT SEMUA', style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.cafe.specialMenus.length,
            itemBuilder: (context, index) {
              final menu = widget.cafe.specialMenus[index];
              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
                child: Row(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(menu.imageUrl, width: 80, height: 104, fit: BoxFit.cover)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(menu.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), const SizedBox(height: 4), Text(menu.description, style: const TextStyle(color: Colors.grey, fontSize: 10), maxLines: 2, overflow: TextOverflow.ellipsis)])),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildFacilitiesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Fasilitas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 3.5),
          itemCount: widget.cafe.facilities.length,
          itemBuilder: (context, i) => Container(padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: const Color(0xFFFBF9F8), borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.check_circle_outline, size: 16, color: Colors.grey), const SizedBox(width: 10), Text(widget.cafe.facilities[i], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))])),
        )
      ],
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Ulasan Jujur', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text('${widget.cafe.reviewsCount ~/ 1000}k ULASAN', style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 20),
        ...widget.cafe.reviews.take(2).map((r) => Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 18, backgroundImage: NetworkImage(r.userAvatar)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(r.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Text('LOCAL GUIDE • 5 HARI LALU', style: TextStyle(color: Colors.grey.shade400, fontSize: 9, fontWeight: FontWeight.bold))])),
                  Row(children: List.generate(5, (i) => Icon(Icons.star_rounded, size: 14, color: i < r.rating ? Colors.amber : Colors.grey.shade200))),
                ],
              ),
              const SizedBox(height: 12),
              Text(r.comment, style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87)),
            ],
          ),
        )),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: _showReviewDialog,
            style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), side: BorderSide(color: Colors.grey.shade200)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Tulis Ulasan Kamu', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFFCECD9), borderRadius: BorderRadius.circular(6)), child: const Text('+50 PTS', style: TextStyle(color: Color(0xFF8B5E3C), fontWeight: FontWeight.bold, fontSize: 10))),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFloatingFooter() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, -5))]),
        child: Row(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [const Text('JAM OPERASIONAL', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)), Text('Buka • Tutup ${widget.cafe.operatingHours.split('-').last}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13))]),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(widget.cafe.name)}+Bandung';
                  if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url));
                },
                icon: const Icon(Icons.directions_outlined, size: 20),
                label: const Text('Rute Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), padding: const EdgeInsets.symmetric(vertical: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
