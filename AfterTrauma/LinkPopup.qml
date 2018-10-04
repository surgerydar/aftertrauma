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
            //
            //
            //
            onClicked: {
                if ( model.section === "resources" ) {
                    var category = categoryModel.findOne({category:model.category});
                    stack.push( "qrc:///DocumentViewer.qml", { title: ( category && category.title ? category.title : container.title ), subtitle: model.title, colour: colour, document: model.document });
                } else {
                    challengeModel.viewChallenge(model.document);
                }
            }
            //
            //
            //
            Component.onCompleted: {
                if (  model.section === "resources" ) {
                    setColour(model.category);
                } else {
                    colour = Colours.lightGreen;
                }
            }
        }
    }
    //
    //
    //
    function find( tags ) {
        documentModel.filter = {};
        links.model.clear();
        var searchResults = tagsModel.find( { tag: { $or: tags } } );
        if ( searchResults.length >= tags.length ) {
            console.log( 'find results : ' + JSON.stringify(searchResults) );
            var frequency = {};
            searchResults.forEach( function( result ) {
                result.documents.forEach( function( document ) {
                    if ( frequency[ document.document ] ) {
                        frequency[ document.document ].frequency++;
                    } else {
                        frequency[ document.document ] = { section: document.section, frequency: 1 };
                    }
                });
            });
            console.log( 'find frequency : ' + JSON.stringify(frequency) );
            var document_ids = [];
            var challenge_ids = [];
            for ( var id in frequency ) {
                if ( frequency[ id ].frequency >= searchResults.length ) { // matches all tags
                    if ( frequency[ id ].section ==='challenges' ) {
                        challenge_ids.push(id);
                    } else {
                        document_ids.push(id);
                    }
                }
            }
            //
            //
            //
            var documents = documentModel.find( { document: { $in: document_ids } } );
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

                results.model.append( {
                                         document: document.document,
                                         title: document.title,
                                         summary: summary,
                                         category: document.category,
                                         section: "resources"
                                     });
            });
            var challenges = challengeModel.find( { _id : { $in: challenge_ids } } );
            challenges.forEach( function( challenge ) {
                results.model.append( {
                                         document: challenge._id,
                                         title: challenge.name,
                                         summary: challenge.activity,
                                         section: "challenges"
                                     });
            });
            //links.height = Math.min( parent.height, links.model.count * ( 64 + 4 ) );
            open();
        }
    }
}
