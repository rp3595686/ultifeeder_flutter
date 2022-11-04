import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

List<GraphData> phGraphData = <GraphData>[];
List<GraphData> tempGraphData = <GraphData>[];

class Graph extends StatelessWidget {
  const Graph({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: SfCartesianChart(
        //title: ChartTitle(text: "test"),
        legend: Legend(
          isVisible: true,
        ),
        // Initialize category axis
        primaryXAxis: DateTimeAxis(),
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
            dataLabelSettings: DataLabelSettings(isVisible: true),
            // Renders the marker
            markerSettings: MarkerSettings(isVisible: true),
          ),
          SplineSeries<GraphData, DateTime>(
            name: "Temperature",
            // Bind data source
            dataSource: tempGraphData,
            xValueMapper: (GraphData data, _) => data.time,
            yValueMapper: (GraphData data, _) =>
                data.value, // Enable data label
            dataLabelSettings: DataLabelSettings(isVisible: true),
            // Renders the marker
            markerSettings: MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

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
}
