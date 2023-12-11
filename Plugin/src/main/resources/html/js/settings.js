getSettings();
getCookieSettings();
getServerNameSettings();
getAndGenerateServerSettings();

function getSettings() {
    $.ajax({
        url: "/api/plugin/settings/",
        error: function () {
            $('#plugin-card').hide();
        }
    }).done(function( data ) {
        if (data.success) {
            $('#enable-HTTPS').prop('checked', data.Webserver.Https);
            $('#webserver-port').val(data.Webserver.Port);
        }
    });
}

function getCookieSettings() {
    let darkmode = localStorage.getItem('darkmode');
    if (darkmode === null) {
        localStorage.setItem('darkmode', '0');
        darkmode = '0';
    }

    if (darkmode === '1') {
        $('#enable-darkmode').prop('checked', true);
    } else {
        $('#enable-darkmode').prop('checked', false);
    }


    let hideRestartButton = localStorage.getItem('hideRestartButton');
    if (hideRestartButton === null) {
        localStorage.setItem('hideRestartButton', '0');
        hideRestartButton = '0';
    }

    if (hideRestartButton === '1') {
        $('#hide-restart-button').prop('checked', true);
    } else {
        $('#hide-restart-button').prop('checked', false);
    }


    let language = localStorage.getItem('language');
    if (language === null) {
        localStorage.setItem('language', 'en');
        language = 'en';
    }

    $('#language').val(language);
}

function getServerNameSettings() {
    $.ajax({
        url: "/api/user/permissions",
    }).done(function( data ) {
        if (data.success) {
            if (!data.permissions.includes("pluginsettings")) {
                $('#server-name-element').hide();
            }
        }
    });

    $.ajax({
        url: "/api/server/name/",
        error: function () {
            $('#server-name-element').hide();
        }
    }).done(function( data ) {
        if (data.success) {
            $('#servername').val(data.servername);
        }
    });
}

$('#webinterface-form').submit(function (event) {
    event.preventDefault();

    let darkmode = $('#enable-darkmode').is(':checked');
    if (darkmode) {
        localStorage.setItem('darkmode', '1');
    } else {
        localStorage.setItem('darkmode', '0');
    }

    let hideRestartButton = $('#hide-restart-button').is(':checked');
    if (hideRestartButton) {
        localStorage.setItem('hideRestartButton', '1');
    } else {
        localStorage.setItem('hideRestartButton', '0');
    }

    let language = $('#language').val();
    localStorage.setItem('language', language);

    document.cookie = "language=" + language;

    let data = {};
    data.servername = $('#servername').val();

    let r = document.querySelector(':root');
    let colorPrimary = getComputedStyle(r).getPropertyValue('--bs-primary');
    let colorPrimaryRGB = getComputedStyle(r).getPropertyValue('--bs-primary-rgb');
    let colorPrimaryDark = getComputedStyle(r).getPropertyValue('--bs-primary-dark');

    data.color = {};
    data.color.primary = colorPrimary;
    data.color.primaryRGB = colorPrimaryRGB;
    data.color.primaryDark = colorPrimaryDark;

    localStorage.setItem("colors", JSON.stringify(data.color));

    if ($('#server-name-element').is(":visible")) {
        $.ajax({
            url: "/api/server/name/",
            method: "POST",
            data: JSON.stringify(data),
            dataType: "json"
        }).done(function( data ) {
            Swal.fire({
                icon: 'success',
                title: $('#saved').text(),
                showConfirmButton: false,
                timer: 1500
            }).then(result => {
                location.reload();
            });
        });
    } else {
        location.reload();
    }
});

