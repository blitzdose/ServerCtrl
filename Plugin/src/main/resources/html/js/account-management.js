let allPermissions = [];

function loadAccounts() {
    let accountsListHtml = $("#accounts");
    $.ajax({
        url: "/api/account/all/",
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
                });
            }
        }
    }).done(function( data ) {
        if (data.success) {
            accountsListHtml.empty();
            let accounts = data.accounts;
            if (accounts.length === 0) {
                accountsListHtml.append('<h5>' + $('#no_accounts').text() + '</h5>');
            }
            accounts.sort(function (a, b) {
                a.localeCompare(b)
            });
            for (let account of accounts) {
                let accountHtml = '<li class="list-group-item">\n' +
                    '              <div class="d-flex align-items-center">\n' +
                    '                <span class="bi me-2 material-icons-round" style="font-size: xxx-large">person</span>\n' +
                    '                <div class="d-flex w-100 justify-content-between flex-column ms-3">\n' +
                    '                  <h5 id="accountname" class="mb-1">' + account + '</h5>\n' +
                    '                </div>\n' +
                    '              </div>\n' +
                    '              <div class="d-flex justify-content-end d-grid gap-3">\n' +
                    '                <button id="account-permission" type="button" class="btn btn-outline-primary kick account-permission">Permissions</button>\n' +
                    '                <button id="account-password" type="button" class="btn btn-outline-primary kick" data-bs-toggle="modal" data-bs-target="#set-password-modal" data-username="' + account + '">Reset Password</button>\n' +
                    '                <button type="button" class="btn btn-outline-primary kick account-delete">Delete</button>\n' +
                    '              </div>\n' +
                    '            </li>'
                accountsListHtml.append(accountHtml);
            }
        }
        getAllPermissions();
    });
}

function registerHandler() {
    $('.account-permission').click(function () {
        let username = $(this).parent().parent().find('#accountname').text();

        let swal = Swal.fire({
            title: $('#loading').text(),
            timerProgressBar: true,
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading()
            }
        });

        $.ajax({
            url: "/api/account/permissions?username=" + username,
            method: "GET"
        }).done(function( data ) {
            if (data.success) {
                swal.close();
                Swal.fire({
                    title: username,
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
                    html: formatPermissionsToHtml(data.permissions),
                    showCancelButton: true,
                    preConfirm: function () {
                        data = {};
                        data['user'] = username;
                        data['permissions'] = []
                        for (let permissionStr of allPermissions) {
                            let checkbox = $('#' + permissionStr)[0];
                            let permission = {}
                            permission['name'] = permissionStr;
                            permission['state'] = checkbox.checked;
                            data['permissions'].push(permission)
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
                            url: "/api/account/permissions/",
                            method: "POST",
                            contentType: "application/json",
                            data: JSON.stringify(data)
                        }).done(function( data ) {
                            if (data.success) {
                                swal.close();
                                Swal.fire({
                                    icon: 'success',
                                    title: $('#saved').text(),
                                    showConfirmButton: false,
                                    timer: 1500
                                }).then(result => {

                                });
                            }
                        })
                    }
                }).then((result) => {

                });
            }
        });
    })
    $('.account-delete').click(function () {
        let username = $(this).parent().parent().find('#accountname').text();

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
                $.ajax({
                    url: "/api/account/delete/",
                    method: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({"username": username})
                }).done(function( data ) {
                    if (data.success) {
                        swal.close();
                        Swal.fire({
                            icon: 'success',
                            title: $('#deleted').text(),
                            showConfirmButton: false,
                            timer: 1500
                        }).then(result => {
                            location.reload()
                        });
                    }
                });
            }
        });
    });
    $('#set-password-modal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget) // Button that triggered the modal
        var username = button.data('username') // Extract info from data-* attributes
        // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
        // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
        var modal = $(this)
        modal.find('#username-passchange').val(username)
    });
}

