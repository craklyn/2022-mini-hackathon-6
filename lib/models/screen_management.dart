import 'package:flutter/material.dart';

class ScreenManagement extends ChangeNotifier {
  bool isPrinting;

  ScreenManagement({this.isPrinting = false});

  void setIsPrinting(bool isPrinting) {
    this.isPrinting = isPrinting;
    notifyListeners();
  }
}
