import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

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
            /*
            anchors.left: parent.left
            anchors.right: parent.right
            */
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            type: model.type
            media: model.content
            onMediaReady: {
                contents.forceLayout();
            }
        }
    }
    //
    //
    //
    footer: Item {
        height: 4
    }
    //
    //
    //
    property bool onStack: false
    StackView.onActivating: {
        contents.model.clear();
        var doc = documentModel.findOne( { document: document } );
        if ( doc ) {
            doc.blocks.forEach( function( block ) {
                contents.model.append( block );
            });
        }
        //
        //
        //
        if( !onStack ) {
            onStack = true;
            usageModel.add('information', 'open', 'document', { category: container.title, title: container.subtitle } );
        }
    }
    StackView.onRemoved: {
        onStack = false;
        usageModel.add('information', 'close', 'document', { category: container.title, title: container.subtitle } );
    }
    //
    //
    //
    property bool firstTime: true
    property string document: ""

}
