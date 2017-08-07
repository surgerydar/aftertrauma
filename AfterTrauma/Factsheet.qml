import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "jsonloader.js" as JSONLoader

AfterTrauma.Page {
    id: container
    //
    //
    //
    ListView {
        id: contents
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
        delegate: AfterTrauma.Block {
            anchors.left: parent.left
            anchors.right: parent.right
            type: model.type
            media: model.media
        }
    }

    StackView.onActivated: {
        /*
         var data = [
                    { type: "text", media: "this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>" },
                    { type: "text", media: "this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>" },
                    { type: "text", media: "this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>" },
                    { type: "text", media: "this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>this is an introduction<br/>" },
                    { type: "image", media: "/icons/title_logo.png" },
                    { type: "video", media: "video.mp4" }
                ];
        content.model.clear();
        data.forEach(function(datum){
            content.model.append(datum);
        });
        */
        contents.model.clear();
        if ( content.length > 0 ) {
            JSONFile.read('/factsheets/' + content);
        }
    }
    //
    //
    //
    Connections {
        target: JSONFile

        onArrayReadFrom: {
            console.log( 'path:' + path );
            console.log( 'array:' + JSON.stringify(array) );
            contents.model.clear();
            array.forEach(function(entry) {
                contents.model.append(entry);
            });
        }
        onObjectReadFrom: {
            console.log( 'path:' + path );
            console.log( 'object:' + JSON.stringify(object) );
        }
        onErrorReadingFrom: {
            console.log( 'path:' + path );
            console.log( 'error:' + error );
        }
    }
    //
    //
    //
    property string content: ""

}
