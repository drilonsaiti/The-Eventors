import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final String tableCategory = 'category';

class CateogryFields {
  static final List<String> values = [
    id,
    name,
  ];

  static final String id = "_id";
  static final String name = "name";
}

class Category {
  final int? id;
  final String name;

  const Category({
    this.id,
    required this.name,
  });
  Category copy({
    int? id,
    String? name,
  }) =>
      Category(id: id ?? this.id, name: name ?? this.name);

  Map<String, Object?> toJson() => {
        CateogryFields.id: id,
        CateogryFields.name: name,
      };

  static Category fromJson(Map<String, Object?> json) => Category(
        id: json[CateogryFields.id] as int?,
        name: json[CateogryFields.name] as String,
      );

  IconData? getIcon(String name) {
    switch (name) {
      case "Sports":
        return Icons.sports;
      case "Music":
        return Icons.music_note;
      case "All":
        return Icons.search;
      default:
        return null;
    }
  }

  IconData getIcon2(String name) {
    switch (name) {
      case "Speech":
        return FontAwesomeIcons.microphone;
      case "Conference":
        return FontAwesomeIcons.users;
      default:
        return FontAwesomeIcons.chalkboard;
    }
  }
}
