import 'dart:convert';

import 'package:duraemon_flutter/model/Item_detail.dart';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));
String itemToJson(Item data) => json.encode(data.toJson());
class Item {
  Item({
    this.id,
    this.goodId,
    this.name,
    this.images,
    this.spec,
    this.price,
    this.isbn,
    this.bestFavor,
    this.storage,
    this.usedStorage,
    this.remark,
    this.ingredient,
    this.brand,
    this.createTime,
    this.updateTime,
    this.details,});

  Item.fromJson(dynamic json) {
    id = json['id'];
    goodId = json['goodId'];
    name = json['name'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    spec = json['spec'];
    price = json['price'];
    isbn = json['isbn'];
    bestFavor = json['bestFavor'];
    storage = json['storage'];
    usedStorage = json['usedStorage'];
    remark = json['remark'];
    ingredient = json['ingredient'];
    brand = json['brand'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details?.add(ItemDetail.fromJson(v));
      });
    }
  }
  int? id;
  int? goodId;
  String? name;
  List<String>? images;
  String? spec;
  int? price;
  String? isbn;
  int? bestFavor;
  String? storage;
  String? usedStorage;
  String? remark;
  String? ingredient;
  String? brand;
  String? createTime;
  String? updateTime;
  List<ItemDetail>? details;
  Item copyWith({  int? id,
    int? goodId,
    String? name,
    List<String>? images,
    String? spec,
    int? price,
    String? isbn,
    int? bestFavor,
    String? storage,
    String? usedStorage,
    String? remark,
    String? ingredient,
    String? brand,
    String? createTime,
    String? updateTime,
    List<ItemDetail>? details,
  }) => Item(  id: id ?? this.id,
    goodId: goodId ?? this.goodId,
    name: name ?? this.name,
    images: images ?? this.images,
    spec: spec ?? this.spec,
    price: price ?? this.price,
    isbn: isbn ?? this.isbn,
    bestFavor: bestFavor ?? this.bestFavor,
    storage: storage ?? this.storage,
    usedStorage: usedStorage ?? this.usedStorage,
    remark: remark ?? this.remark,
    brand:brand ?? this.brand,
    ingredient: ingredient ?? this.ingredient,
    createTime: createTime ?? this.createTime,
    updateTime: updateTime ?? this.updateTime,
    details: details ?? this.details,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['goodId'] = goodId;
    map['name'] = name;
    map['images'] = images;
    map['spec'] = spec;
    map['price'] = price;
    map['isbn'] = isbn;
    map['bestFavor'] = bestFavor;
    map['storage'] = storage;
    map['usedStorage'] = usedStorage;
    map['remark'] = remark;
    map['ingredient'] = ingredient;
    map['brand'] = brand;
    map['createTime'] = createTime;
    map['updateTime'] = updateTime;
    if (details != null) {
      map['details'] = details?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}