import QtQuick 2.6
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

Popup {
    id: container
    modal: true
    focus: true
    x: 0
    y: 0
    width: appWindow.width
    height: appWindow.height
    //
    //
    //
    background: Item {
        Rectangle {
            height: 64
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            color: Colours.almostWhite
        }
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 68
            color: Colours.almostWhite
        }
    }
    //
    //
    //
    Item {
        id: header
        height: 64
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        Label {
            id: title
            anchors.fill: parent
            anchors.leftMargin: closeButton.width + 24
            anchors.rightMargin: closeButton.width + 24
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            fontSizeMode: Label.Fit
            color: Colours.veryDarkSlate
            font.pixelSize: 36
            font.weight: Font.Light
            font.family: fonts.light
            text: "INTRODUCTION"
        }
        //
        //
        //
        AfterTrauma.Button {
            id: closeButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 16
            image: "icons/close.png"
            onClicked: {
                container.close();
            }
        }
    }
    //
    //
    //
    SwipeView {
        id: contentContainer
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: footer.top
        anchors.topMargin: 4
        anchors.bottomMargin: 8
        clip: true
        //
        //
        //
        Repeater {
            id: pages
            anchors.fill: parent
            model: ListModel {}
            delegate: ListView {
                id: page
                //anchors.fill: pages
                //model: model.blocks
                model: blocks
                delegate: AfterTrauma.Block {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    type: model.type
                    media: model.content
                }
                add: Transition {
                    NumberAnimation { properties: "y"; from: contentContainer.height; duration: 250 }
                }
            }
        }
    }
    //
    //
    //
    Item {
        id: footer
        height: 64
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 8

        AfterTrauma.PageIndicator {
            id: pageIndicator
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            //
            //
            //
            interactive: true
            currentIndex: contentContainer.currentIndex
            count: contentContainer.count
            onCurrentIndexChanged: {
                if ( currentIndex != contentContainer.currentIndex ) contentContainer.currentIndex = currentIndex;
            }
        }
        AfterTrauma.Button {
            id: prevButton
            anchors.verticalCenter: pageIndicator.verticalCenter
            anchors.left: parent.left
            image: "icons/left_arrow.png"
            radius: 0
            backgroundColour: Colours.veryLightSlate
            visible: contentContainer.currentIndex > 0
            onClicked: {
                contentContainer.decrementCurrentIndex();
            }
        }
        AfterTrauma.Button {
            id: nextButton
            anchors.verticalCenter: pageIndicator.verticalCenter
            anchors.right: parent.right
            image: "icons/right_arrow.png"
            radius: 0
            backgroundColour: Colours.veryLightSlate
            visible: contentContainer.currentIndex < contentContainer.count - 1
            onClicked: {
                contentContainer.incrementCurrentIndex();
            }
        }
    }

    //
    //
    //
    Component.onCompleted: {
        pages.model.clear();
        var filter = {section: 'introduction'};
        //console.log( 'Introduction : filtering by : ' + JSON.stringify( filter ) );
        documentModel.setFilter(filter);
        var count = documentModel.count;
        //console.log( 'Introduction : appending : ' + count + ' documents' );
        if ( count <= 0 ) {

            //
            // install default
            //
            installDefault();
            documentModel.setFilter(filter);
            //documentModel.save();
            count = documentModel.count;

        }
        for ( var i = 0; i < count; i++ ) {
            var document = documentModel.get(i);
            //console.log( 'Introduction : appending document : ' + JSON.stringify(document));
            pages.model.append(document);
        }
    }

    function installDefault() {
        var documents = [
                    {
                        "_id":"5b34fb182542ff3046a4f26f",
                        "title":"My Recovery",
                        "date":1531218343524,
                        "category": "5ae88e6d541833259b4a2dbe",
                        "section": "introduction",
                        "blocks":[
                            {"type":"text","title":"","content":"   My Recovery - fill out this short questionnaire so you can see where you are with your recovery. Once a week is good early in your recovery.","tags":[""]},{"type":"image","title":"","content":"http://aftertrauma.uk:4000/media/IMG_6180.PNG","tags":[]}
                        ],
                        "index":0
                    },
                    {
                        "_id":"5b34fb822542ff3046a4f270",
                        "title":"Flower Tracker",
                        "date":1531218251807,
                        "category": "5ae88e6d541833259b4a2dbe",
                        "section": "introduction",
                        "blocks":[
                            {"type":"text","title":"","content":"  Flower tracker: this helps you track and see your progress. When you repeat the My Recovery questionnaire over time, the petals will grow or shrink to show you where you are on your journey","tags":[""]},{"type":"image","title":"","content":"http://aftertrauma.uk:4000/media/IMG_6181.PNG","tags":[]}
                        ],
                        "index":1
                    },
                    {
                        "_id":"5b34fbfa2542ff3046a4f271",
                        "title":"Challenge Builder",
                        "date":1531218482186,
                        "category": "5ae88e6d541833259b4a2dbe",
                        "section": "introduction",
                        "blocks":[
                            {"type":"text","title":"","content":"  Challenge Builder - set goals and challenges to help you recover. There are some suggestions you can use, but you can also set your own. ","tags":[""]},{"type":"image","title":"","content":"http://aftertrauma.uk:4000/media/IMG_6182.PNG","tags":[]}
                        ],
                        "index":2
                    },
                    {
                        "_id":"5b34fd4c2542ff3046a4f272",
                        "title":"Diary",
                        "date":1531218530298,
                        "category": "5ae88e6d541833259b4a2dbe",
                        "section": "introduction",
                        "blocks":[
                            { "type":"text", "title":"", "content": "  Diary - take notes and load pictures about your recovery.","tags":[""]},{"type":"image","title":"","content":"http://aftertrauma.uk:4000/media/IMG_6183.png","tags":[]}
                        ],
                        "index":3
                    },
                    {
                        "_id":"5b34fd7e2542ff3046a4f273",
                        "title":"Information",
                        "date":1531218583318,
                        "category": "5ae88e6d541833259b4a2dbe",
                        "section": "introduction",
                        "blocks":[
                            {"type":"text","title":"","content":"  Information on a variety of topics to help you recover.","tags":[""]},{"type":"image","title":"","content":"http://aftertrauma.uk:4000/media/IMG_6184.PNG","tags":[]}
                            ],
                        "index":4
                    },
                    {
                        "_id":"5b34fdb72542ff3046a4f274",
                        "title":"Chat",
                        "date":1531218806877,
                        "category": "5ae88e6d541833259b4a2dbe",
                        "section": "introduction",
                        "blocks":[
                            {"type":"text","title":"","content":" Chat - is where you can connect with others recovering from injury, and share tips and support to help each other.","tags":[]},{"type":"image","title":"","content":"http://aftertrauma.uk:4000/media/IMG_6186.PNG","tags":[]}
                        ],
                        "index":5
                    },
                    {
                        "_id":"5a1d41e6c995b330007e2394",
                        "title":"About After Trauma",
                        "category": "5ae88e6d541833259b4a2dbe",
                        "section": "introduction",
                        "blocks":[
                            {"type":"text","title":"About","content":"     This app has been produced by the <a href=\"http://www.c4ts.qmul.ac.uk\">Centre for Trauma Sciences</a>. We are a medical research institute that is part of Queen Mary University of London. The Royal London Hospital Major Trauma Centre, one of the busiest in Europe, is our primary clinical partner. We conduct research into better treatments for people who are seriously injured to save more lives and improve quality of life for survivors.  This app has been funded by <a href=\"https://bartscharity.org.uk/\">Barts Charity</a> who is a major supporter of our work.","tags":["AfterTrauma","C4TS"]}
                        ],
                        "date":1531218911470,
                        "index":6
                    }
                ];
        documentModel.beginBatch();
        documents.forEach(function( document ) {
            document._id = GuidGenerator.generate(); // to avoid conflicts
            documentModel.batchAdd(document);
        });
        documentModel.endBatch();
    }
}
