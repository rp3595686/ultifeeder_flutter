import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utifeeder_flutter/conpoments/page_scaffold.dart';

import '../firebase_fetch.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  @override
  State<SettingPage> createState() => _SettingPageState();
}

//default interval = 5
int phInterval = 5;
String phInterval_temporary = '5';
int tempInterval = 5;
String tempInterval_temporary = '5';

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Settings',
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                initialValue: phInterval.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  phInterval_temporary = value;
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Fetch pH Data Interval (Default: 5 sec)',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                initialValue: tempInterval.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  tempInterval_temporary = value;
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Fetch Temperature Data Interval (Default: 5 sec)',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (phInterval_temporary == '' ||
                        tempInterval_temporary == '') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please filled in all blanks')));
                    } else {
                      phInterval = int.parse(phInterval_temporary);
                      tempInterval = int.parse(tempInterval_temporary);
                      firebase_ref.child('config/').set({
                        // Save config to Firebase
                        "phInterval": phInterval,
                        "tempInterval": tempInterval
                      });
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Saved')));
                    }
                  });
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColorDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
