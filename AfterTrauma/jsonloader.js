//
// load local / remote JSON files
//
// resolve( object ), reject( error )
//
function load( file, resolve, reject ) {
    var request = new XMLHttpRequest();
    request.open("GET", file );
    request.onreadystatechange = function () {
        if (request.readyState === XMLHttpRequest.DONE) {
            try {
                if( resolve ) resolve(JSON.parse(request.responseText));
            } catch( err ) {
               console.log( request.statusText );
               console.log( request.responseText );
            }
        }
    }
    request.onerror = function() {
        if( reject ) reject('error');
    }
    request.send();
}
//
//
//
function save( file, data ) {

}
