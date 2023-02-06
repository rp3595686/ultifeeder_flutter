import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utifeeder_flutter/main.dart';

import 'json_convert.dart';

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
