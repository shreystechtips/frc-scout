import 'package:flutter/material.dart';
import '../helper/bluealliance.dart' as bluealliance;
import '../helper/appdata.dart' as appdata;
import '../helper/constants.dart' as constants;
import 'dart:convert';

class Page extends StatefulWidget {
  final appdata.ScreenData screendata;
  const Page({super.key, required this.screendata});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late List<dynamic> items;
  late List<dynamic> showItems;
  TextEditingController txtQuery = TextEditingController();
  final indicator = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    items = jsonDecode(
        widget.screendata.prefs.getString(constants.TEAM_KEY, def: '[]'));
    showItems = items;
    super.initState();
  }

  void search(String query) {
    query = query.trim();
    if (query.isEmpty) {
      showItems = items;
      setState(() {});
      return;
    }

    query = query.toLowerCase();
    showItems = items.where((element) {
      return element['team_number'].toString().toLowerCase().contains(query) ||
          element['nickname'].toLowerCase().contains(query);
    }).toList();
    setState(() {});
  }

  Future<void> onRefresh(BuildContext context) {
    if (context.mounted) {
      return Future.delayed(const Duration(milliseconds: 0), () async {
        bool repsonse = false;
        await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Notice'),
                  content: const Text(
                      'Do you really want to refresh, this may take a bit'),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        repsonse = true;
                      },
                    ),
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ));
        if (repsonse) {
          await bluealliance.TBARequest.getTeams(
              save: true,
              prefs: widget.screendata.prefs,
              key: constants.TEAM_KEY);
          setState(() {
            items = jsonDecode(widget.screendata.prefs
                .getString(constants.TEAM_KEY, def: '[]'));
            showItems = items;
          });
        }
      });
    }
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        TextFormField(
          controller: txtQuery,
          onChanged: search,
          decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                txtQuery.text = '';
                search(txtQuery.text);
              },
            ),
          ),
        ),
        Expanded(
            child: RefreshIndicator(
                key: indicator,
                onRefresh: () => onRefresh(context),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: showItems.length,
                  prototypeItem: const ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text("948 - Newport Robotics Group 948"),
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(
                            '${showItems[index]['team_number']}: ${showItems[index]['nickname']}'),
                        onTap: () {
                          // bluealliance.TBARequest.getTeams().then((value) => print(value
                          //     .first
                          //     .nickname)); // TODO: Make this actually do something (like open a new page
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Alert'),
                                    content: Text('This is an alert $index'),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ));
                        });
                  },
                )))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => indicator.currentState?.show()),
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
