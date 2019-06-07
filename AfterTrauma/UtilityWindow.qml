import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

Popup {
    id: container
    //
    //
    //
    Column {
        //anchors.fill: parent
        padding: 8
        spacing: 8
        //
        //
        //
        AfterTrauma.Button {
            anchors.horizontalCenter: parent.horizontalCenter
            backgroundColour: Colours.slate
            text: "generate test data"
            onClicked: {
                console.log( "generate test data" );
                dailyModel.generateTestData();
                //reloadModels();
            }
        }
        //
        //
        //
        AfterTrauma.Button {
            anchors.horizontalCenter: parent.horizontalCenter
            backgroundColour: Colours.slate
            text: "archive media"
            onClicked: {
                console.log( "archive media" );
                var source = SystemUtils.documentDirectory();
                var archive = source + '.at';
                Archive.archive(source,archive,true);
            }
        }
        //
        //
        //
        AfterTrauma.Button {
            anchors.horizontalCenter: parent.horizontalCenter
            backgroundColour: Colours.slate
            text: "prefetch images"
            onClicked: {
                let documents = JSONFile.read('documents.json');
                if ( documents ) {
                    documents.forEach(function(document) {
                        document.blocks.forEach(function(block) {
                            if ( block.type === 'image' ) {
                                let url = block.content;
                                let localPath = SystemUtils.documentDirectory() + '/media' + url.substring(url.lastIndexOf('/'));
                                console.log( 'downloading : ' + url + ' to ' + localPath );
                                Downloader.download(url,localPath);
                            }
                        });
                    });
                }
            }
        }

    }
    Connections {
        target: Archive
        onDone: {
            console.log( 'Archive : done : ' + operation + ' : source : ' + source + ' : target : ' + target );
            if ( operation === "archive" ) {
                Archive.unarchive(target, source + '-unarchive' );
            }
        }
        onProgress: {
            console.log( 'Archive : progress : ' + operation + ' : source : ' + source + ' : archive : ' + archive + ' : total : ' + total + ' : current : ' + current + ' : message : ' + message );
        }
        onError: {
            console.log( 'Archive : done : ' + operation + ' : source : ' + source + ' : target : ' + target + ' : message : ' + message );
        }
    }
}
