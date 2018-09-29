.pragma library

var styles = {
    global : "a { display: inline-block; text-decoration: none; color: #EB5E28; background-color: #F5F7FA; padding: 2px;}",
    recomendations : "a { display: inline-block; text-decoration: none; color: #EB5E28; background-color: #F5F7FA; padding: 4px;}"
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
