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
        id: content
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
        var json = 'qrc:/factsheets/' + factsheet + '.json';
        console.log( 'laoding factsheet:' + json );
        JSONLoader.load(json, function( blocks ) {
            content.model.clear();
            blocks.forEach( function( block ) {
                content.model.append(block);
            })
        });
        */
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

    }

    property string factsheet: ""

}
