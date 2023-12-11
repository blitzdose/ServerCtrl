changeTheme();
getServerName();

let gaugeCpu = $('#cpu-gauge').simpleGauge();
let gaugeMem = $('#memory-gauge').simpleGauge();
let usersListHtml = $("#users");

updateSystemData();
setInterval(updateSystemData, 5000);
updatePlayers();

updateConsole();
setInterval(updateConsole, 5000);

function updateSystemData() {
    $.ajax({
        url: "/api/system/data/",
    }).done(function( data ) {
        if (data.success) {
            updateGauge(gaugeCpu, data.cpuLoad / 100);
            updateGauge(gaugeMem, ((data.totalSystemMem - data.freeSystemMem) / data.totalSystemMem * 100).toFixed(2));
        }
    });
}

function updatePlayers() {
    $.ajax({
        url: "/api/player/online/",
        method: "POST",
        data: JSON.stringify({itemsPerPage: 8, position: 0}),
        contentType: "application/json"
    }).done(function( data ) {
        if (data.success) {
            updateInfo(data.Player.length);
            usersListHtml.empty();
            if (data.Player.length === 0) {
                usersListHtml.append('<h5>' + $('#no_players').text() + '</h5>');
            }
            let max = Math.min(8, data.Player.length);
            for(let i=0; i<max; i++) {
                let player = data.Player[i];
                let playerHtml = '<a href="/players" class="list-group-item list-group-item-action d-flex align-items-center">' +
                    '                                    <img src="' + player.texturelink + '&size=50" alt="avatar"/>' +
                    '                                    <div class="d-flex w-100 justify-content-between flex-column ms-3">' +
                    '                                        <h5 class="mb-1">' + player.name + '</h5>' +
                    '                                    </div>' +
                    '                                </a>';
                usersListHtml.append(playerHtml);
            }
        }
    });
}


function updateInfo(playerCount) {
    $.ajax({
        url: "/api/server/data/",
    }).done(function( data ) {
        if (data.success) {
            let serverData = data.data;
            let table = $('#server-data-table');
            table.append('<tr>' +
                '             <td>' + $('#players').text() + '</td>' +
                '             <td>' + playerCount + ' / ' + serverData.maxPlayers + '</td>' +
                '         </tr>');
            table.append('<tr>' +
                '             <td>MOTD</td>' +
                '             <td>' + serverData.motd + '</td>' +
                '         </tr>');
            table.append('<tr>' +
                '             <td>' + $('#version').text() + '</td>' +
                '             <td>' + serverData.version + '</td>' +
                '         </tr>');
        }
    });
}

function updateConsole() {
    $.ajax({
        url: "/api/console/log",
        error: function (request, status, error) {
            if (request.status === 403) {
                let consoleElement = $('#console');
                consoleElement.empty();
                consoleElement.append($('#no_access').text());
            }
        }
    }).done(function( data ) {
        if (data.success) {
            let log = data.log;
            let consoleElement = $('#console');
            consoleElement.empty();
            let messages = log.split("\n");
            for (let message of messages) {
                let splitMessage = "";
                let parts = message.split("!_/");
                for (let i=0; i<parts.length; i++) {
                    let part = parts[i];
                    if (i > 0) {
                        let color = part.substr(0, 1);
                        part = part.substr(1);
                        switch (color) {
                            case "0":
                                part = part.fontcolor("#333232");
                                break;
                            case "1":
                                part = part.fontcolor("#0000AA");
                                break;
                            case "2":
                                part = part.fontcolor("#00AA00");
                                break;
                            case "3":
                                part = part.fontcolor("#00AAAA");
                                break;
                            case "4":
                                part = part.fontcolor("#AA0000");
                                break;
                            case "5":
                                part = part.fontcolor("#AA00AA");
                                break;
                            case "6":
                                part = part.fontcolor("#FFAA00");
                                break;
                            case "7":
                                part = part.fontcolor("#AAAAAA");
                                break;
                            case "8":
                                part = part.fontcolor("#555555");
                                break;
                            case "9":
                                part = part.fontcolor("#5555FF");
                                break;
                            case "a":
                                part = part.fontcolor("#55FF55");
                                break;
                            case "b":
                                part = part.fontcolor("#55FFFF");
                                break;
                            case "c":
                                part = part.fontcolor("#FF5555");
                                break;
                            case "d":
                                part = part.fontcolor("#FF55FF");
                                break;
                            case "e":
                                part = part.fontcolor("#FFFF55");
                                break;
                            case "f":
                                part = part.fontcolor("#FFFFFF");
                                break;
                        }
                        splitMessage = splitMessage + part;
                    } else {
                        splitMessage = part;
                    }
                }
                consoleElement.append(splitMessage);
                consoleElement.append("<br>");
            }
            consoleElement[0].scrollTop = consoleElement[0].scrollHeight - consoleElement[0].clientHeight;
        }
    });
}

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