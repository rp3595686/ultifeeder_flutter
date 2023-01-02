import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'conpoments/graph.dart';
import 'firebase_options.dart';
import 'responsive.dart';

var firebaseDB;
ChartSeriesController? chartSeriesController_ph, chartSeriesController_temp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  firebaseDB = FirebaseDatabase.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultifeeder Admin Panel',
      theme: ThemeData(
        brightness: Brightness.light,
        visualDensity: VisualDensity.comfortable,
        primarySwatch: Colors.indigo,
        primaryColor: Colors.indigo,
        primaryColorLight: Colors.indigo.shade300,
        primaryColorDark: Colors.indigo.shade900,
        backgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.white,
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentPHLevel = '0', currentTempLevel = '0';
  //Initialize the series controller

  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 5), fetchData);
    super.initState();
  }

  fetchData(Timer timer) async {
    final ref = firebaseDB.ref();
    DataSnapshot snapshot_ph = await ref.child('ph/').limitToLast(10).get();
    if (snapshot_ph.exists) {
      final jsonResponse_ph = json.encode(snapshot_ph.value);
      final Response_ph = graphdataFromJson(jsonResponse_ph);

      List<bool> isExistList = [];
      List<GraphData> temp_phGraphData = [];

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
          temp_phGraphData.add(GraphData(time: time, value: value));
          isExistList.add(isExist);
        }
      }

      int index = 0;
      for (var a in isExistList) {
        if (a == false) {
          phGraphData.add(temp_phGraphData[index]);
          chartSeriesController_ph?.updateDataSource(
            addedDataIndex: phGraphData.length - 1,
            removedDataIndex: 0,
          );
        }
        if (phGraphData.length > 10) {
          while (phGraphData.length > 10) {
            phGraphData.removeAt(0);
            chartSeriesController_ph?.updateDataSource(
              removedDataIndex: 0,
            );
          }
        }
        if (index == Response_ph.length - 1) {
          if (currentPHLevel != temp_phGraphData[index].value.toString()) {
            setState(() {
              //At the last loop set Response_temp.length
              currentPHLevel = temp_phGraphData[index].value.toString();
            });
          }
        }
        index++;
      }
    } else {
      print('No data available.');
    }

    DataSnapshot snapshot_temp = await ref.child('temp/').limitToLast(10).get();
    if (snapshot_temp.exists) {
      final jsonResponse_temp = json.encode(snapshot_temp.value);
      final Response_temp = graphdataFromJson(jsonResponse_temp);

      List<bool> isExistList = [];
      List<GraphData> temp_tempGraphData = [];

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
          temp_tempGraphData.add(GraphData(time: time, value: value));
          isExistList.add(isExist);
        }
      }

      int index = 0;
      for (var a in isExistList) {
        if (a == false) {
          tempGraphData.add(temp_tempGraphData[index]);
          chartSeriesController_temp?.updateDataSource(
              addedDataIndex: tempGraphData.length - 1);
        }
        if (tempGraphData.length > 10) {
          while (tempGraphData.length > 10) {
            tempGraphData.removeAt(0);
            chartSeriesController_temp?.updateDataSource(
              removedDataIndex: 0,
            );
          }
        }
        if (index == Response_temp.length - 1) {
          if (currentTempLevel != temp_tempGraphData[index].value.toString()) {
            setState(() {
              //At the last loop set Response_temp.length
              currentTempLevel = temp_tempGraphData[index].value.toString();
            });
          }
        }
        index++;
      }
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.yellow,
        ),
      ),
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!Responsive.isMobile(context))
              SideMenu(), //If it is not mobile, show SideMenu
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    child: Container(
                      height: 50,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Text('Dashboard'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                          child: Card(
                        elevation: 5,
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: Text("Everything is good :)")),
                            ],
                          ),
                        ),
                      )),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      elevation: 5,
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              ' pH Level:',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Text(
                                            currentPHLevel,
                                            style: TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Card(
                                      elevation: 5,
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              ' Temperature:',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Text(
                                            currentTempLevel,
                                            style: TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ],
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
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Drawer(
        backgroundColor: Theme.of(context).primaryColorDark,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                  child: Column(
                children: [
                  Text(
                    'Ultifeeder',
                    style: TextStyle(
                        color: Theme.of(context).backgroundColor, fontSize: 36),
                  ),
                  SvgPicture.asset(
                    'logo.svg',
                    color: Colors.white,
                    height: 80,
                  ),
                ],
              )),
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
            ],
          ),
        ),
      ),
    );
  }
}
