import 'package:flutter/material.dart';
import '../helper/bluealliance.dart' as bluealliance;
import '../helper/appdata.dart' as appdata;
import '../helper/constants.dart' as constants;
import 'dart:convert';

class Page extends StatefulWidget {
  final appdata.AppData prefs;
  const Page({super.key, required this.prefs});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      widget.prefs.clear();
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items =
        jsonDecode(widget.prefs.getString(constants.TEAM_KEY, def: '[]'));
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: ListView.builder(
        itemCount: items.length,
        prototypeItem: const ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          title: Text("948 - Newport Robotics Group 948"),
        ),
        itemBuilder: (context, index) {
          return ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Text(
                  '${items[index]['team_number']}: ${items[index]['nickname']}'),
              onTap: () {
                // bluealliance.TBARequest.getTeams().then((value) => print(value
                //     .first
                //     .nickname)); // TODO: Make this actually do something (like open a new page
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Alert'),
                          content: Text('This is an alert $index'),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ));
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
