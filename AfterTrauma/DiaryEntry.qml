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
            height: block.implicitHeight
            anchors.left: parent.left
            anchors.right: parent.right
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
                    source: "icons/reorder.png"
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
                        }
                    }
                    onDropped: {
                        console.log('dropped');
                        contents.forceLayout();
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
                }, model.type, model.content );
            }
            onRemove: {
                swipe.close();
                console.log( 'removing block : ' + model.index );
                blocksModel.model.remove(model.index);
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
    /*
    DropArea {
        anchors.fill: parent
        onPositionChanged: {
            console.log( 'x:' + drag.x + ' y:' + drag.y );
            drag.accepted = false;
        }
    }
    */
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
        model: blocksModel
        //
        //
        //
        header: Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            height: 256
            radius: 4
            color: Colours.slate
            //
            //
            //
            FlowerChart {
                id: flowerChart
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 8
                enabled: true
                fontSize: 12
                values: dailyModel.valuesForDate(date)
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stack.navigateTo("qrc:///Questionnaire.qml");
                }
            }
        }
        //
        //
        //
        /* JONS: transitions causing layout issues
        add: Transition {
            NumberAnimation { properties: "y"; from: contents.height; duration: 250 }
        }
        displaced: Transition {
            NumberAnimation { properties: "y"; duration: 250 }
        }
        */
    }
    //
    //
    //
    footer: Item {
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        AfterTrauma.Button {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: editable ? "done" : "edit"
            onClicked: {
                editable = !editable;
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
                });
            }
        }
    }
    //
    //
    //
    StackView.onActivating: {
        //
        //
        //
        var query = {
            day: date.getDate(),
            month: date.getMonth(),
            year: date.getFullYear()
        };
        var day = dailyModel.findOne(query);
        blocksModel.model.clear();
        if ( day  ) {
            if ( day.blocks ) {
                day.blocks.forEach( function(block){
                    /*
                    if ( block.tags.length <= 0 ) {
                        for ( var i = 0; i < 4; i++ ) {
                            block.tags.push( 'testtag' + i );
                        }
                    }
                    block.tags = JSON.stringify(block.tags);
                    */
                    blocksModel.model.append(block);
                });
            }
        }
    }
    StackView.onDeactivating: {
        //
        //
        //
        var count = blocksModel.count;
        var blocks = [];
        for ( var i = 0; i < count; i++ ) {
            var block = blocksModel.items.get(i).model;
           // var tags = block.tags ? JSON.parse(block.tags) : [];
            blocks.push({
                            type: block.type,
                            title: block.title,
                            content: block.content,
                            tags: block.tags // tags
                        });
        }
        console.log( 'DiaryEntry StackView.onDeactivating : saving blocks : ' + JSON.stringify(blocks) );
        //
        //
        //
        dailyModel.updateDay( date, { blocks: blocks } );
        dailyModel.save();
    }
    //
    //
    //
    property bool editable: false
    property date date: new Date()
}
