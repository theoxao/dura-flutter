


import 'dart:developer';

import 'package:duraemon_flutter/bloc/base_bloc.dart';
import 'package:duraemon_flutter/bloc/base_repository.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:flutter/material.dart';

import '../model/good_base_info.dart';

class GoodInfoBloc extends BaseBloc<GoodBaseInfo>{
  GoodBaseInfo info = GoodBaseInfo();

  void goodInfo(id) async{
    var result = await GoodRepository(context).info(id);
    sink.add(result);
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
    GoodBaseInfo info;
    if(response.data['status'] == 200){
      return GoodBaseInfo.fromJson(response.data['data']);
    }
    return GoodBaseInfo();
  }



}