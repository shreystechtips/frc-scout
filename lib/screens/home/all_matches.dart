import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frc_scout/helper/appdata.dart' as appdata;
import 'package:frc_scout/helper/constants.dart' as constants;
import 'package:frc_scout/widgets/confirmdialog.dart' as confirmdialog;

class Page extends StatefulWidget {
  final appdata.ScreenData screendata;
  const Page({super.key, required this.screendata});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  void resetAppData() async {
    bool response = await confirmdialog.acceptAction(
        context, 'Do you really want to reset the app data?');
    if (response) {
      setState(() {
        widget.screendata.prefs.clear();
      });
    }
  }

  void newMatch() {
    context.push('/team-selection', extra: {
      'nextPath': '/match-page',
      'senderPath': '/',
    });
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter state = GoRouter.of(context);
    final items = List<Map<String, dynamic>>.generate(
        10000,
        (i) =>
            {'teamnum': "Team name go brr - $i", 'side': 'red 2', 'match': i});
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () async {
            bool repsonse = await confirmdialog.acceptAction(context, "bro");
            if (repsonse) {
              state.go('/');
            }
          },
        ),
        title: const Text(constants.APP_NAME),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: resetAppData,
            tooltip: 'Reset App Data!',
          ),
        ],
        automaticallyImplyLeading: false,
      ),
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
                context.push('/team-selection', extra: {
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: resetAppData,
      //   tooltip: 'Reset App Data!',
      //   heroTag: null,
      //   child: const Icon(Icons.delete_forever),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: newMatch,
        tooltip: 'New Match',
        heroTag: null,
        child: const Icon(Icons.add),
      ),
    );
  }
}
