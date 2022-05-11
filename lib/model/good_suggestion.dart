class GoodSuggestion {
  GoodSuggestion({
    this.id,
    this.name,
    this.from,
    this.cate,
    this.cateStr,
    this.subCate,
    this.subCateStr,
    this.count,
    this.goodId,
  });

  GoodSuggestion.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    from = json['from'];
    cate = json['cate'];
    cateStr = json['cateStr'];
    subCate = json['subCate'];
    subCateStr = json['subCateStr'];
    count = json['count'];
    goodId = json['goodId'];
  }

  String? id;
  String? name;
  String? from;
  int? cate;
  String? cateStr;
  int? subCate;
  String? subCateStr;
  int? count;
  int? goodId;

  GoodSuggestion copyWith({
    String? id,
    String? name,
    String? from,
    int? cate,
    String? cateStr,
    int? subCate,
    String? subCateStr,
    int? count,
    int? goodId,
  }) =>
      GoodSuggestion(
        id: id ?? this.id,
        name: name ?? this.name,
        from: from ?? this.from,
        cate: cate ?? this.cate,
        cateStr: cateStr ?? this.cateStr,
        subCate: subCate ?? this.subCate,
        subCateStr: subCateStr ?? this.subCateStr,
        count: count ?? this.count,
        goodId: goodId ?? this.goodId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['from'] = from;
    map['cate'] = cate;
    map['cateStr'] = cateStr;
    map['subCate'] = subCate;
    map['subCateStr'] = subCateStr;
    map['count'] = count;
    map['goodId'] = goodId;
    return map;
  }
}
