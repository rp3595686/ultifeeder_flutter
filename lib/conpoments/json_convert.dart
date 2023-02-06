import 'dart:convert';

Map<String, int> configdataFromJson(String str) =>
    Map.from(json.decode(str)).map((k, v) => MapEntry<String, int>(k, (v)));

Map<String, GraphData> graphdataFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, GraphData>(k, GraphData.fromJson(v)));

String graphdataToJson(Map<String, GraphData> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

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
