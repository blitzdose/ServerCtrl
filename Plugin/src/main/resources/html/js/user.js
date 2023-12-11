getUser();
changeTheme();

function getServerName() {
    $.ajax({
        url: "/api/server/name/",
    }).done(function( data ) {
        if (data.success) {
            $('#server-name').text(data.servername);
            document.title = document.title.split("|")[0] + "| " + data.servername;
        }
    });
}

getServerName();

function changeTheme() {

    let darkmode = localStorage.getItem('darkmode');
    if (darkmode === null) {
        localStorage.setItem('darkmode', '0');
        darkmode = '0';
    }

    if (darkmode === '1') {
        document.getElementById('stylesheet-dark').disabled = false;
    }

    let r = document.querySelector(':root');
    let colors = JSON.parse(localStorage.getItem("colors"));

    if (colors !== null) {
        r.style.setProperty('--bs-primary', colors.primary);
        r.style.setProperty('--bs-primary-rgb', colors.primaryRGB);
        r.style.setProperty("--bs-primary-dark", colors.primaryDark);
    }
}

function getUser() {
    $.ajax({
        url: "/api/user/current/",
    }).done(function( data ) {
        if (data.success) {
            let username = data.username;
            $('#username')[0].innerText = username;
            getPermissions();
        }
    });
}

function getPermissions() {
    $.ajax({
        url: "/api/user/permissions",
    }).done(function( data ) {
        if (data.success) {
            if (!data.permissions.includes("console")) {
                $('a.nav-link[href="/console"]').hide();
            }
            if (!data.permissions.includes("files")) {
                $('a.nav-link[href="/files"]').hide();
            }
            if (!data.permissions.includes("log")) {
                $('a.nav-link[href="/log"]').hide();
            }
            if (!data.permissions.includes("admin")) {
                $('a.nav-link[href="/account-management"]').hide();
            }
        }
    });

}

$('#sign-out-button').click(function () {
    $.ajax({
        url: "/api/user/logout/",
        method: "POST"
    }).done(function( data ) {
        if (data.success) {
            document.cookie = "token=;expires=Thu, 01 Jan 1970 00:00:01 GMT";
            window.location.replace("/view/login");
        }
    });
});

$('#submit-change-password').click(function () {
    let oldPass = $('#old-password');
    oldPass.on("input", function () {
        oldPass.removeClass('is-invalid');
    })
    let newPass1 = $('#new-password1');
    let newPass2 = $('#new-password2');

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
    data["username"] = $('#username')[0].innerText;
    data["password"] = btoa($('#old-password').val());
    data["new-password"] = btoa(newPass2.val());

    $.ajax({
        url: "/api/user/password/",
        method: "POST",
        data: data,
        statusCode: {
            401: function() {
                oldPass.addClass('is-invalid');
            }
        }
    }).done(function(data) {
        if (data.success) {
            Swal.fire(
                $('#success').text(),
                $('#password_changed').text(),
                'success'
            ).then(() => {
                location.reload();
            })
        }
    });
});

function toggleSidebar() {
    $('#sidebar').toggleClass("closed");
    if ($('#sidebar').hasClass("closed")) {
        $('.overlay')[0].style.display = 'block';
    } else {
        $('.overlay')[0].style.display = 'none';
    }
}