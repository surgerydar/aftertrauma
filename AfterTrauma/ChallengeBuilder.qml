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
    showNavigation: true
    validate: validateChallenge
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
            onSelected: {
                container.closeall(index);
            }
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
    StackView.onDeactivated: {
    }
    //
    //
    //
    function closeall( exclude ) {
        var nItems = builder.contentItem.children.length;
        for ( var i = 0; i < nItems; i++ ) {
            if ( i !== exclude ) {
                builder.contentItem.children[ i ].open = false;
            }
        }
    }
    //
    //
    //
    function validateChallenge() {
        console.log( 'validating challenge' );
        //
        // check for unique name
        //
        var completed = true;
        [ 0, 1, 3 ].forEach(function(index){
            console.log( 'builder:' + builder.contentItem.children[ index ].label + ' model:' + builder.model.get( index ).label );
            if ( builder.contentItem.children[ index ].label == builder.model.get( index ).label ) completed = false
        });
        if ( !completed ) {
            // TODO: dialog
            console.log('challenge incomplete');
        } else {
            var name = builder.contentItem.children[ 0 ].label;
            if ( challengeModel.findChallenge(name) ) {
                // TODO: dialog
                console.log('challenge name not unique');
            } else {
                //
                // add challenge
                //
                var challenge = {
                    name: name,
                    description: builder.contentItem.children[ 1].label,
                    repeats: builder.contentItem.children[ 2 ].value,
                    frequency: builder.contentItem.children[ 3 ].label,
                    notifications: builder.contentItem.children[ 4 ].on,
                    active: builder.contentItem.children[ 5 ].on
                };
                challengeModel.append(challenge);
                return true;
            }
        }
        return false;
    }
}
