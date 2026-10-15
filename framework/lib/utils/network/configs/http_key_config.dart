/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */

class HttpKeyConfig {
  static const List<int> success_http_codes_default = [200];
  static const List<int> success_json_codes_default = [0];
  static const String data_key_default = "data";
  static const String list_data_key_default = "data";

  static const String code_key_default = "code";
  static const String msg_key_default = "message";
  static const String next_page_key_default = "next";
  static const String previous_page_key_default = "previous";

  static const String http_unknown_error_default = "Request timeout";
  static const String http_analyze_error_default = "Parsing error";
  static const String http_404_error_default = "Request address error";
  static const String http_server_error_default = "Service error";

  List<int> successHttpCodes;
  List<int> successJsonCodes;

  String dataKey;
  String listDataKey;

  String codeKey;
  String msgKey;
  String nextPageKey;
  String previousPageKey;

  String httpUnknownError;
  String httpAnalyzeError;
  String http404Error;
  String httpServerError;

  HttpKeyConfig(
      {this.successHttpCodes = success_http_codes_default,
      this.successJsonCodes = success_json_codes_default,
      this.dataKey = data_key_default,
      this.listDataKey = list_data_key_default,
      this.codeKey = code_key_default,
      this.msgKey = msg_key_default,
      this.nextPageKey = next_page_key_default,
      this.previousPageKey = previous_page_key_default,
      this.httpUnknownError = http_unknown_error_default,
      this.httpAnalyzeError = http_analyze_error_default,
      this.http404Error = http_404_error_default,
      this.httpServerError = http_server_error_default});
}
