import 'package:flutter/material.dart';

class NavigationNavbarProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
  void irAPestania(BuildContext context, int index) {
  if (_currentIndex != index) {
    setIndex(index);
  }
  Navigator.of(context).popUntil((route) => route.isFirst);
}
}
