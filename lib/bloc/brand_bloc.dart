

import 'dart:convert';

import 'package:duraemon_flutter/bloc/base_bloc.dart';
import 'package:duraemon_flutter/bloc/base_repository.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/model/Brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache/flutter_cache.dart' as cache;

const key = "cache:brand_list";

class BrandListBloc extends BaseBloc<List<Brand>>{
  List<Brand> list = [];

}

class BrandRepository extends BaseRepository {

  BrandRepository(BuildContext context) : super(context);

  Future<List<Brand>> brands() async{
    String path = host + "/brand";
    var response = await request.get(path);
    debugPrint("response: ${response.data.toString()}");
    List<Brand> list = [];
    if(response.data['status'] == 200){
      for (var tag in response.data['data']) {
        list.add(Brand.fromJson(tag));
      }
    }
    return list;
  }

  Future<void> addBrand(String name, List<int>? cats) async {
    String path = host + "brand";
    var response = await request.put(path, data:{
      "name": name,
      "cats": cats??[]
    });
    debugPrint("response: ${response.toString()}");
    if (response.data['status'] == 200) {
      cache.destroy(key);
      return ;
    }
  }

  Future<List<String>> brandCandidate(int? cid) async {
    return await cache.remember(key, () async {
      String path = host + "/brand";
      var queryParameters = {
        "cid": cid,
      };
      var response = await request.get(path, queryParameters: queryParameters);
      debugPrint("response: ${response.data.toString()}");
      List<String> list = [];
      if (response.data['status'] == 200) {
        for (var tag in response.data['data']) {
          list.add(tag["name"]);
        }
      }
      return list;
    }, 120);
  }

}