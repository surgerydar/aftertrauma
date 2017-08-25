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
            label: !( model.type === "number" || model.type === "switch" ) && source  ? source[ model.field ] : model.label
            type: model.type
            options: model.options || undefined
            radius: model.index === 0 ? [16,16,0,0] : model.index === builder.model.count - 1 ? [0,0,16,16] : [0]
            on: model.type === "switch"  && source ? source[ model.field ] : false
            value: model.type === "number" && source ? source[ model.field ] : 1
            sourceText: ( model.field === "name" || model.field === "activity" ) && source ? source[model.field] : ""

            onSelected: {
                container.closeall(index);
            }
            onLabelChanged: {
                if ( !( model.type === "switch" || model.type === "number" ) ) {
                    challenge[ model.field ] = label;
                }
            }
            onOnChanged: {
                if ( model.type === "switch" ) {
                    challenge[ model.field ] = value;
                }
            }
            onValueChanged: {
                if ( model.type === "number" ) {
                    challenge[ model.field ] = value;
                }
            }
        }
        add: Transition {
            NumberAnimation { properties: "y"; from: builder.height; duration: 250 }
        }
    }
    //
    //
    //
    StackView.onActivated: {
        var data = [
                    { label: "Challenge name", type: "name", field: "name" },
                    { label: "Challenge activity", type: "description", field: "activity" },
                    { label: "Repeats", type: "number", field: "repeats" },
                    { label: "How often", type: "options", options: [ { label: "Every hour" }, { label: "Morning and evening" }, { label: "Daily" }, { label: "Weekly" } ], field: "frequency"  },
                    { label: "Active", type: "switch", field: "active" },
                    { label: "Notifications", type: "switch", field: "notifications"  }
                ];
        builder.model.clear();
        data.forEach(function(datum){
            builder.model.append(datum);
        });
        challenge = {
            name: ( source ? source.name : undefined ),
            activity: ( source ? source.activity : undefined ),
            repeats: ( source ? source.repeats : 1 ),
            frequency: ( source ? source.frequency : undefined ),
            active: source ? source.active : false,
            notifications: source ? source.notifications : false
        };
    }
    StackView.onDeactivated: {
        source = null;
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
        closeall();
        //
        // check all required fields are filled
        //
        var completed = true;
        [ 0, 1, 3 ].forEach(function(index){
            console.log( 'builder:' + builder.contentItem.children[ index ].label + ' model:' + builder.model.get( index ).label );
            var item = builder.model.get( index );
            if ( challenge[ item.field ] === undefined || challenge[ item.field ] === item.label ) completed = false
        });
        if ( !completed ) {
            // TODO: dialog
            errorDialog.show( "please set all of the options",
                             [
                                 {label:"Retry", action: function() {} },
                                 {label:"Cancel", action: function() { stack.pop(); } },
                             ]);
            console.log('challenge incomplete');
        } else {
            //
            // check for unique name
            //
            if ( !source && challengeModel.findChallenge(challenge.name) ) {
                // TODO: dialog
                errorDialog.show( "a challenge called '" + challenge.name + "' already exists",
                                 [
                                     {label:"Retry", action: function() {} },
                                     {label:"Cancel", action: function() { stack.pop(); } },
                                 ]);
                console.log('challenge name not unique');
            } else {
                //
                // add challenge
                //
                console.log( 'saving challenge : ' + JSON.stringify(challenge));
                if ( source ) {
                    challenge._id = source._id;
                    challengeModel.updateChallenge(challenge);
                } else {
                    challengeModel.addChallenge(challenge);
                }
                return true;
            }
        }
        return false;
    }
    //
    //
    //
    property var challenge: null
    property var source: null
}
