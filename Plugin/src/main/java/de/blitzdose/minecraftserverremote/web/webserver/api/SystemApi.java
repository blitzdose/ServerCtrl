package de.blitzdose.minecraftserverremote.web.webserver.api;

import com.google.gson.JsonObject;
import com.sun.management.OperatingSystemMXBean;
import de.blitzdose.minecraftserverremote.web.webserver.Webserver;
import io.javalin.http.Context;
import org.json.JSONObject;

import java.lang.management.ManagementFactory;

public class SystemApi {
    public static void getData(Context context) {
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

        double cpuLoad = operatingSystemMXBean.getSystemCpuLoad();
        cpuLoad = cpuLoad * 100;
        cpuLoad = Math.round(cpuLoad * 100.0) / 100.0;
        cpuLoad = (int) (cpuLoad * 100);

        JSONObject systemDataJsonObject = new JSONObject();

        systemDataJsonObject.put("success", true);
        systemDataJsonObject.put("memMax", memMax);
        systemDataJsonObject.put("memTotal", memTotal);
        systemDataJsonObject.put("memUsed", memUsed);
        systemDataJsonObject.put("totalSystemMem", totalSystemMem);
        systemDataJsonObject.put("freeSystemMem", freeSystemMem);
        systemDataJsonObject.put("cpuCores", cpuCores);
        systemDataJsonObject.put("cpuLoad", cpuLoad);

        Webserver.returnJson(context, systemDataJsonObject);
    }
}
