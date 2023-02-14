import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utifeeder_flutter/conpoments/page_scaffold.dart';

import '../main.dart';
import 'dashboard_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  @override
  State<SettingPage> createState() => _SettingPageState();
}

// Monitoring Settings
int updatePhInterval = 5000;
String updatePhInterval_temporary = '5000';
int updateTempInterval = 5000;
String updateTempInterval_temporary = '5000';

// Feeder Settings
//int readPhInterval = 15000;
String readPhInterval = '15000';
//int readTempInterval = 10000;
String readTempInterval = '10000';
//int feedInterval = 30000;
String feedInterval = '30000';

// TextField Controllers
final readPhIntervalField = TextEditingController();
final readTempIntervalField = TextEditingController();
final feedIntervalField = TextEditingController();

class _SettingPageState extends State<SettingPage> {
  Future fetchFeederConfig() async {
    DataSnapshot snapshot_feederConfig =
        await firebase_ref.child("$configPath/$selectedChipID").get();
    if (snapshot_feederConfig.exists) {
      final jsonResponse_feederConfig =
          json.encode(snapshot_feederConfig.value);

      var feederConfigData = jsonDecode(jsonResponse_feederConfig);
      if (feederConfigData.isNotEmpty) {
        setState(() {
          if (feederConfigData['readPhInterval'] != null) {
            readPhIntervalField.text = readPhInterval =
                feederConfigData['readPhInterval']
                    .toString(); //prevent data not in String type
          } else {
            readPhIntervalField.text = readPhInterval = '';
          }
          if (feederConfigData['readTempInterval'] != null) {
            readTempIntervalField.text = readTempInterval =
                feederConfigData['readTempInterval'].toString();
          } else {
            readTempIntervalField.text = readTempInterval = '';
          }
          if (feederConfigData['feedInterval'] != null) {
            feedIntervalField.text =
                feedInterval = feederConfigData['feedInterval'].toString();
          } else {
            feedIntervalField.text = feedInterval = '';
          }
        });
      }
    }
  }

  String selectedChipID_prev = '';
  Timer? timer_checkChipIDChange;
  Future checkChipIDChange(Timer timer_checkChipIDChange) async {
    // refresh widget when chipID is being changed
    if (selectedChipID_prev != selectedChipID) {
      setState(() {
        selectedChipID_prev = selectedChipID;
        fetchFeederConfig();
      });
    }
  }

  @override
  void initState() {
    fetchFeederConfig();
    selectedChipID_prev = selectedChipID;
    timer_checkChipIDChange =
        Timer.periodic(Duration(seconds: 5), checkChipIDChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Settings',
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                elevation: 5,
                child: Column(
                  children: [
                    Text(
                      'Monitoring Settings',
                      style: TextStyle(fontSize: 36),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        initialValue: updatePhInterval.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          updatePhInterval_temporary = value;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText:
                              'Fetch pH Data Interval (Default: 5000 milliseconds)',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        initialValue: updateTempInterval.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          updateTempInterval_temporary = value;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText:
                              'Fetch Temperature Data Interval (Default: 5000 milliseconds)',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                elevation: 5,
                child: Column(
                  children: [
                    Text(
                      'Ultifeeder Settings',
                      style: TextStyle(fontSize: 36),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: readPhIntervalField,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // allow only numbers
                        ],
                        onChanged: (value) {
                          readPhInterval = value;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText:
                              'Read pH Data Interval on the Ultifeeder (Default: 15000 milliseconds)',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: readTempIntervalField,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          readTempInterval = value;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText:
                              'Read Temperature Data Interval on the Ultifeeder (Default: 10000 milliseconds)',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: feedIntervalField,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          feedInterval = value;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText:
                              'Feed Interval on the Ultifeeder (Default: 30000 milliseconds)',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    // if any field left blank
                    if (updatePhInterval_temporary == '' ||
                        updateTempInterval_temporary == '' ||
                        readPhInterval == '' ||
                        readTempInterval == '' ||
                        feedInterval == '') {
                      // show snack bar
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please filled in all blanks')));
                    } else {
                      updatePhInterval = int.parse(updatePhInterval_temporary);
                      updateTempInterval =
                          int.parse(updateTempInterval_temporary);

                      // Save Ultifeeder Settings to Firebase
                      firebase_ref.child("$configPath/$selectedChipID").set({
                        "readPhInterval": readPhInterval,
                        "readTempInterval": readTempInterval,
                        "feedInterval": feedInterval,
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
