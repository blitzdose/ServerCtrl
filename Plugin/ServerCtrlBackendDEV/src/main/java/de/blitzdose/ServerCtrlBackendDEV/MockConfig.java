package de.blitzdose.ServerCtrlBackendDEV;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

public class MockConfig {

    private static final ObjectMapper MAPPER = new ObjectMapper();
    private final ObjectNode rootNode;

    public MockConfig() {
        this.rootNode = MAPPER.createObjectNode();
    }

    public MockConfig(ObjectNode rootNode) {
        this.rootNode = rootNode != null ? rootNode : MAPPER.createObjectNode();
    }

    /**
     * Loads configuration from a JSON file.
     */
    public static MockConfig load(File file) throws IOException {
        JsonNode node = MAPPER.readTree(file);
        return new MockConfig(node.isObject() ? (ObjectNode) node : MAPPER.createObjectNode());
    }

    /**
     * Loads configuration from a JSON String.
     */
    public static MockConfig load(String jsonString) throws IOException {
        JsonNode node = MAPPER.readTree(jsonString);
        return new MockConfig(node.isObject() ? (ObjectNode) node : MAPPER.createObjectNode());
    }

    /**
     * Checks if a path exists and is not null.
     */
    public boolean contains(String path) {
        JsonNode node = getNode(path);
        return node != null && !node.isNull();
    }

    /**
     * Sets a value at a given dot-separated path (creates parent objects automatically).
     * If value is null, the key will be removed (matching Bukkit behavior).
     */
    public void set(String path, Object value) {
        if (path == null || path.isEmpty()) return;

        String[] parts = path.split("\\.");
        ObjectNode current = rootNode;

        // Traverse down to the parent node, creating missing ObjectNodes as needed
        for (int i = 0; i < parts.length - 1; i++) {
            String part = parts[i];
            JsonNode next = current.get(part);

            if (next == null || !next.isObject()) {
                next = MAPPER.createObjectNode();
                current.set(part, next);
            }
            current = (ObjectNode) next;
        }

        String targetKey = parts[parts.length - 1];

        // Remove node if setting null
        if (value == null) {
            current.remove(targetKey);
            return;
        }

        // Convert and set the value appropriately
        if (value instanceof String strVal) {
            current.put(targetKey, strVal);
        } else if (value instanceof Integer intVal) {
            current.put(targetKey, intVal);
        } else if (value instanceof Boolean boolVal) {
            current.put(targetKey, boolVal);
        } else if (value instanceof Double doubleVal) {
            current.put(targetKey, doubleVal);
        } else if (value instanceof Long longVal) {
            current.put(targetKey, longVal);
        } else {
            // For Lists or complex custom objects, use POJO conversion
            current.set(targetKey, MAPPER.valueToTree(value));
        }
    }

    /**
     * Saves current configuration back to a JSON File.
     */
    public void save(File file) throws IOException {
        MAPPER.writerWithDefaultPrettyPrinter().writeValue(file, rootNode);
    }

    /**
     * Navigates to a JsonNode via dot-separated path.
     */
    private JsonNode getNode(String path) {
        if (path == null || path.isEmpty()) {
            return rootNode;
        }

        String[] parts = path.split("\\.");
        JsonNode current = rootNode;

        for (String part : parts) {
            if (current == null || !current.isObject()) {
                return null;
            }
            current = current.get(part);
        }

        return current;
    }

    // --- Getter Methods ---

    public String getString(String path) {
        return getString(path, null);
    }

    public String getString(String path, String def) {
        JsonNode node = getNode(path);
        return (node != null && node.isValueNode()) ? node.asText() : def;
    }

    public int getInt(String path) {
        return getInt(path, 0);
    }

    public int getInt(String path, int def) {
        JsonNode node = getNode(path);
        return (node != null && node.isNumber()) ? node.asInt() : def;
    }

    public boolean getBoolean(String path) {
        return getBoolean(path, false);
    }

    public boolean getBoolean(String path, boolean def) {
        JsonNode node = getNode(path);
        return (node != null && node.isBoolean()) ? node.asBoolean() : def;
    }

    public List<String> getStringList(String path) {
        JsonNode node = getNode(path);
        if (node == null || !node.isArray()) {
            return Collections.emptyList();
        }

        List<String> list = new ArrayList<>();
        for (JsonNode element : node) {
            list.add(element.asText());
        }
        return list;
    }

    public List<String> getKeys() {
        return getKeys("");
    }

    public List<String> getKeys(String path) {
        JsonNode node = getNode(path);
        if (node == null || !node.isObject()) {
            return Collections.emptyList();
        }

        List<String> keys = new ArrayList<>();
        Iterator<String> fieldNames = node.fieldNames();
        while (fieldNames.hasNext()) {
            keys.add(fieldNames.next());
        }
        return keys;
    }
}