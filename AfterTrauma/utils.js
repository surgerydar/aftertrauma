
var shortMonths = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

function shortDate(time) {
    var date = new Date(time);
    return shortMonths[ date.getMonth() ] + ', ' + date.getDate();
}
