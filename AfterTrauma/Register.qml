import QtQuick 2.6
import QtQuick.Controls 2.1

import "colours.js" as Colours
import "controls" as AfterTrauma

Popup {
    id: container
    modal: true
    focus: true
    //
    //
    //
    background: Rectangle {
        id: background
        anchors.fill: parent
        radius: 16
        color: "transparent"
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
        AfterTrauma.Background {
            anchors.fill: parent
            fill: Colours.almostWhite
            radius: [ 16, 16, 0, 0 ]
        }
        Text {
            anchors.fill: parent
            anchors.margins: 16
            color: Colours.veryDarkSlate
            font.pixelSize: 32
            verticalAlignment: Text.AlignVCenter
            text: "REGISTER"
        }
    }
    //
    //
    //
    Rectangle {
        id: content
        anchors.fill: parent
        anchors.topMargin: 68
        anchors.bottomMargin: 68
        color: Colours.almostWhite
        //
        //
        //
        AfterTrauma.TextField {
            id: username
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 8
            placeholderText: "username"
            //
            // TODO: WebSocket username lookup
            //
        }
        AfterTrauma.TextField {
            id: email
            anchors.top: username.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 8
            placeholderText: "email"
            validator: RegExpValidator {
                regExp: /^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/
            }
            onValidatorChanged: {
                console.log( 'email ' + ( acceptableInput ? 'valid' : 'invalid' ) );
            }
        }
        AfterTrauma.TextField {
            id: password
            anchors.top: email.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 8
            placeholderText: "password"
            echoMode: TextField.Password
        }
        AfterTrauma.TextField {
            id: confirmPassword
            anchors.top: password.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 8
            placeholderText: "confirm password"
            echoMode: TextField.Password
        }
        AfterTrauma.CheckBox {
            id: acceptTerms
            anchors.top: confirmPassword.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 8
            direction: "Right"
            text: "Accept terms & conditions"
        }
        AfterTrauma.CheckBox {
            id: stayLoggedIn
            anchors.top: acceptTerms.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 8
            direction: "Right"
            text: "Stay logged in"
        }
        //
        //
        //
        AfterTrauma.Button {
            id: loginButton
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 8
            backgroundColour: Colours.veryLightSlate
            borderColour: Colours.veryDarkSlate
            borderWidth: 1
            textColour: Colours.veryDarkSlate
            text: "already registered"
        }
        AfterTrauma.Button {
            id: registerButton
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 8
            backgroundColour: Colours.darkGreen
            text: "REGISTER"
        }
    }
    //
    //
    //
    Item {
        id: footer
        height: 64
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        AfterTrauma.Background {
            anchors.fill: parent
            fill: Colours.almostWhite
            radius: [ 0, 0, 16, 16 ]
        }
        /*
        Text {
            anchors.fill: parent
            anchors.margins: 16
            color: Colours.veryDarkSlate
            font.pixelSize: 32
            verticalAlignment: Text.AlignVCenter
            text: "REGISTER"
        }
        */
    }
    //
    //
    //
    function validate( target ) {

    }
}
