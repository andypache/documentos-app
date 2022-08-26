///Class to management general catalog key value
class KeyValueModel {
  //Constructor of class
  KeyValueModel({required this.key, required this.value});

  String key;
  dynamic value;

  //Load value from json
  factory KeyValueModel.fromJson(Map<String, dynamic> json) =>
      KeyValueModel(key: json["key"], value: json["value"]);

  //Change to json
  Map<String, dynamic> toJson() => {"key": key, "value": value};
}
