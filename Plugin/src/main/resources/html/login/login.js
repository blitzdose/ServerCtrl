setTheme();

$('#login-form').submit(function (event) {
    event.preventDefault();
    document.cookie = "token=;expires=Thu, 01 Jan 1970 00:00:01 GMT";
    let username = $('#username')
    let password = $('#password');
    let loginData = {};
    loginData["username"] = username.val();
    loginData["password"] = btoa(password.val());
    $.ajax({
        url: "/api/user/login",
        method: "POST",
        data: loginData,
        //beforeSend: function (xhr) {
        //    xhr.setRequestHeader ("Authorization", "Basic " + btoa(username.val() + ":" + password.val()));
        //    xhr.setRequestHeader ("WWW-Authenticate", "Basic realm=" + "\"Server Remote\"");
        //},
        statusCode: {
            401: function() {
                $('#password').addClass('is-invalid');
            }
        }
    }).done(function(data, tetStatus, request) {
        if (data.success) {
            window.location.replace("/view/");
        }
    });
});

$('#password').on("input", function () {
    $('#password').removeClass('is-invalid');
})

function setTheme() {
    let darkmode = localStorage.getItem('darkmode');
    if (darkmode === null) {
        localStorage.setItem('darkmode', '0');
        darkmode = '0';
    }

    if (darkmode === '1') {
        document.getElementById('stylesheet-dark').disabled = false;
    }

    $.ajax({
        url: "/api/server/name",
    }).done(function(data) {
        if (data.success) {
            $('#server-name').text(data.servername);
        }
    });
}