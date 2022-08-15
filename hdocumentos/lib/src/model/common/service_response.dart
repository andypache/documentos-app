///Represents reponse of service
class ServiceResponse {
  int statusHttp;
  String status;
  String message;
  dynamic body;
  String? error;
  dynamic errorDescription;

  //Constructor of class
  ServiceResponse(
      {required this.statusHttp,
      required this.status,
      required this.message,
      required this.body,
      this.error,
      this.errorDescription});

  //Load class from json
  factory ServiceResponse.fromJson(
    int statusHttp,
    Map<String, dynamic> parsedJson,
  ) {
    try {
      //Load from body response
      return ServiceResponse(
          statusHttp: statusHttp,
          status: parsedJson['code'].toString(),
          message: parsedJson['message'].toString(),
          error: parsedJson['error'].toString(),
          errorDescription: parsedJson['error_description'].toString(),
          body: parsedJson);
    } on Exception {
      //Create general error for case of error to parse reponse
      return ServiceResponse(
          statusHttp: 509,
          status: '-1',
          message: '',
          error: 'Error de comunicación, por favor intente mas tarde.',
          body: null);
    }
  }
}
