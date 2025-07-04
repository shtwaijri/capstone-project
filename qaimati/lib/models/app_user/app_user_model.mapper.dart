// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'app_user_model.dart';

class AppUserModelMapper extends ClassMapperBase<AppUserModel> {
  AppUserModelMapper._();

  static AppUserModelMapper? _instance;
  static AppUserModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppUserModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AppUserModel';

  static String _$userId(AppUserModel v) => v.userId;
  static const Field<AppUserModel, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static String _$name(AppUserModel v) => v.name;
  static const Field<AppUserModel, String> _f$name = Field('name', _$name);
  static String _$email(AppUserModel v) => v.email;
  static const Field<AppUserModel, String> _f$email = Field('email', _$email);
  static DateTime _$createdAt(AppUserModel v) => v.createdAt;
  static const Field<AppUserModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static String? _$authUserId(AppUserModel v) => v.authUserId;
  static const Field<AppUserModel, String> _f$authUserId =
      Field('authUserId', _$authUserId, key: r'auth_user_id', opt: true);

  @override
  final MappableFields<AppUserModel> fields = const {
    #userId: _f$userId,
    #name: _f$name,
    #email: _f$email,
    #createdAt: _f$createdAt,
    #authUserId: _f$authUserId,
  };

  static AppUserModel _instantiate(DecodingData data) {
    return AppUserModel(
        userId: data.dec(_f$userId),
        name: data.dec(_f$name),
        email: data.dec(_f$email),
        createdAt: data.dec(_f$createdAt),
        authUserId: data.dec(_f$authUserId));
  }

  @override
  final Function instantiate = _instantiate;

  static AppUserModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppUserModel>(map);
  }

  static AppUserModel fromJson(String json) {
    return ensureInitialized().decodeJson<AppUserModel>(json);
  }
}

mixin AppUserModelMappable {
  String toJson() {
    return AppUserModelMapper.ensureInitialized()
        .encodeJson<AppUserModel>(this as AppUserModel);
  }

  Map<String, dynamic> toMap() {
    return AppUserModelMapper.ensureInitialized()
        .encodeMap<AppUserModel>(this as AppUserModel);
  }

  AppUserModelCopyWith<AppUserModel, AppUserModel, AppUserModel> get copyWith =>
      _AppUserModelCopyWithImpl<AppUserModel, AppUserModel>(
          this as AppUserModel, $identity, $identity);
  @override
  String toString() {
    return AppUserModelMapper.ensureInitialized()
        .stringifyValue(this as AppUserModel);
  }

  @override
  bool operator ==(Object other) {
    return AppUserModelMapper.ensureInitialized()
        .equalsValue(this as AppUserModel, other);
  }

  @override
  int get hashCode {
    return AppUserModelMapper.ensureInitialized()
        .hashValue(this as AppUserModel);
  }
}

extension AppUserModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AppUserModel, $Out> {
  AppUserModelCopyWith<$R, AppUserModel, $Out> get $asAppUserModel =>
      $base.as((v, t, t2) => _AppUserModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AppUserModelCopyWith<$R, $In extends AppUserModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? userId,
      String? name,
      String? email,
      DateTime? createdAt,
      String? authUserId});
  AppUserModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AppUserModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AppUserModel, $Out>
    implements AppUserModelCopyWith<$R, AppUserModel, $Out> {
  _AppUserModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AppUserModel> $mapper =
      AppUserModelMapper.ensureInitialized();
  @override
  $R call(
          {String? userId,
          String? name,
          String? email,
          DateTime? createdAt,
          Object? authUserId = $none}) =>
      $apply(FieldCopyWithData({
        if (userId != null) #userId: userId,
        if (name != null) #name: name,
        if (email != null) #email: email,
        if (createdAt != null) #createdAt: createdAt,
        if (authUserId != $none) #authUserId: authUserId
      }));
  @override
  AppUserModel $make(CopyWithData data) => AppUserModel(
      userId: data.get(#userId, or: $value.userId),
      name: data.get(#name, or: $value.name),
      email: data.get(#email, or: $value.email),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      authUserId: data.get(#authUserId, or: $value.authUserId));

  @override
  AppUserModelCopyWith<$R2, AppUserModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AppUserModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
