// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'invite_model.dart';

class InviteModelMapper extends ClassMapperBase<InviteModel> {
  InviteModelMapper._();

  static InviteModelMapper? _instance;
  static InviteModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = InviteModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'InviteModel';

  static String? _$inviteId(InviteModel v) => v.inviteId;
  static const Field<InviteModel, String> _f$inviteId =
      Field('inviteId', _$inviteId, key: r'invite_id');
  static String? _$appUserId(InviteModel v) => v.appUserId;
  static const Field<InviteModel, String> _f$appUserId =
      Field('appUserId', _$appUserId, key: r'app_user_id');
  static String? _$listiId(InviteModel v) => v.listiId;
  static const Field<InviteModel, String> _f$listiId =
      Field('listiId', _$listiId, key: r'list_id');
  static String? _$inviteStatus(InviteModel v) => v.inviteStatus;
  static const Field<InviteModel, String> _f$inviteStatus =
      Field('inviteStatus', _$inviteStatus, key: r'invite_ststus');
  static DateTime _$createdAt(InviteModel v) => v.createdAt;
  static const Field<InviteModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(InviteModel v) => v.updatedAt;
  static const Field<InviteModel, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static String _$senderEmail(InviteModel v) => v.senderEmail;
  static const Field<InviteModel, String> _f$senderEmail =
      Field('senderEmail', _$senderEmail, key: r'sender_email');
  static String _$receiverEmail(InviteModel v) => v.receiverEmail;
  static const Field<InviteModel, String> _f$receiverEmail =
      Field('receiverEmail', _$receiverEmail, key: r'receiver_email');

  @override
  final MappableFields<InviteModel> fields = const {
    #inviteId: _f$inviteId,
    #appUserId: _f$appUserId,
    #listiId: _f$listiId,
    #inviteStatus: _f$inviteStatus,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #senderEmail: _f$senderEmail,
    #receiverEmail: _f$receiverEmail,
  };

  static InviteModel _instantiate(DecodingData data) {
    return InviteModel(
        inviteId: data.dec(_f$inviteId),
        appUserId: data.dec(_f$appUserId),
        listiId: data.dec(_f$listiId),
        inviteStatus: data.dec(_f$inviteStatus),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        senderEmail: data.dec(_f$senderEmail),
        receiverEmail: data.dec(_f$receiverEmail));
  }

  @override
  final Function instantiate = _instantiate;

  static InviteModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InviteModel>(map);
  }

  static InviteModel fromJson(String json) {
    return ensureInitialized().decodeJson<InviteModel>(json);
  }
}

mixin InviteModelMappable {
  String toJson() {
    return InviteModelMapper.ensureInitialized()
        .encodeJson<InviteModel>(this as InviteModel);
  }

  Map<String, dynamic> toMap() {
    return InviteModelMapper.ensureInitialized()
        .encodeMap<InviteModel>(this as InviteModel);
  }

  InviteModelCopyWith<InviteModel, InviteModel, InviteModel> get copyWith =>
      _InviteModelCopyWithImpl<InviteModel, InviteModel>(
          this as InviteModel, $identity, $identity);
  @override
  String toString() {
    return InviteModelMapper.ensureInitialized()
        .stringifyValue(this as InviteModel);
  }

  @override
  bool operator ==(Object other) {
    return InviteModelMapper.ensureInitialized()
        .equalsValue(this as InviteModel, other);
  }

  @override
  int get hashCode {
    return InviteModelMapper.ensureInitialized().hashValue(this as InviteModel);
  }
}

extension InviteModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InviteModel, $Out> {
  InviteModelCopyWith<$R, InviteModel, $Out> get $asInviteModel =>
      $base.as((v, t, t2) => _InviteModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class InviteModelCopyWith<$R, $In extends InviteModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? inviteId,
      String? appUserId,
      String? listiId,
      String? inviteStatus,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? senderEmail,
      String? receiverEmail});
  InviteModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _InviteModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InviteModel, $Out>
    implements InviteModelCopyWith<$R, InviteModel, $Out> {
  _InviteModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InviteModel> $mapper =
      InviteModelMapper.ensureInitialized();
  @override
  $R call(
          {Object? inviteId = $none,
          Object? appUserId = $none,
          Object? listiId = $none,
          Object? inviteStatus = $none,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? senderEmail,
          String? receiverEmail}) =>
      $apply(FieldCopyWithData({
        if (inviteId != $none) #inviteId: inviteId,
        if (appUserId != $none) #appUserId: appUserId,
        if (listiId != $none) #listiId: listiId,
        if (inviteStatus != $none) #inviteStatus: inviteStatus,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (senderEmail != null) #senderEmail: senderEmail,
        if (receiverEmail != null) #receiverEmail: receiverEmail
      }));
  @override
  InviteModel $make(CopyWithData data) => InviteModel(
      inviteId: data.get(#inviteId, or: $value.inviteId),
      appUserId: data.get(#appUserId, or: $value.appUserId),
      listiId: data.get(#listiId, or: $value.listiId),
      inviteStatus: data.get(#inviteStatus, or: $value.inviteStatus),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      senderEmail: data.get(#senderEmail, or: $value.senderEmail),
      receiverEmail: data.get(#receiverEmail, or: $value.receiverEmail));

  @override
  InviteModelCopyWith<$R2, InviteModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _InviteModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
