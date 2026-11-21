import 'package:appinio_social_share/platforms/android.dart';
import 'package:appinio_social_share/platforms/ios.dart';

/// Punto di ingresso della libreria.
///
/// Espone il foglio di condivisione di sistema separato per piattaforma:
/// usa [android] su Android e [iOS] su iOS.
///
/// ```dart
/// final share = AppinioSocialShare();
/// if (Platform.isIOS) {
///   await share.iOS.shareToSystem(message, file.path);
/// } else {
///   await share.android.shareToSystem(title, message, file.path);
/// }
/// ```
class AppinioSocialShare {
  /// API per Android.
  Android android = Android();

  /// API per iOS.
  IOS iOS = IOS();
}
