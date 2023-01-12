import 'package:flutter/material.dart';
import '../helper/bluealliance.dart' as bluealliance;

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = List<Map<String, dynamic>>.generate(
        10000,
        (i) =>
            {'teamnum': "Team name go brr - $i", 'side': 'red 2', 'match': i});
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: ListView.builder(
        itemCount: items.length,
        prototypeItem: const ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          title: Text("Match 948: Newport Robotics Group 948"),
          subtitle: Text('Red 1'),
        ),
        itemBuilder: (context, index) {
          return ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Text(
                  'Match ${items[index]['match']}: ${items[index]['teamnum']}'),
              subtitle: Text('Here is a second line ${items[index]['side']}'),
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
