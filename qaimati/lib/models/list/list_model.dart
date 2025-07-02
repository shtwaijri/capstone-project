import 'package:dart_mappable/dart_mappable.dart';

part 'list_model.mapper.dart';

@MappableClass()
class ListModel with ListModelMappable {
  @MappableField(key: 'list_id')
  final String listId;
  final String name;
  @MappableField(key: 'created_at')
  final DateTime createdAt;
  // @MappableField(key: 'cohsen_color')
  // final String cohsenColor;

  ListModel({
    required this.listId,
    required this.name,
    required this.createdAt,
    //required this.cohsenColor,
  });
}
