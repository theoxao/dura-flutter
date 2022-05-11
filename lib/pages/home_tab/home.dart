//首页

import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:duraemon_flutter/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeNaviBar extends StatefulWidget {
  const HomeNaviBar({Key? key}) : super(key: key);

  @override
  _HomeNaviBarState createState() => _HomeNaviBarState();
}

class _HomeNaviBarState extends State<HomeNaviBar>
    with TickerProviderStateMixin {
  late TabController _tabController;

  var title = Row(
    children: [
      const Text(
        "My Home",
        style: headTextStyle,
      ),
      const Spacer(),
      const Icon(Icons.settings).scale(1.2),
    ],
  ).pa(16.0);

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var searchButton = SizedBox(
      width: 120,
      child: const TextField(
        decoration: InputDecoration(
          enabled: false,
          prefixIcon: Icon(Icons.search),
          hintText: "Search",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide(width: 1, style: BorderStyle.solid),
          ),
        ),
      ).gesture(onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const SearchPage();
        }));
      }).scale(0.8),
    ).pa(8.0);
    var tabBar = SizedBox(
      width: 180,
      child: Material(
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.green,
          tabs: const [
            Tab(
              text: "Room",
            ),
            Tab(
              text: "Good",
            ),
          ],
          labelColor: Colors.black,
          indicator: MaterialIndicator(
            height: 5,
            topLeftRadius: 8,
            topRightRadius: 8,
            horizontalPadding: 20,
            tabPosition: TabPosition.bottom,
          ),
        ),
      ),
    );

    return Column(
      children: [
        SizedBox(
          child: title,
          height: 80,
        ),
        SizedBox(
          height: 60,
          child: Row(
            children: [tabBar, const Spacer(), searchButton],
          ),
        ),
        SizedBox(
          height: 500,
          child: TabBarView(controller: _tabController, children: const [
            Center(child: Text("1")),
            Center(child: Text("2"))
          ]),
        )
      ],
    );
  }
}
