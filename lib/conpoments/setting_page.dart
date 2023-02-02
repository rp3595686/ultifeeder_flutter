import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utifeeder_flutter/conpoments/page_scaffold.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  @override
  State<SettingPage> createState() => _SettingPageState();
}

int phInterval_temp = 5;
int phInterval = 5;

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
                  if (value != '') {
                    phInterval_temp = int.parse(value);
                  }
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Fetch pH data intervals',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    phInterval = phInterval_temp;
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
