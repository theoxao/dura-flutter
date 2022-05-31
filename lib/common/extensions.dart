import 'package:dio/dio.dart';
import 'package:duraemon_flutter/bloc/item_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

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


extension BuildContextExt on BuildContext{

  InputDecoration defaultDecoration(String key) {
    return   InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0x4437474F),
        ),
      ),
      border:OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(this).primaryColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(this).primaryColor,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      // hintText: key,
      label: Text(key),
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 20,
        top: 14,
        bottom: 14,
      ),
    );
  }
}


dynamic customEncode(dynamic item) {
  if(item is DateTime) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(item);
  }
  if(item is Period){
    return item.days();
  }
  return item;
}