package de.blitzdose.minecraftserverremote;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import com.downloader.*;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "de.blitzdose.serverctrl/downloader";

    static Map<Integer, DownloadManager> downloadManagerMap = new HashMap<>();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        methodChannel
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("download")) {
                                String url = call.argument("url");
                                String path = call.argument("path");
                                String fileName = call.argument("fileName");
                                Map<String, String> headers = call.argument("headers");
                                ArrayList<String> acceptedCerts = call.argument("accepted_certs");

                                DownloadManager downloadManager = new DownloadManager(getApplicationContext(), methodChannel, url, path, fileName, headers, acceptedCerts);
                                int downloadId = downloadManager.download();
                                downloadManagerMap.put(downloadId, downloadManager);
                                result.success(downloadId);

                            } else if (call.method.equals("cancel")) {
                                int id = call.argument("id");
                                DownloadManager downloadManager = downloadManagerMap.get(id);
                                if (downloadManager != null) {
                                    downloadManager.cancel();
                                }
                            }
                        }
                );
    }

}
