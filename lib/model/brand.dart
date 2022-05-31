import 'dart:convert';

Brand brandFromJson(String str) => Brand.fromJson(json.decode(str));
String brandToJson(Brand data) => json.encode(data.toJson());
class Brand {
  Brand({
      this.id, 
      this.name, 
      this.cate, 
      this.itemCount,});

  Brand.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    cate = json['cate'] != null ? json['cate'].cast<int>() : [];
    itemCount = json['itemCount'];
  }
  int? id;
  String? name;
  List<int>? cate;
  int? itemCount;
Brand copyWith({  int? id,
  String? name,
  List<int>? cate,
  int? itemCount,
}) => Brand(  id: id ?? this.id,
  name: name ?? this.name,
  cate: cate ?? this.cate,
  itemCount: itemCount ?? this.itemCount,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['cate'] = cate;
    map['itemCount'] = itemCount;
    return map;
  }

}