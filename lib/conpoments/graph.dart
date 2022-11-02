import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Graph extends StatelessWidget {
  const Graph({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GraphData> phGraphData = <GraphData>[
      GraphData(DateTime(2015, 1, 1, 1), 35),
      GraphData(DateTime(2015, 1, 1, 2), 28),
      GraphData(DateTime(2015, 1, 1, 3), 34),
      GraphData(DateTime(2015, 1, 1, 4), 32),
      GraphData(DateTime(2015, 1, 1, 5), 40),
    ];
    final List<GraphData> tempGraphData = <GraphData>[
      GraphData(DateTime(2015, 1, 1, 1), 20),
      GraphData(DateTime(2015, 1, 1, 2), 28),
      GraphData(DateTime(2015, 1, 1, 3), 40),
      GraphData(DateTime(2015, 1, 1, 4), 32),
      GraphData(DateTime(2015, 1, 1, 6), 21),
    ];

    return SfCartesianChart(
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
        ]);
  }
}

class GraphData {
  GraphData(this.time, this.value);
  final DateTime time;
  final double value;
}
