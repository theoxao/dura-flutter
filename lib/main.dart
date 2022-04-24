import 'package:duraemon_flutter/pages/good/good_add_page.dart';
import 'package:duraemon_flutter/pages/good/good_page.dart';
import 'package:duraemon_flutter/pages/home_page.dart';
import 'package:duraemon_flutter/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(750,1334),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          title: 'Dura',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: const SearchPage(),
          home: const GoodAddPage(),
        );
      },
    );
  }
}

