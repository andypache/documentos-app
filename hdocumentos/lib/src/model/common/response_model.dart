///Represents reponse of service
class ResponseModel {
  int code;
  String start;
  String end;
  String idMessage;
  String? messageProcess;
  dynamic response;

  //Constructor of class
  factory ResponseModel.createEmpty() {
    return ResponseModel(
        code: 0,
        start: "",
        end: "",
        idMessage: "",
        messageProcess: "",
        response: null);
  }

  ResponseModel(
      {required this.code,
      required this.start,
      required this.end,
      required this.idMessage,
      this.messageProcess,
      required this.response});

  //Load class from json
  factory ResponseModel.fromJson(Map<String, dynamic> parsedJson) {
    try {
      //Load from body response
      return ResponseModel(
          code: parsedJson['code'].toInt(),
          start: parsedJson['start'].toString(),
          end: parsedJson['end'].toString(),
          idMessage: parsedJson['id_message'].toString(),
          messageProcess: parsedJson['message_process'].toString(),
          response: parsedJson['response']);
    } on Exception {
      //Create general error for case of error to parse reponse
      return ResponseModel(
          code: 0,
          start: '',
          end: '',
          idMessage: '',
          messageProcess: 'Error de comunicación, por favor intente mas tarde.',
          response: null);
    }
  }
}
