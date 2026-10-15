import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:framework/utils/network/configs/http_config.dart';
import 'package:framework/utils/network/configs/http_key_config.dart';
import 'package:framework/utils/network/error_entity.dart';
import 'package:framework/utils/network/http_manager.dart';

class NetworkUtil {
  static const String http_404_error = "404 not found";
  static const String http_server_error = "Service error";

  static const String code_key_default = "code";
  static const String data_key_default = "data";
  static const String msg_key_default = "message";

  static HttpKeyConfig httpKeyConfig = HttpKeyConfig(
      successJsonCodes: [0],
      codeKey: code_key_default,
      dataKey: data_key_default,
      msgKey: msg_key_default);

  static Future<dynamic> request<T>(String method, String url,
      {Map<String, dynamic>? query,
      Map<String, dynamic>? data,
      FormData? formData,
      String? requestKey,
      bool isFormRequest = false,
      bool isCancelable = true,
      bool appendBase = true,
      bool isList = false,
      bool showLog = true,
      bool processResponse = true,
      bool convertDataToJson = true,
      bool cacheResult = true,
      bool useCache = true,
      Map<String, dynamic>? headers,
      SuccessCallback<T>? successCallback,
      SuccessListCallback<T>? successListCallback,
      ErrorCallback? errorCallback,
      ProcessSuccessResponseData processSuccessResponseData =
          processSuccessResponseData,
      ProcessErrorStatus processErrorStatus = processErrorStatus,
      HttpKeyConfig? httpKeyConfig,
      dynamic responseExtra}) async {
    Map<String, dynamic>? theHeaders = headers;
    if (theHeaders == null && convertDataToJson) {
      theHeaders = Map<String, dynamic>();
      theHeaders["content-type"] = "application/json";
    }
    HttpKeyConfig theHttpKeyConfig = httpKeyConfig ?? NetworkUtil.httpKeyConfig;
    return await HttpManager().request(method, url,
        query: query,
        data: data,
        formData: formData,
        requestKey: requestKey,
        isFormRequest: isFormRequest,
        isCancelable: isCancelable,
        appendBase: appendBase,
        isList: isList,
        showLog: showLog,
        processResponse: processResponse,
        convertDataToJson: convertDataToJson,
        cacheResult: cacheResult,
        useCache: useCache,
        headers: theHeaders,
        successCallback: successCallback,
        successListCallback: successListCallback,
        errorCallback: errorCallback,
        processSuccessResponseData: processSuccessResponseData,
        processErrorStatus: processErrorStatus,
        httpKeyConfig: theHttpKeyConfig,
        responseExtra: responseExtra);
  }

  static Future<dynamic> processSuccessResponseData(
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

  static Future<void> processErrorStatus(
      int errorCode, ErrorCallback? error, Response? response,
      {bool isJsonError = false}) async {
    if (isJsonError) {
      switch (errorCode) {
        default:
          break;
      }
      return;
    }
    if (error == null) {
      return;
    }
    switch (errorCode) {
      case 404:
        await error(ErrorEntity(code: errorCode, msg: http_404_error));
        break;
      case 500:
        await error(ErrorEntity(code: errorCode, msg: http_server_error));
        break;
      default:
        await error(
          ErrorEntity(
            code: errorCode,
            msg: response?.data?.toString() ??
                (http_server_error + ":" + errorCode.toString()),
          ),
        );
        break;
    }
  }
}
