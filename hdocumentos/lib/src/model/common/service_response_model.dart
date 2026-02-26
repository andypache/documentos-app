import 'package:hdocumentos/src/model/model.dart';

///Represents reponse of service
class ServiceResponseModel {
  int statusHttp;
  String status;
  String message;
  dynamic body;
  String? error;
  dynamic errorDescription;

  //Constructor of class
  factory ServiceResponseModel.createEmpty() {
    return ServiceResponseModel(
        statusHttp: 0, status: "", body: null, message: "");
  }

  ServiceResponseModel(
      {required this.statusHttp,
      required this.status,
      required this.message,
      required this.body,
      this.error,
      this.errorDescription});

  //Load class from json
  factory ServiceResponseModel.fromJson(
    int statusHttp,
    Map<String, dynamic> parsedJson,
  ) {
    try {
      //Load from body response
      return ServiceResponseModel(
          statusHttp: statusHttp,
          status: parsedJson['code'].toString(),
          message: parsedJson['message'].toString(),
          error: parsedJson['error'].toString(),
          errorDescription: parsedJson['error_description'].toString(),
          body: parsedJson);
    } on Exception {
      //Create general error for case of error to parse reponse
      return ServiceResponseModel(
          statusHttp: 509,
          status: '-1',
          message: '',
          error: 'Error de comunicación, por favor intente mas tarde.',
          body: null);
    }
  }

  ResponseModel createDataResponse() {
    if (body != null) {
      return ResponseModel.fromJson(body);
    } else {
      return ResponseModel.createEmpty();
    }
  }
}
