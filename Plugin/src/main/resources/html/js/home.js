let usersListHtml = $("#users");

updatePlayers();

let gaugeCpu = $('#cpu-gauge').simpleGauge();
let gaugeMem = $('#memory-gauge').simpleGauge();
updateSystemData();
setInterval(updateSystemData, 5000);

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
                    '                                        <p class="mb-1">' + player.uuid + '</p>' +
                    '                                    </div>' +
                    '                                </a>';
                usersListHtml.append(playerHtml);
            }
        }
    });
}

function updateSystemData() {
    $.ajax({
        url: "/api/system/data/",
    }).done(function( data ) {
        if (data.success) {
            updateGauge(gaugeCpu, data.cpuLoad / 100);
            updateGauge(gaugeMem, ((data.totalSystemMem - data.freeSystemMem) / data.totalSystemMem * 100).toFixed(2));

            let systemDataList = $('#system-data-list');
            systemDataList.empty();
            systemDataList.append('<li class="list-group-item d-flex justify-content-between align-items-center">' + $('#cpu_cores').text() + '<span class="badge bg-primary">' + data.cpuCores + '</span>' +
                '  </li>');
            systemDataList.append('<li class="list-group-item d-flex justify-content-between align-items-center">' + $('#cpu_load').text() + '<span class="badge bg-primary">' + data.cpuLoad / 100 + ' %</span>' +
                '  </li>');
            systemDataList.append('<li class="list-group-item d-flex justify-content-between align-items-center">' + $('#usable_memory').text() + '<span class="badge bg-primary">' + data.memMax + ' MB</span>' +
                '  </li>');
            systemDataList.append('<li class="list-group-item d-flex justify-content-between align-items-center">' + $('#allocated_memory').text() + '<span class="badge bg-primary">' + data.memTotal + ' MB</span>' +
                '  </li>');
            systemDataList.append('<li class="list-group-item d-flex justify-content-between align-items-center">' + $('#used_memory').text() + '<span class="badge bg-primary">' + data.memUsed + ' MB</span>' +
                '  </li>');
            systemDataList.append('<li class="list-group-item d-flex justify-content-between align-items-center">' + $('#total_system_memory').text() + '<span class="badge bg-primary">' + data.totalSystemMem + ' MB</span>' +
                '  </li>');
            systemDataList.append('<li class="list-group-item d-flex justify-content-between align-items-center">' + $('#free_system_memory').text() + '<span class="badge bg-primary">' + data.freeSystemMem + ' MB</span>' +
                '  </li>');
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
            table.append('<tr>' +
                '             <td>' + $('#online_mode').text() + '</td>' +
                '             <td>' + (serverData.onlineMode ? '<i class=\"bi bi-check-circle\"></i>' : '<i class="bi bi-x-circle"></i>') + '</td>' +
                '         </tr>');
            table.append('<tr>' +
                '             <td>' + $('#whitelist_enabled').text() + '</td>' +
                '             <td>' + (serverData.hasWhitelist ? '<i class=\"bi bi-check-circle\"></i>' : '<i class="bi bi-x-circle"></i>') + '</td>' +
                '         </tr>');
            table.append('<tr>' +
                '             <td>' + $('#nether_enabled').text() + '</td>' +
                '             <td>' + (serverData.allowNether ? '<i class=\"bi bi-check-circle\"></i>' : '<i class="bi bi-x-circle"></i>') + '</td>' +
                '         </tr>');
            table.append('<tr>' +
                '             <td>' + $('#end_enabled').text() + '</td>' +
                '             <td>' + (serverData.allowEnd ? '<i class=\"bi bi-check-circle\"></i>' : '<i class="bi bi-x-circle"></i>') + '</td>' +
                '         </tr>');
            table.append('<tr>' +
                '             <td>' + $('#commandblock_enabled').text() + '</td>' +
                '             <td>' + (serverData.allowCommandBlock ? '<i class=\"bi bi-check-circle\"></i>' : '<i class="bi bi-x-circle"></i>') + '</td>' +
                '         </tr>');
        }
    });
}