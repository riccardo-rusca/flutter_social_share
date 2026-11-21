import 'package:appinio_social_share/appinio_social_share_platform_interface.dart';

/// Condivisione tramite il chooser di sistema di Android.
///
/// I file vengono passati alle altre app tramite il `FileProvider` dell'app
/// ospite, che deve essere dichiarato con authority `${applicationId}.provider`
/// (vedi README).
///
/// Tutti i metodi restituiscono `"SUCCESS"` se il chooser è stato aperto,
/// altrimenti il messaggio dell'eccezione nativa.
class Android {
  /// Condivide [message] e, se presente, il file in [filePath].
  ///
  /// [title] è usato come titolo del chooser e come oggetto (`EXTRA_SUBJECT`).
  Future<String> shareToSystem(String title, String message, String? filePath) {
    return AppinioSocialSharePlatform.instance
        .shareToSystemAndroid(title, message, filePath);
  }

  /// Condivide più file in una volta sola.
  ///
  /// [title] è usato come titolo del chooser e come oggetto (`EXTRA_SUBJECT`).
  Future<String> shareFilesToSystem(String title, List<String>? filePaths) {
    return AppinioSocialSharePlatform.instance
        .shareToSystemAndroidMultifiles(title, filePaths);
  }
}
