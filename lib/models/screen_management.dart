import 'package:flutter/material.dart';

class ScreenManagement extends ChangeNotifier {
  bool isPrinting;
  bool isGeneratingInvoice;

  ScreenManagement({this.isPrinting = false, this.isGeneratingInvoice = false});

  void setIsPrinting(bool isPrinting) {
    this.isPrinting = isPrinting;
    notifyListeners();
  }

  void setIsGeneratingInvoice(bool isGeneratingInvoice) {
    this.isGeneratingInvoice = isGeneratingInvoice;
    notifyListeners();
  }
}
