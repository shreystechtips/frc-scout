import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frc_scout/helper/appdata.dart' as appdata;
import 'package:frc_scout/widgets/bottombarnav.dart' as bottombarnav;
import 'package:frc_scout/screens/home/all_matches.dart' as matches;
import 'package:frc_scout/screens/home/all_rankings.dart' as rankings;
import 'package:frc_scout/screens/home/all_pitnotes.dart' as pitnotes;
import 'package:frc_scout/screens/teamselection.dart' as teamselection;
import 'package:frc_scout/helper/constants.dart' as constants;
import 'package:frc_scout/widgets/confirmdialog.dart' as confirmdialog;
import 'package:go_router/go_router.dart';

class HomeNav extends StatefulWidget {
  final appdata.ScreenData screendata;

  const HomeNav({Key? key, required this.screendata}) : super(key: key);

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  static const List<BottomNavigationBarItem> _barItems =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.note_alt),
      label: 'Record Data',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.book),
      label: 'Events',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.handyman),
      label: 'Parameters',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final GoRouterState state = GoRouterState.of(context);
    final Map<String, dynamic> arguments = state.extra as Map<String, dynamic>;
    print(arguments);
    final List<Widget> pages = <Widget>[
      matches.Page(
        screendata: widget.screendata,
      ),
      rankings.Page(
        screendata: widget.screendata,
      ),
      // pitnotes.Page(
      //   screendata: widget.screendata,
      // ),
      teamselection.Page(screendata: widget.screendata),
    ];

    return bottombarnav.BottomBarNav(pages: pages, barItems: _barItems);
  }
}
