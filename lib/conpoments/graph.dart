import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utifeeder_flutter/main.dart';

List<GraphData> phGraphData = <GraphData>[];
List<GraphData> tempGraphData = <GraphData>[];

class Graph extends StatelessWidget {
  const Graph({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Card(
            elevation: 5,
            child: SfCartesianChart(
              //title: ChartTitle(text: "test"),
              enableAxisAnimation: true,
              legend: Legend(
                isVisible: true,
              ),
              // Initialize category axis
              primaryXAxis: DateTimeAxis(),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 14),
              //tooltipBehavior: TooltipBehavior(enable: true),

              /// To set the track ball as true and customized trackball behaviour.
              trackballBehavior: TrackballBehavior(
                enable: true,
                markerSettings: TrackballMarkerSettings(
                  markerVisibility: TrackballVisibilityMode.visible,
                  height: 10,
                  width: 10,
                  borderWidth: 3,
                ),
                activationMode: ActivationMode.singleTap,
                tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                /*tooltipSettings: InteractiveTooltip(
                    format: TrackballDisplayMode.floatAllPoints !=
                            TrackballDisplayMode.groupAllPoints
                        ? 'series.name : point.y'
                        : null,
                  ),*/
              ),
              series: <SplineSeries<GraphData, DateTime>>[
                SplineSeries<GraphData, DateTime>(
                  name: "pH Level",
                  // Bind data source
                  dataSource: phGraphData,
                  xValueMapper: (GraphData data, _) => data.time,
                  yValueMapper: (GraphData data, _) =>
                      data.value, // Enable data label
                  //dataLabelSettings: DataLabelSettings(isVisible: true),
                  // Renders the marker
                  //markerSettings: MarkerSettings(isVisible: true),
                  onRendererCreated: (ChartSeriesController controller) {
                    chartSeriesController_ph = controller;
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Card(
            elevation: 5,
            child: SfCartesianChart(
              //title: ChartTitle(text: "test"),
              enableAxisAnimation: true,
              legend: Legend(
                isVisible: true,
              ),
              // Initialize category axis
              primaryXAxis: DateTimeAxis(),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 30),
              //tooltipBehavior: TooltipBehavior(enable: true),

              /// To set the track ball as true and customized trackball behaviour.
              trackballBehavior: TrackballBehavior(
                enable: true,
                markerSettings: TrackballMarkerSettings(
                  markerVisibility: TrackballVisibilityMode.visible,
                  height: 10,
                  width: 10,
                  borderWidth: 3,
                ),
                activationMode: ActivationMode.singleTap,
                tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                /*tooltipSettings: InteractiveTooltip(
                    format: TrackballDisplayMode.floatAllPoints !=
                            TrackballDisplayMode.groupAllPoints
                        ? 'series.name : point.y'
                        : null,
                  ),*/
              ),
              series: <SplineSeries<GraphData, DateTime>>[
                SplineSeries<GraphData, DateTime>(
                  name: "Temperature",
                  color: Colors.orange,
                  // Bind data source
                  dataSource: tempGraphData,
                  xValueMapper: (GraphData data, _) => data.time,
                  yValueMapper: (GraphData data, _) =>
                      data.value, // Enable data label
                  //dataLabelSettings: DataLabelSettings(isVisible: true),
                  // Renders the marker
                  //markerSettings: MarkerSettings(isVisible: true),
                  onRendererCreated: (ChartSeriesController controller) {
                    chartSeriesController_temp = controller;
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
/*
class GraphData {
  GraphData(this.time, this.value);
  final DateTime time;
  final double value;
/*
  factory GraphData.fromJson(Map<DateTime, dynamic> parsedJson) {
    print(parsedJson.runtimeType);
    return GraphData(
      DateTime.parse(parsedJson['time'].toString()),
      parsedJson['value'],
    );
  }*/
}*/

// To parse this JSON data, do
//
//     final graphdata = graphdataFromJson(jsonString);

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
