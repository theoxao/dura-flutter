class GoodBaseInfo {
  GoodBaseInfo({
      this.id, 
      this.name, 
      this.desc, 
      this.cate, 
      this.cateStr, 
      this.subCate, 
      this.subCateStr, 
      this.remainBatch, 
      this.recentPrice, 
      this.images, 
      this.needBuy, 
      this.createTime, 
      this.updateTime,});

  GoodBaseInfo.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    cate = json['cate'];
    cateStr = json['cateStr'];
    subCate = json['subCate'];
    subCateStr = json['subCateStr'];
    remainBatch = json['remainBatch'];
    recentPrice = json['recentPrice'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    needBuy = json['needBuy'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }
  int? id;
  String? name;
  String? desc;
  int? cate;
  String? cateStr;
  int? subCate;
  String? subCateStr;
  int? remainBatch;
  int? recentPrice;
  List<String>? images;
  int? needBuy;
  String? createTime;
  String? updateTime;
GoodBaseInfo copyWith({  int? id,
  String? name,
  String? desc,
  int? cate,
  String? cateStr,
  int? subCate,
  String? subCateStr,
  int? remainBatch,
  int? recentPrice,
  List<String>? images,
  int? needBuy,
  String? createTime,
  String? updateTime,
}) => GoodBaseInfo(  id: id ?? this.id,
  name: name ?? this.name,
  desc: desc ?? this.desc,
  cate: cate ?? this.cate,
  cateStr: cateStr ?? this.cateStr,
  subCate: subCate ?? this.subCate,
  subCateStr: subCateStr ?? this.subCateStr,
  remainBatch: remainBatch ?? this.remainBatch,
  recentPrice: recentPrice ?? this.recentPrice,
  images: images ?? this.images,
  needBuy: needBuy ?? this.needBuy,
  createTime: createTime ?? this.createTime,
  updateTime: updateTime ?? this.updateTime,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['desc'] = desc;
    map['cate'] = cate;
    map['cateStr'] = cateStr;
    map['subCate'] = subCate;
    map['subCateStr'] = subCateStr;
    map['remainBatch'] = remainBatch;
    map['recentPrice'] = recentPrice;
    map['images'] = images;
    map['needBuy'] = needBuy;
    map['createTime'] = createTime;
    map['updateTime'] = updateTime;
    return map;
  }

}