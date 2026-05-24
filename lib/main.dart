import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/bottom_nav_bar.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/ranking/presentation/pages/ranking_screen.dart';
import 'features/match/presentation/pages/mood_matcher_screen.dart';
import 'features/rewards/presentation/pages/rewards_screen.dart';
import 'features/common/presentation/providers/loyalty_provider.dart';
import 'features/common/presentation/providers/auth_provider.dart';
import 'features/common/presentation/providers/favorite_provider.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'data/datasources/local/database_helper.dart';
import 'data/repositories/cafe_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (!kIsWeb) {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.seedCafes(CafeRepository.getCafesAsMaps());
      
      await dbHelper.insertUser({
        'id': '2',
        'name': 'Admin UlinKuy',
        'email': 'admin@ulinkuy.com',
        'password': 'admin123!A',
        'avatarUrl': 'https://i.pravatar.cc/150?u=admin',
        'role': 'admin',
      });
    } catch (e) {
      debugPrint('Database initialization failed: $e');
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoyaltyProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: const UlinKuyApp(),
    ),
  );
}

class UlinKuyApp extends StatelessWidget {
  const UlinKuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UlinKuy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isAuthenticated) {
            return const MainShell(
              screens: [
                HomeScreen(),
                RankingScreen(),
                MoodMatcherScreen(),
                RewardsScreen(),
              ],
            );
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
