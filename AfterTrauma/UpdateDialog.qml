import QtQuick 2.6
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

Popup {
    id: container
    //
    //
    //
    background: AfterTrauma.Background {
        anchors.fill: parent
        fill: Colours.almostWhite
        opacity: .5
    }
    //
    //
    //
    contentItem: Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Text {
            id: prompt
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            width: container.width - 32
            wrapMode: Text.WordWrap
            font.weight: Font.Bold
            font.family: fonts.light
            font.pixelSize: 24
            color: Colours.darkSlate
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16
            Repeater {
                id: actionButtons
                model: 0
                //
                //
                //
                AfterTrauma.Button {
                    backgroundColour: Colours.slate
                    textColour: Colours.almostWhite
                    text: actionButtons.model[index].label
                    onClicked: {
                        console.log( 'actionButtons : ' + JSON.stringify(actionButtons.model));
                        actions[index]();
                    }
                }
            }
        }
    }
    //
    //
    //
    WebSocketChannel {
        id: updateChannel
        url: baseWS
        //
        //
        //
        onReceived: {
            busyIndicator.running = false;
            var command = JSON.parse(message); // TODO: channel should probably emit object???
            if ( command.status === "OK" ) {
                if ( command.command === 'categories' ) {
                    if ( command.response.length > 0 ) {
                        processCategories(command.response);
                    }
                    send({command:'manifest',date:lastUpdate});
                } else if ( command.command === 'manifest' ) {
                    //console.log( 'manifest : ' + JSON.stringify(command.response) );
                    if ( command.response.length > 0 ) {
                        prompt.text = "<h1>Updates Available</h1>Do you want to download and install now?";
                        actionButtons.model = [{ label: 'yes'},{ label: 'no'}];
                        actions = [ function() { processUpdate(command.response); }, function() { container.close(); } ];
                    } else {
                        container.close();
                    }
                } else if ( command.command === 'documents' ) {
                    if ( command.response.length > 0 ) {
                        //console.log( 'documents : ' + JSON.stringify(command.response[0]) );
                        installDocuments(command.response);
                    }
                    send({command:'challenges',date:lastUpdate});
                } else if ( command.command === 'challenges' ) {
                    if ( command.response.length > 0 ) {
                        installChallenges(command.response);
                    }
                    settingsModel.update({name:'lastupdate'},{name:'lastupdate',value:Date.now()},true);
                    settingsModel.save();
                    container.close();
                }
            } else if ( command.error ) {
                prompt.text = '<h1>Server says</h1><br/>' + ( typeof command.error === 'string' ? command.error : command.error.error );
                actionButtons.model = [{ label: 'try again'},{ label: 'forget about it'}];
                actions = [ function() { send({command:'categories',date:lastUpdate}) },  function() { container.close(); } ];
            } else {
                console.log( 'unknown message: ' + message );
            }
        }
        onError: {
            busyIndicator.running = false;
            errorDialog.show( '<h1>Network error</h1><br/>' + error, userProfile ?
                                 [
                                     { label: 'try again', action: function() {send({command:'categories',date:lastUpdate});} }
                                 ] :
                                 [
                                     { label: 'try again', action: function() {send({command:'categories',date:lastUpdate});} },
                                     { label: 'forget about it', action: function() { container.close(); } },
                                 ] );
        }
        onOpened: {
            send({command:'categories',date:lastUpdate});
        }
        onClosed: {

        }
    }
    Component.onCompleted: {

    }
    onOpened: {
        prompt.text = '<h1>Checking for Updates</h1>Please wait...';
        actionButtons.model = [];
        actions = [];
        var lastUpdateEntry = settingsModel.findOne({name:'lastupdate'});
        if ( lastUpdateEntry ) {
            console.log( 'UpdateDialog.onOpened : lastUpdateEntry=' + JSON.stringify(lastUpdateEntry));
            lastUpdate = lastUpdateEntry.value;
            console.log( 'UpdateDialog.onOpened : lastUpdate=' + lastUpdate);
        } else {
            lastUpdate = 0;
        }
        updateChannel.open();
    }
    onClosed: {
        updateChannel.close();
        actionButtons.model = [];
        actions = [];
        if ( closeCallback ) {
            closeCallback();
            closeCallback = null;
        }
        busyIndicator.running = false;
    }
    //
    //
    //
    function processCategories( categories ) {
        categories.forEach( function( category ) {
            console.log( 'updating category : ' + JSON.stringify(category) );
            var entry = {
                section:    category.section,
                category:   category._id,
                title:      category.title,
                date:       category.date,
                index:      category.index
            };
            categoryModel.update({category: category._id},entry,true);
        });
        categoryModel.save();
    }
    function processUpdate( manifest ) {
        //
        //
        //
        prompt.text = '<h1>Installing Updates</h1>Please wait...';
        actionButtons.model = [];
        actions = [];
        busyIndicator.running = true;
        //
        // delete removed
        //
        var filter = documentModel.filter;
        documentModel.filter = {};
        manifest.forEach( function( delta ) {
            if ( delta.operation === 'remove' ) {
                //
                // TODO: delete file, possibly delete associated media
                //
                if ( delta.category ) {
                    var category = categoryModel.findOne({category:delta.category});
                    if ( category && category.section ) {
                        var path = category.section + '/' + delta.category + '.' + delta.document + '.json';
                        console.log( 'removing:' + path );
                        documentModel.remove( {document: delta.document} );
                    } else {
                        console.log( 'remove : unable to find catgegory : ' + delta.category );
                    }
                } else if ( delta.challenge ) {
                    challengeModel.remove({_id: delta.challenge});
                }
            }
        });
        documentModel.save();
        documentModel.filter = filter;
        //
        // request updated
        //
        updateChannel.send({command:'documents',date:lastUpdate});
    }
    function installDocuments( documents ) {
        var filter = documentModel.filter;
        documentModel.filter = {};
        documents.forEach( function( document ) {
            var category = categoryModel.findOne({category:document.category});
            if ( category && category.section ) {
                var path = category.section + '/' + document.category + '.' + document._id;
                console.log( 'installing:' + path + ' : ' + document.title + ' : ' + document.index );
                var entry = {
                    document: document._id,
                    category: document.category,
                    section: category.section,
                    title: document.title,
                    blocks: document.blocks,
                    date: document.date,
                    index: document.index
                };
                //
                // TODO: extract tags
                //
                var result = documentModel.update( {document: document._id}, entry, true );
                console.log( 'updated document : ' + JSON.stringify(result) );
                if ( result ) {
                    //
                    // add category title as tag
                    //
                    if ( category.section === "resources" ) {
                        tagsModel.updateTag( category.title.toLowerCase(), document._id || result._id );
                    }
                    //
                    //
                    //
                    document.blocks.forEach( function( block ) {
                        console.log( 'extracting tags : ' + JSON.stringify(block.tags) );
                        block.tags.forEach( function( tag ) {
                            if ( tag.length > 0 ) {
                                tagsModel.updateTag( tag.toLowerCase(), { section: category.section, document: document._id || result._id } );
                            }
                        });
                    });
                    //
                    //
                    //
                    tagsModel.save();
                }
            } else {
                console.log( 'install : unable to find catgegory : ' + document.category );
            }
        });
        documentModel.save();
        documentModel.setFilter(filter);
    }
    function installChallenges( challenges ) {
        challenges.forEach( function( challenge ) {
            console.log( 'updating challenge : ' + challenge._id );
            challenge.active = false;
            var result = challengeModel.update( {_id: challenge._id}, challenge, true );
            console.log( 'updated challenges : ' + JSON.stringify(result) );
            if ( challenge.tags ) {
                challenge.tags.forEach( function( tag ) {
                    tag.trim();
                    if ( tag.length > 0 ) {
                        tagsModel.updateTag( tag.toLowerCase(), { section: "challenges", document: challenge._id || result._id } );
                    }
                });
            }
        });
        tagsModel.save();
        challengeModel.save();
    }
    //
    //
    //
    function checkForUpdates( callback ) {
        closeCallback = callback;
        open();
    }
    //
    //
    //
    property var actions: []
    property var closeCallback: null
    property var lastUpdate: 0
}
