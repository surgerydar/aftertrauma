import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQml.Models 2.2

import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

Page {
    id: container
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
                            contents.positionViewAtIndex(to, ListView.Visible);
                            //
                            //
                            //
                            var temp = plan.blocks[ to ];
                            plan.blocks[ to ] = plan.blocks[ from ];
                            plan.blocks[ from ] = temp;
                        }
                    }
                    onDropped: {
                        console.log('dropped');
                        contents.forceLayout();
                        syncDatabase();
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
                    plan.blocks[blockIndex] = block;
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
                plan.blocks.splice(model.index,1);
                updateDatabase();
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
        /*
        header: Rectangle {
            width: contents.width
            height: 64
            AfterTrauma.Button {
                id: addButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.margins: 8
                image: "icons/add.png"
                backgroundColour: "transparent"
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
                        //
                        //
                        //
                        plan.blocks.push(block);
                        syncDatabase();
                    });
                }
            }
        }
        */
        //
        //
        //
        footer: Rectangle {
            id: goalsBlock
            height: childrenRect.height + 16
            width: contents.width
            color: Colours.lightSlate
            Item {
                id: editBar
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 64
                AfterTrauma.Button {
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    enabled: blocksModel.count > 0
                    text: editable ? "done" : "edit"
                    onClicked: {
                        editable = !editable;
                    }
                }
                AfterTrauma.Button {
                    id: addButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.margins: 8
                    image: "icons/add.png"
                    backgroundColour: "transparent"
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
                            //
                            //
                            //
                            plan.blocks.push(block);
                            syncDatabase();
                        });
                    }
                }
                Rectangle {
                    height: 1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    color: Colours.veryDarkSlate
                }
            }
            //
            //
            //
            Label {
                id: goalsHeader
                anchors.top: editBar.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 8
                color: Colours.veryDarkSlate
                fontSizeMode: Label.Fit
                font.family: fonts.light
                font.pointSize: 24
                text: "Goals"
            }
            Column {
                anchors.top: goalsHeader.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 4
                width: parent.width
                Repeater {
                    model: plan && plan.goals ? plan.goals.length : 0
                    Item {
                        width: goalsBlock.width
                        height: 48
                        Label {
                            id: nameLabel
                            width: parent.width / 3
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 8
                            font.family: fonts.light
                            font.pointSize: 18
                            verticalAlignment: Label.AlignVCenter
                            horizontalAlignment: Label.AlignRight
                            text: plan.goals[ index ].name
                        }
                        AfterTrauma.Slider {
                            id: valueSlider
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: nameLabel.right
                            anchors.right: parent.right
                            anchors.margins: 8
                            from: 0; to: 100;
                            value: plan.goals[ index ].value * 100
                            onValueChanged: {
                                plan.goals[ index ].value = value / 100.;
                                syncDatabase();
                            }
                        }
                    }
                }
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
        rehabModel.update( {id:plan.id},{goals: plan.goals,blocks: plan.blocks} );
        rehabModel.save();
    }

    //
    //
    //
    onPlanChanged: {
        blocksModel.model.clear();
        if ( plan && plan.blocks ) {
            plan.blocks.forEach( function( block ) {
                blocksModel.model.append(block);
            });
        }
    }
    //
    //
    //
    property bool editable: false
    property var plan: null
}
