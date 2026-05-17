import 'package:flutter/foundation.dart';
import '../../../../data/models/cafe_model.dart';

class FavoriteProvider with ChangeNotifier {
  final List<Cafe> _favorites = [];

  List<Cafe> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String cafeId) {
    return _favorites.any((c) => c.id == cafeId);
  }

  void toggleFavorite(Cafe cafe) {
    final index = _favorites.indexWhere((c) => c.id == cafe.id);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(cafe);
    }
    notifyListeners();
  }
}
