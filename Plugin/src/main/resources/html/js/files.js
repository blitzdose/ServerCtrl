let path = "/";
let filesSaved;
let itemsPerPage = 25;
let currentPage = 0;

let knownFileTypes = ['txt', 'yml', 'json', 'properties', 'log']

function loadKnownFileTypes() {
    $.ajax({
        url: "/api/files/editable-files",
        dataType: "json"
    }).done(function(data) {
        if (data.success) {
            knownFileTypes = data.fileExtensions;
            loadFiles();
        }
    });
}

loadKnownFileTypes();

var myCodeMirror;

let checkedElems = [];

$('.fab, .fab-options').mouseenter(function () {
    $('.fab-backdrop')[0].style.pointerEvents = "all";
});

$('.fab, .fab-options').mouseleave(function () {
    setTimeout(function() {
        $('.fab-backdrop')[0].style.pointerEvents = "none";
    }, 100);
});

function setItemsPerPage(items) {
    itemsPerPage = items;
    $('#itemsPerPage').text(itemsPerPage);
    loadFiles();
}

function changePage(page) {
    currentPage = page;
    loadFiles();
}

function nextPage() {
    currentPage = currentPage + 1;
    loadFiles();
}

function prevPage() {
    currentPage = currentPage -1;
    loadFiles();
}

function calcAndDisplayPages(count) {
    let pages;
    if (count % itemsPerPage === 0) {
        pages = (count / itemsPerPage | 0);
    } else {
        pages = (count / itemsPerPage | 0) + 1;
    }

    if (currentPage >= pages) {
        currentPage = pages - 1;
    } else if (currentPage < 0) {
        currentPage = 0;
    }
    if (currentPage <= 0) {
        currentPage = 0;
    }

    let pagination = $('#files-pagination');
    pagination.html('<li class="page-item"><a class="page-link" href="#" onclick="prevPage()">\n' +
        '                                <span aria-hidden="true">&laquo;</span>\n' +
        '                            </a></li>\n' +
        '                            <li id="last-page" class="page-item"><a class="page-link" href="#" onclick="nextPage()">\n' +
        '                                <span aria-hidden="true">&raquo;</span>\n' +
        '                            </a></li>');

    let lastPage = $('#last-page');

    let nextPages = 3;
    if (currentPage === 1) {
        nextPages = 4;
    } else if (currentPage === 0) {
        nextPages = 5;
    }

    let prevPages = 2;
    if (pages - currentPage === 2) {
        prevPages = 3;
    } else if (pages - currentPage === 1) {
        prevPages = 4;
    }

    for (let i=currentPage-prevPages; i<currentPage+nextPages; i++)  {
        if (i < 0 || i >= pages) {
            continue;
        }
        if (i === currentPage) {
            lastPage.before('<li class="page-item active"><a class="page-link" href="#" onclick="changePage(' + i + ')">' + (i+1) + '</a></li>');
        } else {
            lastPage.before('<li class="page-item"><a class="page-link" href="#" onclick="changePage(' + i + ')">' + (i+1) + '</a></li>');
        }
    }
}

