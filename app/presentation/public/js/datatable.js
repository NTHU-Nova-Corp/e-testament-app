$(document).ready(function () {
    $('#content-table').DataTable();

    document.querySelector("#content-table_length").style.color = "white"
    document.querySelector("#content-table_length > label > select").style.color = "white"
    document.querySelector("#content-table_filter > label").style.color = "white"
    document.querySelector("#content-table_info").style.color = "white"
    document.querySelector("#content-table").style.paddingTop = "10px"
});
