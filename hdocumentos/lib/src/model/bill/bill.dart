import 'package:hdocumentos/src/model/bill/item.dart';

///Class to management bill, represent a user bill that create
class Bill {
  //Product list
  final List<Item> items;
  final double subtotal;
  final double total;

  //Constructor of class
  Bill(this.items, this.subtotal, this.total);

  //Create empty bill
  factory Bill.createEmpty() {
    return Bill([], 0, 0);
  }

  //Method to add item
  void addItem(Item item) {}

  //Method to remove item
  void deleteItem(Item item) {}
}
