// ignore_for_file: unnecessary_import

import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';

part 'list_model.mapper.dart';

@MappableClass()
class ListModel with ListModelMappable {
  @MappableField(key: 'list_id')
  final String listId;
  final String name;
  final int color;
  @MappableField(key: 'created_at')
  final DateTime createdAt;
  // @MappableField(key: 'cohsen_color')
  // final String cohsenColor;

  ListModel({
    required this.listId,
    required this.name,
    required this.color,
    required this.createdAt,
    //required this.cohsenColor,
  });

  Color getColor() {
    switch (color) {
      case 1:
        return StyleColor.green;
      case 2:
        return StyleColor.yallow;
      case 3:
        return StyleColor.red;
      case 4:
        return StyleColor.orange;
      case 5:
        return StyleColor.blue;
      default:
        return Colors.grey;
    }
  }
}
