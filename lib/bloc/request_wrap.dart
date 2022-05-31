import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:flutter/material.dart';

class RequestWrap {
  final BuildContext context;

  RequestWrap(this.context);
  var dio = Dio(getOptions);

  Future<Response> get(String url,{ Map<String, dynamic>? queryParameters}) async {
    try {
      var start = DateTime.now().millisecondsSinceEpoch;

      Response response = await dio.get(url, queryParameters: queryParameters);
      // dio.close();
      debugPrint("request@$url interval:${DateTime.now().millisecondsSinceEpoch-start} ms");
      return response;
    } on DioError catch (e) {
      debugPrint(e.toString());
      return Response(data: [], requestOptions: getOptions.toRequestOption());
    }
  }

  Future<Response> post(String url, {dynamic data}) async {
    try {
      var start = DateTime.now().millisecondsSinceEpoch;
      Response response = await dio.post(url, data: data);
      // dio.close();
      debugPrint("request@$url interval:${DateTime.now().millisecondsSinceEpoch-start} ms");
      return response;
    } on DioError catch (e) {
      debugPrint(e.toString());
      return Response(data: [], requestOptions: getOptions.toRequestOption());
    }
  }

  Future<Response> put(String url, {dynamic data}) async {
    try {
      var start = DateTime.now().millisecondsSinceEpoch;
      Response response = await dio.put(url, data: data);
      // dio.close();
      debugPrint("request@$url interval:${DateTime.now().millisecondsSinceEpoch-start} ms");
      return response;
    } on DioError catch (e) {
      debugPrint(e.toString());
      return Response(data: [], requestOptions: getOptions.toRequestOption());
    }
  }

}
