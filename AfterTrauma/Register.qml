import QtQuick 2.6
import QtQuick.Controls 2.1
import SodaControls 1.0

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
            font.weight: Font.Light
            font.family: fonts.light
            font.pixelSize: 32
            verticalAlignment: Text.AlignVCenter
            text: content.currentItem.title || "REGISTER"
        }
    }
    //
    //
    //
    SwipeView {
        id: content
        //
        //
        //
        anchors.fill: parent
        anchors.topMargin: 68
        anchors.bottomMargin: 68
        //
        //
        //
        clip: true
        interactive: false
        //
        //
        //
        background: Rectangle {
            anchors.fill: parent
            color: Colours.almostWhite
        }
        Page {
            id: register
            //
            //
            //
            title: "REGISTER"
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
                inputMethodHints: Qt.ImhNoAutoUppercase
                validator: RegExpValidator {
                    regExp: /[0-9a-zA-Z]{6,}/
                }
                onTextChanged: {
                    if ( text.length > 0 && !acceptableInput ) {
                        backgroundColour = Colours.red
                    } else {
                        backgroundColour =  Colours.veryLightSlate
                    }
                }
                onAccepted: {
                    email.forceActiveFocus();
                }
            }
            AfterTrauma.TextField {
                id: email
                anchors.top: username.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 8
                placeholderText: "email"
                inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhNoAutoUppercase
                validator: RegExpValidator {
                    regExp: /^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/
                }
                onTextChanged: {
                    if ( text.length > 0 && !acceptableInput ) {
                        backgroundColour = Colours.red
                    } else {
                        backgroundColour = Colours.veryLightSlate
                    }
                }
                onAccepted: {
                    password.forceActiveFocus();
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
                validator: RegExpValidator {
                    regExp: /[0-9a-zA-Z]{6,}/
                }
                onTextChanged: {
                    if ( text.length > 0 && !acceptableInput) {
                        backgroundColour = Colours.red;
                    } else {
                        backgroundColour =  Colours.veryLightSlate;
                    }
                }
                onAccepted: {
                    confirmPassword.forceActiveFocus();
                }
            }
            AfterTrauma.TextField {
                id: confirmPassword
                anchors.top: password.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 8
                placeholderText: "confirm password"
                echoMode: TextField.Password
                validator: RegExpValidator {
                    regExp: /[0-9a-zA-Z]{6,}/
                }
                onTextChanged: {
                    if ( text.length > 0 && !( acceptableInput && text === password.text ) ) {
                        backgroundColour = Colours.red
                    } else {
                        backgroundColour =  Colours.veryLightSlate
                    }
                }
                onAccepted: {
                    acceptTerms.forceActiveFocus();
                }
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
                id: gotoLoginButton
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 8
                backgroundColour: Colours.veryLightSlate
                textColour: Colours.veryDarkSlate
                text: "already registered"
                onClicked: {
                    content.setCurrentIndex(1);
                }
            }
            AfterTrauma.Button {
                id: registerButton
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 8
                backgroundColour: Colours.darkGreen
                text: "REGISTER"
                onClicked: {
                    validate(register);
                }
            }
        }
        //
        //
        //
        Page {
            id: login
            //
            //
            //
            title: "LOGIN"
            //
            //
            //
            AfterTrauma.TextField {
                id: loginUsername
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 8
                placeholderText: "username"
                inputMethodHints: Qt.ImhNoAutoUppercase
                validator: RegExpValidator {
                    regExp: /[0-9a-zA-Z]{6,}/
                }
                onTextChanged: {
                    if ( text.length > 0 && !acceptableInput) {
                        backgroundColour = Colours.red;
                    } else {
                        backgroundColour =  Colours.veryLightSlate;
                    }
                }
                onAccepted: {
                    loginPassword.forceActiveFocus();
                }
            }
            AfterTrauma.TextField {
                id: loginPassword
                anchors.top: loginUsername.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 8
                placeholderText: "password"
                echoMode: TextField.Password
                validator: RegExpValidator {
                    regExp: /[0-9a-zA-Z]{6,}/
                }
                onTextChanged: {
                    if ( text.length > 0 && !acceptableInput) {
                        backgroundColour = Colours.red;
                    } else {
                        backgroundColour =  Colours.veryLightSlate;
                    }
                }
                onAccepted: {
                    loginButton.clicked();
                }
            }
            AfterTrauma.CheckBox {
                id: loginStayLoggedIn
                anchors.top: loginPassword.bottom
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
                id: gotoRegisterButton
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 8
                backgroundColour: Colours.veryLightSlate
                textColour: Colours.veryDarkSlate
                text: "register"
                onClicked: {
                    content.setCurrentIndex(0);
                }
            }
            AfterTrauma.Button {
                id: loginButton
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 8
                backgroundColour: Colours.darkGreen
                text: "LOGIN"
                onClicked: {
                    if ( validate(login) ) {
                        container.close();
                    }
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
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        AfterTrauma.Background {
            anchors.fill: parent
            fill: Colours.almostWhite
            radius: [ 0, 0, 16, 16 ]
        }
    }
    //
    //
    //
    WebSocketChannel {
        id: authenticationChannel
        url: "wss://aftertrauma.uk:4000"
        //
        //
        //
        onReceived: {
            busyIndicator.running = false;
            var command = JSON.parse(message); // TODO: channel should probably emit object
            if ( command.command === 'register' || command.command === 'login' ) {
                if( command.status === "OK" ) {
                    loggedIn    = true;
                    userProfile = command.response;
                    container.close()
                } else {
                    errorDialog.show( '<h1>Server says</h1><br/>' + ( typeof command.error === 'string' ? command.error : command.error.error ), [
                                         { label: 'try again', action: function() {} },
                                         { label: 'forget about it', action: function() { container.close(); } },
                                     ] );
                }
            }
        }
        onError: {
            busyIndicator.running = false;
            errorDialog.show( '<h1>Network error</h1><br/>' + error, [
                                 { label: 'try again', action: function() {} },
                                 { label: 'forget about it', action: function() { container.close(); } },
                             ] );
        }
        onOpened: {

        }
        onClosed: {

        }
    }
    Component.onCompleted: {

    }
    onOpened: {
        authenticationChannel.open();
    }
    onClosed: {
        authenticationChannel.close();
        username.text = "";
        email.text = "";
        password.text = "";
        confirmPassword.text = "";
        acceptTerms.checked = false;
        stayLoggedIn.checked = false;
        loginUsername.text = "";
        loginPassword.text = "";
        loginStayLoggedIn.checked = false;
    }

    //
    //
    //
    function validate( target ) {
        var user;
        if ( target === register ) {
            console.log( 'validating registration' );
            if ( username.acceptableInput && email.acceptableInput && password.acceptableInput && confirmPassword.text === password.text ) {
                busyIndicator.running = true;
                user = {
                    command: 'register',
                    username: username.text,
                    email: email.text,
                    password: password.text,
                    id: GuidGenerator.generate()
                };
                authenticationChannel.send(user);
            } else {
                // show error
            }
        } else {
            console.log( 'validating login' );
            if( loginUsername.acceptableInput && loginPassword.acceptableInput ) {
                user = {
                    command: 'login',
                    username: loginUsername.text,
                    password: loginPassword.text
                };
                authenticationChannel.send(user);
            } else {
                // show error
            }
        }
    }
    function testUsername( name ) {

    }
}
