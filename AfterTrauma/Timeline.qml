import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    title: "TIMELINE"
    colour: Colours.darkSlate
    //
    //
    //
    ListView {
        id: dailyList
        //
        //
        //
        anchors.fill: parent
        //
        //
        //
        clip: true
        spacing: 8
        //
        //
        //
        model: ListModel {}
        //
        //
        //
        delegate: TimelineItem {
            anchors.left: parent.left
            anchors.right: parent.right
            date: model.date
            images: model.images
            notes: model.notes
            values: model.values
        }
    }
    //
    //
    //
    StackView.onActivated: {
        var datapoints = [];
        var week = 1000 * 60 * 60 * 24 * 7;
        for ( var i = 0; i < 64; i++ ) {
            var datapoint = {
                date: Date.now() - week * i,

            };
            datapoint.values = [];
            for ( var j = 0; j < 5; j++ ) {
                datapoint.values.push( {
                                          name: 'value ' + j,
                                          value: Math.random()
                                      });
            }
            datapoint.images = [];
            for ( j = 0; j < Math.random() * 4; j++ ) {
                datapoint.images.push('icons/chart.png')
            }
            datapoint.notes = [];
            for ( j = 0; j < Math.random() * 4; j++ ) {
                datapoint.images.push('note number ' + j );
            }
            datapoints.push(datapoint);
        }
        dailyList.model.clear();
        datapoints.forEach(function(datum) {
            dailyList.model.append(datum);
        });
    }
}
