/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import '../exception_util.dart';

typedef ConvertResponse<T> = T Function<T>(dynamic);

class EntityFactory {
  static ConvertResponse? _convertResponse;

  static registerConvertResponse(ConvertResponse convertResponse) {
    _convertResponse = convertResponse;
  }

  static T? generateOBJ<T>(dynamic json) {
    if (json == null || _convertResponse == null) {
      return null;
    }
    try {
      return _convertResponse?.call(json);
    } catch (e, s) {
      ExceptionUtil.printException(e, s);
    }
    return null;
  }
}
