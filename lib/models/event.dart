import 'package:flutter/material.dart';
import 'package:the_eventors_app/models/category.dart';
import 'package:the_eventors_app/models/Event.dart';
import 'package:the_eventors_app/models/user.dart';

final String tableEvent = 'events';

class EventFields {
  static final List<String> values = [
    id,
    title,
    startTime,
    duration,
    location,
    description,
    images,
    categoryId,
    createdTime,
    createdBy,
    guest,
    going,
    interesed,
  ];

  static final String id = "_id";
  static final String title = "title";
  static final String startTime = "startTime";
  static final String duration = "duration";
  static final String location = "location";
  static final String description = "description";
  static final String images = "images";
  static final String guest = "guest";
  static final String categoryId = "categoryId";
  static final String going = "going";
  static final String interesed = "interesed";
  static final String createdTime = "createdTime";
  static final String createdBy = "createdBy";
}

class Event {
  final int? id;
  final String title;
  final DateTime startTime;
  final String duration;
  final String location;
  final String description;
  final String images;
  final String? guest;
  final int categoryId;
  final String? going;
  final String? interesed;
  final DateTime createdTime;
  final String createdBy;

  const Event({
    this.id,
    required this.title,
    required this.startTime,
    required this.duration,
    required this.location,
    required this.description,
    required this.images,
    required this.categoryId,
    required this.createdTime,
    required this.createdBy,
    this.guest,
    this.going,
    this.interesed,
  });

  Event copy({
    int? id,
    String? title,
    DateTime? startTime,
    String? duration,
    String? location,
    String? description,
    String? images,
    String? guest,
    int? categoryId,
    String? going,
    String? interesed,
    DateTime? createdTime,
    String? createdBy,
  }) =>
      Event(
        id: id ?? this.id,
        title: title ?? this.title,
        startTime: startTime ?? this.startTime,
        duration: duration ?? this.duration,
        location: location ?? this.location,
        description: description ?? this.description,
        images: images ?? this.images,
        categoryId: categoryId ?? this.categoryId,
        createdTime: createdTime ?? this.createdTime,
        createdBy: createdBy ?? this.createdBy,
        guest: guest ?? this.guest,
        going: going ?? this.going,
        interesed: interesed ?? this.interesed,
      );

  Map<String, Object?> toJson() => {
        EventFields.id: id,
        EventFields.title: title,
        EventFields.startTime: startTime.toIso8601String(),
        EventFields.duration: duration,
        EventFields.location: location,
        EventFields.description: description,
        EventFields.images: images,
        EventFields.categoryId: categoryId,
        EventFields.createdTime: createdTime.toIso8601String(),
        EventFields.createdBy: createdBy,
        EventFields.guest: guest,
        EventFields.going: going,
        EventFields.interesed: interesed
      };

  static Event fromJson(Map<String, Object?> json) => Event(
        id: json[EventFields.id] as int?,
        title: json[EventFields.title] as String,
        startTime: DateTime.parse(json[EventFields.startTime] as String),
        duration: json[EventFields.duration] as String,
        location: json[EventFields.location] as String,
        description: json[EventFields.description] as String,
        images: json[EventFields.images] as String,
        categoryId: json[EventFields.categoryId] as int,
        createdTime: DateTime.parse(json[EventFields.createdTime] as String),
        createdBy: json[EventFields.createdBy] as String,
        guest: json[EventFields.guest] as String,
      );
}
