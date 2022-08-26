import 'package:hdocumentos/src/model/model.dart';

///Class to management bill, represent a user bill that create or view
class BillModel {
  int? id;
  DateTime date;
  //Product list
  final List<ItemModel> items;
  final double subtotal;
  final double total;
  String? resume;
  //Client
  ClientModel client;

  //Constructor of class
  BillModel(this.id, this.date, this.items, this.subtotal, this.total,
      this.resume, this.client);

  //Create empty bill
  factory BillModel.createEmpty() {
    return BillModel(
        0, DateTime.now(), [], 0, 0, "", ClientModel.createEmpty());
  }

  //Method to add item
  void addItem(ItemModel item) {}

  //Method to remove item
  void deleteItem(ItemModel item) {}
}
