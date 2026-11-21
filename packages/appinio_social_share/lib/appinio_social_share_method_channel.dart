import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'appinio_social_share_platform_interface.dart';

/// Implementazione di [AppinioSocialSharePlatform] basata su method channel.
///
/// I nomi dei metodi e delle chiavi degli argomenti devono restare allineati
/// con `AppinioSocialSharePlugin.swift` (iOS) e
/// `AppinioSocialSharePlugin.java` (Android).
class MethodChannelAppinioSocialShare extends AppinioSocialSharePlatform {
  static const String _systemShareIos = "system_share_ios";
  static const String _systemShareIosMultiFiles = "system_share_ios_multifiles";
  static const String _systemShareAndroid = "system_share_android";
  static const String _systemShareAndroidMultiFiles =
      "system_share_android_multifiles";

  @visibleForTesting
  final methodChannel = const MethodChannel('appinio_social_share');

  Future<String> _invoke(String method, Map<String, Object?> arguments) async {
    return await methodChannel.invokeMethod<String>(method, arguments) ?? "";
  }

  @override
  Future<String> shareToSystemIos(String title, String message,
      {String? filePath}) {
    return _invoke(_systemShareIos,
        {"title": title, "message": message, "imagePath": filePath});
  }

  @override
  Future<String> shareToSystemIosMultifiles(String title,
      {List<String>? filePaths}) {
    return _invoke(
        _systemShareIosMultiFiles, {"title": title, "imagePaths": filePaths});
  }

  @override
  Future<String> shareToSystemAndroid(
      String title, String message, String? filePath) {
    return _invoke(_systemShareAndroid,
        {"title": title, "message": message, "imagePath": filePath});
  }

  @override
  Future<String> shareToSystemAndroidMultifiles(
      String title, List<String>? filePaths) {
    return _invoke(_systemShareAndroidMultiFiles,
        {"title": title, "imagePaths": filePaths});
  }
}
