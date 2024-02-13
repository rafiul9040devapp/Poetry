// class PoetryDetails {
//   PoetryDetails({
//       this.title,
//       this.author,
//       this.lines,
//       this.lineCount,});
//
//   PoetryDetails.fromJson(dynamic json) {
//     title = json['title'];
//     author = json['author'];
//     lines = json['lines'] != null ? json['lines'].cast<String>() : [];
//     lineCount = json['linecount'];
//   }
//   String? title;
//   String? author;
//   List<String>? lines;
//   String? lineCount;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['title'] = title;
//     map['author'] = author;
//     map['lines'] = lines;
//     map['linecount'] = lineCount;
//     return map;
//   }
// }


class PoetryDetails {
  final String title;
  final String author;
  final List<String> lines;
  late final String lineCount;

  PoetryDetails({
    required this.title,
    required this.author,
    required this.lines,
    required this.lineCount,
  });

  factory PoetryDetails.fromJson(Map<String, dynamic> json) {
    return PoetryDetails(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      lines: List<String>.from(json['lines'] ?? []),
      lineCount: json['linecount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'lines': lines,
      'linecount': lineCount,
    };
  }
}
