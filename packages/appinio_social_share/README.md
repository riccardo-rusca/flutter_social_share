# appinio_social_share (fork PinVision)

Fork interno di [appinio_social_share](https://pub.dev/packages/appinio_social_share), ridotto a una sola funzione: condividere testo e file tramite il **foglio di condivisione di sistema**.

- iOS: `UIActivityViewController`
- Android: chooser di sistema (`Intent.createChooser`)

Le integrazioni dirette con le app social della libreria originale (Facebook, Instagram, WhatsApp, Telegram, ecc.) sono state rimosse insieme al Facebook SDK, perché l'app PinVision non le usa. Il foglio di sistema permette comunque di condividere verso tutte queste app.

## Installazione

Nel `pubspec.yaml` dell'app:

```yaml
dependencies:
  appinio_social_share:
    git:
      url: https://github.com/riccardo-rusca/flutter_social_share.git
      path: packages/appinio_social_share
```

Senza `ref` viene usato il branch `main`. Per aggiornare dopo un push: `flutter pub upgrade appinio_social_share`.

## Uso

```dart
import 'dart:io';
import 'package:appinio_social_share/appinio_social_share.dart';

final share = AppinioSocialShare();

if (Platform.isIOS) {
  await share.iOS.shareToSystem(message, file.path, title: title);
} else {
  await share.android.shareToSystem(title, message, file.path);
}
```

### API

| Piattaforma | Metodo | Note |
|---|---|---|
| iOS | `iOS.shareToSystem(String message, String? filePath, {String? title})` | `title` è usato come oggetto dalle app che lo supportano (es. Mail). |
| iOS | `iOS.shareFilesToSystem({List<String>? filePaths})` | Più file insieme. |
| Android | `android.shareToSystem(String title, String message, String? filePath)` | `title` è il titolo del chooser e l'oggetto (`EXTRA_SUBJECT`). |
| Android | `android.shareFilesToSystem(String title, List<String>? filePaths)` | Più file insieme. |

### Valore restituito

Tutti i metodi restituiscono una `String`:

- `"SUCCESS"`: il foglio di condivisione è stato aperto. **Non** significa che l'utente abbia completato la condivisione.
- iOS, `"ERROR"`: non c'era niente da condividere oppure nessuna schermata da cui mostrare il foglio.
- Android, qualunque altro valore: il messaggio dell'eccezione nativa (per esempio un file fuori dai percorsi del `FileProvider`).

## Configurazione

### iOS

Non serve nessuna configurazione. La versione minima è iOS 13. Il plugin supporta sia Swift Package Manager (`ios/appinio_social_share/Package.swift`) sia CocoaPods (`ios/appinio_social_share.podspec`).

### Android

Per condividere file l'app deve dichiarare un `FileProvider` con authority **`${applicationId}.provider`**. Il plugin costruisce gli URI con questa authority, quindi il nome è obbligatorio.

`android/app/src/main/AndroidManifest.xml`, dentro `<application>`:

```xml
<provider
    android:name="androidx.core.content.FileProvider"
    android:authorities="${applicationId}.provider"
    android:exported="false"
    android:grantUriPermissions="true">
    <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/file_paths" />
</provider>
```

`android/app/src/main/res/xml/file_paths.xml` deve coprire la cartella in cui l'app salva i file da condividere. Per esempio:

```xml
<paths>
    <cache-path name="cache" path="." />           <!-- getTemporaryDirectory() -->
    <external-path name="external" path="." />     <!-- getExternalStorageDirectory() -->
</paths>
```

Se il file non è coperto da nessun percorso, il metodo restituisce il messaggio dell'eccezione di `FileProvider` invece di `"SUCCESS"`.

Il MIME type viene ricavato dall'estensione del file (fallback `*/*`). Con più file di tipi diversi si usa `*/*`.

## Esempio

`example/` contiene un'app minima con due pulsanti: condividi solo testo, e condividi testo più file.
