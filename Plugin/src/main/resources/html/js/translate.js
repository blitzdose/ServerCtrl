translate();
function translate() {
    let language = localStorage.getItem("language");
    $.ajax({
        url: "/view/translation/" + language + ".html",
        async: false
    }).done(function( data ) {
        let translation = $(data);
        let table = translation.find(".translations");
        table.find("tr").each(function () {
            document.body.innerHTML = document.body.innerHTML.replaceAll(">" + $(this).find(".src").text().trim() + "<", ">" + $(this).find(".tra").text().trim() + "<");
            document.title = document.title.split("|")[0].replaceAll($(this).find(".src").text().trim(), $(this).find(".tra").text().trim()).trim() + " | Minecraft Server Remote";
        })
    });
}