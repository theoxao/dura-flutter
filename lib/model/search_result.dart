class SearchResult {
  SearchResult({
    this.id,
    this.name,
    this.desc,
    this.images,
    this.type,
  });

  SearchResult.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    type = json['type'];
  }

  int? id;
  String? name;
  String? desc;
  List<String>? images;
  int? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['desc'] = desc;
    map['images'] = images;
    map['type'] = type;
    return map;
  }
}
