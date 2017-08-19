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
    title: "PROFILE"
    subtitle: profile ? profile.username : ""
    colour: Colours.blue
    //
    //
    //
    Flickable {
        id: content
        anchors.fill: parent
        //
        //
        //
        clip: true
        contentHeight: layout.height
        //
        //
        //
        Column {
            id: layout
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 16
            Image {
                id: avatar
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 16
                fillMode: Image.PreserveAspectFit
                source: profile && profile.avatar ? /*'file://' + SystemUtils.documentDirectory() + '/' + */profile.avatar : "icons/add.png"
                //source: "icons/add.png"
                onStatusChanged: {
                    if( status === Image.Error ) {
                        source = "icons/add.png";
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
            //
            //
            //
            AfterTrauma.TextArea {
                id: publicProfile
                height: Math.max( contentHeight, 128 )
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 16
                wrapMode: Text.WordWrap
                placeholderText: "Type your public profile"
                text: profile && profile.profile ? profile.profile : ""
                onTextChanged: {
                    profile.profile = text;
                }
            }
            //
            //
            //
            AfterTrauma.TextField {
                id: tags
                height: Math.max( contentHeight, 48 )
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 16
                wrapMode: Text.WordWrap
                inputMethodHints: Qt.ImhNoAutoUppercase
                validator: RegExpValidator {
                    regExp: /[a-z,]{6,}/
                }
                placeholderText: "Tags"
                text: profile && profile.tags ? profile.tags.join() : ""
                onTextChanged: {
                    profile.tags = text.length > 0 ? text.split() : [];
                }
            }
            //
            //
            //
            Row {
                height: 48
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16
                AfterTrauma.Button {
                    id: cancel
                    //
                    //
                    //
                    backgroundColour: Colours.blue
                    text: "Cancel"
                    onClicked: {
                        stack.pop();
                    }
                }
                AfterTrauma.Button {
                    id: save
                    //
                    //
                    //
                    backgroundColour: Colours.blue
                    text: "Save"
                    onClicked: {
                        //
                        // update local
                        //
                        if ( profile ) {
                            for ( var key in profile ) {
                                userProfile[ key ] = profile[ key ];
                                //
                                // save to server
                                //
                                var command = {
                                    command: 'updateprofile',
                                    profile: profile
                                };
                                console.log('updating profile: ' + JSON.stringify(profile));
                                profileChannel.send(command);
                            }
                        } else {
                            stack.pop();
                        }
                    }
                }
            }
        }
        ScrollBar.vertical: ScrollBar {

                  anchors.top: content.top
                  anchors.right: content.right
                  anchors.bottom: content.bottom

        }
    }
    Connections {
        target: ImagePicker
        onImagePicked: {
            var encoded = ImageUtils.urlEncode(url,64,64);
            avatar.source = encoded;
            if( profile ) {
                profile.avatar = encoded;
                //profile.avatar = url.substring(url.lastIndexOf('/')+1,url.length);
            }
        }
    }
    StackView.onActivated: {
        if ( profile ) {
            console.log( 'profile : ' + JSON.stringify(profile) );
        } else {
            console.log( 'no profile!' );
        }
        profileChannel.open();
    }
    StackView.onDeactivated: {
        profileChannel.close();
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
    property var profile: null
}
