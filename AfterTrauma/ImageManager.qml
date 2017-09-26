import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

AfterTrauma.Page {
    id: container
    //
    //
    //
    title: "IMAGES"
    subtitle: date > 0 ? Utils.shortDate(date) : ""
    colour: Colours.blue
    //
    //
    //
    SwipeView {
        id: imagesView
        anchors.fill: parent
        anchors.bottomMargin: 36
        //
        //
        //
        Repeater {
            id: imagesRepeater
            delegate: ImagePage {
                image: images[ index ].image
                onImageChanged: {
                    //images[ index ].image = image;
                    console.log('image changed : ' + image );
                }
            }
        }
    }
    AfterTrauma.PageIndicator {
        anchors.horizontalCenter: imagesView.horizontalCenter
        anchors.bottom: imagesView.bottom
        anchors.bottomMargin: 16
        currentIndex: imagesView.currentIndex
        count: imagesView.count
        colour: Colours.lightSlate
    }
    AfterTrauma.Button {
        id: addButton
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 8
        image: "icons/add.png"
        backgroundColour: "transparent"
        //visible: images.length > 1 && images[ images.length -  1 ].image !== ""
        onClicked: {
            images.push({title:"", image:""});
            imagesRepeater.model = images;
            imagesView.currentIndex = images.length - 1;
        }
    }
    //
    //
    //
    footer: Item {
        height: 28
    }
    //
    //
    //
    StackView.onActivated: {
        console.log( 'ImagesManager : activating' );
        var day;
        if ( date === 0 ) {
            console.log( 'ImagesManager : getting todays images' );
            day = dailyModel.getToday();
            date = day.date;
        } else {
            day = dailyModel.getDay(new Date(date));
        }
        images = day.images;
        if ( images === undefined || images.length === 0 ) {
            console.log( 'ImagesManager : no images so creating default' );
            //
            // add default empty image
            //
            images = [{title:"",image:""}];
            //images.push({title:"",image:""});
         }
         imagesRepeater.model = images;
    }
    StackView.onDeactivating: {
        dailyModel.update({date: date},{images: images});
        dailyModel.save();
    }
    //
    //
    //
    Connections {
        target: ImagePicker
        onImagePicked: {
            var source = 'file://' + url;
            console.log( 'image picked : ' + source );
            images[imagesView.currentIndex].image = source;
            imagesView.currentItem.image = images[imagesView.currentIndex].image;
        }
    }
    //
    //
    //
    property var images: []
    property var date: 0
}
