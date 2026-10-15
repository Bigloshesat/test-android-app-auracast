/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'package:dio/dio.dart';

import 'configs/http_config.dart';
import 'configs/http_key_config.dart';
import 'entity_factory.dart';

class BaseListEntity<T> {
  final int code;
  final List<T> data;
  final String? msg;
  final String? next;
  final String? previous;
  HttpKeyConfig? httpKeyConfig;
  Response? response;

  BaseListEntity(
      {required this.code,
      required this.data,
      this.msg,
      this.next,
      this.previous,
      this.httpKeyConfig,
      this.response});

  factory BaseListEntity.fromJson(dynamic json,
      {HttpKeyConfig? httpKeyConfig}) {
    httpKeyConfig = httpKeyConfig ?? HttpConfig.httpKeyConfig;
    List<T> data = [];
    dynamic object = json[httpKeyConfig.listDataKey];
    if (object != null) {
      (object as List).forEach((value) {
        T? result = EntityFactory.generateOBJ<T>(value);
        if (result != null) {
          data.add(result);
        }
      });
    }
    return BaseListEntity(
        code: json[httpKeyConfig.codeKey]??0,
        msg: json[httpKeyConfig.msgKey]?.toString(),
        data: data,
        next: json[httpKeyConfig.nextPageKey],
        previous: json[httpKeyConfig.previousPageKey],
        httpKeyConfig: httpKeyConfig);
  }

  bool get success => httpKeyConfig?.successJsonCodes.contains(code) ?? false;
}
