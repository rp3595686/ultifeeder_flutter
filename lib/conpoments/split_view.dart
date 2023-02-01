import 'package:flutter/material.dart';
import 'package:utifeeder_flutter/responsive.dart';

class SplitView extends StatelessWidget {
  const SplitView({
    Key? key,
    required this.menu,
    required this.content,
    this.breakpoint = 600,
    this.menuWidth = 240,
  }) : super(key: key);
  final Widget menu;
  final Widget content;
  final double breakpoint;
  final double menuWidth;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        // narrow screen: show content, menu inside drawer
        body: content,
        drawer: SizedBox(
          width: menuWidth,
          child: Drawer(
            child: menu,
          ),
        ),
      ),
      tablet: Scaffold(
        // narrow screen: show content, menu inside drawer
        body: content,
        drawer: SizedBox(
          width: menuWidth,
          child: Drawer(
            child: menu,
          ),
        ),
      ),
      desktop: Row(
        // wide screen: menu on the left, content on the right
        children: [
          SizedBox(
            width: menuWidth,
            child: menu,
          ),
          //Container(width: 5, color: Colors.black),
          Expanded(child: content),
        ],
      ),
    );
  }
}
