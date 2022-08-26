///Class to management client fot bill, represent a user bill that create or view
class ClientModel {
  //Constructor of class
  ClientModel(this.id, this.email, this.identification, this.surnames,
      this.names, this.completeName);

  int id;
  String email;
  String identification;
  String surnames;
  String names;
  String? completeName;

  //Create empty bill
  factory ClientModel.createEmpty() {
    return ClientModel(
        0, "", "0000000000", "FINAL", "CONSUMIDOR", "CONSUMIDOR FINAL");
  }
}
