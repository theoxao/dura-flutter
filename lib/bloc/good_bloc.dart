


import 'dart:convert';
import 'dart:developer';

import 'package:duraemon_flutter/bloc/base_bloc.dart';
import 'package:duraemon_flutter/bloc/base_repository.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/model/good_suggestion.dart';
import 'package:duraemon_flutter/model/request_model.dart';
import 'package:flutter/material.dart';

import '../model/good_base_info.dart';

class GoodInfoBloc extends BaseBloc<GoodBaseInfo>{
  GoodBaseInfo info = GoodBaseInfo();

  void goodInfo(id) async{
    var result = await GoodRepository(context).info(id);
    sink.add(result);
  }
}

class GoodSuggestionBloc extends BaseBloc<List<GoodSuggestion>>{
  GoodSuggestionBloc(){
    sink.add([]);
  }

  List<GoodSuggestion> list = [];

  void load(keyword) async{
    var result = await GoodRepository(context).suggestion(keyword);
    if(result.isNotEmpty){
      list = result;
    }else{
      list = [];
    }
    sink.add(list);
  }

  void empty(){
    list= [];
    sink.add(list);
  }

}

class GoodRepository extends BaseRepository {
  GoodRepository(BuildContext context): super(context);

  Future<GoodBaseInfo> info(id) async{
    String path = host + "good/$id";
    var option = getOption(path);
    var response = await request.get(option);
    log("request:${response.requestOptions.path}");
    log("param:  ${option.queryParameters.toString()}");
    log("response: ${response.data.toString()}");
    if(response.data['status'] == 200){
      return GoodBaseInfo.fromJson(response.data['data']);
    }
    return GoodBaseInfo();
  }

  Future<List<GoodSuggestion>> suggestion(name) async {
    String path = host + "/good/suggestion";
    var option = getOption(path);
    option.queryParameters={
      "name": name,
    };
    var response = await request.get(option);
    log("request:${response.requestOptions.path}");
    log("param:  ${option.queryParameters.toString()}");
    log("response: ${response.data.toString()}");
    List<GoodSuggestion> list = [];
    if(response.data['status'] == 200){
      for (var tag in response.data['data']) {
        list.add(GoodSuggestion.fromJson(tag));
      }
    }
    return list;
  }

  Future<GoodBaseInfo> addGood(NewGoodRequest data) async{
    String path = host + "good/update";
    var option = getOption(path);
    var response = await request.post(option, data:json.encode(data.toJson()));
    log("response: ${response.toString()}");
    if(response.data['status'] == 200){
      return GoodBaseInfo.fromJson(response.data['data']);
    }
    return GoodBaseInfo();

  }



}