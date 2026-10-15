/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
typedef VoidBoolCallback = void Function(bool value);

typedef VoidIntCallback = void Function(int value);

typedef VoidDoubleCallback = void Function(double value);

typedef VoidStringCallback = void Function(String value);

typedef VoidCallback = void Function();

typedef BoolCallback = bool Function();

typedef IntCallback = int Function();

typedef DoubletCallback = double Function();

typedef VoidObjectCallback<T> = void Function(T value);

typedef BoolObjectCallback<T> = bool Function(T value);

typedef IntObjectCallback<T> = int Function(T value);

typedef DoubleObjectCallback<T> = double Function(T value);

typedef VoidFutureCallback = Future<void> Function();

typedef BoolFutureCallback = Future<bool> Function();

typedef IntFutureCallback = Future<int> Function();

typedef DoubleFutureCallback = Future<double> Function();

typedef VoidFutureObjectCallback<T> = Future<void> Function(T value);

typedef BoolFutureObjectCallback<T> = Future<bool> Function(T value);

typedef IntFutureObjectCallback<T> = Future<int> Function(T value);

typedef DoubleFutureObjectCallback<T> = Future<double> Function(T value);
