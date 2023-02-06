import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:utifeeder_flutter/conpoments/setting_page.dart';

import '../firebase_fetch.dart';
import '../responsive.dart';
import 'graph.dart';
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