$('#generate-https-cert').click(function () {
    Swal.fire({
        title: $('#certificate').text(),
        customClass: {
            popup: 'customSwal'
        },
        showCloseButton: true,
        confirmButtonText: $('#save').text(),
        confirmButtonColor: '#327f31',
        cancelButtonColor: '#EE6055',
        cancelButtonText: $('#cancel').text(),
        backdrop: true,
        allowOutsideClick: false,
        allowEnterKey: false,
        allowEscapeKey: false,
        html: "<label for=\"name\" class=\"form-label\">Domain or IP-Address</label>\n" +
            "                                    <div class=\"input-group mb-3 has-validation\">\n" +
            "                                        <input type=\"text\" class=\"form-control\" id=\"name\" aria-describedby=\"cert-label\">\n" +
            "                                        <div class=\"invalid-feedback\">Cannot be empty</div>\n" +
            "                                    </div>",
        showCancelButton: true,
        preConfirm: function () {

            let name = $('#name');

            name.removeClass('is-invalid');

            if (name.val() === "") {
                name.addClass('is-invalid');
                return false;
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
                url: "/api/plugin/certificate/generate",
                method: "POST",
                data: JSON.stringify({name: name.val()}),
                contentType: "application/json"
            }).done(function( data ) {
                if (data.success) {
                    swal.close();
                    Swal.fire({
                        icon: 'success',
                        title: $('#saved').text(),
                        showConfirmButton: false,
                        timer: 1500
                    }).then(result => {
                        location.reload();
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: $('#something_went_wrong').text(),
                        showConfirmButton: false,
                        timer: 1500
                    }).then((result) => {
                        location.reload();
                    });
                }
            })
        }
    }).then((result) => {

    });
})

