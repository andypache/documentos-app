///Represents reponse of service
class ResponseModel {
  String start;
  String end;
  dynamic response;

  //Constructor of class
  factory ResponseModel.createEmpty() {
    return ResponseModel(start: "", end: "", response: null);
  }

  ResponseModel(
      {required this.start, required this.end, required this.response});

  //Load class from json
  factory ResponseModel.fromJson(Map<String, dynamic> parsedJson) {
    try {
      //Load from body response
      return ResponseModel(
          start: parsedJson['start'].toString(),
          end: parsedJson['end'].toString(),
          response: parsedJson['response']);
    } on Exception {
      //Create general error for case of error to parse reponse
      return ResponseModel(start: '', end: '', response: null);
    }
  }
}
