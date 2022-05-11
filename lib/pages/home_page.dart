
import 'package:duraemon_flutter/pages/good/good_add_page.dart';
import 'package:duraemon_flutter/pages/home_tab/home.dart';
import 'package:duraemon_flutter/pages/home_tab/me.dart';
import 'package:fancy_bar/fancy_bar.dart';
import 'package:flutter/material.dart';

import 'home_tab/category.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var naviBars = [
    FancyItem(
      textColor: Colors.orange,
      title: 'Home',
      icon: const Icon(Icons.home),
    ),
    FancyItem(
      textColor: Colors.red,
      title: 'Category',
      icon: const Icon(Icons.category),
    ),
    FancyItem(
      textColor: Colors.green,
      title: 'Me',
      icon: const Icon(Icons.person),
    ),
  ];

  var currentIndex = 0;

  final  _optionBars = [
      const HomeNaviBar(),const CategoryNaviBar(), const MeNaviBar()
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: _optionBars.elementAt(currentIndex),
      ),
      bottomNavigationBar: FancyBottomBar(
        type: FancyType.FancyV2,   // Fancy Bar Type
        items: naviBars,
        onItemSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const GoodAddPage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}