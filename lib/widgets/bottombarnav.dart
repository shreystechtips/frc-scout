import 'package:flutter/material.dart';

class BottomBarNav extends StatefulWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> barItems;
  final String title;

  const BottomBarNav({
    Key? key,
    required this.pages,
    required this.barItems,
    required this.title,
  }) : super(key: key);

  @override
  State<BottomBarNav> createState() => _BottomBarNavState();
}

class _BottomBarNavState extends State<BottomBarNav> {
  int selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: widget.pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: widget.barItems,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
