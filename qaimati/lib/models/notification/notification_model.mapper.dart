// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'notification_model.dart';

class NotificationModelMapper extends ClassMapperBase<NotificationModel> {
  NotificationModelMapper._();

  static NotificationModelMapper? _instance;
  static NotificationModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'NotificationModel';

  static String _$notiId(NotificationModel v) => v.notiId;
  static const Field<NotificationModel, String> _f$notiId =
      Field('notiId', _$notiId, key: r'noti_id');
  static String _$memberId(NotificationModel v) => v.memberId;
  static const Field<NotificationModel, String> _f$memberId =
      Field('memberId', _$memberId, key: r'member_id');
  static String _$title(NotificationModel v) => v.title;
  static const Field<NotificationModel, String> _f$title =
      Field('title', _$title);
  static String _$body(NotificationModel v) => v.body;
  static const Field<NotificationModel, String> _f$body = Field('body', _$body);
  static bool _$isRead(NotificationModel v) => v.isRead;
  static const Field<NotificationModel, bool> _f$isRead =
      Field('isRead', _$isRead, key: r'is_read');
  static DateTime _$createdAt(NotificationModel v) => v.createdAt;
  static const Field<NotificationModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');

  @override
  final MappableFields<NotificationModel> fields = const {
    #notiId: _f$notiId,
    #memberId: _f$memberId,
    #title: _f$title,
    #body: _f$body,
    #isRead: _f$isRead,
    #createdAt: _f$createdAt,
  };

  static NotificationModel _instantiate(DecodingData data) {
    return NotificationModel(
        notiId: data.dec(_f$notiId),
        memberId: data.dec(_f$memberId),
        title: data.dec(_f$title),
        body: data.dec(_f$body),
        isRead: data.dec(_f$isRead),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static NotificationModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotificationModel>(map);
  }

  static NotificationModel fromJson(String json) {
    return ensureInitialized().decodeJson<NotificationModel>(json);
  }
}

mixin NotificationModelMappable {
  String toJson() {
    return NotificationModelMapper.ensureInitialized()
        .encodeJson<NotificationModel>(this as NotificationModel);
  }

  Map<String, dynamic> toMap() {
    return NotificationModelMapper.ensureInitialized()
        .encodeMap<NotificationModel>(this as NotificationModel);
  }

  NotificationModelCopyWith<NotificationModel, NotificationModel,
          NotificationModel>
      get copyWith =>
          _NotificationModelCopyWithImpl<NotificationModel, NotificationModel>(
              this as NotificationModel, $identity, $identity);
  @override
  String toString() {
    return NotificationModelMapper.ensureInitialized()
        .stringifyValue(this as NotificationModel);
  }

  @override
  bool operator ==(Object other) {
    return NotificationModelMapper.ensureInitialized()
        .equalsValue(this as NotificationModel, other);
  }

  @override
  int get hashCode {
    return NotificationModelMapper.ensureInitialized()
        .hashValue(this as NotificationModel);
  }
}

extension NotificationModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotificationModel, $Out> {
  NotificationModelCopyWith<$R, NotificationModel, $Out>
      get $asNotificationModel => $base
          .as((v, t, t2) => _NotificationModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NotificationModelCopyWith<$R, $In extends NotificationModel,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? notiId,
      String? memberId,
      String? title,
      String? body,
      bool? isRead,
      DateTime? createdAt});
  NotificationModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _NotificationModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotificationModel, $Out>
    implements NotificationModelCopyWith<$R, NotificationModel, $Out> {
  _NotificationModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotificationModel> $mapper =
      NotificationModelMapper.ensureInitialized();
  @override
  $R call(
          {String? notiId,
          String? memberId,
          String? title,
          String? body,
          bool? isRead,
          DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (notiId != null) #notiId: notiId,
        if (memberId != null) #memberId: memberId,
        if (title != null) #title: title,
        if (body != null) #body: body,
        if (isRead != null) #isRead: isRead,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  NotificationModel $make(CopyWithData data) => NotificationModel(
      notiId: data.get(#notiId, or: $value.notiId),
      memberId: data.get(#memberId, or: $value.memberId),
      title: data.get(#title, or: $value.title),
      body: data.get(#body, or: $value.body),
      isRead: data.get(#isRead, or: $value.isRead),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  NotificationModelCopyWith<$R2, NotificationModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _NotificationModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
