//分类

import 'package:flutter/material.dart';

class CategoryNaviBar extends StatefulWidget {
  const CategoryNaviBar({Key? key}) : super(key: key);

  @override
  _CategoryNaviBarState createState() => _CategoryNaviBarState();
}

class _CategoryNaviBarState extends State<CategoryNaviBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("category"),
    );
  }
}
