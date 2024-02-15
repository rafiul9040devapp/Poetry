class Author {
  Author({
    this.authors,
  });

  Author.fromJson(dynamic json) {
    authors = json['authors'] != null ? json['authors'].cast<String>() : [];
  }

  List<String>? authors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['authors'] = authors;
    return map;
  }
}
