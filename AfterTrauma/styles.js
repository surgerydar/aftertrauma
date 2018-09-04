.pragma library

var styles = {
    recomendations : "a { display: inline-block; text-decoration: none; color: black; background-color: white; padding: 4px;}"
}

function style(text,style) {
    if ( !text.startsWith("<html>") ) {
        if ( styles[style] ) {
            console.log('styles.style : applying style : ' + style );
            return "<html><head><style>%1</style></head><body>%2</body></html>".replace("%1",styles[style]).replace("%2",text);
        } else {
            console.log( 'styles.style : invalid style : ' + style)
        }
    }
    return text;
}
