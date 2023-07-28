// To parse this JSON data, do
//
//     final info = infoFromJson(jsonString);

// import 'dart:convert';
//
// List<Info> infoFromJson(String str) =>
//     List<Info>.from(json.decode(str).map((x) => Info.fromJson(x)));
//
// String infoToJson(List<Info> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class Info {
//   String tyrenol;
//
//   Info({
//     required this.tyrenol,
//   });
//
//   factory Info.fromJson(Map<String, dynamic> json) => Info(
//         tyrenol: json["tyrenol"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "tyrenol": tyrenol,
//       };
// }

import 'dart:convert';

List<Info> infoFromJson(String str) =>
    List<Info>.from(json.decode(str).map((x) => Info.fromJson(x)));

String infoToJson(List<Info> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Info {
  String title;
  String corp;
  String ingredient;
  String effect;
  String usage;

  Info({
    required this.title,
    required this.corp,
    required this.ingredient,
    required this.effect,
    required this.usage,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    title: json["title"],
    corp: json["corp"],
    ingredient: json["ingredient"],
    effect: json["effect"],
    usage: json["usage"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "corp": corp,
    "ingredient": ingredient,
    "effect": effect,
    "usage": usage,
  };
}