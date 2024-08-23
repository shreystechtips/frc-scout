import 'package:flutter/material.dart';

class BottomBarNav extends StatefulWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> barItems;
  final String title;
  final Function(int) onItemTapped;
  final int selectedIndex;

  const BottomBarNav({
    Key? key,
    required this.pages,
    required this.barItems,
    required this.onItemTapped,
    required this.selectedIndex,
    required this.title,
  }) : super(key: key);

  @override
  State<BottomBarNav> createState() => _BottomBarNavState();
}

class _BottomBarNavState extends State<BottomBarNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: widget.pages[widget.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: widget.barItems,
        currentIndex: widget.selectedIndex,
        onTap: widget.onItemTapped,
      ),
    );
  }
}
