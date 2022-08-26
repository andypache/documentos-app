///Class to represent Item into bill
class ItemModel {
  int? id;
  String name;

  //Constructor class
  ItemModel(this.id, this.name);

  //Create empty bill
  factory ItemModel.createEmpty() {
    return ItemModel(0, "");
  }
}
