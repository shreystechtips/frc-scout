import 'package:flutter/material.dart';

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
      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       const Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headline4,
      //       ),
      //       ElevatedButton(
      //         child: const Text("Reset Counter"),
      //         onPressed: () => setState(() => _counter = 0),
      //       ),
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
