/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
typedef void EventCallback(arg);

class EventBusManager {
  static EventBusManager? _eventBusManager;

  EventBusManager._internal();

  factory EventBusManager() => _eventBusManager ??= EventBusManager._internal();

  Map<Object, List<EventCallback>> _eventMap =
      Map<Object, List<EventCallback>>();

  Map<Object, List<EventCallback>> get eventMap => _eventMap;

  //add observer
  void on(eventName, EventCallback? eventCallback) {
    if (eventName == null || eventCallback == null) {
      return;
    }
    _eventMap[eventName] ??= [];
    _eventMap[eventName]?.add(eventCallback);
  }

  //remove observer
  void off(eventName, [EventCallback? eventCallback]) {
    var list = _eventMap[eventName];
    if (eventName == null || list == null) {
      return;
    }
    if (eventCallback == null) {
      _eventMap.remove(eventName);
    } else {
      list.remove(eventCallback);
    }
  }

  //send event
  void send(eventName, [arg]) {
    var list = _eventMap[eventName];
    if (list == null) {
      return;
    }
    int len = list.length - 1;
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}
