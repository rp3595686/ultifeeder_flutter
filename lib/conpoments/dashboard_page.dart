import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:utifeeder_flutter/conpoments/setting_page.dart';

import '../main.dart';
import '../responsive.dart';
import 'graph.dart';
import 'json_convert.dart';
import 'page_scaffold.dart';

bool timer_isRunning = true;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String currentPHLevel = '0', currentTempLevel = '0';
  Timer? timer_ph, timer_temp;

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
          setState(() {});
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
        while (phGraphData.length > 10) {
          phGraphData.removeAt(0);
          chartSeriesController_ph?.updateDataSource(
            removedDataIndex: 0,
          );
        }
        setState(() {
          currentPHLevel = phGraphData[phGraphData.length - 1].value.toString();
        });
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
          setState(() {});
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
          setState(() {
            currentTempLevel =
                tempGraphData[tempGraphData.length - 1].value.toString();
          });
        }
      }
      while (tempGraphData.length > 10) {
        tempGraphData.removeAt(0);
        chartSeriesController_temp?.updateDataSource(
          removedDataIndex: 0,
        );
      }
    }
  }

  Future fetchConfig() async {
    DataSnapshot snapshot_config = await firebase_ref.child('config/').get();
    if (snapshot_config.exists) {
      final jsonResponse_config = json.encode(snapshot_config.value);

      var configData = jsonDecode(jsonResponse_config);
      phInterval = configData['phInterval'];
      phInterval_temporary = configData['phInterval'].toString();
      tempInterval = configData['tempInterval'];
      tempInterval_temporary = configData['tempInterval'].toString();
    }
  }

  @override
  void initState() {
    fetchConfig();
    timer_ph = Timer.periodic(Duration(seconds: phInterval), fetchData_ph);
    timer_temp = Timer.periodic(const Duration(seconds: 5), fetchData_temp);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: Responsive.isDesktop(context) ? '' : 'Ultifeeder',
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Dashboard(
                  currentPHLevel: currentPHLevel,
                  currentTempLevel: currentTempLevel),
            ),
          ],
        ),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({
    Key? key,
    required this.currentPHLevel,
    required this.currentTempLevel,
  }) : super(key: key);

  final String currentPHLevel;
  final String currentTempLevel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Responsive(
          mobile: Expanded(
            child: Column(
              children: [
                DashboardMessage(),
                Expanded(
                  flex: 3,
                  child: DashboardSensorDetail(
                      currentPHLevel: currentPHLevel,
                      currentTempLevel: currentTempLevel),
                )
              ],
            ),
          ),
          tablet: DashboardMessage(),
          desktop: DashboardMessage(),
        ),
        if (!Responsive.isMobile(context))
          Expanded(
            child: DashboardSensorDetail(
                currentPHLevel: currentPHLevel,
                currentTempLevel: currentTempLevel),
          ),
      ],
    );
  }
}

class DashboardMessage extends StatelessWidget {
  const DashboardMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Everything is OK :)'),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        itemCount: 20,
      ),
    );
  }
}

class DashboardSensorDetail extends StatelessWidget {
  const DashboardSensorDetail({
    Key? key,
    required this.currentPHLevel,
    required this.currentTempLevel,
  }) : super(key: key);

  final String currentPHLevel;
  final String currentTempLevel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 5,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      padding: EdgeInsets.symmetric(),
                      child: Column(
                        children: [
                          Text(
                            'pH Level:',
                            style: TextStyle(
                                fontSize: 72, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            currentPHLevel,
                            style: TextStyle(
                                fontSize: 72, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 5,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      children: [
                        Text(
                          ' Temperature:',
                          style: TextStyle(
                              fontSize: 72, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          currentTempLevel,
                          style: TextStyle(
                              fontSize: 72, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Graph(),
        ),
      ],
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).primaryColorDark,
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'Ultifeeder',
                      style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontSize: 36),
                    ),
                  ),
                  SvgPicture.asset(
                    'logo.svg',
                    color: Colors.white,
                    height: 80,
                  ),
                ],
              ),
            ),
            /*Expanded(
              child: ListView(
                // Note: use ListView.builder if there are many items
                children: <Widget>[
                  // iterate through the keys to get the page names
                  Container(
                    height: 10,
                    color: Colors.blue,
                  )
                ],
              ),
            ),*/
            ListTile(
              onTap: () {},
              /*leading: Image.asset(
                "web/icons/Icon-192.png",
              ),*/
              title: Text(
                "Dashboard",
                style: TextStyle(
                    color: Theme.of(context).backgroundColor, fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {},
              /*leading: Image.asset(
                "web/icons/Icon-192.png",
              ),*/
              title: Text(
                "Settings",
                style: TextStyle(
                    color: Theme.of(context).backgroundColor, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
