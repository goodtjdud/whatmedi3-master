import 'dart:convert';

List<Data> dataFromJson(String str) =>
    List<Data>.from(json.decode(str).map((x) => Data.fromJson(x)));

String dataToJson(List<Data> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Data {
  String title;
  String corp;
  String ingredient;
  String effect;
  String usage;

  Data({
    required this.title,
    required this.corp,
    required this.ingredient,
    required this.effect,
    required this.usage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
