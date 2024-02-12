class PoetryDetails {
  PoetryDetails({
      this.title, 
      this.author, 
      this.lines, 
      this.lineCount,});

  PoetryDetails.fromJson(dynamic json) {
    title = json['title'];
    author = json['author'];
    lines = json['lines'] != null ? json['lines'].cast<String>() : [];
    lineCount = json['linecount'];
  }
  String? title;
  String? author;
  List<String>? lines;
  String? lineCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['author'] = author;
    map['lines'] = lines;
    map['linecount'] = lineCount;
    return map;
  }

}