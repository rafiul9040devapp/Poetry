class PoetryTitleAlternative {
  PoetryTitleAlternative({
    this.titles,});

  PoetryTitleAlternative.fromJson(dynamic json) {
    titles = json['titles'] != null ? json['titles'].cast<String>() : [];
  }
  List<String>? titles;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['titles'] = titles;
    return map;
  }

}