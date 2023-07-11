import 'package:flutter/material.dart';

class Tax extends ChangeNotifier {
  double taxincome;
  double taxspending;
  double creditcardHelp;
  double spendingFoodHelp;
  double estimateTax;

  Tax(
      {required this.taxincome,
      required this.spendingFoodHelp,
      required this.estimateTax,
      required this.creditcardHelp,
      required this.taxspending});

  void reset() {
    taxincome = 0;
    taxspending = 0;
    creditcardHelp = 0;
    spendingFoodHelp = 0;
    estimateTax = 0;
    notifyListeners();
  }
}

class Taxsave extends ChangeNotifier {
  double estimateTaxsave;

  double taxincomesave;

  double spendingFoodsave;

  double spendingProuctsave;

  String today;

  Taxsave(
      {required this.estimateTaxsave,
      required this.spendingFoodsave,
      required this.spendingProuctsave,
      required this.taxincomesave,
      required this.today});
}
