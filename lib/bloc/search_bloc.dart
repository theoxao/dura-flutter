

import 'dart:developer';

import 'package:duraemon_flutter/bloc/base_repository.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/model/search_result.dart';
import 'package:flutter/cupertino.dart';

import 'base_bloc.dart';

class SearchBloc extends BaseBloc<List<SearchResult>>{
  SearchBloc();
  List<SearchResult> list = [];

  void initData(keyword) async{
    var result = await SearchRepository(context).search(keyword, 1, 0);
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

  Future<int> loadMore(keyword) async{
      var offset = list.length;
      var result =  await SearchRepository(context).search(keyword, 1, offset);
      if(result.isNotEmpty){
          list.addAll(result);
          sink.add(list);
      }
      return result.length;
  }
}

class SelectedBookBLoc extends BaseBloc<SearchResult>{
  SearchResult book =SearchResult();

  SelectedBookBLoc(){
    sink.add(book);
  }
}

class SearchRepository extends BaseRepository {
  SearchRepository(BuildContext context): super(context);

  Future<List<SearchResult>> search(String keyword, int type, int offset) async {
    String path = host + "search";
    var option = getOption(path);
    option.queryParameters={
      "keyword": keyword,
      "type": type,
      "offset":offset,
    };
    var response = await request.get(option);
    log("request:${response.requestOptions.path}");
    log("param:  ${option.queryParameters.toString()}");
    log("response: ${response.data.toString()}");
    List<SearchResult> list = [];
    if(response.data['status'] == 200){
      for (var tag in response.data['data']) {
        list.add(SearchResult.fromJson(tag));
      }
      return list;
    }
    log("request@${response.requestOptions.path} error");
    return [];
  }
}