function loadFiles() {
    $.ajax({
        type: "POST",
        url: "/api/files/count",
        data: JSON.stringify({ path: path}),
        contentType: "application/json",
        dataType: "json",
    }).done(function( data ) {
        if (data.success) {
            calcAndDisplayPages(data.count);

            $('#itemsPerPage').text(itemsPerPage);

            $.ajax({
                type: "POST",
                url: "/api/files/list",
                data: JSON.stringify({ path: path, limit: itemsPerPage, position: currentPage * itemsPerPage }),
                contentType: "application/json",
                dataType: "json",
                error: function (request, status, error) {
                    if (request.status === 403) {
                        Swal.fire({
                            icon: 'error',
                            title: $('#stop').text(),
                            text: $('#no_access').text(),
                            showConfirmButton: false,
                            allowEnterKey: false,
                            allowEscapeKey: false,
                            allowOutsideClick: false,
                        })
                    }
                }
            }).done(function( data ) {
                if (data.success) {
                    let filesElem = $('#files');
                    filesElem.empty();
                    let files = data.data;
                    filesSaved = files;
                    files.sort(function (a, b) {
                        return b.type.toString().localeCompare(a.type.toString()) || a.name.localeCompare(b.name)
                    });

                    filesElem.append('<button onclick="no(event)" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between no-change-on-hover" id="files-top-bar">' +
                        '                 <div class="d-flex pe-2" onclick="checkFile(event);"><input class="fileCheckBox clickable" id="allfiles" type="checkbox" value="" onclick="selectAllFiles(event);"></div>' +
                        '                 <div class="w-100 text-end row justify-content-end">' +
                        '                     <a class="btn btn-primary clickable col-5 me-2 max-w-fit-content d-flex align-items-center" href="" onclick="downloadSelected(event)" role="button"><span class="material-icons-round">file_download</span><span class="hide-when-small">' + $('#download_selected').text() + '</span></a>' +
                        '                     <a class="btn btn-danger clickable col-5 max-w-fit-content d-flex align-items-center" href="" onclick="removeSelected(event)" role="button"><span class="material-icons-round">delete_forever</span><span class="hide-when-small">' + $('#remove_selected').text() + '</span></a>' +
                        '                 </div>' +
                        '             </button>');

                    if (path !== "/") {
                        filesElem.append('<button onclick="fileClick(\'..\')" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between">' +
                            '                 <div class="d-flex align-items-center w-100">' +
                            '                     <span class="material-icons-round me-2">arrow_upward</span>' +
                            '..' +
                            '                 </div>' +
                            '                 <div class="w-100 text-end"></div>' +
                            '                 <div class="w-100 text-end"></div>' +
                            '             </button>');
                    }

                    for (let file of files) {
                        let icon = "description";
                        let filesize = humanFileSize(file.size, true);
                        let deleteButton = "";
                        if (file.type === 1) {
                            icon = "folder"
                            filesize = "";
                            deleteButton = '<div class="text-end d-flex align-items-center"><span class="folder-icon material-icons-round ms-2" style="color: #EE6055">clear</span></div>'
                        }

                        filesElem.append('<button onclick="fileClick(\'' + file.name + '\')" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between p-0 pe-3">' +
                            '                 <div class="d-flex pe-2 py-2 ps-3" onclick="checkFile(event);"><input class="fileCheckBox" id="' + icon + ': ' + file.name + '" type="checkbox" value="" onclick="no(event);"></div>' +
                            '                 <div class="filename d-flex align-items-center w-100">' +
                            '                     <span class="material-icons-round me-2">' + icon + '</span><span class="filename-span">' +
                            file.name +
                            '                 </span></div>' +
                            '                 <div class="nowrap-1l text-end">' +
                            filesize +
                            '                 </div>' +
                            '                 <div class="nowrap-1l text-end mobile-hidden">' +
                            convertTime(file) +
                            '                 </div>' +
                            deleteButton +
                            '             </button>');
                    }
                    $('.folder-icon').click(function (event) {
                        let filename = $(this).parent().parent().find('.filename').find('.filename-span').text().replace('<span class="material-icons-round me-2">folder</span>', '').trim();

                        let clickedFile;
                        for (let file of filesSaved) {
                            if (file.name === filename) {
                                clickedFile = file;
                            }
                        }
                        Swal.fire({
                            title: $('#you_sure').text(),
                            text: $('#really_delete').text().replace("[...]", clickedFile.name),
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonColor: '#327f31',
                            cancelButtonColor: '#EE6055',
                            cancelButtonText: $('#cancel').text(),
                            confirmButtonText: $('#yes_delete').text()
                        }).then((result) => {
                            if (result.isConfirmed) {
                                $.ajax({
                                    type: "POST",
                                    url: "/api/files/delete",
                                    contentType: "application/json",
                                    data: JSON.stringify({ path: path, name: clickedFile.name, dir: true }),
                                    dataType: "json"
                                }).done(function(data) {
                                    if (data.success) {
                                        Swal.fire({
                                            icon: 'success',
                                            title: $('#deleted').text(),
                                            text: $('#folder_deleted').text(),
                                            showConfirmButton: false,
                                            timer: 1500
                                        }).then(result => {
                                            loadFiles();
                                        });
                                    } else {
                                        Swal.fire({
                                            icon: 'error',
                                            title: $('#something_went_wrong').text(),
                                            showConfirmButton: false,
                                            timer: 1500
                                        }).then((result) => {
                                            loadFiles();
                                        });
                                    }
                                });
                            }
                        });
                        event.stopPropagation();
                    });
                }
            });
        }
    });
}

