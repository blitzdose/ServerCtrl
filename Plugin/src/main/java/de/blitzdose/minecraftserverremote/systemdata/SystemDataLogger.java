package de.blitzdose.minecraftserverremote.systemdata;

import com.sun.management.OperatingSystemMXBean;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.nio.file.FileStore;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;
import java.util.TreeMap;

public class SystemDataLogger implements Runnable {

    public static JSONArray historicSystemData = new JSONArray();

    @Override
    public void run() {
        Runtime r = Runtime.getRuntime();

        long memMax = r.maxMemory();
        memMax = memMax / 1000000;

        long memTotal = r.totalMemory();
        memTotal = memTotal / 1000000;

        long memUsed = (r.totalMemory() - r.freeMemory());
        memUsed = memUsed / 1000000;

        OperatingSystemMXBean operatingSystemMXBean = (OperatingSystemMXBean) ManagementFactory.getOperatingSystemMXBean();

        long totalSystemMem = operatingSystemMXBean.getTotalPhysicalMemorySize();
        totalSystemMem = totalSystemMem / 1000000;

        long freeSystemMem = operatingSystemMXBean.getFreePhysicalMemorySize();
        freeSystemMem = freeSystemMem / 1000000;

        long cpuCores = r.availableProcessors();

        double cpuLoad = operatingSystemMXBean.getCpuLoad();
        cpuLoad = cpuLoad * 100;
        cpuLoad = Math.round(cpuLoad * 100.0) / 100.0;
        cpuLoad = (int) (cpuLoad * 100);

        Map<String, long[]> fileSystemSpaces = new TreeMap<>();
        for (Path root : FileSystems.getDefault().getRootDirectories()) {
            try {
                FileStore store = Files.getFileStore(root);
                String name = "" + root;
                name = name.replaceAll("\\\\", "");
                long freeSpace = store.getUsableSpace();
                long totalSpace = store.getTotalSpace();
                fileSystemSpaces.put(name, new long[]{freeSpace, totalSpace});
            } catch (IOException ignore) { }
        }

        JSONObject systemDataJsonObject = new JSONObject();

        systemDataJsonObject.put("time", System.currentTimeMillis());
        systemDataJsonObject.put("memMax", memMax);
        systemDataJsonObject.put("memTotal", memTotal);
        systemDataJsonObject.put("memUsed", memUsed);
        systemDataJsonObject.put("totalSystemMem", totalSystemMem);
        systemDataJsonObject.put("freeSystemMem", freeSystemMem);
        systemDataJsonObject.put("cpuCores", cpuCores);
        systemDataJsonObject.put("cpuLoad", cpuLoad);
        systemDataJsonObject.put("fileSystemSpaces", fileSystemSpaces);

        historicSystemData.put(systemDataJsonObject);
        if (historicSystemData.length() >= 40) {
            historicSystemData.remove(0);
        }
    }
}
