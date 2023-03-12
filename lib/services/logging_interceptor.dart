import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor implements Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint(
        "<-- ${options.method.toUpperCase()} ${options.baseUrl}${options.path}");

    debugPrint("Headers:");
    options.headers.forEach((k, v) => debugPrint('$k: $v'));

    debugPrint("queryParameters:");
    options.queryParameters.forEach((k, v) => debugPrint('$k: $v'));

    if (options.data != null) {
      debugPrint("Body: ${options.data}");
    }

    debugPrint("END ${options.method.toUpperCase()} -->");

    return handler.next(options);
  }

  @override
  void onError(DioError dioError, ErrorInterceptorHandler handler) {
    debugPrint(
        "<-- ${dioError.message} ${(dioError.response?.requestOptions != null ? (dioError.response!.requestOptions.baseUrl + dioError.response!.requestOptions.path) : 'URL')}");
    debugPrint(
        "${dioError.response != null ? dioError.response!.data : 'Unknown Error'}");
    debugPrint("End error -->");

    return handler.next(dioError);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        "<-- ${response.statusCode} ${response.requestOptions.baseUrl + response.requestOptions.path}");

    debugPrint("Headers:");
    response.headers.forEach((k, v) => debugPrint('$k: $v'));

    debugPrint("Response: ${response.data}");
    debugPrint("END Response -->");

    return handler.next(response);
  }
}
