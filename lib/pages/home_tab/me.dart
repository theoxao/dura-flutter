//我的

import 'package:flutter/material.dart';

class MeNaviBar extends StatefulWidget {
  const MeNaviBar({Key? key}) : super(key: key);

  @override
  _MeNaviBarState createState() => _MeNaviBarState();
}

class _MeNaviBarState extends State<MeNaviBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("me"),
    );
  }
}
