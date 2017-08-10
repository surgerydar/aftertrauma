import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container
    //
    //
    //
    title: "CHALLENGE BUILDER"
    colour: Colours.lightGreen
    //
    //
    //
    ListView {
        id: builder
        //
        //
        //
        //anchors.fill: parent
        height: Math.min( parent.height, contentHeight )
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 16
        //
        //
        //
        interactive: contentHeight >= parent.height
        clip: true
        spacing: 8
        //
        //
        //
        model: ListModel {}
        //
        //
        //
        delegate: ChallengeBuilderItem {
            anchors.left: parent.left
            anchors.right: parent.right
            //
            //
            //
            label: model.label
            type: model.type
            options: model.options || undefined
            radius: model.index === 0 ? [16,16,0,0] : model.index === builder.model.count - 1 ? [0,0,16,16] : [0]
        }
    }
    //
    //
    //
    StackView.onActivated: {
        var data = [
                    { label: "Challenge name", type: "name" },
                    { label: "Challenge activity", type: "description" },
                    { label: "Repeats", type: "number" },
                    { label: "How often", type: "options", options: [ { label: "Every hour" }, { label: "Morning and evening" }, { label: "Daily" }, { label: "Weekly" } ] },
                    { label: "Notifications", type: "switch" },
                    { label: "Active", type: "switch" }
                ];
        builder.model.clear();
        data.forEach(function(datum){
            builder.model.append(datum);
        });
    }

}
