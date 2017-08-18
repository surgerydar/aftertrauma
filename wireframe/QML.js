var fs = require( 'fs' );

const kHeader   = 'import QtQuick 2.7\n'
                    + 'import QtQuick.Controls 2.0\n'
                    + 'import QtQuick.Layouts 1.0\n'
                    + 'import QtMultimedia 5.8\n';
const kListHeader = 'VisualItemModel {\n';
const kListFooter = '}\n';
//
// TODO: async + promises
//
function QML() {
    this.cachedTemplates = {}
}

QML.prototype.render = function( template, data ) {
    var self = this;
	return new Promise( function( resolve, reject ) {
		try {
            //
            // load template
            //
            var format = self.loadTemplate( template );
            //
            // render
            //
            var qml = kHeader;
            if ( Array.isArray(data) ) {
                qml += kListHeader;
                var count = data.length;
                for ( var i = 0; i < count; i++ ) {
                    var item = data[ i ];
                    item.index = i;
                    qml += self.substitute( format, data[ i ] );
                }
                qml += kListFooter;
            } else {
                data.index = 0;
                qml += self.substitute( format, data );
            }
            console.log( 'qml:\n' + qml );
            resolve( qml );
		} catch( err ) {
			reject( err );
		}
	});
}

QML.prototype.loadTemplate = function( template ) {
    if ( this.cachedTemplates[ template ] ) {
        return this.cachedTemplates[ template ];
    } else {
        //
        //
        //
        var path = './qml/' + template + '.qml';
        var data = fs.readFileSync(path,'utf8');
        if ( data.length > 0 ) {
            console.log( 'template:\n' + JSON.stringify(data) );
            //this.cachedTemplates[ template ] = data;
            return data;
        } else {
            throw new Error('QML.loadTemplate : unable to open template :' + template );
        }
    }
    
}
QML.prototype.substitute = function( template, data ) {
    console.log( 'data:\n' + JSON.stringify(data) );
    var qml = template;
    for ( var key in data ) {
        var variable = '#' + key;
        var regex = new RegExp(variable,'gi');
        qml = qml.replace(regex,data[key]);
        //qml = qml.replace(regex,JSON.stringify(data[key]));
    }
    return qml;
}

module.exports = new QML();