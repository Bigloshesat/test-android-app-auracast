/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
class Bundle {
  Map<String, dynamic> _map = {};

  _setValue(var k, var v) => _map[k] = v;

  _getValue(var k) {
    if (!_map.containsKey(k)) {
      return null;
    }
    return _map[k];
  }

  putBool(String k, bool v) => _setValue(k, v);

  putInt(String k, int v) => _setValue(k, v);

  putString(String k, String v) => _setValue(k, v);

  putList<T>(String k, List<T> v) => _setValue(k, v);

  putObject<T>(String k, T v) => _setValue(k, v);

  bool getBool(String k, {bool defaultValue = false}) {
    dynamic value = _getValue(k);
    if (value != null && value is bool) {
      return value;
    }
    return defaultValue;
  }

  int getInt(String k, {int defaultValue = -1}) {
    dynamic value = _getValue(k);
    if (value != null && value is int) {
      return value;
    }
    return defaultValue;
  }

  String? getString(String k, {String? defaultValue}) {
    dynamic value = _getValue(k);
    if (value != null && value is String) {
      return value;
    }
    return defaultValue;
  }

  List<T>? getList<T>(String k) {
    dynamic value = _getValue(k);
    if (value != null && value is List<T>) {
      return value;
    }
    return null;
  }

  T? getObject<T>(String k) {
    dynamic value = _getValue(k);
    if (value != null && value is T) {
      return value;
    }
    return null;
  }

  @override
  String toString() {
    return _map.toString();
  }
}
