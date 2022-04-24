import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  Widget pad(EdgeInsetsGeometry padding) {
    return Padding(
      child: this,
      padding: padding,
    );
  }

  Widget pa(double padding) {
    return Padding(
      child: this,
      padding: EdgeInsets.all(padding),
    );
  }

  Widget scale(double scale) {
    return Transform.scale(scale: scale, child: this);
  }

  Widget onTap(GestureTapCallback? onTap){
    return Material(
      child: InkWell(
        child: this,
        onTap: onTap,
      ),
    );
  }

  Widget gesture({
    GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
  }) {
    return Material(
      child: InkWell(
        child: this,
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
      ),
    );
  }
}


extension RequestOptionExt on BaseOptions {
  RequestOptions toRequestOption(){
    return RequestOptions(path: baseUrl,method: method, queryParameters: queryParameters, headers: headers);
  }
}