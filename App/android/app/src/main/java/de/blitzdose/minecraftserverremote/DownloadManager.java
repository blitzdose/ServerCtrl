package de.blitzdose.minecraftserverremote;

import android.content.Context;

import java.security.KeyManagementException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import com.downloader.OnCancelListener;
import com.downloader.OnDownloadListener;
import com.downloader.OnPauseListener;
import com.downloader.OnProgressListener;
import com.downloader.OnStartOrResumeListener;
import com.downloader.PRDownloader;
import com.downloader.Progress;
import com.downloader.request.DownloadRequestBuilder;
import io.flutter.plugin.common.MethodChannel;

class DownloadManager {

    private long counter = 0;

    String url;
    String path;
    String fileName;
    Map<String, String> headers = new HashMap<>();
    Context context;
    MethodChannel methodChannel;
    int id;

    DownloadManager(Context context, MethodChannel methodChannel, String url, String path, String fileName, Map<String, String> headers, ArrayList<String> hashes) {
        configureSSL(hashes);
        this.context = context;
        this.methodChannel = methodChannel;
        this.url = url;
        this.path = path;
        this.fileName = fileName;
        this.headers = headers;
    }

    void cancel() {
        PRDownloader.initialize(context);
        PRDownloader.cancel(id);
        MainActivity.downloadManagerMap.remove(id);
    }

    int download() {
        PRDownloader.initialize(context);

        DownloadRequestBuilder builder = PRDownloader.download(url, path, fileName);
        for (String key : headers.keySet()) {
            builder.setHeader(key, headers.get(key));
        }

        id = builder.build()
                .setOnStartOrResumeListener(new OnStartOrResumeListener() {
                    @Override
                    public void onStartOrResume() {

                    }
                })
                .setOnPauseListener(new OnPauseListener() {
                    @Override
                    public void onPause() {

                    }
                })
                .setOnCancelListener(new OnCancelListener() {
                    @Override
                    public void onCancel() {

                    }
                })
                .setOnProgressListener(new OnProgressListener() {
                    @Override
                    public void onProgress(Progress progress) {
                        counter++;
                        if (counter % 100 == 0) {
                            methodChannel.invokeMethod("notifyProgress", new HashMap<String, Object>(){{
                                put("status", "Running");
                                put("progress", (double) progress.currentBytes / (double) progress.totalBytes);
                            }});
                        }
                    }
                })
                .start(new OnDownloadListener() {
                    @Override
                    public void onDownloadComplete() {
                        methodChannel.invokeMethod("notifyProgress", new HashMap<String, Object>(){{
                            put("status", "Finished");
                            put("progress", 1.0);
                        }});
                        MainActivity.downloadManagerMap.remove(id);
                    }

                    @Override
                    public void onError(com.downloader.Error error) {
                        methodChannel.invokeMethod("notifyProgress", new HashMap<String, Object>(){{
                            put("status", "Error");
                            put("progress", 1.0);
                        }});
                        MainActivity.downloadManagerMap.remove(id);
                    }
                });
        return id;
    }

    void configureSSL(ArrayList<String> hashes) {
        TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
            @Override
            public void checkClientTrusted(java.security.cert.X509Certificate[] x509Certificates, String s) throws CertificateException {

            }

            @Override
            public void checkServerTrusted(java.security.cert.X509Certificate[] x509Certificates, String s) throws CertificateException {
                try {
                    byte[] sha1 = MessageDigest.getInstance("SHA-1").digest(
                            x509Certificates[x509Certificates.length-1].getEncoded());
                    final char[] HEX_ARRAY = "0123456789ABCDEF".toCharArray();
                    char[] hexChars = new char[sha1.length * 2];
                    for (int j = 0; j < sha1.length; j++) {
                        int v = sha1[j] & 0xFF;
                        hexChars[j * 2] = HEX_ARRAY[v >>> 4];
                        hexChars[j * 2 + 1] = HEX_ARRAY[v & 0x0F];
                    }
                    if (!hashes.contains(new String(hexChars))) {
                        throw new CertificateException();
                    }
                } catch (NoSuchAlgorithmException e) {
                    throw new CertificateException();
                }
            }

            public X509Certificate[] getAcceptedIssuers() {
                return null;
            }
        } };

        try {
            SSLContext sc = SSLContext.getInstance("TLS");

            sc.init(null, trustAllCerts, new java.security.SecureRandom());

            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
        } catch (KeyManagementException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }
}
