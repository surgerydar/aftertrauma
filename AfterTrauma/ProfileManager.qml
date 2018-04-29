import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container
    //
    //
    //
    title: "About You"
    colour: Colours.almostWhite
    //
    //
    //
    SwipeView {
        id: contents
        anchors.fill: parent
        //
        //
        //
        Page {
            padding: 0
            title: "About You"
            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
            }
            //
            //
            //
            Flickable {
                id: profileContainer
                anchors.fill: parent
                clip: true
                contentHeight: profileItems.childrenRect.height + 16
                //
                //
                //
                Column {
                    id: profileItems
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 4
                    //
                    //
                    //
                    Rectangle {
                        width: profileContainer.width
                        height: childrenRect.height + 16
                        color: Colours.almostWhite
                        //
                        //
                        //
                        Label {
                            id: roleHeader
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 8
                            color: Colours.veryDarkSlate
                            fontSizeMode: Label.Fit
                            font.family: fonts.light
                            font.pointSize: 24
                            text: "Who is the person filling in this profile?"
                        }
                        AfterTrauma.CheckBox {
                            id: patient
                            anchors.top: roleHeader.bottom
                            anchors.right: parent.right
                            anchors.margins: 8
                            direction: "Right"
                            text: "I have the injury"
                            checked: profile ? profile.role === "patient" : true
                            onCheckedChanged: {
                                dirty = true;
                                carer.checked = !checked;
                            }
                        }
                        AfterTrauma.CheckBox {
                            id: carer
                            anchors.top: patient.bottom
                            anchors.right: parent.right
                            anchors.margins: 8
                            direction: "Right"
                            text: "I am the carer"
                            checked: profile ? profile.role === "carer" : false
                            onCheckedChanged: {
                                dirty = true;
                                patient.checked = !checked;
                            }
                        }
                        //
                        //
                        //
                        Label {
                            id: ageLabel
                            anchors.top: age.top
                            anchors.bottom: age.bottom
                            anchors.right: age.left
                            anchors.rightMargin: 4
                            color: Colours.veryDarkSlate
                            verticalAlignment: Label.AlignVCenter
                            font.family: fonts.light
                            font.pointSize: 18
                            text: "Age"
                        }
                        AfterTrauma.TextField {
                            id: age
                            width: 64
                            anchors.top: carer.bottom
                            anchors.topMargin: 16
                            anchors.right: parent.right
                            anchors.rightMargin: 8
                            validator: IntValidator {
                                top: 150
                                bottom: 0
                            }
                            text: profile && profile.age ? profile.age : ""
                            onTextChanged: {
                                dirty = true;
                            }
                        }
                    }
                    Rectangle {
                        width: profileContainer.width
                        height: childrenRect.height + 16
                        color: Colours.almostWhite
                        //
                        //
                        //
                        Label {
                            id: sexHeader
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.margins: 8
                            color: Colours.veryDarkSlate
                            wrapMode: Label.WordWrap
                            font.family: fonts.light
                            font.pointSize: 24
                            text: "Sex"
                        }
                        AfterTrauma.CheckBox {
                            id: female
                            anchors.top: sexHeader.bottom
                            anchors.right: parent.right
                            anchors.margins: 8
                            direction: "Right"
                            text: "Female"
                            checked: profile ? profile.gender === "female" : false
                            onCheckedChanged: {
                                dirty = true;
                                if ( checked ) {
                                    male.checked = false;
                                    nogender.checked = false;
                                }
                            }
                        }
                        AfterTrauma.CheckBox {
                            id: male
                            anchors.top: female.bottom
                            anchors.right: parent.right
                            anchors.margins: 8
                            direction: "Right"
                            text: "Male"
                            checked: profile ? profile.gender === "male" : false
                            onCheckedChanged: {
                                dirty = true;
                                if ( checked ) {
                                    female.checked = false;
                                    nogender.checked = false;
                                }
                            }
                        }
                        AfterTrauma.CheckBox {
                            id: nogender
                            anchors.top: male.bottom
                            anchors.right: parent.right
                            anchors.margins: 8
                            direction: "Right"
                            text: "Rather not say"
                            checked: profile ? profile.gender === "notspecified" : true
                            onCheckedChanged: {
                                dirty = true;
                                if ( checked ) {
                                    female.checked = false;
                                    male.checked = false;
                                }
                            }
                        }
                    }
                    Rectangle {
                        width: profileContainer.width
                        height: 128
                        color: Colours.almostWhite
                        //
                        //
                        //
                        Image {
                            id: avatar
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.margins: 16
                            fillMode: Image.PreserveAspectFit
                            source: profile && profile.avatar ? profile.avatar : "icons/profile_icon.png"
                            onStatusChanged: {
                                if( status === Image.Error ) {
                                    source = "icons/profile_icon.png";
                                }
                            }
                            //
                            //
                            //
                            MouseArea {
                                id: selectAvatar
                                anchors.fill: parent
                                onClicked: {
                                    ImagePicker.openCamera();
                                }
                            }
                        }
                    }
                    Rectangle {
                        height: childrenRect.height + 16
                        width: profileContainer.width
                        color: Colours.almostWhite
                        //
                        //
                        //
                        AfterTrauma.TextArea {
                            id: profileText
                            height: 128
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 8
                            placeholderText: "Tell us a little about you and your trauma experience"
                            text: profile && profile.profile ? profile.profile : ""
                        }
                    }
                }
            }
        }
        Page {
            padding: 0
            title: "Where are your injuries?"
            BodyParts {
                anchors.fill: parent
            }
        }
        onCurrentItemChanged: {
            container.title = currentItem.title || "Your Profile"
        }
    }
    //
    //
    //
    footer: Item {
        height: 64
        width: parent.width
        AfterTrauma.Button {
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            image: "icons/left_arrow.png"
            visible: contents.currentIndex > 0
            onClicked: {
                contents.decrementCurrentIndex();
            }
        }
        AfterTrauma.PageIndicator {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            currentIndex: contents.currentIndex
            count: contents.count
            colour: Colours.lightSlate
        }
        AfterTrauma.Button {
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            image: "icons/right_arrow.png"
            visible: contents.currentIndex < contents.count - 1
            onClicked: {
                contents.incrementCurrentIndex();
            }
        }
    }
    //
    //
    //
    StackView.onActivated: {
        dirty = false;
        if ( profile ) {
            console.log( 'profile:' + profile.username );
        } else {
            console.log( 'no profile!' );
        }
        profileChannel.open();
    }

    StackView.onDeactivating: {

    }

    StackView.onDeactivated: {
    }
    //
    //
    //
    WebSocketChannel {
        id: profileChannel
        url: "wss://aftertrauma.uk:4000"
        //
        //
        //
        onReceived: {
            busyIndicator.running = false;
            var command = JSON.parse(message); // TODO: channel should probably emit object
            if ( command.command === 'updateprofile' ) {
                if( command.status === "OK" ) {
                    stack.pop()
                } else {
                    errorDialog.show( '<h1>Server says</h1><br/>' + ( typeof command.error === 'string' ? command.error : command.error.error ), [
                                         { label: 'try again', action: function() {} },
                                         { label: 'forget about it', action: function() { stack.pop(); } },
                                     ] );
                }
            }
        }

    }
    //
    //
    //
    Connections {
        target: ImagePicker
        onImagePicked: {
            // TODO: ensure this isn't called from addImage
            console.log( 'ProfileManager : setting profile avatar');
            var encoded = ImageUtils.urlEncode(url, 256, 256);
            avatar.source = encoded;
            if( profile ) {
                dirty = true;
                profile.avatar = encoded;
                //profile.avatar = url.substring(url.lastIndexOf('/')+1,url.length);
            }
        }
    }
    //
    //
    //
    function saveProfile() {
        if ( patient.checked ) {
            profile.role = "patient";
        } else if ( carer.checked ) {
            profile.role = "carer";
        }
        if ( female.checked ) {
            profile.gender = "female";
        } else if ( male.checked ) {
            profile.gender = "male";
        } else {
            profile.gender = "notspecified";
        }
        if ( age.text.length > 0 && age.acceptableInput ) {
            profile.age = Qt.atob(age.text);
        }
        profile.profile = profileText.text;
        profileChannel.send({command:'updateprofile',profile:profile});
    }
    //
    //
    //
    validate: function() {
        if ( profile ) {
            if ( dirty ) {
                //
                // serialise profile
                //
                confirmDialog.show('<h1>Save Changes?</h1>Do you want to save the changes you have made?', [
                                       { label: 'yes', action: function() { saveProfile() } },
                                       { label: 'no', action: function() { profileChannel.close() } }
                                   ] );
                return false;
            }
            return true;
        } else {
            return true;
        }
    }
    //
    //
    //
    property bool dirty: false
    property var profile: null
}
