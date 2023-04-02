import 'dart:developer';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:frappe_app/services/http_inspector.dart';
import 'package:frappe_app/services/logging_interceptor.dart';
import 'package:path_provider/path_provider.dart';

import '../model/config.dart';

class DioHelper {
  static Dio? dio;
  static String? cookies;

  static Future init(String baseUrl) async {
    var cookieJar = await getCookiePath();
    dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api",
      ),
    )..interceptors.addAll([
        CookieManager(cookieJar),
        LoggingInterceptor(),
        HttpInspector().alice.getDioInterceptor(),
      ]);
    dio?.options.connectTimeout = 60 * 1000;
    dio?.options.receiveTimeout = 60 * 1000;
  }

  static Future initCookies() async {
    cookies = await getCookies();
  }

  static Future<PersistCookieJar> getCookiePath() async {
    Directory appDocDir = await getApplicationSupportDirectory();
    String appDocPath = appDocDir.path;
    return PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath));
  }

  static Future<String?> getCookies() async {
    var cookieJar = await getCookiePath();
    if (Config().uri != null) {
      var cookies = await cookieJar.loadForRequest(Config().uri!);

      var cookie = CookieManager.getCookies(cookies);
      log("cookies: $cookie");

      return cookie;
    } else {
      return null;
    }
  }
}
