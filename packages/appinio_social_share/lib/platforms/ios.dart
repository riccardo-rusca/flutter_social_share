import 'package:appinio_social_share/appinio_social_share_platform_interface.dart';

class IOS {
  Future<String> shareToWhatsapp(String message) {
    return AppinioSocialSharePlatform.instance.shareToWhatsapp(message);
  }

  Future<String> shareToTelegram(String message) {
    return AppinioSocialSharePlatform.instance.shareToTelegram(message);
  }

  Future<String> shareImageToWhatsApp(String filePath) {
    return AppinioSocialSharePlatform.instance.shareImageToWhatsApp(filePath);
  }

  Future<String> shareToTwitter(String message, String? filePath) {
    return AppinioSocialSharePlatform.instance
        .shareToTwitter(message, filePath);
  }

  Future<String> shareToInstagramDirect(String message) {
    return AppinioSocialSharePlatform.instance.shareToInstagramDirect(message);
  }

  Future<String> shareToInstagramFeed(String imagePath) {
    return AppinioSocialSharePlatform.instance
        .shareToInstagramFeed("", imagePath);
  }

  Future<String> shareToInstagramReels(String videoPath) {
    return AppinioSocialSharePlatform.instance
        .shareToInstagramFeed("", videoPath);
  }

  Future<String> shareToMessenger(String message) {
    return AppinioSocialSharePlatform.instance.shareToMessenger(message);
  }

  Future<String> copyToClipBoard(String imagePath) {
    return AppinioSocialSharePlatform.instance.copyToClipBoard(imagePath);
  }

  Future<String> shareToFacebook(String hashtag, List<String> filePaths) {
    return AppinioSocialSharePlatform.instance
        .shareToFacebook(hashtag, filePaths);
  }

  Future<String> shareToInstagramStory(String appId,
      {String? stickerImage,
      String? backgroundImage,
      String? backgroundVideo,
      String? backgroundTopColor,
      String? backgroundBottomColor,
      String? attributionURL}) {
    return AppinioSocialSharePlatform.instance.shareToInstagramStory(appId,
        stickerImage: stickerImage,
        backgroundImage: backgroundImage,
        backgroundVideo: backgroundVideo,
        backgroundTopColor: backgroundTopColor,
        backgroundBottomColor: backgroundBottomColor,
        attributionURL: attributionURL);
  }

  Future<String> shareToFacebookStory(String appId,
      {String? stickerImage,
      String? backgroundImage,
      String? backgroundVideo,
      String? backgroundTopColor,
      String? backgroundBottomColor,
      String? attributionURL}) {
    return AppinioSocialSharePlatform.instance.shareToFacebookStory(appId,
        stickerImage: stickerImage,
        backgroundImage: backgroundImage,
        backgroundVideo: backgroundVideo,
        backgroundTopColor: backgroundTopColor,
        backgroundBottomColor: backgroundBottomColor,
        attributionURL: attributionURL);
  }

  Future<String> shareToSystem(String message, String? filePath) {
    return AppinioSocialSharePlatform.instance
        .shareToSystemIos("", message, filePath: filePath);
  }

  Future<String> shareFilesToSystem({List<String>? filePaths}) {
    return AppinioSocialSharePlatform.instance
        .shareToSystemIosMultifiles("", filePaths: filePaths);
  }

  Future<String> shareToSMS(String message) {
    return AppinioSocialSharePlatform.instance
        .shareToSMS(message, filePaths: []);
  }
}
