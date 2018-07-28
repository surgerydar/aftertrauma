import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Popup {
    id: container
    modal: true
    focus: true
    x: 0
    y: ( appWindow.height - height ) / 2
    width: appWindow.width
    height: Math.min( links.contentHeight + 16, appWindow.height - 128 )
    //
    //
    //
    background: AfterTrauma.Background {
        anchors.fill: parent
        fill: Colours.veryDarkSlate
        opacity: .5
    }
    //
    //
    //
    contentItem: ListView {
        id: links
        width: parent.width
        height: Math.min( container.height - 16, contentHeight )
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        clip: true
        spacing: 4
        model: ListModel {}
        delegate: SearchItem {
            anchors.left: parent.left
            anchors.right: parent.right
            title: model.title
            summary: model.summary
            colour: Colours.darkOrange
            //
            //
            //
            onClicked: {
                stack.push( "qrc:///DocumentViewer.qml", { title: ( category && category.title ? category.title : 'LINK' ), subtitle: model.title, colour: colour, document: model.document });
                container.close();
            }
            //
            //
            //
            Component.onCompleted: {
                setColour();
            }
            //
            //
            //
            function setColour() {
                colour = Colours.darkOrange;
                var category = categoryModel.findOne({category:model.category});
                if ( category ) {
                    colour = Colours.categoryColour(category.index);
                } else {
                    console.log( 'unable to find category : ' + model.category );
                }
                return colour;
            }
        }
    }
    /*
    enter: Transition {
        NumberAnimation { property: "y"; from: parent.height; to: parent.height - implicitHeight }
    }

    exit: Transition {
        NumberAnimation { property: "y"; from: parent.height - implicitHeight; to: parent.height }
    }
    */
    function find( tags ) {
        documentModel.filter = {};
        links.model.clear();
        var searchResults = tagsModel.find( { tag: { $or: tags } } );
        if ( searchResults.length >= tags.length ) {
            console.log( 'find results : ' + JSON.stringify(searchResults) );
            var frequency = {};
            searchResults.forEach( function( result ) {
                result.documents.forEach( function( document ) {
                    if ( frequency[ document ] ) {
                        frequency[ document ]++;
                    } else {
                        frequency[ document ] = 1;
                    }
                });
            });
            console.log( 'find frequency : ' + JSON.stringify(frequency) );
            var ids = [];
            for ( var id in frequency ) {
                if ( frequency[ id ] >= searchResults.length ) {
                    ids.push(id);
                }
            }
            var documents = documentModel.find( { document: { $in: ids } } );
            console.log( 'find documents : ' + documents.length );
            documents.forEach( function( document ) {
                //
                // find first text block
                //
                var summary = document.blocks[0].content;
                for ( var i = 0; i < document.blocks.length; i++ ) {
                    if ( document.blocks[ i ].type === 'text' && document.blocks[ i ].content.length > 0 ) {
                        summary = document.blocks[ i ].content;
                        break;
                    }
                }
                console.log( 'appending : ' + document.title);
                links.model.append( {
                                       category: document.category,
                                       document: document.document,
                                       title: document.title,
                                       summary: summary
                                   });
            });
            //links.height = Math.min( parent.height, links.model.count * ( 64 + 4 ) );
            open();
        }
    }
}
