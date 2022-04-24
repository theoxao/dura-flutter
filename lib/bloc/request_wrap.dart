import 'package:dio/dio.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:flutter/material.dart';

class RequestWrap {
  final BuildContext context;

  RequestWrap(this.context);

  Future<Response> get(BaseOptions options) async {
    try {
      Response response = await Dio(options).get(options.baseUrl);
      return response;
    } on DioError catch (e) {
      return Response(data: [], requestOptions: options.toRequestOption());;
    }
  }

  Future<Response> post(BaseOptions options, {dynamic data}) async {
    try {
      Response response = await Dio(options).post(options.baseUrl, data: data);
      return response;
    } on DioError catch (e) {
      return Response(data: [], requestOptions: options.toRequestOption());
    }
  }
}
