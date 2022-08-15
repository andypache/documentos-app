import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/bill/bill.dart';

///Create bill provider for load process, manager
///update create and delete bill
class BillProvider extends ChangeNotifier {
  List<Bill> currentsBills = [];

  //Constructor for provider
  BillProvider({required List<Bill> bills});

  //Set bills into class
  setBills(List<Bill> bills) {
    currentsBills = bills;
  }
}
