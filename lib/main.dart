import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'conpoments/graph.dart';
import 'firebase_options.dart';

var firebaseDB;

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
        primaryColorDark: Colors.indigo.shade700,
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

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() async {
    final ref = firebaseDB.ref();
    var snapshot_ph = await ref.child('ph/').get();
    /*final jsonResponse = json.encode(snapshot_ph.value);
    final jsonResponse = json.decode('{"test":"1"}');
    print(json.encode(snapshot_ph.value[0]));*/
    if (snapshot_ph.exists) {
      final jsonResponse = json.encode(snapshot_ph.value);
      final Response = json.decode(jsonResponse);
      for (var i = 0; i < Response.length; i++) {
        setState(() {
          phGraphData.add(GraphData(
              DateTime.parse(Response[i]['time']), Response[i]['value']));
          if (i == Response.length - 1) {
            currentPHLevel = Response[i]['value'].toString();
          }
        });
      }
    } else {
      print('No data available.');
    }

    var snapshot_temp = await ref.child('temp/').get();
    if (snapshot_temp.exists) {
      final jsonResponse = json.encode(snapshot_temp.value);
      final Response = json.decode(jsonResponse);
      for (var i = 0; i < Response.length; i++) {
        setState(() {
          tempGraphData.add(GraphData(
              DateTime.parse(Response[i]['time']), Response[i]['value']));
          if (i == Response.length - 1) {
            currentTempLevel = Response[i]['value'].toString();
          }
        });
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
            SideMenu(),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: Colors.green,
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
                            Expanded(
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        phGraphData =
                                            <GraphData>[]; //claer data in list
                                        tempGraphData =
                                            <GraphData>[]; //claer data in list

                                        fetchData();
                                      });
                                    },
                                    child: Icon(
                                      Icons.refresh,
                                      color: Colors.blue,
                                    )))
                          ],
                        ),
                      ),
                    ],
                  )),

                  /*Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 5,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              height: 500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Card(
                              elevation: 5,
                              child: Container(
                                height: 500,
                                child: SfCartesianChart(
                                    // Initialize category axis
                                    primaryXAxis: CategoryAxis(),
                                    tooltipBehavior:
                                        TooltipBehavior(enable: true),

                                    /// To set the track ball as true and customized trackball behaviour.
                                    trackballBehavior: TrackballBehavior(
                                      enable: true,
                                      markerSettings: TrackballMarkerSettings(
                                        markerVisibility:
                                            TrackballVisibilityMode.visible,
                                        height: 10,
                                        width: 10,
                                        borderWidth: 1,
                                      ),
                                      activationMode: ActivationMode.singleTap,
                                      tooltipDisplayMode:
                                          TrackballDisplayMode.floatAllPoints,
                                      tooltipSettings: InteractiveTooltip(
                                        format: TrackballDisplayMode
                                                    .floatAllPoints !=
                                                TrackballDisplayMode
                                                    .groupAllPoints
                                            ? 'series.name : point.y'
                                            : null,
                                      ),
                                    ),
                                    series: <SplineSeries<SalesData, String>>[
                                      SplineSeries<SalesData, String>(
                                          // Bind data source
                                          dataSource: <SalesData>[
                                            SalesData('Jan', 35),
                                            SalesData('Feb', 28),
                                            SalesData('Mar', 34),
                                            SalesData('Apr', 32),
                                            SalesData('May', 40)
                                          ],
                                          xValueMapper: (SalesData sales, _) =>
                                              sales.year,
                                          yValueMapper: (SalesData sales, _) =>
                                              sales.sales, // Enable data label
                                          dataLabelSettings: DataLabelSettings(
                                              isVisible: true))
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        color: Colors.red,
                      ),
                    ],
                  )*/
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
        backgroundColor: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                  child: Icon(
                Icons.flutter_dash,
                size: 50,
              )),
              ListTile(
                onTap: () {},
                leading: Image.asset(
                  "web/icons/Icon-192.png",
                ),
                title: Text("title"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
