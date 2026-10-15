/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferencesManager? _sharedPreferencesManager;

  SharedPreferencesManager._internal();

  factory SharedPreferencesManager() =>
      _sharedPreferencesManager ??= SharedPreferencesManager._internal();

  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> put(String key, Object value) {
    if (value is int) {
      return putInt(key, value);
    } else if (value is String) {
      return putString(key, value);
    } else if (value is bool) {
      return putBool(key, value);
    } else if (value is double) {
      return putDouble(key, value);
    } else if (value is List<String>) {
      return putStringList(key, value);
    }
    throw Exception("Type not supported");
  }

  _checkInit() {
    if (_sharedPreferences == null) {
      throw Exception("Please do init before put value");
    }
  }

  String? getString(String key, {String? defValue}) {
    _checkInit();
    return _sharedPreferences.getString(key) ?? defValue;
  }

  Future<bool> putString(String key, String value) {
    _checkInit();
    return _sharedPreferences.setString(key, value);
  }

  bool getBool(String key, {bool defValue = false}) {
    _checkInit();
    return _sharedPreferences.getBool(key) ?? defValue;
  }

  Future<bool> putBool(String key, bool value) {
    _checkInit();
    return _sharedPreferences.setBool(key, value);
  }

  int getInt(String key, {int defValue = 0}) {
    _checkInit();
    return _sharedPreferences.getInt(key) ?? defValue;
  }

  Future<bool> putInt(String key, int value) {
    _checkInit();
    return _sharedPreferences.setInt(key, value);
  }

  double getDouble(String key, {double defValue = 0.0}) {
    _checkInit();
    return _sharedPreferences.getDouble(key) ?? defValue;
  }

  Future<bool> putDouble(String key, double value) {
    _checkInit();
    return _sharedPreferences.setDouble(key, value);
  }

  List<String> getStringList(String key) {
    _checkInit();
    return _sharedPreferences.getStringList(key) ?? [];
  }

  Future<bool> putStringList(String key, List<String> value) {
    _checkInit();
    return _sharedPreferences.setStringList(key, value);
  }

  dynamic getDynamic(String key, {Object? defValue}) {
    _checkInit();
    return _sharedPreferences.get(key) ?? defValue;
  }

  bool haveKey(String key) {
    _checkInit();
    return _sharedPreferences.getKeys().contains(key);
  }

  Set<String> getKeys() {
    _checkInit();
    return _sharedPreferences.getKeys();
  }

  Future<bool> remove(String key) {
    _checkInit();
    return _sharedPreferences.remove(key);
  }

  Future<bool> clear() {
    _checkInit();
    return _sharedPreferences.clear();
  }

  Future<bool> putObject(String key, Object? value) {
    _checkInit();
    return _sharedPreferences.setString(
        "object_$key", value == null ? "" : json.encode(value));
  }

  T? getTarget<T>(String key, T f(Map v), {T? defValue}) {
    Map? map = getObject(key);
    return map == null ? defValue : f(map);
  }

  Map? getObject(String key) {
    _checkInit();
    String? _data = _sharedPreferences.getString("object_$key");
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  Future<bool> putObjectList(String key, List<Object> list) {
    _checkInit();
    List<String> _dataList = list.map((value) {
      return json.encode(value);
    }).toList();
    return _sharedPreferences.setStringList(key, _dataList);
  }

  List<T> getTargetList<T>(String key, T f(Map v),
      {List<T> defValue = const []}) {
    List<Map>? dataList = getObjectList(key);
    if (dataList == null) {
      return defValue;
    }
    List<T>? list = dataList.map((value) {
      return f(value);
    }).toList();
    return list;
  }

  List<Map>? getObjectList(String key) {
    _checkInit();
    List<String>? dataList = _sharedPreferences.getStringList(key);
    return dataList?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    }).toList();
  }

  Future<bool> putMapList<T>(String key, Map<String, List<T>> mapList) {
    _checkInit();
    Map<String, List<T>> mapStringList = {};
    mapList.forEach((k, v) {
      List<T> dataList = v
          .map((value) {
            return json.encode(value);
          })
          .cast<T>()
          .toList();
      mapStringList[k] = dataList;
    });
    return putObject(key, mapStringList);
  }

  Map<String, List<T>> getMapList<T>(String key, T f(Map v)) {
    _checkInit();
    Map mapStringList = getObject(key) ?? {};
    Map<String, List<T>> mapList = {};
    mapStringList.forEach((k, v) {
      List<String> newValue = [];
      v.map((value) {
        return newValue.add(value as String);
      })?.toList();
      List<T> list = newValue.map((value) {
        return f(json.decode(value));
      }).toList();
      mapList[k] = list;
    });
    return mapList;
  }
}
