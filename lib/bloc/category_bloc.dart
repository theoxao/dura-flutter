import 'dart:developer';

import 'package:duraemon_flutter/bloc/base_bloc.dart';
import 'package:duraemon_flutter/bloc/base_repository.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/model/category.dart';
import 'package:flutter/material.dart';


class CategoryListBloc extends BaseBloc<List<Category>>{
  List<Category> list = [];

  void categories() async{
    var result = await CategoryRepository(context).categories();
    sink.add(result);
  }
}

class CategoryRepository extends BaseRepository {
  CategoryRepository(BuildContext context) : super(context);

  Future<List<Category>> categories() async{
    String path = host + "/category";
    var option = getOption(path);
    var response = await request.get(option);
    log("request:${response.requestOptions.path}");
    log("response: ${response.data.toString()}");
    List<Category> list = [];
    if(response.data['status'] == 200){
      for (var tag in response.data['data']) {
        list.add(Category.fromJson(tag));
      }
    }
    return list;
  }
}