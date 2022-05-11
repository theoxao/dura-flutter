
class NewGoodRequest{
  int? id;
  String? name;
  int? cate;
  String? desc;
  List<String> images = [];

  NewGoodRequest from(NewGoodRequest it){
    name = it.name;
    cate =it.cate;
    images = it.images;
    desc = it.desc;
    id = it.id;
    return this;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['cate'] = cate;
    map['desc'] = desc;
    map['images'] = images;
    return map;
  }
}

class NewDetailRequest{

}