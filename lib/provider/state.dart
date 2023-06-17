import 'package:flutter/material.dart';

class EnglishState with ChangeNotifier {
  bool _isEnglishSelected = true;

  bool get isEnglishSelected => _isEnglishSelected;

  void toggleLanguage() {
    _isEnglishSelected = !_isEnglishSelected;
    notifyListeners();
  }
}
