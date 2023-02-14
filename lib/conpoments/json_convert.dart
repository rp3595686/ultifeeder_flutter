import 'dart:convert';

Map<String, GraphData> graphdataFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, GraphData>(k, GraphData.fromJson(v)));

String graphdataToJson(Map<String, GraphData> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

String errordataToJson(Map<String, ErrorData> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

Map<String, ErrorData> errordataFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, ErrorData>(k, ErrorData.fromJson(v)));

class GraphData {
  GraphData({
    required this.time,
    required this.value,
  });

  DateTime time;
  double value;

  factory GraphData.fromJson(Map<String, dynamic> json) => GraphData(
        time: DateTime.parse(json["time"]),
        value: json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "time": time.toIso8601String(),
        "value": value,
      };
}

class ErrorData {
  ErrorData({
    required this.message,
  });

  String message;

  factory ErrorData.fromJson(Map<String, dynamic> json) => ErrorData(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
