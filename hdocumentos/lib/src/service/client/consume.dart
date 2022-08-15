import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hdocumentos/src/model/model.dart';

//Create client for call service
postFormFetch(
    {required String url,
    required dynamic body,
    required dynamic header}) async {
  ServiceResponse result;
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: header,
      body: body,
    );
    result = getResponse(response);
  } on Exception catch (e) {
    // ignore: avoid_print
    print('never reached');
    // ignore: avoid_print
    print(e);
    result = getGeneralErrorResponse();
  }
  return result;
}

//Get response for json parse pull
getResponse(dynamic response) {
  final status = response.statusCode;
  final data = json.decode(response.body);
  return ServiceResponse.fromJson(status, data);
}

//Get general response to call error message
getGeneralErrorResponse() {
  return ServiceResponse(
      statusHttp: 509,
      status: '-1',
      message:
          'No se puede comunicar con el servicio, por favor intente mas tarde',
      body: null);
}
