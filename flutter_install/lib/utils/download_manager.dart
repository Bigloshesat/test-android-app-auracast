import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:framework/utils/exception_util.dart';

typedef VoidObjectCallback<T> = void Function(T value);

class DownloadManager {
  static DownloadManager? _downloadManager;

  factory DownloadManager() => _getInstance();

  DownloadManager._internal();

  Map<String, CancelToken> downloadingUrls = Map<String, CancelToken>();

  static DownloadManager _getInstance() {
    if (_downloadManager == null) {
      _downloadManager = DownloadManager._internal();
    }
    return _downloadManager!;
  }

  Future<String?> download(String url, String savePath,
      {ProgressCallback? onReceiveProgress,
      VoidObjectCallback<String>? onSuccess,
      VoidObjectCallback<String>? onError, bool allowFollowRedirects = true}) async {
    int downloadStart = 0;
    bool fileExists = false;
    File file = File(savePath);
    if (await file.exists()) {
      downloadStart = file.lengthSync();
      fileExists = true;
    }
    if (fileExists && downloadingUrls.containsKey(url)) {
      onError?.call("file exists");
      return null;
    }
    Dio dio = Dio();
    int contentLength = await _getContentLength(dio, url);
    if (contentLength == 0) {
      onError?.call("network file length error");
      return null;
    }
    if (downloadStart == contentLength) {
      onSuccess?.call(savePath);
      return savePath;
    }
    CancelToken cancelToken = CancelToken();
    downloadingUrls[url] = cancelToken;

    String? result;
    String error = "download error";
    Future downloadByDio(String url, int start, int total) async {
      try {
        Response response = await dio.get(
          url,
          options: Options(
            responseType: ResponseType.stream,
            followRedirects: allowFollowRedirects,
            headers: {"range": "bytes=$start-"},
          ),
        );
        File file = File(savePath);
        RandomAccessFile randomAccessFile =
            file.openSync(mode: FileMode.append);
        Completer completer = Completer<Response>();
        Future future = completer.future;

        int received = start;
        Stream<List<int>> stream = response.data.stream;
        StreamSubscription? subscription;
        Future? asyncWrite;
        subscription = stream.listen(
          (data) {
            subscription?.pause();
            asyncWrite =
                randomAccessFile.writeFrom(data).then((_randomAccessFile) {
              received += data.length;
              if (onReceiveProgress != null) {
                onReceiveProgress(received, total);
              }
              randomAccessFile = _randomAccessFile;
              if (!cancelToken.isCancelled) {
                subscription?.resume();
              }
            });
          },
          onDone: () async {
            try {
              await asyncWrite;
              await randomAccessFile.close();
              completer.complete(response);
              downloadingUrls.remove(url);
              result = savePath;
            } catch (e, s) {
              ExceptionUtil.printException(e, s);
              downloadingUrls.remove(url);
              completer.completeError(_assureDioError(e));
              error = e.toString();
            }
          },
          onError: (e, s) async {
            ExceptionUtil.printException(e, s);
            try {
              await asyncWrite;
              await randomAccessFile.close();
              downloadingUrls.remove(url);
              error = e.toString();
            } finally {
              completer.completeError(_assureDioError(e));
            }
          },
          cancelOnError: true,
        );
        cancelToken.whenCancel.then((_) async {
          await subscription?.cancel();
          await asyncWrite;
          await randomAccessFile.close();
        });
        return await _listenCancelForAsyncTask(cancelToken, future);
      } catch (e, s) {
        ExceptionUtil.printException(e, s);
        error = e.toString();
        downloadingUrls.remove(url);
      }
    }

    await downloadByDio(url, downloadStart, contentLength);
    if (result != null) {
      onSuccess?.call(result!);
      return result;
    } else {
      onError?.call(error);
      return null;
    }
  }

  Future<int> _getContentLength(Dio dio, url) async {
    try {
      Response response = await dio.head(url);
      return int.parse(
          response.headers.value(HttpHeaders.contentLengthHeader)!);
    } catch (e, s) {
      ExceptionUtil.printException(e, s);
      return 0;
    }
  }

  void stop(String url) {
    if (downloadingUrls.containsKey(url)) {
      downloadingUrls[url]!.cancel();
    }
  }

  Future _listenCancelForAsyncTask(CancelToken cancelToken, Future future) {
    if (cancelToken.cancelError == null) {
      return Future.any([cancelToken.whenCancel, future]).then((result) {
        return result;
      }).catchError((e) {
        throw e;
      });
    } else {
      return future;
    }
  }

  DioError _assureDioError(err) {
    if (err is DioError) {
      return err;
    } else {
      return DioError(error: err, requestOptions: RequestOptions(path: ""));
    }
  }
}
