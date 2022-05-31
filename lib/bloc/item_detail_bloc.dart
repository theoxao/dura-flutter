import 'dart:async';
import 'dart:convert';

import 'package:duraemon_flutter/bloc/base_repository.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class Period {
  int unit = 1;
  String duration = "";


  Period();

  Period.from(this.unit, this.duration):super();

  static Period parse(int? days){
    if(days==null) return Period();
    if(days>1 && days<7){
      return Period.from(1, days.toString());
    }
    if(days>=7 && days<30){
      return Period.from(2, (days~/7).toString());
    }
    if(days>=30 && days<365){
      return Period.from(3, (days~/30).toString());
    }
    return Period.from(4, (days~/365).toString());
  }

  int days() {
    var days = 1;
    switch (unit) {
      case 1:
        break;
      case 2:
        days = 7;
        break;
      case 3:
        days = 30;
        break;
      case 4:
        days = 365;
        break;
    }
    var parsed = int.tryParse(duration);
    if(parsed!=null){
      return parsed * days;
    }else {
      return -1;
    }
  }
}

Object? emptyValidator(Object? value){
  if((value is String)  &&  value.toString().isEmpty) {
    return "不能为空";
  }
  if(value is List && value.isEmpty) {
    return "不能为空";
  }
  return null;
}

class ItemDetailFormBloc extends FormBloc<String, String> {
  int? goodId;
  int? itemId;
  // "name" , "desc" , "pd" , "qty", "best_favor", "storage" , "storage_used", "cost"
  final name = TextFieldBloc(name:"name", validators:[emptyValidator] );
  final desc = TextFieldBloc(name: "desc");
  final pd = InputFieldBloc<DateTime, Object>(name:"pd",initialValue: DateTime.now());
  final qty = TextFieldBloc(name: "qty",validators:[emptyValidator], initialValue: "1");
  final bestFavor = InputFieldBloc<Period, int>(name:"bestFavor",initialValue: Period());
  final storage = SelectFieldBloc<String, Object>(name: "storage");
  final storageUsed = SelectFieldBloc<String, Object>(name: "storageUsed");
  final cost = TextFieldBloc(name:"cost");
  final images = InputFieldBloc<List<String>, Object>(initialValue: [], name: "images");

  late ItemDetailRepository _repository;

  ItemDetailFormBloc(BuildContext context) {
    _repository = ItemDetailRepository(context);
    addFieldBlocs(fieldBlocs: [
      name,
      desc,
      pd,
      qty,
      bestFavor,
      storage,
      storageUsed,
      cost,
      images
    ]);
  }

  @override
  Future<void> onSubmitting() async{
    await name.validate();
    var data = state.toJson();
    data["goodId"] = goodId;
    data["itemId"] = itemId;
    return await _repository.save(data);
  }
}


class ItemDetailRepository extends BaseRepository {
  ItemDetailRepository(BuildContext context) : super(context);

  Future<void> save(Map<String, dynamic> data) async {
    String path = host + "item/detail/update";
    debugPrint("request body:${json.encode(data, toEncodable: customEncode)}");
    var response = await request.post(path, data:json.encode(data, toEncodable: customEncode));
    debugPrint("response: ${response.toString()}");
    if(response.data['status'] == 200){
    }else{
      debugPrint(response.toString());
    }
  }

}