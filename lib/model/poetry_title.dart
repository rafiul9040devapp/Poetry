// class PoetryTitle {
//   List<String>? titles;
//
//   PoetryTitle({this.titles});
//
//   factory PoetryTitle.fromJson(dynamic json) {
//     return PoetryTitle(
//       titles: json['titles'] != null ? List<String>.from(json['titles']) : [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'titles': titles,
//     };
//   }
// }


class PoetryTitle {
  static List<String>? fromJson(dynamic json) {
    return json['titles'] != null ? List<String>.from(json['titles']) : [];
  }

  static Map<String, dynamic> toJson(List<String>? titles) {
    return {
      'titles': titles,
    };
  }
}
