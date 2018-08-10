import QtQuick 2.7
import QtQuick.Controls 2.1

import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

AfterTrauma.Page {
    title: "DIARY"
    colour: Colours.slate
    //
    //
    //
    ListView {
        id: dailyList
        //
        //
        //
        anchors.fill: parent
        anchors.bottomMargin: 4
        //
        //
        //
        clip: true
        spacing: 8
        cacheBuffer: 0
        //
        //
        //
        model: dailyModel
        //
        //
        //
        /*
        delegate: Text {
            height: 32
            anchors.left: parent?parent.left:undefined
            anchors.right: parent?parent.right:undefined
            text: Utils.shortDate(model.date)
        }
        */

        delegate: DiaryListItem {
            anchors.left: parent?parent.left:undefined
            anchors.right: parent?parent.right:undefined
            date: model.date
            images: model.images
            notes: model.notes
            values: model.values
            blocks: model.blocks || []
        }
        //
        //
        //
        section.property: "year"
        section.delegate: Text {
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 4
            font.weight: Font.Light
            font.family: fonts.light
            font.pointSize: 32
            color: Colours.almostWhite
            text: section
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
            id: share
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            backgroundColour: "transparent"
            text: "share"
            //
            //
            //
            DiaryWriter {
                id: writer
                font: fonts.lightFont
            }
            //
            //
            //
            onClicked: {
                //
                // show date range dialog
                //
                dateRangePicker.show( function( fromDate, toDate ) {
                    //var fromIndex = dailyModel.indexOfFirstDayBefore( fromDate );
                    //var toIndex = dailyModel.indexOfFirstDayAfter( toDate );
                    var query = { $and: [{ date: { $gte: fromDate.getTime() } }, { date: { $lte: toDate.getTime() } }] };
                    var entries = dailyModel.find(query);
                    if ( entries.length > 0 ) {
                        var pdfPath = SystemUtils.documentDirectory() + '/diary.pdf';
                        writer.save(entries,pdfPath);
                        ShareDialog.shareFile('Shared from AfterTrauma', pdfPath);
                    }
                });
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
                blockEditor.show( true, function( type, content, date ) {
                    var day = dailyModel.getDay( date, true );
                    if ( day ) {
                        var blocks = day.blocks || [];
                        blocks.push({
                                        type: type,
                                        title: Date(),
                                        content: content,
                                        tags: []
                                    });
                        dailyModel.updateDay( date, { blocks: blocks } );
                        dailyModel.save();
                        var dayIndex = dailyModel.getDayIndex(date);
                        if ( dayIndex >= 0 ) {
                            dailyList.positionViewAtIndex(dayIndex, ListView.Visible);
                        }
                    }
                });
            }
        }
    }
    //
    //
    //
    StackView.onActivated: {
        //dailyList.forceLayout();
    }
    //
    //
    //
    Connections {
        target: dailyModel
        onDataChanged : {
            console.log('dailyModel.onDataChanged');
            //dailyList.forceLayout();
        }
    }
}
