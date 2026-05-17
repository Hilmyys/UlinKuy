import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../features/common/presentation/pages/favorite_screen.dart';
import '../theme/app_theme.dart';

class MainShell extends StatefulWidget {
  final List<Widget> screens;
  const MainShell({super.key, required this.screens});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> allScreens = [
      widget.screens[0], // Explore
      widget.screens[1], // Ranking
      widget.screens[2], // Match
      const FavoriteScreen(), // Saved
      widget.screens[3], // Rewards
    ];

    return Scaffold(
      body: allScreens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withAlpha(10))],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 24),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 6,
            activeColor: AppColors.primary,
            iconSize: 22,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: const Color(0xFFF2EBE4),
            color: Colors.black45,
            tabs: const [
              GButton(icon: Icons.explore_outlined, text: 'Explore'),
              GButton(icon: Icons.bar_chart_outlined, text: 'Ranking'),
              GButton(icon: Icons.coffee_outlined, text: 'Match'),
              GButton(icon: Icons.bookmark_outline, text: 'Saved'),
              GButton(icon: Icons.wallet_giftcard_outlined, text: 'Rewards'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) => setState(() => _selectedIndex = index),
          ),
        ),
      ),
    );
  }
}
