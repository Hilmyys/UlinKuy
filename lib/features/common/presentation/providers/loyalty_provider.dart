import 'package:flutter/material.dart';

class LoyaltyProvider with ChangeNotifier {
  int _points = 2450;
  String _rank = 'Caffeine Master';
  int _nextTierPoints = 550;
  String _nextReward = 'Cold Brew';

  int get points => _points;
  String get rank => _rank;
  int get nextTierPoints => _nextTierPoints;
  String get nextReward => _nextReward;

  void addPoints(int amount) {
    _points += amount;
    notifyListeners();
  }

  bool redeemPoints(int amount) {
    if (_points >= amount) {
      _points -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }
}
