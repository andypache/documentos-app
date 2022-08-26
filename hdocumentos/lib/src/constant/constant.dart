import 'package:hdocumentos/src/model/model.dart';

//config to service
const protocol = "https";
const host = "electronic.haku-innovaciones.com";
const baseUrl = "api/electronic-documents";
//config to app create into database
const String clientName = "b8f0757f-b463-490e-8e2d-c28b2be579a0";
const String clientSecret =
    "NRiXPShE2woeZa7QFsxDzYgIRLbVbXKyfrzH9RFpAwFUHEiDIf";
//URL for security
//const apiSecurity = '$protocol://$host:8090/$baseUrl/security-service/';
const apiSecurity = '$protocol://$host/$baseUrl/security-service/';
const apiSecurityLogin = "${apiSecurity}oauth/token";
//example bill for my sales
List<BillModel> billExamples = [
  BillModel(
      1,
      DateTime.now(),
      [
        ItemModel(1, "Producto1"),
        ItemModel(2, "Producto2"),
        ItemModel(3, "Producto3"),
        ItemModel(4, "Producto4"),
        ItemModel(5, "Producto5")
      ],
      20,
      20,
      "",
      ClientModel.createEmpty()),
  BillModel(2, DateTime.now(), [ItemModel(1, "Producto1")], 20, 20, "",
      ClientModel.createEmpty()),
  BillModel(
      3,
      DateTime.now(),
      [
        ItemModel(1, "Producto1"),
        ItemModel(2, "Producto2"),
      ],
      20,
      20,
      "",
      ClientModel.createEmpty()),
  BillModel(
      4,
      DateTime.now(),
      [
        ItemModel(1, "Producto1"),
        ItemModel(2, "Producto2"),
        ItemModel(3, "Producto3"),
      ],
      20,
      20,
      "",
      ClientModel.createEmpty()),
  BillModel(
      5,
      DateTime.now(),
      [
        ItemModel(1, "Producto1"),
        ItemModel(2, "Producto2"),
        ItemModel(3, "Producto3"),
        ItemModel(4, "Producto4"),
      ],
      20,
      20,
      "",
      ClientModel.createEmpty()),
  BillModel(6, DateTime.now(), [], 20, 20, "", ClientModel.createEmpty()),
  BillModel(7, DateTime.now(), [], 20, 20, "", ClientModel.createEmpty()),
  BillModel(8, DateTime.now(), [], 20, 20, "", ClientModel.createEmpty()),
  BillModel(9, DateTime.now(), [], 20, 20, "", ClientModel.createEmpty()),
  BillModel(10, DateTime.now(), [], 20, 20, "", ClientModel.createEmpty()),
  BillModel(11, DateTime.now(), [], 20, 20, "", ClientModel.createEmpty()),
  BillModel(12, DateTime.now(), [], 20, 20, "", ClientModel.createEmpty()),
  BillModel(13, DateTime.now(), [], 20, 20, "", ClientModel.createEmpty())
];
