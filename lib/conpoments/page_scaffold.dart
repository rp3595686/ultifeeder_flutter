import 'package:flutter/material.dart';

import 'dashboard_page.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    Key? key,
    required this.title,
    this.actions = const [],
    this.body,
    this.floatingActionButton,
  }) : super(key: key);
  final String title;
  final List<Widget> actions;
  final Widget? body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    // 1. look for an ancestor Scaffold
    final ancestorScaffold = Scaffold.maybeOf(context);
    // 2. check if it has a drawer
    final hasDrawer = ancestorScaffold != null && ancestorScaffold.hasDrawer;
    return Scaffold(
      appBar: AppBar(
        // 3. add a non-null leading argument if we have a drawer
        leading: hasDrawer
            ? IconButton(
                icon: Icon(Icons.menu),
                // 4. open the drawer if we have one
                onPressed:
                    hasDrawer ? () => ancestorScaffold?.openDrawer() : null,
              )
            : null,
        title: Text(title),
        flexibleSpace: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Currently Monitoring:',
                style: TextStyle(
                    color: Theme.of(context).backgroundColor, fontSize: 18),
              ),
              const SizedBox(
                width: 10,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  items:
                      sensorList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                      alignment: Alignment.center,
                    );
                  }).toList(),
                  value: sensorPath,
                  onChanged: (Object? value) {
                    ancestorScaffold?.setState(() {
                      sensorPath = value.toString();
                    });
                  },
                  style: TextStyle(
                      color: Theme.of(context).backgroundColor, fontSize: 16),
                  dropdownColor: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular(10),
                  iconEnabledColor: Colors.white,
                  isDense: true,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        actions: actions,
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
