import 'package:flutter/material.dart';

class BottomNavBarProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

   getCurrentIndex(int index) {
    _currentIndex = index;
    
    notifyListeners();
  }
}