$('#change-https-cert').click(function () {
    Swal.fire({
        title: $('#certificate').text(),
        customClass: {
            popup: 'customSwal'
        },
        showCloseButton: true,
        confirmButtonText: $('#save').text(),
        confirmButtonColor: '#327f31',
        cancelButtonColor: '#EE6055',
        cancelButtonText: $('#cancel').text(),
        backdrop: true,
        allowOutsideClick: false,
        allowEnterKey: false,
        allowEscapeKey: false,
        html: "<ul class=\"nav nav-tabs justify-content-center mb-2\" id=\"myTab\" role=\"tablist\">\n" +
            "  <li class=\"nav-item\" role=\"presentation\">\n" +
            "    <button class=\"nav-link active\" id=\"upload-cert-tab\" data-bs-toggle=\"tab\" data-bs-target=\"#upload-cert\" type=\"button\" role=\"tab\" aria-controls=\"home\" aria-selected=\"true\">Upload</button>\n" +
            "  </li>\n" +
            "  <li class=\"nav-item\" role=\"presentation\">\n" +
            "    <button class=\"nav-link\" id=\"copypaste-cert-tab\" data-bs-toggle=\"tab\" data-bs-target=\"#copypaste-cert\" type=\"button\" role=\"tab\" aria-controls=\"profile\" aria-selected=\"false\">Copy/Paste</button>\n" +
            "  </li>\n" +
            "</ul>\n" +
            "<div class=\"tab-content\" id=\"myTabContent\">\n" +
            "  <div class=\"tab-pane fade show active\" id=\"upload-cert\" role=\"tabpanel\" aria-labelledby=\"upload-cert-tab\">" +
            "<label for=\"cert-cert\" class=\"form-label\">Zertifikat (z.B. cert.pem)</label>\n" +
            "                                    <div class=\"input-group mb-3 has-validation\">\n" +
            "                                        <input type=\"file\" class=\"form-control\" id=\"cert-cert\" accept=\".pem,.crt,.cert\" aria-describedby=\"cert-label\">\n" +
            "                                        <div class=\"invalid-feedback\">Certificate AND key must be provided.</div>\n" +
            "                                    </div><hr>\n" +
            "                                    <label for=\"cert-key\" class=\"form-label\">Zertifikatsschlüssel (z.B. privkey.pem)</label>\n" +
            "                                    <div class=\"input-group mb-3 has-validation\">\n" +
            "                                        <input type=\"file\" class=\"form-control\" id=\"cert-key\" accept=\".pem,.crt,.cert\" aria-describedby=\"cert-key-label\">\n" +
            "                                        <div class=\"invalid-feedback\">Certificate AND key must be provided.</div>\n" +
            "                                    </div>" +
            "</div>\n" +
            "  <div class=\"tab-pane fade\" id=\"copypaste-cert\" role=\"tabpanel\" aria-labelledby=\"copypaste-cert-tab\">" +
            "<label for=\"cert-cert\" class=\"form-label\">Zertifikat (z.B. cert.pem)</label>\n" +
            "                                    <div class=\"input-group mb-3 has-validation\">\n" +
            "                                        <textarea class=\"form-control pem-text\" id=\"cert-cert-text\" aria-describedby=\"cert-label\"></textarea>\n" +
            "                                        <div class=\"invalid-feedback\">Certificate AND key must be provided.</div>\n" +
            "                                    </div><hr>\n" +
            "                                    <label for=\"cert-key\" class=\"form-label\">Zertifikatsschlüssel (z.B. privkey.pem)</label>\n" +
            "                                    <div class=\"input-group mb-3 has-validation\">\n" +
            "                                        <textarea class=\"form-control pem-text\" id=\"cert-key-text\" aria-describedby=\"cert-key-label\"></textarea>\n" +
            "                                        <div class=\"invalid-feedback\">Certificate AND key must be provided.</div>\n" +
            "                                    </div>" +
            "</div>\n" +
            "</div>",
        showCancelButton: true,
        preConfirm: function () {
            let formData = new FormData();

            if ($('#upload-cert-tab').hasClass('upload-cert-tab active')) {
                let certFile = $('#cert-cert');
                let certKeyFile = $('#cert-key');

                certFile.removeClass('is-invalid');
                certKeyFile.removeClass('is-invalid');

                if (certFile[0].files.length === 0) {
                    certFile.addClass('is-invalid');
                    return false;
                }

                if (certKeyFile[0].files.length === 0) {
                    certKeyFile.addClass('is-invalid');
                    return false;
                }

                formData.append('cert', certFile[0].files[0], 'cert.pem');
                formData.append("certKey", certKeyFile[0].files[0], 'key.pem');
            } else {
                let cert = $('#cert-cert-text');
                let key = $('#cert-key-text');

                cert.removeClass('is-invalid');
                key.removeClass('is-invalid');

                if (cert.val() === "") {
                    cert.addClass('is-invalid');
                    return false;
                }
                if (key.val() === "") {
                    key.addClass('is-invalid');
                    return false;
                }

                formData.append('cert', new Blob([cert.val()], {type: 'text/plain'}), 'cert.pem');
                formData.append('certKey', new Blob([key.val()], {type: 'text/plain'}), 'key.pem');

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
                url: "/api/plugin/certificate/upload",
                method: "POST",
                data: formData,
                processData: false,
                contentType: false,
                enctype: 'multipart/form-data',
            }).done(function( data ) {
                if (data.success) {
                    swal.close();
                    Swal.fire({
                        icon: 'success',
                        title: $('#saved').text(),
                        showConfirmButton: false,
                        timer: 1500
                    }).then(result => {
                        location.reload();
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: $('#something_went_wrong').text(),
                        showConfirmButton: false,
                        timer: 1500
                    }).then((result) => {
                        location.reload();
                    });
                }
            })
        }
    }).then((result) => {

    });
});

$('#plugin-form').submit(function (event) {
    event.preventDefault();

    let httpsEnabled = $('#enable-HTTPS').is(':checked');
    let webserverPort = $('#webserver-port').val();

    let formData = new FormData();

    formData.append('port', webserverPort);
    formData.append('https', httpsEnabled);

    $.ajax({
        type: "POST",
        url: "/api/plugin/settings/",
        data: formData,
        processData: false,
        contentType: false,
        enctype: 'multipart/form-data',
    }).done(function (data) {
        if (data.success) {
            Swal.fire({
                icon: 'success',
                title: $('#saved').text(),
                showConfirmButton: false,
                timer: 1500
            }).then(result => {
                location.reload();
            });
        } else {
            Swal.fire({
                icon: 'error',
                title: $('#something_went_wrong').text(),
                showConfirmButton: false,
                timer: 1500
            }).then((result) => {

            });
        }
    });
});

