# CLAUDE.md

Repository dei pacchetti Flutter usati dall'app PinVision (`pinvision-app`). Per ora c'è un solo pacchetto: `packages/appinio_social_share`.

## appinio_social_share

Fork di `appinio_social_share` ridotto al **solo foglio di condivisione di sistema**. Le integrazioni social e il Facebook SDK sono stati rimossi di proposito nella 0.5.0: non vanno reintrodotti senza una richiesta esplicita.

### Chi lo usa

`pinvision-app` lo include via `git:` sul branch `main`, senza `ref`, e usa solo:

- `AppinioSocialShare().iOS.shareToSystem(message, filePath)`
- `AppinioSocialShare().android.shareToSystem(title, message, filePath)`

(`pinvision-app/lib/ui/bottom_sheets/share_scorecard/share_scorecard_sheet_model.dart`)

Ogni push su `main` arriva all'app al prossimo `flutter pub upgrade appinio_social_share`. **Non cambiare le firme pubbliche** senza aggiornare anche l'app.

### Struttura

```
packages/appinio_social_share/
  lib/
    appinio_social_share.dart                    # AppinioSocialShare: .android / .iOS
    platforms/android.dart, platforms/ios.dart   # API pubblica per piattaforma
    appinio_social_share_platform_interface.dart
    appinio_social_share_method_channel.dart     # nomi dei metodi e chiavi degli argomenti
  ios/
    appinio_social_share/Package.swift           # Swift Package Manager
    appinio_social_share/Sources/appinio_social_share/AppinioSocialSharePlugin.swift
    appinio_social_share.podspec                 # CocoaPods (stessi sorgenti)
  android/
    build.gradle
    src/main/java/com/appinio/socialshare/appinio_social_share/AppinioSocialSharePlugin.java
  example/                                       # app di prova
```

### Contratto del method channel

Canale `appinio_social_share`. I nomi devono coincidere in Dart, Swift e Java:

| Metodo | Argomenti |
|---|---|
| `system_share_ios` | `title`, `message`, `imagePath` |
| `system_share_ios_multifiles` | `title`, `imagePaths` |
| `system_share_android` | `title`, `message`, `imagePath` |
| `system_share_android_multifiles` | `title`, `imagePaths` |

Il risultato è sempre una `String`: `"SUCCESS"` se il foglio è stato aperto (non vuol dire che l'utente abbia condiviso). Altrimenti `"ERROR"` su iOS, o il messaggio dell'eccezione su Android.

### Vincoli

- **iOS**: niente Objective-C nel target. SPM non permette target misti e il plugin deve restare solo Swift. `Package.swift` e `podspec` vanno tenuti allineati (sorgenti, iOS minimo 13.0). Su iPad `UIActivityViewController` richiede un'ancora per il popover.
- **Android**: i file passano dal `FileProvider` dell'app ospite con authority `<applicationId>.provider`, fissata nel codice. `androidx.core` è dichiarato esplicitamente in `build.gradle`. Il context è quello dell'applicazione, quindi il chooser parte con `FLAG_ACTIVITY_NEW_TASK`.

### Comandi

Da `packages/appinio_social_share`:

```sh
flutter analyze
cd example && flutter test
cd example && flutter build ios --simulator --debug   # verifica SPM/iOS
```

L'Android dell'example usa ancora Gradle 7.4 e non compila con Java 21. Per verificare il plugin Android si può creare un'app usa e getta (`flutter create`) che lo includa via `path:` e lanciare `flutter build apk --debug`.

Le build dell'example possono far partire migrazioni automatiche di Flutter (`example/ios`, `analysis_options.yaml`, `.gitignore`, Gradle). Non vanno committate a meno che non sia richiesto.

### Convenzioni

- Documentazione e commenti in italiano.
- Aggiornare `CHANGELOG.md` e `version` in `pubspec.yaml` quando cambia il comportamento.
