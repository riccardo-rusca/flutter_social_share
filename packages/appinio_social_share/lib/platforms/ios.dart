import 'package:appinio_social_share/appinio_social_share_platform_interface.dart';

/// Condivisione tramite il foglio di sistema di iOS (`UIActivityViewController`).
///
/// Tutti i metodi restituiscono `"SUCCESS"` se il foglio è stato mostrato,
/// `"ERROR"` se non c'era niente da condividere o nessuna schermata da cui
/// presentarlo.
class IOS {
  /// Condivide [message] e, se presente, il file in [filePath].
  ///
  /// [title], se indicato, viene usato come oggetto dalle app che lo
  /// supportano (per esempio Mail).
  Future<String> shareToSystem(String message, String? filePath,
      {String? title}) {
    return AppinioSocialSharePlatform.instance
        .shareToSystemIos(title ?? "", message, filePath: filePath);
  }

  /// Condivide più file in una volta sola.
  Future<String> shareFilesToSystem({List<String>? filePaths}) {
    return AppinioSocialSharePlatform.instance
        .shareToSystemIosMultifiles("", filePaths: filePaths);
  }
}
