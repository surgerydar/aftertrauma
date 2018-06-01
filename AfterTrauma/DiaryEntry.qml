import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQml.Models 2.2

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
        delegate: MouseArea {
            id: dragArea
            enabled: editable
            anchors { left: parent.left; right: parent.right }
            height: block.height
            onPressAndHold: held = true
            onReleased: {
                if ( held ) {
                    held = false;
                    block.y = 0;
                }
            }
            property bool held: false
            drag.target: held ? block : undefined
            drag.axis: Drag.YAxis

            AfterTrauma.Block {
                id: block
                anchors.left: parent.left
                anchors.right: parent.right
                type: model.type
                media: model.content
                onMediaReady: {
                    contents.forceLayout();
                }

                Drag.active: dragArea.held
                Drag.source: dragArea
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                states: State {
                    when: dragArea.held

                    ParentChange { target: block; parent: container }
                    AnchorChanges {
                        target: block
                        anchors { horizontalCenter: undefined; verticalCenter: undefined }
                    }
                }
            }

            DropArea {
                anchors.fill: parent
                onEntered: {
                    console.log( 'dragging from ' + drag.source.DelegateModel.itemsIndex + ' to ' + dragArea.DelegateModel.itemsIndex );
                    if ( drag.source.DelegateModel.itemsIndex !== dragArea.DelegateModel.itemsIndex ) {
                        blocksModel.items.move(
                                    drag.source.DelegateModel.itemsIndex,
                                    dragArea.DelegateModel.itemsIndex);
                    }
                }
                onDropped: {
                    console.log('dropped');
                    contents.forceLayout();
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
        //
        //
        //
        clip: true
        spacing: 4
        //
        //
        //
        /*
        model: ListModel {}
        //
        //
        //
        delegate: AfterTrauma.Block {
            anchors.left: parent.left
            anchors.right: parent.right
            type: model.type
            media: model.content
            editable: true // TODO: toggle this with edit tool
            onMediaReady: {
                contents.update();
            }
        }
        */
        model: blocksModel
        add: Transition {
            NumberAnimation { properties: "y"; from: contents.height; duration: 250 }
        }
        displaced: Transition {
            NumberAnimation { properties: "y"; duration: 250 }
        }
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
            id: addEntry
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 8
            backgroundColour: "transparent"
            image: "icons/add.png"
            onClicked: {
                //addDialog.open();
                blockEditor.show( false );
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
        if ( day && day.blocks ) {
            day.blocks.forEach( function(block){
                if ( block.tags.length <= 0 ) {
                    for ( var i = 0; i < 4; i++ ) {
                        block.tags.push( 'testtag' + i );
                    }
                }
                block.tags = JSON.stringify(block.tags);
                blocksModel.model.append(block);
            });
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
            var tags = block.tags ? JSON.parse(block.tags) : [];
            blocks.push({
                            type: block.type,
                            title: block.title,
                            content: block.content,
                            tags: tags
                        });
        }

        var query = {
            day: date.getDate(),
            month: date.getMonth(),
            year: date.getFullYear()
        };
        var result = dailyModel.update( query, { blocks: blocks } );
    }
    //
    //
    //
    property bool editable: true
    property date date: new Date()
}
