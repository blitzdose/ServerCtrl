updateConsole();

let interval = setInterval(updateConsole, 5000);

let historyCounter = -1;

let hideRestartButton = localStorage.getItem("hideRestartButton");
if (hideRestartButton === null) {
    localStorage.setItem("hideRestartButton", "0");
    hideRestartButton = "0";
}

if (hideRestartButton === "1") {
    $('#restart-server-button').hide();
}

let disableLineBreakCheckBox = $('#disable-linebreak');
disableLineBreak();

function disableLineBreak() {
    let console = $('#console');
    if (disableLineBreakCheckBox[0].checked) {
        console[0].style.whiteSpace = "nowrap";
    } else {
        console[0].style.whiteSpace = "unset";
    }
}

disableLineBreakCheckBox.change(function () {
    disableLineBreak();
})

function updateConsole() {
    $.ajax({
        url: "/api/console/log",
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
            clearInterval(interval);
        }
    }).done(function( data ) {
        if (data.success) {
            let log = data.log;
            let consoleElement = $('#console');
            let autoScrollCheck = $('#disable-autoscroll');
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
            if (!autoScrollCheck[0].checked) {
                consoleElement[0].scrollTop = consoleElement[0].scrollHeight - consoleElement[0].clientHeight;
            }
        }
    });
}

function sendCommand() {
    historyCounter = -1;
    let commandElement = $('#command-text');
    if (commandElement.val().trim().startsWith("msr")) {
        Swal.fire({
            icon: 'warning',
            title: $('#stop').text(),
            text: $('#no_msr_command').text(),
            showConfirmButton: true,
            confirmButtonColor: '#327f31'
        })
    }
    let command = btoa(commandElement.val());

    let history = JSON.parse(localStorage.getItem("command_history"));
    if (history === null) {
        history = [];
    }
    if (history.length >= 15) {
        history.splice(0, 1);
    }
    history.push(commandElement.val());
    localStorage.setItem("command_history", JSON.stringify(history));

    $.ajax({
        type: "POST",
        url: "/api/console/command/",
        data: JSON.stringify({ command: command }),
        dataType: "json"
    }).done(function () {
        setTimeout(updateConsole, 1000);
        commandElement.val("");
    });
}

function sendCommandWithParam(commandString) {
    let command = btoa(commandString);

    $.ajax({
        type: "POST",
        url: "/api/console/command/",
        data: JSON.stringify({ command: command }),
        dataType: "json"
    }).done(function () {
        setTimeout(updateConsole, 1000);
    });
}

$('#restart-server-button').click(function () {
    Swal.fire({
        icon: 'warning',
        title: $('#restart').text(),
        text: $('#restart_text').text(),
        showConfirmButton: true,
        showCancelButton: true,
        confirmButtonColor: '#327f31',
        cancelButtonColor: '#EE6055',
        cancelButtonText: $('#cancel').text(),
        confirmButtonText: $('#yes').text(),
        preConfirm: function () {
            sendCommandWithParam("restartmsr");
        }
    })
})

$('#send-command-button').click(function () {
    sendCommand();
});

$('#command-text').keypress(function (event) {
    if (event.which === 13) {
        sendCommand();
    }
});

$('#command-text').keydown(function (event) {
    if (event.which === 38) {
        let history = JSON.parse(localStorage.getItem("command_history"));
        historyCounter++;
        if (historyCounter < history.length) {
            $('#command-text').val(history[history.length - 1 - historyCounter]);
        } else {
            historyCounter = history.length-1;
        }
    } else if (event.which === 40) {
        let history = JSON.parse(localStorage.getItem("command_history"));
        historyCounter--;
        if (historyCounter >= 0) {
            $('#command-text').val(history[history.length - 1 - historyCounter]);
        } else {
            historyCounter = -1;
            $('#command-text').val("");
        }
    }
});