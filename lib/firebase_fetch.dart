import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:utifeeder_flutter/conpoments/setting_page.dart';

import 'conpoments/dashboard_page.dart';
import 'conpoments/graph.dart';
import 'conpoments/json_convert.dart';
import 'main.dart';

final firebase_ref = firebaseDB.ref();
Future fetchData_ph(Timer timer_ph) async {
  if (!timer_isRunning) {
    // cancel the timer
    timer_ph.cancel();
  }
  DataSnapshot snapshot_ph =
      await firebase_ref.child('ph/').limitToLast(10).get();
  if (snapshot_ph.exists) {
    final jsonResponse_ph = json.encode(snapshot_ph.value);
    final Response_ph = graphdataFromJson(jsonResponse_ph);

    if (phGraphData.isEmpty) {
      //Add all data
      for (var data in Response_ph.values) {
        DateTime time = data.time;
        double value = data.value;
        phGraphData.add(GraphData(time: time, value: value));
        //setState(() {});
        //chartSeriesController_ph?.updateDataSource(
        //    addedDataIndexes: <int>[phGraphData.length - 1]);
      }
    } else {
      for (var data in Response_ph.values) {
        DateTime time = data.time;
        double value = data.value;
        bool isExist = false;

        //Check if exist
        for (var a in phGraphData) {
          if (a.time == time) {
            isExist = true;
            break;
          }
        }
        if (isExist == false) {
          phGraphData.add(GraphData(time: time, value: value));
          chartSeriesController_ph?.updateDataSource(
            addedDataIndex: phGraphData.length - 1,
          );
        }
      }
      if (phGraphData.length > 10) {
        while (phGraphData.length > 10) {
          phGraphData.removeAt(0);
          chartSeriesController_ph?.updateDataSource(
            removedDataIndex: 0,
          );
        }
      }
    }
  }
}

Future fetchData_temp(Timer timer_temp) async {
  if (!timer_isRunning) {
    // cancel the timer
    timer_temp.cancel();
  }
  DataSnapshot snapshot_temp =
      await firebase_ref.child('temp/').limitToLast(10).get();
  if (snapshot_temp.exists) {
    final jsonResponse_temp = json.encode(snapshot_temp.value);
    final Response_temp = graphdataFromJson(jsonResponse_temp);

    if (tempGraphData.isEmpty) {
      //Add all data
      for (var data in Response_temp.values) {
        DateTime time = data.time;
        double value = data.value;
        tempGraphData.add(GraphData(time: time, value: value));
        //setState(() {});
      }
    } else {
      for (var data in Response_temp.values) {
        DateTime time = data.time;
        double value = data.value;
        bool isExist = false;

        //Check if exist
        for (var a in tempGraphData) {
          if (a.time == time) {
            isExist = true;
            break;
          }
        }
        if (isExist == false) {
          tempGraphData.add(GraphData(time: time, value: value));
          chartSeriesController_temp?.updateDataSource(
            addedDataIndex: tempGraphData.length - 1,
          );
        }
      }
    }
    if (tempGraphData.length > 10) {
      while (tempGraphData.length > 10) {
        tempGraphData.removeAt(0);
        chartSeriesController_temp?.updateDataSource(
          removedDataIndex: 0,
        );
      }
    }
    /*if (index == Response_temp.length - 1) {
        if (currentTempLevel != temp_tempGraphData[index].value.toString()) {
          /*setState(() {
              //At the last loop set Response_temp.length
              currentTempLevel = temp_tempGraphData[index].value.toString();
            });*/
        }
      }*/
  }
}

Future fetchConfig() async {
  DataSnapshot snapshot_config = await firebase_ref.child('config/').get();
  if (snapshot_config.exists) {
    final jsonResponse_config = json.encode(snapshot_config.value);

    var configData = jsonDecode(jsonResponse_config);
    phInterval = configData['phInterval'];
    tempInterval = configData['tempInterval'];
  }
}
