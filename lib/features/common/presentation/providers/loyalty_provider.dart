import 'package:flutter/foundation.dart';

class LoyaltyProvider with ChangeNotifier {
  int _points = 2450;
  String _rank = 'Caffeine Master';

  int get points => _points;
  String get rank => _rank;

  int get nextTierPoints => 3000 - _points;
  String get nextReward => 'Gold Brew';

  void addPoints(int amount) {
    _points += amount;
    _updateRank();
    notifyListeners();
  }

  bool redeemPoints(int amount) {
    if (_points >= amount) {
      _points -= amount;
      _updateRank();
      notifyListeners();
      return true;
    }
    return false;
  }

  void _updateRank() {
    if (_points >= 5000) {
      _rank = 'Coffee Legend';
    } else if (_points >= 2000) {
      _rank = 'Caffeine Master';
    } else {
      _rank = 'Novice Brewer';
    }
  }
}
