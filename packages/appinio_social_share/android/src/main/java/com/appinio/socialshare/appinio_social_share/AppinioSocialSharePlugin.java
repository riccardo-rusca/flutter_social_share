package com.appinio.socialshare.appinio_social_share;

import android.content.ClipData;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.webkit.MimeTypeMap;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.FileProvider;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * Plugin Flutter che apre il chooser di condivisione di sistema.
 *
 * <p>I nomi dei metodi e delle chiavi degli argomenti devono restare allineati con
 * {@code lib/appinio_social_share_method_channel.dart}.
 *
 * <p>I file vengono esposti tramite il {@link FileProvider} dell'app ospite, che deve essere
 * dichiarato con authority {@code <applicationId>.provider}.
 */
public class AppinioSocialSharePlugin implements FlutterPlugin, MethodCallHandler {

    private static final String TAG = "AppinioSocialShare";
    private static final String SUCCESS = "SUCCESS";
    private static final String SYSTEM_SHARE = "system_share_android";
    private static final String SYSTEM_SHARE_MULTIFILES = "system_share_android_multifiles";

    private MethodChannel channel;
    private Context context;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        context = binding.getApplicationContext();
        channel = new MethodChannel(binding.getBinaryMessenger(), "appinio_social_share");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        String title = call.argument("title");
        try {
            switch (call.method) {
                case SYSTEM_SHARE:
                    result.success(shareToSystem(title, call.argument("message"), call.argument("imagePath")));
                    break;
                case SYSTEM_SHARE_MULTIFILES:
                    result.success(shareFilesToSystem(title, call.argument("imagePaths")));
                    break;
                default:
                    result.notImplemented();
            }
        } catch (Exception e) {
            Log.e(TAG, "Condivisione non riuscita", e);
            String message = e.getLocalizedMessage();
            result.success(message != null ? message : e.toString());
        }
    }

    private String shareToSystem(@Nullable String title, @Nullable String message, @Nullable String filePath) {
        Intent intent = new Intent(Intent.ACTION_SEND);
        if (filePath != null) {
            Uri uri = uriForFile(filePath);
            intent.setType(mimeTypeOf(filePath));
            intent.putExtra(Intent.EXTRA_STREAM, uri);
            // Con la ClipData il chooser mostra l'anteprima e concede i permessi di lettura.
            intent.setClipData(ClipData.newRawUri("", uri));
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        } else {
            intent.setType("text/plain");
        }
        intent.putExtra(Intent.EXTRA_TEXT, message);
        intent.putExtra(Intent.EXTRA_SUBJECT, title);
        startChooser(intent, title);
        return SUCCESS;
    }

    private String shareFilesToSystem(@Nullable String title, @Nullable List<String> filePaths) {
        Intent intent = new Intent(Intent.ACTION_SEND_MULTIPLE);
        if (filePaths == null || filePaths.isEmpty()) {
            intent.setType("text/plain");
        } else {
            ArrayList<Uri> uris = new ArrayList<>();
            ClipData clipData = null;
            for (String filePath : filePaths) {
                Uri uri = uriForFile(filePath);
                uris.add(uri);
                if (clipData == null) {
                    clipData = ClipData.newRawUri("", uri);
                } else {
                    clipData.addItem(new ClipData.Item(uri));
                }
            }
            intent.setType(commonMimeTypeOf(filePaths));
            intent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris);
            intent.setClipData(clipData);
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        }
        intent.putExtra(Intent.EXTRA_SUBJECT, title);
        startChooser(intent, title);
        return SUCCESS;
    }

    /** Il context è quello dell'applicazione, quindi serve FLAG_ACTIVITY_NEW_TASK. */
    private void startChooser(Intent intent, @Nullable String title) {
        Intent chooser = Intent.createChooser(intent, title);
        chooser.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(chooser);
    }

    private Uri uriForFile(String filePath) {
        return FileProvider.getUriForFile(context, context.getPackageName() + ".provider", new File(filePath));
    }

    private static String mimeTypeOf(String filePath) {
        int dot = filePath.lastIndexOf('.');
        String extension = dot >= 0 ? filePath.substring(dot + 1).toLowerCase(Locale.ROOT) : "";
        String mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
        return mimeType != null ? mimeType : "*/*";
    }

    /** Il tipo comune a tutti i file, oppure {@code *}{@code /*} se sono di tipi diversi. */
    private static String commonMimeTypeOf(List<String> filePaths) {
        String mimeType = mimeTypeOf(filePaths.get(0));
        for (String filePath : filePaths) {
            if (!mimeType.equals(mimeTypeOf(filePath))) {
                return "*/*";
            }
        }
        return mimeType;
    }
}