function downloadSelected(event) {

    let checkboxes = $(".fileCheckBox");
    let toBeDownloaded = [];
    for (let checkbox of checkboxes) {
        if (checkbox.checked) {
            if (checkbox.id.startsWith("description: ")) {
                toBeDownloaded.push({name: checkbox.id.replace("description: ", ""), dir: false});
            } else if (checkbox.id.startsWith("folder: ")){
                toBeDownloaded.push({name: checkbox.id.replace("folder: ", ""), dir: true});
            }
        }
    }

    let swal = Swal.fire({
        title: $('#loading').text(),
        timerProgressBar: true,
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading()
        }
    });

    $.ajax({
        type: "POST",
        url: "/api/files/download-multiple",
        data: JSON.stringify({ path: path, names: toBeDownloaded}),
        dataType: "json"
    }).done(function(data) {
        if (data.success) {
            swal.close();
            window.location = "/api/files/download?id=" + data.id;
        } else {
            Swal.fire({
                icon: 'error',
                title: $('#something_went_wrong').text(),
                showConfirmButton: false,
                timer: 1500
            }).then((result) => {
                loadFiles();
            });
        }
    });

    event.preventDefault();
}


function removeSelected(event) {
    Swal.fire({
        title: $('#you_sure').text(),
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#327f31',
        cancelButtonColor: '#EE6055',
        cancelButtonText: $('#cancel').text(),
        confirmButtonText: $('#yes_delete').text()
    }).then((result) => {
        if (result.isConfirmed) {
            let checkboxes = $(".fileCheckBox");
            let toBeDeleted = [];
            for (let checkbox of checkboxes) {
                if (checkbox.checked) {
                    if (checkbox.id.startsWith("description: ")) {
                        toBeDeleted.push({name: checkbox.id.replace("description: ", ""), dir: false});
                    } else if (checkbox.id.startsWith("folder: ")){
                        toBeDeleted.push({name: checkbox.id.replace("folder: ", ""), dir: true});
                    }
                }
            }

            $.ajax({
                type: "POST",
                url: "/api/files/delete-multiple",
                data: JSON.stringify({ path: path, names: toBeDeleted}),
                dataType: "json",
                contentType: "application/json"
            }).done(function(data) {
                if (data.success) {
                    Swal.fire({
                        icon: 'success',
                        title: $('#deleted').text(),
                        showConfirmButton: false,
                        timer: 1500
                    }).then(result => {
                        loadFiles();
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: $('#something_went_wrong').text(),
                        showConfirmButton: false,
                        timer: 1500
                    }).then((result) => {
                        loadFiles();
                    });
                }
            });
        }
    });
    event.preventDefault();
}

function selectAllFiles(event) {
    let checkboxes = $(".fileCheckBox");
    for (let checkbox of checkboxes) {
        checkbox.checked = event.target.checked;
    }
    event.stopPropagation();
}

function no(event) {
    event.stopPropagation()
}

function checkFile(event) {
    let checkbox = event.target.getElementsByTagName("input")[0];
    checkbox.checked = !checkbox.checked;

    event.stopPropagation()
}

function createDir() {
    Swal.fire({
        title: $('#name').text(),
        input: 'text',
        inputAttributes: {
            autocapitalize: 'off'
        },
        showCancelButton: true,
        cancelButtonColor: '#EE6055',
        cancelButtonText: $('#cancel').text(),
        confirmButtonText: $('#create_folder').text(),
        confirmButtonColor: '#327f31',
        showLoaderOnConfirm: true,
        preConfirm: (newName) => {
            return fetch('/api/files/create-dir', {
                method: 'POST',
                body: JSON.stringify({ path: path, name: newName }),
            })
                .then(response => {
                    response.json().then(json => {
                        if (json.success) {
                            Swal.fire({
                                icon: 'success',
                                title: $('#folder_created').text(),
                                showConfirmButton: false,
                                timer: 1500
                            }).then((result) => {
                                loadFiles();
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: $('#something_went_wrong').text(),
                                showConfirmButton: false,
                                timer: 1500
                            }).then((result) => {
                                loadFiles();
                            });
                        }
                    });
                    if (!response.ok) {
                        throw new Error(response.statusText)
                    }
                    return response.json()
                })
                .catch(error => {
                    Swal.fire({
                        icon: 'error',
                        title: $('#something_went_wrong').text(),
                        showConfirmButton: false,
                        timer: 1500
                    }).then((result) => {
                        loadFiles();
                    });
                })
        },
        backdrop: true,
        allowOutsideClick: () => !Swal.isLoading()
    });
}

