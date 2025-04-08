import 'package:flutter/widgets.dart';

class NextOrPreviousQuestionsProvider extends ChangeNotifier {
  int _index = 0;
  int get index => _index;
  void nextPage(int total) {
    if (_index < total - 1) {
      _index++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_index > 0) {
      _index--;
      notifyListeners();
    }
  }
}