function formatPermissionsToHtml(permissions) {
    let permissionsListHtml = "";
    for (let permission of allPermissions) {
        let checked = "";
        if (permissions.includes(permission)) {
            checked = "checked";
        }
        permissionsListHtml = permissionsListHtml + '<button onclick="checkPermission(\'' + permission + '\');" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between p-0 pe-3" style="font-size: 1rem">' +
            '                 <div class="d-flex pe-2 py-2 ps-3""><input ' + checked + ' onclick="nopropagation(event)" class="fileCheckBox" id="' + permission + '" type="checkbox" value=""></div>' +
            '                 <div class="filename d-flex align-items-center w-100">' +
            permission +
            '                 </div>' +
            '             </button>';
    }
    return permissionsListHtml;
}

function nopropagation(event) {
    event.stopPropagation();
}

function checkPermission(permission) {
    let checkbox = $('#' + permission)[0]
    checkbox.checked = !checkbox.checked;
}

function getAllPermissions() {
    $.ajax({
        url: "/api/account/all-permissions/",
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
                });
            }
        }
    }).done(function( data ) {
        if (data.success) {
            allPermissions = data.permissions;
            allPermissions.sort();
        }
    });
    registerHandler();
}

loadAccounts()

$('#submit-add-account').click(function () {
    let newPass1 = $('#set-new-password3');
    let newPass2 = $('#set-new-password4');
    let username = $('#new-username');

    let reUsername = new RegExp("^([a-zA-Z0-9]+)$");


    newPass1.on("input", function () {
        newPass1.removeClass('is-invalid');
        newPass2.removeClass('is-invalid');
    });

    newPass2.on("input", function () {
        newPass1.removeClass('is-invalid');
        newPass2.removeClass('is-invalid');
    });

    if (newPass1.val() !== newPass2.val()) {
        newPass1.addClass('is-invalid');
        newPass2.addClass('is-invalid');
        return;
    }

    username.on("input", function () {
        username.removeClass('is-invalid')
        $('#invalid-feedback-username-create-account').text($('#username_exists').text())
    })

    if (!reUsername.test(username.val())) {
        $('#invalid-feedback-username-create-account').text($('#must_match_username_regex').text())
        username.addClass('is-invalid')
        return;
    }

    let data = {};
    data["username"] = username.val();
    data["new-password"] = btoa(newPass2.val());

    $.ajax({
        url: "/api/account/create/",
        method: "POST",
        data: JSON.stringify(data),
        contentType: "application/json"
    }).done(function(data) {
        if (data.success) {
            Swal.fire(
                $('#success').text(),
                $('#account_created').text(),
                'success'
            ).then(() => {
                location.reload();
            })
        } else {
            if (data.error === 2) {
                username.addClass('is-invalid')
            } else {
                Swal.fire({
                    icon: 'error',
                    title: $('#something_went_wrong').text(),
                    showConfirmButton: false,
                    timer: 1500
                }).then((result) => {

                });
            }
        }
    });


});

$('#submit-set-password').click(function () {
    let newPass1 = $('#set-new-password1');
    let newPass2 = $('#set-new-password2');

    newPass1.on("input", function () {
        newPass1.removeClass('is-invalid');
        newPass2.removeClass('is-invalid');
    });

    newPass2.on("input", function () {
        newPass1.removeClass('is-invalid');
        newPass2.removeClass('is-invalid');
    });

    if (newPass1.val() !== newPass2.val()) {
        newPass1.addClass('is-invalid');
        newPass2.addClass('is-invalid');
        return;
    }

    let data = {};
    data["username"] = $('#username-passchange').val();
    data["new-password"] = btoa(newPass2.val());

    $.ajax({
        url: "/api/account/reset-password/",
        method: "POST",
        data: JSON.stringify(data),
        contentType: "application/json"
    }).done(function(data) {
        if (data.success) {
            Swal.fire(
                $('#success').text(),
                $('#password_changed').text(),
                'success'
            ).then(() => {
                location.reload();
            })
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