function createFile() {
    Swal.fire({
        title: $('#name').text(),
        input: 'text',
        inputAttributes: {
            autocapitalize: 'off'
        },
        showCancelButton: true,
        cancelButtonColor: '#EE6055',
        cancelButtonText: $('#cancel').text(),
        confirmButtonText: $('#create_file').text(),
        confirmButtonColor: '#327f31',
        showLoaderOnConfirm: true,
        preConfirm: (newName) => {
            return fetch('/api/files/create-file', {
                method: 'POST',
                body: JSON.stringify({ path: path, name: newName }),
            })
                .then(response => {
                    response.json().then(json => {
                        if (json.success) {
                            Swal.fire({
                                icon: 'success',
                                title: $('#file_created').text(),
                                showConfirmButton: false,
                                timer: 1500
                            }).then((result) => {
                                loadFiles();
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: $('#something_went_wrong').text(),
                                showConfirmButton: false,
                                timer: 1500
                            }).then((result) => {
                                loadFiles();
                            });
                        }
                    });
                    if (!response.ok) {
                        throw new Error(response.statusText)
                    }
                    return response.json()
                })
                .catch(error => {
                    Swal.fire({
                        icon: 'error',
                        title: $('#something_went_wrong').text(),
                        showConfirmButton: false,
                        timer: 1500
                    }).then((result) => {
                        loadFiles();
                    });
                })
        },
        backdrop: true,
        allowOutsideClick: () => !Swal.isLoading()
    });
}

