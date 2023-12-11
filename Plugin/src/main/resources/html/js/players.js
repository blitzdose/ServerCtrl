let itemsPerPage = 25;
let currentPage = 0;

updatePlayers();

function setItemsPerPage(items) {
    itemsPerPage = items;
    $('#itemsPerPage').text(itemsPerPage);
    updatePlayers();
}

function changePage(page) {
    currentPage = page;
    updatePlayers();
}

function nextPage() {
    currentPage = currentPage + 1;
    updatePlayers();
}

function prevPage() {
    currentPage = currentPage -1;
    updatePlayers();
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

    let pagination = $('#players-pagination');

    if (pages === 0) {
        pagination.hide();
        $('#dropdown-playersPerPage').hide();
        return;
    }

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

function updatePlayers() {
    $.ajax({
        url: "/api/player/count"
    }).done(function( data ) {
        if (data.success) {

            calcAndDisplayPages(data.count);

            let usersListHtml = $("#players");
            $.ajax({
                url: "/api/player/online/",
                method: "POST",
                data: JSON.stringify({itemsPerPage: itemsPerPage, position: currentPage * itemsPerPage}),
                contentType: "application/json"
            }).done(function( data ) {
                if (data.success) {
                    usersListHtml.empty();
                    if (data.Player.length === 0) {
                        usersListHtml.append('<h5>' + $('#no_players').text() + '</h5>');
                    }
                    for (let player of data.Player) {
                        let op = "OP";
                        if (player.isOp === "true") {
                            op = "DE-OP";
                        }
                        let playerHtml = '<li class="list-group-item">' +
                            '                            <div class="d-flex align-items-center">' +
                            '                                <img src="' + player.texturelink + '&size=50" alt="avatar">' +
                            '                                <div class="d-flex w-100 justify-content-between flex-column ms-3">' +
                            '                                    <h5 id="playername" class="mb-1">' + player.name + '</h5>' +
                            '                                    <p class="mb-1">' + player.uuid + '</p>' +
                            '                                </div>' +
                            '                            </div>' +
                            '                            <div class="d-flex justify-content-end d-grid gap-3">' +
                            '                                <button type="button" class="btn btn-outline-primary kick">KICK</button>' +
                            '                                <button type="button" class="btn btn-outline-primary ban">BAN</button>' +
                            '                                <button type="button" class="btn btn-outline-primary op">' + op + '</button>' +
                            '                            </div>' +
                            '                        </li>'
                        usersListHtml.append(playerHtml);
                    }
                }
                registerHandler();
                hideIfNoPermission();
            });
        }
    });
}

function hideIfNoPermission() {
    $.ajax({
        url: "/api/user/permissions",
    }).done(function( data ) {
        if (data.success) {
            if (!data.permissions.includes("kick")) {
                $('.kick').hide();
            }
            if (!data.permissions.includes("ban")) {
                $('.ban').hide();
            }
            if (!data.permissions.includes("op")) {
                $('.op').hide();
            }
        }
    });
}

function registerHandler() {
    $('.kick').click(function () {
        let element = $(this);
        let listItem = element.parent().parent();
        let name = listItem.find("#playername").text();

        let data = {};
        data.command = btoa("kick " + name);

        $.ajax({
            url: "/api/console/command/",
            method: "POST",
            dataType: "json",
            contentType: "application/json",
            data: JSON.stringify(data)
        }).done(function( data ) {
            if (data.success) {
                let toast = bootstrap.Toast.getOrCreateInstance($('#toast-success'));
                toast.show();
                setTimeout(updatePlayers, 1000);
            } else {
                let toast = bootstrap.Toast.getOrCreateInstance($('#toast-fail'));
                toast.show();
            }
        });
    });

    $('.ban').click(function () {
        let element = $(this);
        let listItem = element.parent().parent();
        let name = listItem.find("#playername").text();

        let data = {};
        data.command = btoa("ban " + name);

        $.ajax({
            url: "/api/console/command/",
            method: "POST",
            dataType: "json",
            contentType: "application/json",
            data: JSON.stringify(data)
        }).done(function( data ) {
            if (data.success) {
                let toast = bootstrap.Toast.getOrCreateInstance($('#toast-success'));
                toast.show();
                setTimeout(updatePlayers, 1000);
            } else {
                let toast = bootstrap.Toast.getOrCreateInstance($('#toast-fail'));
                toast.show();
            }
        });
    });

    $('.op').click(function () {
        let element = $(this);
        let listItem = element.parent().parent();
        let name = listItem.find("#playername").text();
        let status = element.text();

        let data = {};
        if (status === "OP") {
            data.command = btoa("op " + name);
        } else {
            data.command = btoa("deop " + name);
        }

        $.ajax({
            url: "/api/console/command/",
            method: "POST",
            dataType: "json",
            contentType: "application/json",
            data: JSON.stringify(data)
        }).done(function( data ) {
            if (data.success) {
                let toast = bootstrap.Toast.getOrCreateInstance($('#toast-success'));
                toast.show();
                setTimeout(updatePlayers, 1000);
            } else {
                let toast = bootstrap.Toast.getOrCreateInstance($('#toast-fail'));
                toast.show();
            }
        });
    });
}

