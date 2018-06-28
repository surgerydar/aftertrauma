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
                    //
                    // save userProfile
                    //
                    userProfile.stayLoggedIn = ( command.command === 'login' && loginStayLoggedIn.checked ) || ( command.command === 'register' && stayLoggedIn.checked )
                    JSONFile.write('user.json',userProfile);
                    //container.close();
                    //
                    // TODO: move all update logic to single module
                    // sync content
                    //
                    send({command:'categories',date:0});
                } else if ( command.command === 'categories' ) {
                    if ( command.response.length > 0 ) {
                        processCategories(command.response);
                    }
                    send({command:'manifest',date:0});
                } else if ( command.command === 'manifest' ) {
                    //console.log( 'manifest : ' + JSON.stringify(command.response) );
                    if ( command.response.length > 0 ) {
                        confirmDialog.show('<h1>Updates Available</h1>Do you want to download and install now?', [
                                           { label: 'yes', action: function() { processUpdate(command.response) } },
                                           { label: 'no', action: function() { container.close(); } }
                                           ] );
                    } else {
                        container.close();
                    }
                } else if ( command.command === 'documents' ) {
                    if ( command.response.length > 0 ) {
                        //console.log( 'documents : ' + JSON.stringify(command.response[0]) );
                        installDocuments(command.response);
                    }
                    authenticationChannel.send({command:'challenges',date:0});
                } else if ( command.command === 'challenges' ) {
                    if ( command.response.length > 0 ) {
                        installChallenges(command.response);
                    }
                    container.close();
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
                if( userProfile && username.text !== userProfile.username ) {
                    message = "<h1>Error</h1>Please enter username associated with this device";
                } else {
                    busyIndicator.running = true;
                    user = {
                        command: 'register',
                        username: username.text,
                        email: email.text,
                        password: password.text,
                        id: GuidGenerator.generate()
                    };
                    authenticationChannel.send(user);
                }
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
                user = {
                    command: 'login',
                    username: loginUsername.text,
                    password: loginPassword.text
                };
                authenticationChannel.send(user);
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
    function processCategories( categories ) {
        categories.forEach( function( category ) {
            console.log( 'updating category : ' + JSON.stringify(category) );
            var entry = {
                section:    category.section,
                category:   category._id,
                title:      category.title,
                date:       category.date,
                index:      category.index
            };
            categoryModel.update({category: category._id},entry,true);
        });
        categoryModel.save();
    }
    function processUpdate( manifest ) {
        //
        // delete removed
        //
        var filter = documentModel.filter;
        documentModel.filter = {};
        manifest.forEach( function( delta ) {
            if ( delta.operation === 'remove' ) {
                //
                // TODO: delete file, possibly delete associated media
                //
                if ( delta.category ) {
                    var category = categoryModel.findOne({category:delta.category});
                    if ( category && category.section ) {
                        var path = category.section + '/' + delta.category + '.' + delta.document + '.json';
                        console.log( 'removing:' + path );
                        documentModel.remove( {document: delta.document} );
                    } else {
                        console.log( 'remove : unable to find catgegory : ' + delta.category );
                    }
                } else if ( delta.challenge ) {
                    challengeModel.remove({_id: delta.challenge});
                }
            }
        });
        documentModel.save();
        documentModel.filter = filter;
        //
        // request updated
        //
        authenticationChannel.send({command:'documents',date:0});
    }
    function installDocuments( documents ) {
        var filter = documentModel.filter;
        documentModel.filter = {};
        documents.forEach( function( document ) {
            var category = categoryModel.findOne({category:document.category});
            if ( category && category.section ) {
                var path = category.section + '/' + document.category + '.' + document._id;
                console.log( 'installing:' + path + ' : ' + document.title + ' : ' + document.index );
                var entry = {
                    document: document._id,
                    category: document.category,
                    section: category.section,
                    title: document.title,
                    blocks: document.blocks,
                    date: document.date,
                    index: document.index
                };
                //
                // TODO: extract tags
                //
                var result = documentModel.update( {document: document._id}, entry, true );
                console.log( 'updated document : ' + JSON.stringify(result) );
                if ( result ) {
                    document.blocks.forEach( function( block ) {
                        console.log( 'extracting tags : ' + JSON.stringify(block.tags) );
                        block.tags.forEach( function( tag ) {
                            if ( tag.length > 0 ) {
                                tagsModel.updateTag( tag.toLowerCase(), document._id || result._id );
                            }
                        });
                    });
                    tagsModel.save();
                }
            } else {
                console.log( 'install : unable to find catgegory : ' + document.category );
            }
        });
        documentModel.save();
        documentModel.filter = filter;
    }
    function installChallenges( challenges ) {
        challenges.forEach( function( challenge ) {
            console.log( 'updating challenge : ' + challenge._id );
            challenge.active = false;
            var result = challengeModel.update( {_id: challenge._id}, challenge, true );
            console.log( 'updated challenges : ' + JSON.stringify(result) );
        });
        challengeModel.save();
    }
}
