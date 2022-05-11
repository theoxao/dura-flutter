class Category {
  Category({
    required this.id,
    required this.name,
    this.level,
    this.pid,
    this.children,
  });

  Category.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    level = json['level'];
    pid = json['pid'];
    if (json['children'] != null) {
      children = [];
      json['children'].forEach((v) {
        children?.add(Category.fromJson(v));
      });
    }
  }

  late int id;
  late String name;
  int? level;
  dynamic pid;
  List<Category>? children;

  Category copyWith({
    int? id,
    String? name,
    int? level,
    dynamic pid,
    List<Category>? children,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        level: level ?? this.level,
        pid: pid ?? this.pid,
        children: children ?? this.children,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['level'] = level;
    map['pid'] = pid;
    if (children != null) {
      map['children'] = children?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