function getAndGenerateServerSettings() {
    $.ajax({
        url: "/api/server/settings/",
        error: function () {
            $('#server-card').hide();
        }
    }).done(function( returnDdata ) {
        if (returnDdata.success) {
            let data = returnDdata.data;
            let serverSettingsElem = $('#server-form');
            let keys = Object.keys(data);
            keys.sort();
            for (let key of keys) {
                serverSettingsElem.append('<div class="input-group mb-3">' +
                    '                            <span class="input-group-text" id="' + key + 'Label">' + key + '</span>' +
                    '                            <input type="text" class="form-control" id="' + key + '" aria-describedby="' + key + 'Label" value="' + data[key] + '">' +
                    '                        </div>')
            }
            serverSettingsElem.append('<button type="submit" class="btn btn-primary align-self-end">Save</button>');
        }
    });
}

$('#server-form').submit(function (event) {
    event.preventDefault();

    let data = {}

    $(this).children().each( function () {
        let elem = $(this).find("input");
        if (elem.length !== 0) {
            data[elem.attr('id')] = elem.val();
        }
    });

    $.ajax({
        type: "POST",
        url: "/api/server/settings/",
        data: JSON.stringify(data),
        dataType: "json"
    }).done(function (data) {
        if (data.success) {
            Swal.fire({
                icon: 'success',
                title: $('#saved').text(),
                showConfirmButton: false,
                timer: 1500
            }).then(result => {
                location.reload();
            });
        }
    });
});



let colorpicker;

$(function () {
    let r = document.querySelector(':root');
    let colors = JSON.parse(localStorage.getItem("colors"));
    if (colors === null) {
        colors = {};
        colors.primary = "#327f31";
    }

    colorpicker = $('#cp5a').colorpicker({
        format: 'auto',
        autoInputFallback: false,
        autoHexInputFallback: false,
        color: colors.primary,
        template: '<div class="colorpicker">' +
            '<div class="colorpicker-saturation"><i class="colorpicker-guide"></i></div>' +
            '<div class="colorpicker-hue"><i class="colorpicker-guide"></i></div>' +
            '<div class="colorpicker-alpha">' +
            '   <div class="colorpicker-alpha-color"></div>' +
            '   <i class="colorpicker-guide"></i>' +
            '</div>' +
            '<div class="colorpicker-bar"><button class="btn btn-default" onclick="setDefaultColor();">Default</button></div>' +
            '</div>'
    }).on('colorpickerChange colorpickerCreate', function (e) {
        e.colorpicker.picker.parents('.card').find('.card-header')
            .css('background-color', e.value);

        let hsl = e.color.string("hsl").replace("hsl(", "").replace(")", "");
        let lastPart = hsl.split(",")[2].trim().replace("%", "");
        if (parseInt(lastPart) - 20 < 0) {
            lastPart = parseInt(lastPart) + 20;
        } else {
            lastPart = parseInt(lastPart) - 20;
        }

        hsl = "hsl(" + hsl.split(",")[0] + ", " + hsl.split(",")[1] + ", " + lastPart + "%" + ")";

        r.style.setProperty('--bs-primary', e.value);
        r.style.setProperty('--bs-primary-rgb', e.color.string('rgb').replace("rgb(", "").replace(")", ""));
        r.style.setProperty("--bs-primary-dark", hsl);
    });
});

function setDefaultColor() {
    let r = document.querySelector(':root');
    r.style.setProperty('--bs-primary', '#327F31');
    r.style.setProperty('--bs-primary-rgb', '50, 127, 49');
    r.style.setProperty("--bs-primary-dark", 'hsl(119, 44%, 15%)');
    $('#color-text').val("#327f31");
}