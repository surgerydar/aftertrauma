import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQml.Models 2.2

import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

AfterTrauma.Page {
    id: container
    title: 'DIARY'
    subtitle: Utils.shortDate(date, true)
    colour: Colours.slate
    //
    //
    //
    DelegateModel {
        id: blocksModel
        model: ListModel {}
        delegate: AfterTrauma.EditableListItem {
            id: editableItem
            width: contents.width
            height: block.implicitHeight
            topPadding: 0
            bottomPadding: 0
            swipeEnabled: editable
            opacity: dragArea.held ? 0. : 1.
            //
            //
            //
            contentItem: Item {
                id: dragContainer
                height: block.implicitHeight
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                AfterTrauma.Block {
                    id: block
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    type: model.type
                    media: model.type === 'text' ? model.content : 'file://' + SystemUtils.documentDirectory() + '/' + model.content
                    onMediaReady: {
                        contents.forceLayout();
                    }
                    //
                    //
                    //
                    Drag.active: dragArea.held
                    Drag.source: editableItem
                    //Drag.hotSpot.x: width / 2
                    //Drag.hotSpot.y: height / 2
                    //
                    //
                    //
                    states: State {
                        when: dragArea.held
                        ParentChange { target: block; parent: container }
                        AnchorChanges {
                            target: block
                            anchors { verticalCenter: undefined; }
                        }
                        PropertyChanges {
                            target: block
                            z: 10
                        }
                    }
                }
                Image {
                    id: reorder
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    width: 48
                    height: 48
                    fillMode: Image.PreserveAspectFit
                    visible: editable
                    source: "icons/up_down.png"
                    //
                    //
                    //
                    MouseArea {
                        id: dragArea
                        anchors.fill: parent
                        enabled: editable
                        onPressAndHold: held = true
                        onReleased: {
                            if ( held ) {
                                held = false;
                                block.y = 0;
                                syncDatabase();
                            }
                        }
                        drag.target: held ? block : undefined
                        drag.axis: Drag.YAxis
                        property bool held: false
                    }
                }
                //
                //
                //
                DropArea {
                    anchors.fill: parent
                    onEntered: {
                        var from = drag.source.DelegateModel.itemsIndex;
                        var to = editableItem.DelegateModel.itemsIndex;
                        console.log( 'dragging from ' + from + ' to ' + to );
                        if ( from !== to ) {
                            blocksModel.items.move( from, to );
                            contents.positionViewAtIndex(to, ListView.Visible);
                        }
                    }
                    onDropped: {
                        console.log('dropped');
                        contents.forceLayout();
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    enabled: !editable
                    onClicked: {
                        if( block.type === 'image' ) {
                            zoomed.show('file://' + SystemUtils.documentDirectory() + '/' + model.content);
                        }
                    }
                }
            }
            //
            //
            //
            onEdit: {
                swipe.close();
                var blockIndex = model.index;
                console.log( 'editing block : ' + blockIndex );
                blockEditor.show( false, function( type, content ) {
                    var block = {
                        type: type,
                        content: content
                    };
                    blocksModel.model.set(blockIndex,block);
                    contents.forceLayout();
                    syncDatabase();
                }, model.type, model.content );
            }
            onRemove: {
                swipe.close();
                console.log( 'removing block : ' + model.index );
                if ( model.type === 'image' ) {
                    //
                    // delete image file
                    //
                    SystemUtils.removeFile( SystemUtils.documentDirectory() + '/' + model.content );
                }
                blocksModel.model.remove(model.index);
                syncDatabase();
            }
            onClicked: {
                console.log( 'block clicked : ' + model.index );
                swipe.close();
            }
            onEnabledChanged: {
                swipe.close();
            }
        }
    }
    //
    //
    //
    DelegateModel {
        id: challengesModel
        //
        //
        //
        model: ListModel {}
        delegate: Item {
            width: contents.width
            height: 48
            //
            //
            //
            Image {
                id: challengeIcon
                width: height
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 4
                fillMode: Image.PreserveAspectFit
                source:"icons/challenge.png"
            }
            //
            //
            //
            Text {
                anchors.top: parent.top
                anchors.left: challengeIcon.right
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 4
                horizontalAlignment: Label.AlignLeft
                verticalAlignment: Label.AlignTop
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                minimumPointSize: 12
                fontSizeMode: Text.Fit
                font.weight: Font.Light
                font.family: fonts.light
                font.pointSize: 18
                color: Colours.almostWhite
                text: model.name
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var challenge = challengeModel.findOne({_id:model._id});
                    if ( challenge ) {
                        var properties = {
                            title: challenge.name,
                            activity: Utils.formatChallengeDescription(challenge.activity, challenge.repeats, challenge.frequency),
                            active: challenge.active,
                            notifications: challenge.notifications,
                            challengeId: model._id
                        };
                        stack.push( "qrc:///ChallengeViewer.qml", properties );
                    }
                }
            }
        }
    }

    //
    //
    //
    ListView {
        id: contents
        anchors.fill: parent
        anchors.bottomMargin: 4
        //
        //
        //
        clip: true
        spacing: 4
        //
        //
        //
        model: blocksModel
        //
        //
        //
        header: Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            height: childrenRect.height + 16
            radius: 4
            color: Colours.slate
            //
            //
            //
            FlowerChart {
                id: flowerChart
                height: 240
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 8
                enabled: true
                fontSize: 12
                values: dailyModel.valuesForDate(date)
                maxValues: rehabModel.getGoalValues(date)
                animated: false
            }
            //
            //
            //
            ListView {
                id: challenges
                width: parent.width
                height: model.count * 50 //Math.min( model.count, 3 ) * 48
                anchors.top: flowerChart.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 8
                spacing: 2
                clip: true
                visible: model.count > 0
                model: challengesModel
            }
        }
    }
    //
    //
    //
    footer: Rectangle {
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        color: Colours.slate
        //
        //
        //
        AfterTrauma.Button {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: editable ? "done" : "edit"
            enabled: blocksModel.count > 0
            onClicked: {
                editable = !editable;
            }
        }
        //
        //
        //
        AfterTrauma.Button {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "share"
            //
            //
            //
            AsyncDiaryWriter {
                id: writer
                font: fonts.light
                onDone: {
                    ShareDialog.shareFile('Shared from AfterTrauma', filePath);
                    busyIndicator.running = false;
                }
                onError: {
                    busyIndicator.running = false;
                    errorDialog.show( error );
                }
            }
            //
            //
            //
            onClicked: {
                var query = {
                    day: date.getDate(),
                    month: date.getMonth(),
                    year: date.getFullYear()
                };
                var day = dailyModel.findOne(query);
                if ( day ) {
                    busyIndicator.prompt = "preparing diary for sharing";
                    busyIndicator.running = true;
                    console.log( 'sharing diary entry: ' + day.day + '-' + day.month + '-' + day.year );
                    var pdfPath = SystemUtils.documentDirectory() + '/diary-' + day.day + '-' + ( day.month + 1 ) + '-' + day.year + '.pdf';
                    writer.save([day], pdfPath);
                }
            }
        }
        //
        //
        //
        AfterTrauma.Button {
            id: addEntry
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            backgroundColour: "transparent"
            image: "icons/add.png"
            onClicked: {
                blockEditor.show( false, function( type, content ) {
                    //
                    // append block
                    //
                    var block = {
                        type: type,
                        title: Date(),
                        content: content,
                        tags: []
                    };
                    blocksModel.model.append(block);
                    contents.positionViewAtIndex(blocksModel.model.count-1,ListView.Visible);
                    syncDatabase();
                });
            }
        }
    }
    //
    //
    //
    ImageViewer {
        id: zoomed
        anchors.fill: parent
    }
    //
    //
    //
    function syncDatabase() {
        //
        //
        //
        var count = blocksModel.count;
        var blocks = [];
        for ( var i = 0; i < count; i++ ) {
            var block = blocksModel.items.get(i).model;
            if ( block.tags === undefined || block.tags === null || !Array.isArray(block.tags) ) {
                console.log( 'DiaryEntry.StackView.onDeavtivating : invalid tags : ' + block.tags );
                block.tags = [];
            } else {
                console.log( 'DiaryEntry.StackView.onDeavtivating : tags : ' + JSON.stringify(block.tags) );
            }

            blocks.push({
                            type: block.type,
                            title: block.title,
                            content: block.content/*,
                            tags: block.tags // tags*/
                        });
        }
        //
        //
        //
        dailyModel.updateDay( date, { blocks: blocks } );
        dailyModel.save();
    }
    //
    //
    //
    StackView.onActivating: {
        //
        //
        //
        console.log( 'DiaryEntry.StackView.onActivating : finding day : ' + JSON.stringify(date));
        var query = {
            day: date.getDate(),
            month: date.getMonth(),
            year: date.getFullYear()
        };
        var day = dailyModel.findOne(query);
        if ( day ) {
            console.log( 'DiaryEntry.StackView.onActivating : found day : ' + JSON.stringify(day));
        } else {
            console.log( 'DiaryEntry.StackView.onActivating : unable to find day : ' + JSON.stringify(date));
        }

        //
        //
        //
        console.log( 'DiaryEntry.StackView.onActivating : clearing models' );
        blocksModel.model.clear();
        challengesModel.model.clear();
        if ( day  ) {
            if ( day.blocks ) {
                console.log( 'DiaryEntry.StackView.onActivating : bulding blocksModel from : ' + JSON.stringify(day.blocks) );
                day.blocks.forEach( function(block){
                    blocksModel.model.append(block);
                });
            }
            if ( day.challenges ) {
                console.log( 'DiaryEntry.StackView.onActivating : bulding challengesModel from : ' + JSON.stringify(day.challenges) );
                day.challenges.forEach( function(challenge) {
                    challengesModel.model.append(challenge);
                });
            }
        }
    }
    StackView.onDeactivating: {
    }
    //
    //
    //
    property bool editable: false
    property date date: new Date()
}
