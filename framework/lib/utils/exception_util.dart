/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'log_util.dart';

class ExceptionUtil {
  static void printException(dynamic exception, StackTrace stackTrace) {
    LogUtil.v('exception details:\n $exception');
    LogUtil.v('stack trace:\n $stackTrace');
  }
}
