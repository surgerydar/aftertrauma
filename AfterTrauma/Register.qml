import QtQuick 2.6
import QtQuick.Controls 2.1
import SodaControls 1.0

import "colours.js" as Colours
import "controls" as AfterTrauma

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
            text: "REGISTER"
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
            visible: !userProfile
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
        id: content
        //
        //
        //
        anchors.fill: parent
        anchors.topMargin: 68
        //anchors.bottomMargin: 68
        //
        //
        //
        clip: true
        interactive: false
        //
        //
        //
        Page {
            id: register
            padding: 0
            background: Rectangle {
                anchors.fill: parent
                color: Colours.almostWhite
            }
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
                textSize: 18
                text: "Accept terms & conditions"
                visible: termsViewed
            }
            AfterTrauma.Button {
                id: viewTerms
                anchors.top: confirmPassword.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 8
                backgroundColour: Colours.veryLightSlate
                textColour: Colours.veryDarkSlate
                text: "View terms & conditions"
                visible: !termsViewed
                onClicked: {
                    terms.open();
                    termsViewed = true
                }
            }

            AfterTrauma.CheckBox {
                id: stayLoggedIn
                anchors.top: acceptTerms.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 8
                direction: "Right"
                textSize: 18
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
                textSize: 18
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
                textSize: 18
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
            padding: 0
            background: Rectangle {
                anchors.fill: parent
                color: Colours.almostWhite
            }
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
            AfterTrauma.Button {
                anchors.top: loginStayLoggedIn.bottom
                anchors.right: parent.right
                anchors.margins: 8
                backgroundColour: Colours.lightSlate
                textColour: Colours.almostWhite
                text: "forgotten password"
                onClicked: {
                    resetPassword.y = 0;
                }
            }
            Rectangle {
                id: resetPassword
                height: 256
                y: -height
                anchors.left: parent.left
                anchors.right: parent.right
                //
                //
                //
                AfterTrauma.TextField {
                    id: resetUsernameEmail
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 8
                    placeholderText: "username or email"
                }
                AfterTrauma.Button {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.margins: 8
                    backgroundColour: Colours.lightSlate
                    textColour: Colours.almostWhite
                    text: "cancel"
                    onClicked: {
                        resetPassword.y = -resetPassword.height;
                    }
                }
                AfterTrauma.Button {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: 8
                    backgroundColour: Colours.lightSlate
                    textColour: Colours.almostWhite
                    text: "request password"
                    onClicked: {
                        authenticationChannel.send({
                            command: 'resetpassword',
                            identifier: resetUsernameEmail.text
                        });
                        resetPassword.y = -resetPassword.height;
                    }
                }
                Behavior on y {
                    NumberAnimation { duration: 250 }
                }
            }
            //
            //
            //
            AfterTrauma.Button {
                id: gotoRegisterButton
                visible: !userProfile
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 8
                backgroundColour: Colours.veryLightSlate
                textColour: Colours.veryDarkSlate
                textSize: 18
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
                textSize: 18
                text: "LOGIN"
                onClicked: {
                    if ( validate(login) ) {
                        container.close();
                    }
                }
            }
        }
        onCurrentItemChanged: {
            title.text = currentItem.title;
        }
    }
    //
    //
    //
    WebSocketChannel {
        id: authenticationChannel
        url: baseWS
        //
        //
        //
        onReceived: {
            busyIndicator.running = false;
            var command = JSON.parse(message); // TODO: channel should probably emit object???
            if ( command.status === "OK" ) {
                if ( command.command === 'register' || command.command === 'login' ) {
                    loggedIn    = true;
                    userProfile = command.response;
                    console.log( 'logged in, openning chat channel');
                    chatChannel.open();
                    //
                    // save userProfile
                    //
                    userProfile.stayLoggedIn = ( command.command === 'login' && loginStayLoggedIn.checked ) || ( command.command === 'register' && stayLoggedIn.checked )
                    JSONFile.write('user.json',userProfile);
                    //
                    // sync with tags BodyPartList
                    //
                    if ( userProfile.tags ) {
                        userProfile.tags.forEach( function(tag) {
                            var canonical = bodyPartModel.nameToCanonical(tag);
                            if ( canonical ) {
                                bodyPartModel.setSelected(canonical,true);
                            }
                        });
                    }
                    //
                    // check for updates
                    //
                    updateDialog.checkForUpdates(function() {
                        container.close();
                    });
                } else if ( command.command === 'resetpassword' ) {
                    confirmDialog.show('<h1>Password Reset</h1>' + command.response );
                }
            } else if ( command.error ) {
                errorDialog.show( '<h1>Server says</h1><br/>' + ( typeof command.error === 'string' ? command.error : command.error.error ), userProfile ?
                                     [
                                         { label: 'try again', action: function() {} }
                                     ] :
                                     [
                                         { label: 'try again', action: function() {} },
                                         { label: 'forget about it', action: function() { container.close(); } },
                                     ] );
            } else {
                console.log( 'unknown message: ' + message );
            }
        }
        onError: {
            busyIndicator.running = false;
            errorDialog.show( '<h1>Network error</h1><br/>' + error, userProfile ?
                                 [
                                     { label: 'try again', action: function() {} }
                                 ] :
                                 [
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
        content.currentIndex = userProfile ? 1 : 0;
        authenticationChannel.open();
    }
    onClosed: {
        authenticationChannel.close();
        username.text = "";
        email.text = "";
        password.text = "";
        confirmPassword.text = "";
        acceptTerms.checked = false;
        termsViewed = false;
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
        var message = "";
        if ( target === register ) {
            console.log( 'validating registration' );
            if ( username.acceptableInput && email.acceptableInput && password.acceptableInput && confirmPassword.text === password.text && acceptTerms.checked ) {
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
                //
                // show error
                //
                message = "<h1>Error</h1>";
                if ( !username.acceptableInput ) {
                    message += "Please enter a username containing 6 or more letters and/or numbers";
                } else if ( !email.acceptableInput ) {
                    message += "Please enter valid email";
                } else if ( !password.acceptableInput ) {
                    message += "Please enter a password containing 6 or more letters and/or numbers";
                } else if ( confirmPassword.text !== password.text ){
                    message += "Passwords must match";
                } else {
                    message += "You must accept our terms and conditions";
                }
            }
        } else {
            console.log( 'validating login' );
            if( loginUsername.acceptableInput && loginPassword.acceptableInput ) {
                if( userProfile && loginUsername.text !== userProfile.username ) {
                    console.log( 'entered: ' + loginUsername.text + ' stored:' + userProfile.username );
                    message = "<h1>Error</h1>Please enter username associated with this device";
                } else {
                    user = {
                        command: 'login',
                        username: loginUsername.text,
                        password: loginPassword.text
                    };
                    authenticationChannel.send(user);
                }
            } else {
                // show error
                message = "<h1>Error</h1>Please enter username and password";
            }
        }
        if ( message.length > 0 ) {
            errorDialog.show(message);
        }
    }
    function testUsername( name ) {

    }
    //
    //
    //
    property bool termsViewed: false
}
