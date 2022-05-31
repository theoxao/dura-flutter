import 'dart:async';
import 'dart:convert';

import 'package:duraemon_flutter/bloc/base_bloc.dart';
import 'package:duraemon_flutter/bloc/base_repository.dart';
import 'package:duraemon_flutter/bloc/item_detail_bloc.dart';
import 'package:duraemon_flutter/common/constant.dart';
import 'package:duraemon_flutter/common/extensions.dart';
import 'package:duraemon_flutter/model/Item.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:ktx/standard.dart';


class ItemFormBloc extends FormBloc<String, String> {
  int? goodId;
  final name = TextFieldBloc(name:"name", validators:[emptyValidator] );
  final spec = TextFieldBloc(name: "spec");
  final price = TextFieldBloc(name: "price");
  final bestFavor = InputFieldBloc<Period, int>(name:"bestFavor",initialValue: Period());
  final isbn = InputFieldBloc<String, int>(name:"isbn",initialValue: "");
  final brand = SelectFieldBloc<String, Object>(name: "brand");
  final storage = SelectFieldBloc<String, Object>(name: "storage");
  final storageUsed = SelectFieldBloc<String, Object>(name: "storageUsed");
  final remark = TextFieldBloc(name:"remark");
  final images = InputFieldBloc<List<String>, Object>(initialValue: [], name: "images");

  late ItemRepository _repository;

  set(Item? item){
    debugPrint(item?.toString());
    if(item==null) return ;
    name.updateValue(item.name??"");
    spec.updateValue(item.spec??"");
    price.updateValue(item.price?.toString()??"");
    bestFavor.updateValue(Period.parse(item.bestFavor));
    isbn.updateValue(item.isbn??"");
    item.storage?.let((value){
      storage.addItem(value);
      storage.updateValue(value);
    });
    item.usedStorage?.let((value){
      storageUsed.addItem(value);
      storage.updateValue(item.storage);
    });
    storageUsed.updateValue(item.usedStorage);
    remark.updateValue(item.remark??"");
    images.updateValue(item.images??[]);
    brand.updateValue(item.brand??"");
  }

  ItemFormBloc(BuildContext context) {
    _repository = ItemRepository(context);
    addFieldBlocs(fieldBlocs: [
      name,
      spec,
      price,
      isbn,
      storage,
      storageUsed,
      images,
      brand,
    ]);
  }

  @override
  FutureOr<void> onSubmitting() async{
    await name.validate();
    var data = state.toJson();
    data["goodId"] = goodId;
    await _repository.save(data);
  }
}

class ItemListBloc extends BaseBloc<List<Item>>{
  ItemListBloc(){
    sink.add([]);
  }

  load(int gid) async{
    var list = await ItemRepository(context).list(gid);
    sink.add(list);
  }
}


class ItemRepository extends BaseRepository {
  ItemRepository(BuildContext context) : super(context);

  FutureOr<void> save(Map<String, dynamic> data) async {
    String path = host + "item/update";
    var response = await request.post(path, data:json.encode(data, toEncodable: customEncode));
    debugPrint("response: ${response.toString()}");
    if(response.data['status'] == 200){
    }else{
      debugPrint(response.toString());
    }
  }

  Future<List<Item>> list(int gid) async{
    String path = host + "item/list/$gid";
    var response = await request.get(path);
    debugPrint("response: ${response.data.toString()}");
    List<Item> list = [];
    if(response.data['status'] == 200){
      for (var tag in response.data['data']) {
        list.add(Item.fromJson(tag));
      }
    }
    return list;
  }
}