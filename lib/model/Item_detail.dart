import 'dart:convert';

ItemDetail itemDetailFromJson(String str) =>
    ItemDetail.fromJson(json.decode(str));

String itemDetailToJson(ItemDetail data) => json.encode(data.toJson());

class ItemDetail {
  ItemDetail({
    this.id,
    this.itemId,
    this.goodId,
    this.name,
    this.images,
    this.desc,
    this.pd,
    this.qty,
    this.bestFavor,
    this.shelfLife,
    this.storage,
    this.usedStorage,
    this.batchCode,
    this.cost,
    this.expiry,
    this.createTime,
    this.updateTime,
  });

  ItemDetail.fromJson(dynamic json) {
    id = json['id'];
    itemId = json['itemId'];
    goodId = json['goodId'];
    name = json['name'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    desc = json['desc'];
    pd = json['pd'];
    qty = json['qty'];
    bestFavor = json['bestFavor'];
    shelfLife = json['shelfLife'];
    storage = json['storage'];
    usedStorage = json['usedStorage'];
    batchCode = json['batchCode'];
    cost = json['cost'];
    expiry = json['expiry'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  int? id;
  int? itemId;
  int? goodId;
  String? name;
  List<String>? images;
  String? desc;
  String? pd;
  int? qty;
  int? bestFavor;
  int? shelfLife;
  String? storage;
  String? usedStorage;
  String? batchCode;
  int? cost;
  String? expiry;
  String? createTime;
  String? updateTime;

  ItemDetail copyWith({
    int? id,
    int? itemId,
    int? goodId,
    String? name,
    List<String>? images,
    String? desc,
    String? pd,
    int? qty,
    int? bestFavor,
    int? shelfLife,
    String? storage,
    String? usedStorage,
    String? batchCode,
    int? cost,
    String? expiry,
    String? createTime,
    String? updateTime,
  }) =>
      ItemDetail(
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        goodId: goodId ?? this.goodId,
        name: name ?? this.name,
        images: images ?? this.images,
        desc: desc ?? this.desc,
        pd: pd ?? this.pd,
        qty: qty ?? this.qty,
        bestFavor: bestFavor ?? this.bestFavor,
        shelfLife: shelfLife ?? this.shelfLife,
        storage: storage ?? this.storage,
        usedStorage: usedStorage ?? this.usedStorage,
        batchCode: batchCode ?? this.batchCode,
        cost: cost ?? this.cost,
        expiry: expiry ?? this.expiry,
        createTime: createTime ?? this.createTime,
        updateTime: updateTime ?? this.updateTime,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['itemId'] = itemId;
    map['goodId'] = goodId;
    map['name'] = name;
    map['images'] = images;
    map['desc'] = desc;
    map['pd'] = pd;
    map['qty'] = qty;
    map['bestFavor'] = bestFavor;
    map['shelfLife'] = shelfLife;
    map['storage'] = storage;
    map['usedStorage'] = usedStorage;
    map['batchCode'] = batchCode;
    map['cost'] = cost;
    map['expiry'] = expiry;
    map['createTime'] = createTime;
    map['updateTime'] = updateTime;
    return map;
  }
}
