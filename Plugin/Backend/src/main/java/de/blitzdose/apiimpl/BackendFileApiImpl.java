package de.blitzdose.apiimpl;

import de.blitzdose.api.BackendApiInstance;

import java.util.List;

public class BackendFileApiImpl {
    private final BackendApiInstance instance;

    public BackendFileApiImpl(BackendApiInstance instance) {
        this.instance = instance;
    }


    public List<String> getEditableFiles() {
        return instance.configGetStringList("Webserver.editable-files");
    }

    public void setEditableFiles(List<String> editableFiles) {
        instance.configUpdate("Webserver.editable-files", editableFiles);
    }
}
