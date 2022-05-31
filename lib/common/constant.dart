import 'dart:developer';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:flutter/material.dart';

const headTextStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold
);


const host = "https://api.theoxao.com/dura/";
// const host = "http://localhost:8989/";


double get windowWidth => window.physicalSize.width;

double get width5 => windowWidth /20.0;
double get width10 => windowWidth /10.0;
double get width20 => windowWidth /5.0;
double get width40 => windowWidth /2.5;
double get width50 => windowWidth /2.0;
double get width80 => windowWidth /1.25;
double get width100 => windowWidth;

EdgeInsets pt8= const EdgeInsets.only(top: 8.0);
EdgeInsets pt16= const EdgeInsets.only(top: 16.0);

EdgeInsets pb8= const EdgeInsets.only(bottom: 8.0);
EdgeInsets pb16= const EdgeInsets.only(bottom: 16.0);

EdgeInsets pl8= const EdgeInsets.only(left: 8.0);
EdgeInsets pl16= const EdgeInsets.only(left: 16.0);

EdgeInsets pr8= const EdgeInsets.only(right: 8.0);
EdgeInsets pr16= const EdgeInsets.only(right: 16.0);

EdgeInsets ph8= const EdgeInsets.only(right: 8.0 , left: 8.0);
EdgeInsets ph16= const EdgeInsets.only(right: 16.0 , left: 16.0);

EdgeInsets pv8= const EdgeInsets.only(top: 8.0 , bottom: 8);
EdgeInsets pv16= const EdgeInsets.only(top: 16.0 , bottom: 16);

TextStyle titleSm =  const TextStyle(fontSize: 24, fontWeight: FontWeight.w500);
TextStyle titleMe =  const TextStyle(fontSize: 28, fontWeight: FontWeight.w500);
TextStyle titleLa =  const TextStyle(fontSize: 32, fontWeight: FontWeight.w500);

TextStyle bodySm =  const TextStyle(fontSize: 18, fontWeight: FontWeight.w200);
TextStyle bodyMe =  const TextStyle(fontSize: 22, fontWeight: FontWeight.w200);
TextStyle bodyLa =  const TextStyle(fontSize: 26, fontWeight: FontWeight.w200);



int maxHistory = 10;

BaseOptions get getOptions {
  Map<String, dynamic> headers = {};
  var _options = BaseOptions(headers: headers);
  return _options;
}

BaseOptions getOption(String path) {
  var options = getOptions;
  options.baseUrl = path;
  return options;
}


const  defaultOutlineBorder =  OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
    borderSide: BorderSide(width: 1, style: BorderStyle.solid),
  );


outlineBorder (double radius) =>OutlineInputBorder(
borderRadius: BorderRadius.all(Radius.circular(radius)),
borderSide: const BorderSide(width: 1, style: BorderStyle.solid),
);


InputDecoration defaultDecoration(String key) {
  return   InputDecoration(
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0x4437474F),
      ),
    ),
    border: InputBorder.none,
    hintText: key,
    contentPadding: const EdgeInsets.only(
      left: 16,
      right: 20,
      top: 14,
      bottom: 14,
    ),
  );
}