import 'dart:io';

import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'appinio_social_share',
      home: SharePage(),
    );
  }
}

class SharePage extends StatelessWidget {
  const SharePage({super.key});

  static const _title = 'Esempio';
  static const _message = 'Messaggio di prova da appinio_social_share';

  /// Crea un file di testo nella cartella temporanea (su Android è la cache
  /// dell'app, coperta dal FileProvider dichiarato nel manifest).
  Future<File> _createSampleFile() async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/esempio.txt');
    return file.writeAsString(_message);
  }

  Future<void> _share(BuildContext context, {required bool withFile}) async {
    final share = AppinioSocialShare();
    final filePath = withFile ? (await _createSampleFile()).path : null;
    final result = Platform.isIOS
        ? await share.iOS.shareToSystem(_message, filePath, title: _title)
        : await share.android.shareToSystem(_title, _message, filePath);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Risultato: $result')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('appinio_social_share')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _share(context, withFile: false),
              child: const Text('Condividi testo'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _share(context, withFile: true),
              child: const Text('Condividi testo e file'),
            ),
          ],
        ),
      ),
    );
  }
}
