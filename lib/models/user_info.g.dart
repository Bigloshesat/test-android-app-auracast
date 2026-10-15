// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo()
  ..token = json['token'] as String?
  ..name = json['name'] as String?
  ..role = json['role'] as int?;

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'token': instance.token,
      'name': instance.name,
      'role': instance.role,
    };
