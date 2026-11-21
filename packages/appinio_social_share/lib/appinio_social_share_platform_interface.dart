import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'appinio_social_share_method_channel.dart';

/// Interfaccia di piattaforma del plugin.
///
/// L'implementazione predefinita è [MethodChannelAppinioSocialShare]; nei test
/// si può sostituire impostando [instance].
abstract class AppinioSocialSharePlatform extends PlatformInterface {
  AppinioSocialSharePlatform() : super(token: _token);

  static final Object _token = Object();

  static AppinioSocialSharePlatform _instance =
      MethodChannelAppinioSocialShare();

  /// Istanza in uso. Predefinita: [MethodChannelAppinioSocialShare].
  static AppinioSocialSharePlatform get instance => _instance;

  static set instance(AppinioSocialSharePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> shareToSystemIos(String title, String message,
      {String? filePath}) {
    throw UnimplementedError('shareToSystemIos() has not been implemented.');
  }

  Future<String> shareToSystemIosMultifiles(String title,
      {List<String>? filePaths}) {
    throw UnimplementedError(
        'shareToSystemIosMultifiles() has not been implemented.');
  }

  Future<String> shareToSystemAndroid(
      String title, String message, String? filePath) {
    throw UnimplementedError(
        'shareToSystemAndroid() has not been implemented.');
  }

  Future<String> shareToSystemAndroidMultifiles(
      String title, List<String>? filePaths) {
    throw UnimplementedError(
        'shareToSystemAndroidMultifiles() has not been implemented.');
  }
}
