/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'dart:convert';

import 'package:dio/dio.dart';

import '../error_entity.dart';
import '../http_manager.dart';
import 'http_key_config.dart';

typedef ProcessSuccessResponseData<T> = Future<dynamic>
    Function(Response response, dynamic responseExtra, {bool convertToJson});

typedef ProcessErrorStatus<T> = Future<dynamic> Function(
    int errorCode, ErrorCallback? error, Response? response,
    {bool isJsonError});

class HttpConfig {
  static HttpKeyConfig httpKeyConfig = HttpKeyConfig();

  static ProcessSuccessResponseData processSuccessResponseData =
      _processSuccessResponseData;

  static ProcessErrorStatus processErrorStatus = _processErrorStatus;

  static updateHttpKeyConfig(HttpKeyConfig httpKeyConfig) {
    HttpConfig.httpKeyConfig = httpKeyConfig;
  }

  static updateProcessSuccessResponseData(
      ProcessSuccessResponseData processSuccessResponseData) {
    HttpConfig.processSuccessResponseData = processSuccessResponseData;
  }

  static updateProcessErrorStatus(ProcessErrorStatus processErrorStatus) {
    HttpConfig.processErrorStatus = processErrorStatus;
  }

  static Future<dynamic> _processSuccessResponseData(
      Response response, dynamic responseExtra,
      {bool convertToJson = true}) async {
    dynamic data;
    String contentType = response.headers.value("content-type") ?? "text/plain";
    if (convertToJson && response.data != "" && !contentType.contains("json")) {
      data = jsonDecode(response.data.toString());
    } else {
      data = response.data;
    }
    return data;
  }

  static Future<void> _processErrorStatus(
      int errorCode, ErrorCallback? error, Response? response,
      {bool isJsonError = false}) async {
    if (error == null) {
      return;
    }
    if (isJsonError) {
      return;
    }
    switch (errorCode) {
      case 404:
        await error(
            ErrorEntity(code: errorCode, msg: httpKeyConfig.http404Error));
        break;
      case 500:
        await error(
            ErrorEntity(code: errorCode, msg: httpKeyConfig.httpServerError));
        break;
      default:
        await error(
          ErrorEntity(
            code: errorCode,
            msg: response?.data?.toString() ??
                (httpKeyConfig.httpServerError + ":" + errorCode.toString()),
          ),
        );
        break;
    }
  }
}
