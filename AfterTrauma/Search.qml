import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

AfterTrauma.Page {
    id: container
    //
    //
    //
    title: "SEARCH"
    colour: Colours.darkOrange
    //
    //
    //
    ListView {
        id: results
        anchors.fill: parent
        //
        //
        //
        clip: true
        spacing: 4
        //
        //
        //
        model: ListModel {}
        //
        //
        //
        delegate: SearchItem {
            anchors.left: parent.left
            anchors.right: parent.right
            title: model.title
            summary: model.summary
            //
            //
            //
            onClicked: {
                console.log( 'SearchItem.onClicked' )
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
        /*
        add: Transition {
            NumberAnimation { properties: "y"; from: results.height; duration: 250 }
        }
        */
    }
    footer: Item {
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        /*
        AfterTrauma.TextField {
            id: searchField
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: searchButton.left
            anchors.margins: 8
            onAccepted: {
                search();
            }
        }
        */
        AfterTrauma.TokenisedTextField {
            id: searchField
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: searchButton.left
            anchors.margins: 8
            font.family: fonts.light
            font.pointSize: 32
        }
        //
        //
        //
        AfterTrauma.Button {
            id: searchButton
            anchors.verticalCenter: searchField.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 8
            image: "icons/search.png"
            backgroundColour: "transparent"
            //
            //
            //
            onClicked: {
                search();
            }
        }
     }
    //
    //
    //
    property bool onStack: false
    //
    //
    //
    StackView.onActivated: {
        documentModel.filter = {};
        if ( !onStack ) {
            onStack = true;
            usageModel.add('search', 'open' );
        }
    }
    StackView.onRemoved: {
        onStack = false;
        usageModel.add('search', 'close' );
    }
    //
    //
    //
    function search() {
        //
        //
        //
        results.model.clear();
        /*
        var searchText = searchField.text;
        var tags = searchText.split(',');
        */
        var tags = searchField.tokenised;
        if ( tags.length > 0 ) {
            for ( var t = 0; t < tags.length; t++ ) {
                tags[ t ] = tags[ t ].trim().toLowerCase();
            }
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
            }
            //
            //
            //
            usageModel.add('search', 'search', undefined, {tags: tags} );
        }
    }
}
