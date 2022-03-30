import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int selectedCategoryId = 1;

  void updateCategoryId(int selectedCategoryId) {
    this.selectedCategoryId = selectedCategoryId;
    notifyListeners();
  }
}
