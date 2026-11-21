import Flutter
import UIKit

/// Plugin Flutter che mostra il foglio di condivisione di sistema
/// (`UIActivityViewController`).
///
/// I nomi dei metodi e delle chiavi degli argomenti devono restare allineati
/// con `lib/appinio_social_share_method_channel.dart`.
public class AppinioSocialSharePlugin: NSObject, FlutterPlugin {
    private static let success = "SUCCESS"
    private static let error = "ERROR"

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "appinio_social_share", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(AppinioSocialSharePlugin(), channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any] ?? [:]

        switch call.method {
        case "system_share_ios":
            var items: [Any] = []
            if let message = args["message"] as? String, !message.isEmpty {
                items.append(TextItemSource(text: message, subject: args["title"] as? String))
            }
            if let filePath = args["imagePath"] as? String {
                items.append(URL(fileURLWithPath: filePath))
            }
            result(presentShareSheet(items: items))

        case "system_share_ios_multifiles":
            let filePaths = args["imagePaths"] as? [String] ?? []
            result(presentShareSheet(items: filePaths.map { URL(fileURLWithPath: $0) }))

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /// Presenta il foglio di condivisione sopra la schermata visibile.
    private func presentShareSheet(items: [Any]) -> String {
        guard !items.isEmpty, let presenter = Self.topViewController() else {
            return Self.error
        }

        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)

        // Su iPad il foglio è un popover e senza un'ancora l'app va in crash.
        if let popover = controller.popoverPresentationController {
            let bounds = presenter.view.bounds
            popover.sourceView = presenter.view
            popover.sourceRect = CGRect(x: bounds.midX, y: bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        presenter.present(controller, animated: true)
        return Self.success
    }

    private static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        return topViewController(from: keyWindow?.rootViewController)
    }

    private static func topViewController(from controller: UIViewController?) -> UIViewController? {
        if let navigation = controller as? UINavigationController {
            return topViewController(from: navigation.visibleViewController)
        }
        if let tab = controller as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(from: selected)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(from: presented)
        }
        return controller
    }
}

/// Testo da condividere con un oggetto opzionale, usato per esempio da Mail.
final class TextItemSource: NSObject, UIActivityItemSource {
    private let text: String
    private let subject: String?

    init(text: String, subject: String?) {
        self.text = text
        self.subject = subject
        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        text
    }

    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        text
    }

    func activityViewController(_ activityViewController: UIActivityViewController,
                                subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        subject ?? ""
    }
}
