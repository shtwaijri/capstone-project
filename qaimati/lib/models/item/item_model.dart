import 'package:dart_mappable/dart_mappable.dart';

part 'item_model.mapper.dart';

@MappableClass()
class ItemModel with ItemModelMappable {
  @MappableField(key: 'item_id')
  final String? itemId;
    String title;
    int quantity;
    bool status;
  //is_completed
  @MappableField(key: 'is_completed')
    bool isCompleted;
  @MappableField(key: 'list')
  final String listId;
  @MappableField(key: 'app_user_id')
  final String appUserId;
  @MappableField(key: 'created_at')
  final String? createdAt;
  @MappableField(key: 'closed_at')
    String? closedAt;
  //created_by
  @MappableField(key: 'created_by')
  final String? createdBy;

    bool important;
  ItemModel({
    this.createdBy,
    required this.important,
    required this.isCompleted,
    this.itemId,
    required this.title,
    required this.quantity,
    required this.status,
    required this.listId,
    required this.appUserId,
     this.createdAt,
    this.closedAt,
  });
}
