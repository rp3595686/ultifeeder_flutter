import 'package:flutter/material.dart';
import 'package:utifeeder_flutter/conpoments/page_scaffold.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Settings',
      body: Center(
        child: Text('Settings', style: Theme.of(context).textTheme.headline4),
      ),
    );
  }
}
