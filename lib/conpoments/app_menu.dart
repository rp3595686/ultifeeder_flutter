import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dashboard_page.dart';
import 'setting_page.dart';

// a map of ("page name", WidgetBuilder) pairs
final _availablePages = <String, WidgetBuilder>{
  'Dashboard': (_) => DashboardPage(),
  'Setting': (_) => SettingPage(),
};

// make this a `StateProvider` so we can change its value
final selectedPageNameProvider = StateProvider<String>((ref) {
  // default value
  return _availablePages.keys.first;
});

final selectedPageBuilderProvider = Provider<WidgetBuilder>((ref) {
  // watch for state changes inside selectedPageNameProvider
  final selectedPageKey = ref.watch(selectedPageNameProvider.state).state;
  // return the WidgetBuilder using the key as index
  return _availablePages[selectedPageKey]!;
});

// 1. extend from ConsumerWidget
class AppMenu extends ConsumerWidget {
  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedPageNameProvider.state).state != pageName) {
      ref.read(selectedPageNameProvider.state).state = pageName;
      // dismiss the drawer of the ancestor Scaffold if we have one
      if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onTap: () {
                _selectPage(context, ref, 'Dashboard');
                timer_isRunning = true;
              },
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
              onTap: () {
                _selectPage(context, ref, 'Setting');
                timer_isRunning = false;
              },
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
