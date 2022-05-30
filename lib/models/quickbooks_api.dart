import 'package:flutter/material.dart';

class QuickBooksAPI extends ChangeNotifier {
  String? token;

  void updateToken(String? token) {
    this.token = token;
    notifyListeners();
  }
}
