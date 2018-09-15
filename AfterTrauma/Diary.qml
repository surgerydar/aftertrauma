import QtQuick 2.7
import QtQuick.Controls 2.1

import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

AfterTrauma.Page {
    id: container
    title: "DIARY"
    colour: Colours.slate
    //
    //
    //
    AfterTrauma.EditableList {
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
        //
        //
        //
        emptyPrompt: "Add a Diary Entry<br/>or<br/>complete your<br/>Recovery Questionnaire"
        //
        //
        //
        model: dailyModel
        //
        //
        //
        /*
        delegate: Component {
            Loader {
                source: "DiaryListItem.qml"
                onLoaded: {
                    //
                    // extract numeric scores
                    //
                    var scores = [];
                    model.values.forEach( function( value ) {
                        scores.push(value.value);
                    });
                    //
                    // set properties
                    //
                    item.width  = dailyList.width;
                    item.date   = model.date;
                    item.values = scores;
                    item.blocks = model.blocks;
                }
            }
        }
        */
        delegate: Item {
            width: dailyList.width;
            height: width / 4.
            //
            //
            //
            Rectangle {
                id: background
                anchors.fill: parent
                color: Colours.slate
            }
            //
            //
            //
            Label {
                id: dateText
                width: height
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 4
                //
                //
                //
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                font.weight: Font.Light
                font.family: fonts.light
                font.pointSize: 32
                color: Colours.almostWhite
                text: Utils.shortDateVertical(model.date,true)
            }
            //
            // Indicators
            //
            Image {
                id: imageIndicator
                width: height
                anchors.top: parent.top
                anchors.left: dateText.right
                anchors.bottom: parent.bottom
                anchors.margins: 4
                sourceSize.height: height
                sourceSize.width: width
                fillMode: Image.PreserveAspectCrop
                visible: status === Image.Ready
                source: firstBlockContent("image")
            }
            //
            //
            //
            Label {
                id: notesIndicator
                width: height
                anchors.top: parent.top
                anchors.left: imageIndicator.right
                anchors.bottom: parent.bottom
                anchors.margins: 4
                fontSizeMode: Label.Fit
                minimumPointSize: 12
                font.weight: Font.Light
                font.family: fonts.light
                font.pointSize: 32
                elide: Label.ElideRight
                wrapMode: Label.WordWrap
                topPadding: height / 3.
                bottomPadding: height / 3.
                leftPadding: 4
                rightPadding: 4
                color: Colours.darkSlate
                visible: text.length > 0
                text: firstBlockContent("text")

                background: Rectangle {
                    anchors.fill: parent
                    color: Colours.lightSlate
                }
            }
            //
            //
            //
            FlowerChart {
                id: flowerChart
                width: height
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 4
                enabled: false
                values: dailyModel.valuesForDate(model.date)
                animated: false
            }
            //
            //
            //
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var d = new Date( model.date );
                    stack.push( "qrc:///DiaryEntry.qml", { date: d } );
                }
            }
            //
            //
            //
            function firstBlockContent(type) {
                var blocks = model.blocks;
                for ( var i = 0; i < blocks.length; i++ ) {
                    if ( blocks[ i ].type === type ) return ( type === 'image' ? 'file://' + SystemUtils.documentDirectory() + '/' : "" ) + blocks[ i ].content;
                }
                return "";
            }
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
            AsyncDiaryWriter {
                id: writer
                font.family: fonts.light
                onDone: {
                    ShareDialog.shareFile('Shared from AfterTrauma', filePath);
                    busyIndicator.running = false;
                    container.enabled = true;
                }
                onError: {
                    busyIndicator.hide();
                    container.enabled = true;
                    errorDialog.show( error );
                }
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
                        busyIndicator.show( 'preparing diary for sharing' );
                        var lastIndex = entries.length - 1;
                        var rangeText = entries[ 0 ].day + '-' + entries[ 0 ].month + '-' + entries[ 0 ].year + '-to-' + entries[ lastIndex ].day + '-' + entries[ lastIndex ].month + '-' + entries[ lastIndex ].year;
                        var pdfPath = SystemUtils.documentDirectory() + '/diary-' +  rangeText + '.pdf';
                        writer.save(entries,pdfPath);
                    }
                }, 'Share Diary' );
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
                            dailyList.list.positionViewAtIndex(dayIndex, ListView.Visible);
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
    }
    //
    //
    //
    Connections {
        target: dailyModel
        onDataChanged: {
            console.log( 'Diary : dailyModel data changed');
        }
    }
}
