import 'dart:convert';

/// Data Model representing an Item for JSON storage
class ItemModel {
  final int id;
  final String title;
  final String category;
  final String description;

  ItemModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
  });

  /// Convert JSON Map into an ItemModel instance
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
    );
  }

  /// Convert ItemModel instance into a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
    };
  }

  /// Helper copyWith method for editing item fields
  ItemModel copyWith({
    int? id,
    String? title,
    String? category,
    String? description,
  }) {
    return ItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }
}
