// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'member_model.dart';

class MemberModelMapper extends ClassMapperBase<MemberModel> {
  MemberModelMapper._();

  static MemberModelMapper? _instance;
  static MemberModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MemberModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MemberModel';

  static String _$memberId(MemberModel v) => v.memberId;
  static const Field<MemberModel, String> _f$memberId =
      Field('memberId', _$memberId, key: r'member_id');
  static String _$email(MemberModel v) => v.email;
  static const Field<MemberModel, String> _f$email = Field('email', _$email);
  static String _$password(MemberModel v) => v.password;
  static const Field<MemberModel, String> _f$password =
      Field('password', _$password);
  static String _$subListId(MemberModel v) => v.subListId;
  static const Field<MemberModel, String> _f$subListId =
      Field('subListId', _$subListId, key: r'sub_list_id');
  static DateTime _$createdAt(MemberModel v) => v.createdAt;
  static const Field<MemberModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');

  @override
  final MappableFields<MemberModel> fields = const {
    #memberId: _f$memberId,
    #email: _f$email,
    #password: _f$password,
    #subListId: _f$subListId,
    #createdAt: _f$createdAt,
  };

  static MemberModel _instantiate(DecodingData data) {
    return MemberModel(
        memberId: data.dec(_f$memberId),
        email: data.dec(_f$email),
        password: data.dec(_f$password),
        subListId: data.dec(_f$subListId),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static MemberModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MemberModel>(map);
  }

  static MemberModel fromJson(String json) {
    return ensureInitialized().decodeJson<MemberModel>(json);
  }
}

mixin MemberModelMappable {
  String toJson() {
    return MemberModelMapper.ensureInitialized()
        .encodeJson<MemberModel>(this as MemberModel);
  }

  Map<String, dynamic> toMap() {
    return MemberModelMapper.ensureInitialized()
        .encodeMap<MemberModel>(this as MemberModel);
  }

  MemberModelCopyWith<MemberModel, MemberModel, MemberModel> get copyWith =>
      _MemberModelCopyWithImpl<MemberModel, MemberModel>(
          this as MemberModel, $identity, $identity);
  @override
  String toString() {
    return MemberModelMapper.ensureInitialized()
        .stringifyValue(this as MemberModel);
  }

  @override
  bool operator ==(Object other) {
    return MemberModelMapper.ensureInitialized()
        .equalsValue(this as MemberModel, other);
  }

  @override
  int get hashCode {
    return MemberModelMapper.ensureInitialized().hashValue(this as MemberModel);
  }
}

extension MemberModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MemberModel, $Out> {
  MemberModelCopyWith<$R, MemberModel, $Out> get $asMemberModel =>
      $base.as((v, t, t2) => _MemberModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MemberModelCopyWith<$R, $In extends MemberModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? memberId,
      String? email,
      String? password,
      String? subListId,
      DateTime? createdAt});
  MemberModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MemberModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MemberModel, $Out>
    implements MemberModelCopyWith<$R, MemberModel, $Out> {
  _MemberModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MemberModel> $mapper =
      MemberModelMapper.ensureInitialized();
  @override
  $R call(
          {String? memberId,
          String? email,
          String? password,
          String? subListId,
          DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (memberId != null) #memberId: memberId,
        if (email != null) #email: email,
        if (password != null) #password: password,
        if (subListId != null) #subListId: subListId,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  MemberModel $make(CopyWithData data) => MemberModel(
      memberId: data.get(#memberId, or: $value.memberId),
      email: data.get(#email, or: $value.email),
      password: data.get(#password, or: $value.password),
      subListId: data.get(#subListId, or: $value.subListId),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  MemberModelCopyWith<$R2, MemberModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MemberModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