function fileClick(filename) {
    if (filename === "..") {
        path = path.substr(0, path.length-1);
        path = path.substr(0, path.lastIndexOf("/")+1);

        loadFiles();
    } else {
        let clickedFile;
        for (let file of filesSaved) {
            if (file.name === filename) {
                clickedFile = file;
                if (file.type === 1) {
                    path = path + filename + "/";
                    loadFiles();
                    return;
                }
            }
        }
        if (clickedFile === undefined) {
            return;
        }

        let downloadButtonText = $('#download').text();
        let editable = false;
        if (knownFileTypes.includes(getFileType(clickedFile.name.toLowerCase()))) {
            downloadButtonText = $('#download_edit').text();
            editable = true;
        }

        Swal.fire({
            title: filename,
            text: $('#what_do').text(),
            icon: 'question',
            showCloseButton: true,
            showCancelButton: true,
            showDenyButton: true,
            confirmButtonColor: '#327f31',
            denyButtonColor: '#EE6055',
            cancelButtonColor: '#2274A5',
            confirmButtonText: downloadButtonText,
            denyButtonText: $('#delete').text(),
            cancelButtonText: $('#rename').text()
        }).then(async (result) => {
            if (result.isConfirmed) {
                if (editable) {
                    let swal = Swal.fire({
                        title: $('#loading').text(),
                        timerProgressBar: true,
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading()
                        }
                    });
                    $.ajax({
                        type: "POST",
                        url: "/api/files/download",
                        data: JSON.stringify({ path: path, name: clickedFile.name }),
                        contentType: "application/json",
                        dataType: "json"
                    }).done(function(data) {
                        if (data.success) {
                            $.ajax({
                                type: "GET",
                                url: "/api/files/download?id=" + data.id,
                            }).done(function(data) {
                                swal.close();
                                Swal.fire({
                                    title: clickedFile.name,
                                    customClass: {
                                        popup: 'customSwal'
                                    },
                                    showCloseButton: true,
                                    confirmButtonText: $('#save').text(),
                                    confirmButtonColor: '#327f31',
                                    showDenyButton: true,
                                    denyButtonText: $('#download').text(),
                                    denyButtonColor: '#2274A5',
                                    cancelButtonColor: '#EE6055',
                                    cancelButtonText: $('#cancel').text(),
                                    backdrop: true,
                                    allowOutsideClick: false,
                                    allowEnterKey: false,
                                    allowEscapeKey: false,
                                    html: '<div id="code-editor" style="height: 60vh; width: 80vw; text-align: start" class="swal-input2"></div>', /*<textarea id="swal-input2" class="swal2-input text-area" style="height: 60vh; width: 80vw" oninput="update(this.value);">' + data + '</textarea>',*/
                                    showCancelButton: true,
                                    preDeny: function () {
                                        return fetch('/api/files/download/', {
                                            method: 'POST',
                                            body: JSON.stringify({path: path, name: clickedFile.name}),
                                        }).then(response => {
                                            response.json().then(json => {
                                                if (json.success) {
                                                    window.location = "/api/files/download?id=" + json.id;
                                                }
                                            })
                                        });
                                    },
                                    preConfirm: function () {
                                        let content = $('#swal-input2').val();
                                        content = myCodeMirror.getValue();
                                        let swal = Swal.fire({
                                            title: $('#saving').text(),
                                            timerProgressBar: true,
                                            allowOutsideClick: false,
                                            didOpen: () => {
                                                Swal.showLoading()
                                            }
                                        });
                                        var blob = new Blob([content], {type : 'text/plain'});
                                        let formData = new FormData();
                                        formData.append("tmp", "");
                                        formData.append("path", path);
                                        formData.append("file", blob, clickedFile.name);

                                        $.ajax({
                                            type: "POST",
                                            url: "/api/files/upload",
                                            data: formData,
                                            processData: false,
                                            contentType: false,
                                        }).done(function( data ) {
                                            swal.close();
                                            Swal.fire({
                                                icon: 'success',
                                                title: $('#file_saved').text(),
                                                showConfirmButton: false,
                                                timer: 1500
                                            });
                                            loadFiles();
                                        });
                                    }
                                }).then((result) => {
                                    loadFiles();
                                });
                                let mode;
                                let fileType = getFileType(clickedFile.name.toLowerCase());
                                if (fileType === "yml") {
                                    mode = {name: "yaml"}
                                } else if (fileType === "json") {
                                    mode = {name: "javascript", json: true}
                                } else if (fileType === "properties") {
                                    mode = {name: "properties"}
                                } else {
                                    mode = {name: "text/plain"}
                                }

                                let theme = "idea";
                                if (localStorage.getItem("darkmode") === "1") {
                                    theme = "dracula";
                                }

                                myCodeMirror = CodeMirror($('#code-editor')[0], {
                                    value: data,
                                    mode: mode,
                                    theme: theme
                                });
                                $('#code-editor').parent()[0].style = "border: #595959 solid 2px; border-radius: 5px;"
                                //$('<div class="info-keybinds"><b>Search:</b> CTRL+F &emsp; <b>Replace:</b> CTRL+Shift+F &emsp; <b>Replace all:</b> CTRL+Shift+R</div>').insertAfter($('#code-editor').parent());
                                $('<div class="row justify-content-center">' +
                                    '<div class="col info-keybinds">' +
                                        '<button type="button" class="btn btn-primary btn-sm me-2" onclick="myCodeMirror.execCommand(\'find\')">Search</button>' +
                                    '</div>' +
                                    '<div class="col info-keybinds">' +
                                        '<button type="button" class="btn btn-primary btn-sm me-2" onclick="myCodeMirror.execCommand(\'replace\')">Replace</button>' +
                                    '</div>' +
                                    '<div class="col info-keybinds">' +
                                        '<button type="button" class="btn btn-primary btn-sm" onclick="myCodeMirror.execCommand(\'replaceAll\')">Replace all</button>' +
                                    '</div>' +
                                '</div>').insertAfter($('#code-editor').parent());

                            });
                        }
                    });
                } else {
                    $.ajax({
                        type: "POST",
                        url: "/api/files/download",
                        data: JSON.stringify({ path: path, name: clickedFile.name }),
                        dataType: "json"
                    }).done(function(data) {
                        if (data.success) {
                            window.location = "/api/files/download?id=" + data.id;
                        }
                    });
                }
            } else if (result.dismiss === Swal.DismissReason.cancel) { // Rename
                Swal.fire({
                    title: $('#new_name').text(),
                    input: 'text',
                    inputAttributes: {
                        autocapitalize: 'off'
                    },
                    inputValue: clickedFile.name,
                    showCancelButton: true,
                    cancelButtonColor: '#EE6055',
                    confirmButtonText: $('#rename').text(),
                    confirmButtonColor: '#327f31',
                    showLoaderOnConfirm: true,
                    preConfirm: (newName) => {
                        return fetch('/api/files/rename', {
                            method: 'POST',
                            body: JSON.stringify({ path: path, name: clickedFile.name, newName: newName }),
                        })
                            .then(response => {
                                response.json().then(json => {
                                    if (json.success) {
                                        Swal.fire({
                                            icon: 'success',
                                            title: $('#file_renamed').text(),
                                            showConfirmButton: false,
                                            timer: 1500
                                        }).then((result) => {
                                            loadFiles();
                                        });
                                    } else {
                                    Swal.fire({
                                        icon: 'error',
                                        title: $('#something_went_wrong').text(),
                                        showConfirmButton: false,
                                        timer: 1500
                                    }).then((result) => {
                                        loadFiles();
                                    });
                                }
                                });
                                if (!response.ok) {
                                    throw new Error(response.statusText)
                                }
                                return response.json()
                            })
                            .catch(error => {
                                Swal.fire({
                                    icon: 'error',
                                    title: $('#something_went_wrong').text(),
                                    showConfirmButton: false,
                                    timer: 1500
                                }).then((result) => {
                                    loadFiles();
                                });
                            })
                    },
                    backdrop: true,
                    allowOutsideClick: () => !Swal.isLoading()
                });
            } else if (result.value === false) { // Delete
                Swal.fire({
                    title: $('#you_sure').text(),
                    text: $('#really_delete').text().replace("[...]", clickedFile.name),
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#327f31',
                    cancelButtonColor: '#EE6055',
                    cancelButtonText: $('#cancel').text(),
                    confirmButtonText: $('#yes_delete').text()
                }).then((result) => {
                    if (result.isConfirmed) {
                        $.ajax({
                            type: "POST",
                            url: "/api/files/delete",
                            data: JSON.stringify({ path: path, name: clickedFile.name, dir: false }),
                            dataType: "json"
                        }).done(function(data) {
                            if (data.success) {
                                Swal.fire({
                                    icon: 'success',
                                    title: $('#deleted').text(),
                                    text: $('#file_deleted').text(),
                                    showConfirmButton: false,
                                    timer: 1500
                                }).then(result => {
                                    loadFiles();
                                });
                            } else {
                                Swal.fire({
                                    icon: 'error',
                                    title: $('#something_went_wrong').text(),
                                    showConfirmButton: false,
                                    timer: 1500
                                }).then((result) => {
                                    loadFiles();
                                });
                            }
                        });
                    }
                });
            }
        });
    }

}

