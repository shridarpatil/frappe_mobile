import 'package:alice/alice.dart';

class HttpInspector {
  HttpInspector._();
  static final HttpInspector _instance = HttpInspector._();
  factory HttpInspector() => _instance;

  Alice alice = Alice(
    showNotification: true,
    showInspectorOnShake: true,
    notificationIcon: '@mipmap/ic_launcher',
  );
}
