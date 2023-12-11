let itemsPerPage = 50;
let currentPage = 0;

getLog();

function setItemsPerPage(items) {
    itemsPerPage = items;
    $('#itemsPerPage').text(itemsPerPage);
    getLog();
}

function changePage(page) {
    currentPage = page;
    getLog();
}

function nextPage() {
    currentPage = currentPage + 1;
    getLog();
}

function prevPage() {
    currentPage = currentPage -1;
    getLog();
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

    let pagination = $('#log-pagination');
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


function getLog() {
    $.ajax({
        url: "/api/log/count"
    }).done(function( data ) {
        if (data.success) {

            calcAndDisplayPages(data.count);

            $.ajax({
                url: "/api/log/log",
                method: "POST",
                data: JSON.stringify({limit: itemsPerPage, position: currentPage * itemsPerPage}),
                contentType: "application/json",
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

                    let dataSplit = data.log.split("\n");
                    let logElem = $('#log');
                    logElem.empty();
                    for (let login of dataSplit) {
                        if (login === "") {
                            continue;
                        }
                        let color = "list-group-item-warning";
                        if (login.includes("[Login failed]")) {
                            color = "list-group-item-danger";
                        } else if (login.includes("[Login Successfully]")) {
                            color = "list-group-item-success";
                        } else if (login.includes("[Player join]") || login.includes("[Player quit]")) {
                            color = "list-group-item-blue";
                        }
                        logElem.append($('<li class="list-group-item ' + color + '"></li>').text(login));
                    }
                }
            });
        }
    });
}