$('#folderupload').change(function () {
    handleUpload($(this));
})

$('#fileupload').change(function () {
    handleUpload($(this));
})

function handleUpload(elem) {
    let swal = Swal.fire({
        title: $('#upload').text(),
        text: "0%",
        timerProgressBar: true,
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading()
        }
    });

    let formData = new FormData();
    formData.append("placeholder", "");
    formData.append("path", path);

    for (let i = 0; i < elem[0].files.length; i++) {
        let file = elem[0].files[i];
        formData.append(file.name, file);
    }

    $.ajax({
        uploadProgress: function(e) {
            // track uploading
            if (e.lengthComputable) {
                let completedPercentage = Math.round((e.loaded * 100) / e.total);
                $('#swal2-html-container').text(completedPercentage + "%");
            }
        },
        type: "POST",
        url: "/api/files/upload",
        data: formData,
        processData: false,
        contentType: false,
    }).done(function( data ) {
        let icon;
        let title;
        let text;
        let timer;
        if (data.success) {
            icon = "success";
            title = $('#file_uploaded').text();
            text = ""
            timer = 1500;
        } else {
            icon = "error";
            title = $('#something_went_wrong').text()
            text = data.message;
            timer = 3000;
        }
        swal.close();
        Swal.fire({
            icon: icon,
            title: title,
            text: text,
            showConfirmButton: false,
            timer: timer
        });
        loadFiles();
    });

   elem.val("");
}

function startUpload() {
    $('#fileupload').click();
}

function startUploadFolder() {
    $('#folderupload').click();
}

function getFileType(filename) {
    return filename.slice(filename.lastIndexOf('.')+1, filename.length);
}

function convertTime(file) {
    let dateJson = file.date;
    let date = new Date(dateJson.year, dateJson.month - 1, dateJson.dayOfMonth, dateJson.hourOfDay, dateJson.minute, dateJson.second);
    return date.toISOString().slice(0,10) + " " +  date.toISOString().slice(11,16);
}

function humanFileSize(bytes, si=false, dp=1) {
    const thresh = si ? 1000 : 1024;

    if (Math.abs(bytes) < thresh) {
        return bytes + ' Byte';
    }

    const units = si
        ? ['KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
        : ['KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB'];
    let u = -1;
    const r = 10**dp;

    do {
        bytes /= thresh;
        ++u;
    } while (Math.round(Math.abs(bytes) * r) / r >= thresh && u < units.length - 1);


    return bytes.toFixed(dp) + ' ' + units[u];
}

function update(text) {
    $('#highlighting-content').text(text);
    hljs.highlightAll();
    //Prism.highlightElement(result_element);
}