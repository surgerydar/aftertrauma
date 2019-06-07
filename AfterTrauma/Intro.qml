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
                        "_id":"5b5ecf974c37ca0c1bf96349",
                        "title":"Welcome",
                        "date":1559140640200,
                        "category":"5a1d41e1c995b330007e2393",
                        "blocks":[
                            {
                                "type":"text",
                                "title":"Welcome!",
                                "content":"   Welcome to AfterTrauma! This app is for survivors of serious injury who want some help to rebuild their lives. It has a recovery tracker, challenges, a diary, information sections and a chatroom. Swipe to find out more! ",
                                "tags":["welcome"]
                            },
                            {
                                "type":"image",
                                "title":"Welcome!",
                                "content":"http://aftertrauma.uk:4000/media/survivor%20resized.png",
                                "tags":[]
                            }
                        ],
                        "index":0
                    },
                    {
                        "_id":"5b34fb182542ff3046a4f26f",
                        "title":"My Recovery",
                        "date":1543425389610,
                        "category":"5a1d41e1c995b330007e2393",
                        "blocks":[
                            {
                                "type":"text",
                                "title":"",
                                "content":"   My Recovery - fill out this short questionnaire so you can see where you are with your recovery. Once a week is good early in your recovery.",
                                "tags":[]
                            },
                            {
                                "type":"image",
                                "title":"",
                                "content":"http://aftertrauma.uk:4000/media/1%20my%20recovery.PNG",
                                "tags":[]
                            }
                        ],
                        "index":1
                    },
                    {
                        "_id":"5b34fb822542ff3046a4f270",
                        "title":"Flower Tracker",
                        "date":1543424439096,
                        "category":"5a1d41e1c995b330007e2393",
                        "blocks":[
                            {
                                "type":"text",
                                "title":"",
                                "content":"  Flower tracker: this helps you track and see your progress. When you repeat the My Recovery questionnaire over time, the petals will grow or shrink to show you where you are on your journey",
                                "tags":[]
                            },
                            {
                                "type":"image",
                                "title":"",
                                "content":"http://aftertrauma.uk:4000/media/2%20home%20flower.PNG",
                                "tags":[]
                            }
                        ],
                        "index":2
                    },
                    {
                        "_id":"5b34fbfa2542ff3046a4f271",
                        "title":"Challenge Builder",
                        "date":1543424482988,
                        "category":"5a1d41e1c995b330007e2393",
                        "blocks":[
                            {
                                "type":"text",
                                "title":"",
                                "content":"  Challenge Builder - set goals and challenges to help you recover. There are some suggestions you can use, but you can also set your own. ",
                                "tags":[

                                ]
                            },
                            {
                                "type":"image",
                                "title":"",
                                "content":"http://aftertrauma.uk:4000/media/3%20challenge%20builder.PNG",
                                "tags":[]
                            }
                        ],
                        "index":3
                    },
                    {
                        "_id":"5b9926bccb70d222e17d12a6",
                        "title":"My Rehab",
                        "date":1543588151377,
                        "category":"5a1d41e1c995b330007e2393",
                        "blocks":[
                            {
                                "type":"text",
                                "title":"My Rehab",
                                "content":"Set goals, text and images for your rehabilitation plan here so you can easily refer to it anytime.",
                                "tags":["rehabilitation plan"]
                            },
                            {
                                "type":"image",
                                "title":"",
                                "content":"http://aftertrauma.uk:4000/media/rehab.png",
                                "tags":[]
                            }
                        ],
                        "index":4
                    },
                    {
                        "_id":"5b34fd4c2542ff3046a4f272",
                        "title":"Diary",
                        "date":1543425399823,
                        "category":"5a1d41e1c995b330007e2393",
                        "blocks":[
                            {
                                "type":"text",
                                "title":"",
                                "content":"  Diary - take notes and load pictures about your recovery.",
                                "tags":[]
                            },
                            {
                                "type":"image",
                                "title":"",
                                "content":"http://aftertrauma.uk:4000/media/4%20diary.PNG",
                                "tags":[]
                            }
                        ],
                        "index":5
                    },
                    {
                        "_id":"5b34fd7e2542ff3046a4f273",
                        "title":"Information",
                        "date":1543424831316,
                        "category":"5a1d41e1c995b330007e2393",
                        "blocks":[
                            {
                                "type":"text",
                                "title":"",
                                "content":"  Information on a variety of topics to help you recover.",
                                "tags":[""]
                            },
                            {
                                "type":"image",
                                "title":"",
                                "content":"http://aftertrauma.uk:4000/media/5%20information.PNG",
                                "tags":[""]
                            }
                        ],
                        "index":6
                    },
                    {
                        "_id":"5b34fdb72542ff3046a4f274",
                        "title":"Chat",
                        "date":1545389951546,
                        "category":"5a1d41e1c995b330007e2393",
                        "blocks":[
                            {
                                "type":"text",
                                "title":"",
                                "content":"  Chat - is where you can connect with others recovering from injury, and share tips and support to help each other. If you get messages which are rude or abusive please use the report abuse link in the sender's profile.",
                                "tags":[""]
                            },
                            {
                                "type":"image",
                                "title":"",
                                "content":"http://aftertrauma.uk:4000/media/6%20chat.PNG",
                                "tags":[]
                            }
                        ],
                        "index":7
                    },
                    {
                        "_id":"5b6064b507bd8926cd46e7a7",
                        "title":"Please register!",
                        "date":1543425768819,
                        "category":"5a1d41e1c995b330007e2393",
                        "blocks":[
                            {
                                "type":"text",
                                "title":"Please register!",
                                "content":" When you register, you can set up a profile, use the Chat function and find other people with similar injuries.",
                                "tags":[]
                            },
                            {
                                "type":"image",
                                "title":"",
                                "content":"http://aftertrauma.uk:4000/media/7b%20register.png",
                                "tags":[]}
                        ],
                        "index":8
                    },
                    {
                        "_id":"5a1d41e6c995b330007e2394",
                        "title":"About After Trauma",
                        "category":"5a1d41e1c995b330007e2393",
                        "blocks":[
                            {
                                "type":"text",
                                "title":"About",
                                "content":"           This app has been produced by the <a href=\"http://www.c4ts.qmul.ac.uk\">Centre for Trauma Sciences</a>. We are a medical research institute that is part of Queen Mary University of London. The Royal London Hospital Major Trauma Centre, one of the busiest in Europe, is our primary clinical partner. We conduct research into better treatments for people who are seriously injured to save more lives and improve quality of life for survivors.  This app has been funded by <a href=\"https://bartscharity.org.uk/\">Barts Charity</a> who is a major supporter of our work. <p>This app was co-designed and tested with people who have experienced major injury, carers of those people and clinicians who work in the trauma field. The advice provided here is reviewed periodically (at least every six months) and updated or modified as required. </p>The data we collect in this app is compliant with the EU's GDPR requirements. You can find out how your information is used and protected in the privacy statement on our <a href=\"http://www.aftertrauma.org/app_privacy\">website</a> <p><p>If you have any feedback you’d like to provide to us about this app, you can do so by contacting <a href=\"mailto:info@aftertrauma.org\">info@aftertrauma.org</a>  We will do our best to address any issues you have. </p>",
                                "tags":["AfterTrauma","C4TS"]
                            },
                            {
                                "type":"image",
                                "title":"C4TS logo",
                                "content":"http://aftertrauma.uk:4000/media/C4TS%20logo%20with%20strapline%20PNG%20FOR%20APP.png",
                                "tags":[]
                            }
                        ],
                        "date":1558517726144,
                        "index":9
                    },
                    {
                        "_id":"5b87eafb92c21f4d5676f194",
                        "title":"Acknowledgements",
                        "date":1543592403584,
                        "category":"5a1d41e1c995b330007e2393",
                        "blocks":[
                            {
                                "type":"text",
                                "title":"Acknowledgements",
                                "content":"  Content for this app has kindly been provided by: St Georges Major Trauma Centre (London), Royal London Hospital Major Trauma Centre, Queen Alexander Hospital Portsmouth Hospitals NHS Trust, Fieldfisher Solicitors (London), Colm Treacy, Janice Hiller, Kerry Staab, Shan Martin, Evi Machova, Grace Havard, Angela and Roger Hughes-Penney, Ella Dove, Thwaites Communications, members of the AfterTrauma app development focus group and the Centre for Trauma Sciences.<Br/><Br/>The app's developers are Soda Limited <a href='http://www.soda.co.uk'>www.soda.co.uk</a>",
                                "tags":["acknowledgements","credits"]
                            }
                        ],
                        "index":10
                    }
                ];
        documentModel.beginBatch();
        documents.forEach(function( document ) {
            document._id = GuidGenerator.generate(); // to avoid conflicts, TODO: may cause problems in update
            document.section = 'introduction';
            documentModel.batchAdd(document);
        });
        documentModel.endBatch();
    }
}
