import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../helper/bluealliance.dart' as bluealliance;
import '../../helper/appdata.dart' as appdata;

class Page extends StatefulWidget {
  final appdata.ScreenData screendata;
  const Page({super.key, required this.screendata});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  void resetAppData() {
    setState(() {
      widget.screendata.prefs.clear();
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
                context.push('/teams', extra: {
                  'teamnum': items[index]['teamnum'],
                  'side': items[index]['side'],
                  'match': items[index]['match'],
                  'nextPath': '/',
                  'senderPath': '/'
                });
                // bluealliance.TBARequest.getTeams().then((value) => print(value
                //     .first
                //     .nickname)); // TODO: Make this actually do something (like open a new page
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: resetAppData,
        tooltip: 'Reset App Data!',
        heroTag: null,
        child: const Icon(Icons.delete_forever),
      ),
    );
  }
}
