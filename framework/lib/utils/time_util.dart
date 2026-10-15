/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */

class TimeUtil {
  static int _microTimestamp = 0;
  static int _milliTimestamp = 0;

  static int getUniqueMicroTimestamp() {
    int newTimestamp = DateTime.now().microsecondsSinceEpoch;
    if (newTimestamp == _microTimestamp) {
      newTimestamp = getTimestamp(newTimestamp,true);
    }
    _microTimestamp = newTimestamp;
    return newTimestamp;
  }

  static int getUniqueTimestamp() {
    int newTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (newTimestamp == _milliTimestamp) {
      newTimestamp = getTimestamp(newTimestamp,false);
    }
    _milliTimestamp = newTimestamp;
    return newTimestamp;
  }

  static int getTimestamp(int newTimestamp,bool isMicro) {
    while (true) {
      double _ = 99999 * 99999;
      int timestamp = isMicro?DateTime.now().microsecondsSinceEpoch:DateTime.now().millisecondsSinceEpoch;
      if (newTimestamp != timestamp) {
        newTimestamp = timestamp;
        break;
      }
    }
    return newTimestamp;
  }
}
