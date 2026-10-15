/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'package:dio/dio.dart';

import 'configs/http_config.dart';
import 'configs/http_key_config.dart';
import 'entity_factory.dart';

class BaseEntity<T> {
  final int code;
  final T? data;
  final String? msg;
  HttpKeyConfig? httpKeyConfig;
  Response? response;

  BaseEntity(
      {required this.code,
      this.data,
      this.msg,
      this.httpKeyConfig,
      this.response});

  factory BaseEntity.fromJson(dynamic json, {HttpKeyConfig? httpKeyConfig}) {
    httpKeyConfig = httpKeyConfig ?? HttpConfig.httpKeyConfig;
    return BaseEntity(
        code: json[httpKeyConfig.codeKey]??0,
        msg: json[httpKeyConfig.msgKey]?.toString(),
        data: EntityFactory.generateOBJ<T>(json[httpKeyConfig.dataKey]),
        httpKeyConfig: httpKeyConfig);
  }

  bool get success => httpKeyConfig?.successJsonCodes.contains(code) ?? false;
}
