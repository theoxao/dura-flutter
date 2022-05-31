import 'dart:convert';
import 'dart:developer';

import 'package:duraemon_flutter/bloc/base_bloc.dart';
import 'package:duraemon_flutter/bloc/base_repository.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/model/good_suggestion.dart';
import 'package:duraemon_flutter/model/request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache/flutter_cache.dart' as cache;

import '../model/good_base_info.dart';

class GoodInfoBloc extends BaseBloc<GoodBaseInfo> {
  GoodBaseInfo info = GoodBaseInfo();

  void goodInfo(id) async {
    var result = await GoodRepository(context).info(id);
    sink.add(result);
  }
}

class GoodSuggestionBloc extends BaseBloc<List<GoodSuggestion>> {
  GoodSuggestionBloc() {
    sink.add([]);
  }

  List<GoodSuggestion> list = [];

  void load(keyword) async {
    var result = await GoodRepository(context).suggestion(keyword);
    if (result.isNotEmpty) {
      list = result;
    } else {
      list = [];
    }
    sink.add(list);
  }

  void empty() {
    list = [];
    sink.add(list);
  }

}

class GoodRepository extends BaseRepository {
  GoodRepository(BuildContext context) : super(context);

  Future<GoodBaseInfo> info(id) async {
    String path = host + "good/$id";
    var response = await request.get(path);
    debugPrint("response: ${response.data.toString()}");
    if (response.data['status'] == 200) {
      return GoodBaseInfo.fromJson(response.data['data']);
    }
    return GoodBaseInfo();
  }

  Future<List<GoodSuggestion>> suggestion(name) async {
    String path = host + "/good/suggestion";
    var queryParameters = {
      "name": name,
    };
    var response = await request.get(path, queryParameters: queryParameters);
    debugPrint("param:  ${queryParameters.toString()}");
    debugPrint("response: ${response.data.toString()}");
    List<GoodSuggestion> list = [];
    if (response.data['status'] == 200) {
      for (var tag in response.data['data']) {
        list.add(GoodSuggestion.fromJson(tag));
      }
    }
    return list;
  }

  Future<GoodBaseInfo> addGood(NewGoodRequest data) async {
    String path = host + "good/update";
    var response = await request.post(path, data: json.encode(data.toJson()));
    debugPrint("response: ${response.toString()}");
    if (response.data['status'] == 200) {
      return GoodBaseInfo.fromJson(response.data['data']);
    }
    return GoodBaseInfo();
  }

  Future<List<String>> storageCandidate(int? cid) async {
    var key = "cache:storage_method";
    return await cache.remember(key, () async {
      String path = host + "/good/storage";
      var queryParameters = {
        "cid": cid,
      };
      var response = await request.get(path, queryParameters: queryParameters);
      debugPrint("param:  ${queryParameters.toString()}");
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