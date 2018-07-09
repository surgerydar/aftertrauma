import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "chats"
    roles: [ "id", "date", "subject", "owner", "public", "members", "active", "invited", "messages", "status", "unread" ]
    sort: { "status": 1, "date": -1 }
    //
    //
    //
    Component.onCompleted: {
        //
        //
        //
        messageModel = Qt.createComponent("MessageModel.qml");
    }
    //
    //
    //
    function totalUnread() {
        var count = 0;
        for ( var i = 0; i < count; i++ ) {
            var chat = get( i );
        }
        return count;
    }

    //
    //
    //
    function chattingTo( id ) {
        for ( var i = 0; i < count; i++ ) {
            var chat = get( i );
            if ( chat.to === id || chat.from === id ) {
                return true;
            }
        }
        return false;
    }
    //
    //
    //
    function addMessage( chatId, message ) {
        //
        // find live chat
        //
        var cached = findMessageModel(chatId);
        if ( cached ) {
            //cached.model.append(message);
            cached.model.add(message);
        } else {
            var chat = findOne({id:chatId});
            if ( chat ) {
                var unread = ( chat.unread || chat.messages.length ) + 1
                chat.messages.push(message);
                update({id:chatId},{messages:chat.messages,unread:unread});
            }
        }
    }
    //
    //
    //
    function getMessageModel( chatId ) {
        var cached = findMessageModel( chatId );
        if ( cached ) {
            cached.ref++;
        } else {
            //
            // create cached model
            //
            cached = {
                id: chatId,
                model: messageModel.createObject(),
                ref: 1
            };
            var chat = findOne({id: chatId});
            if ( chat ) {
                //
                // add messages to model
                //
                if ( chat.messages ) {
                    chat.messages.forEach( function( message ) {
                        console.log( 'GroupChats.getMessageModel : appending : ' + message + ' : to model : ' + cached.model );
                        //cached.model.append(message);
                        cached.model.add(message);
                    });
                }
                //
                // connect to sync changes
                //
                /*
                cached.model.rowsInserted.connect( function( index, first, last ) {
                    //
                    // update chat model with messages from cached message model
                    //
                    console.log( 'messages inserted ' + first + ' : ' + last );
                    var chat = findOne({id: chatId});
                    if ( chat ) {
                        for ( var i = first; i <= last; i++ ) {
                            var message = cached.model.get(i);
                            var sanitisedMessage = {
                                id: message.id,
                                date: message.date,
                                from: message.from,
                                message: message.message
                            };
                            if ( i >= chat.messages.length ) {
                                chat.messages.push(sanitisedMessage);
                            } else {
                                chat.messages[i] = sanitisedMessage;
                            }
                        }
                        update( {id: chatId},{messages: chat.messages});
                        save();
                        //
                        //
                        //
                        chat = findOne({id: chatId});
                        if ( chat ) {
                            console.log( 'updated chat : \n' + JSON.stringify(chat) );
                        }
                    }
                });
                */
                //
                // cache model
                //
                messageModels.push(cached);
            }
        }
        return cached.model;
    }
    function releaseMessageModel( chatId ) {
        for ( var i = 0; i < messageModels.length; i++ ) {
            if ( messageModels[ i ].id === chatId ) {
                messageModels[ i ].ref--;
                if ( messageModels[ i ].ref <= 0 ) {
                    messageModels.splice( i, 1 );
                }
                return;
            }
        }
    }
    function findMessageModel( chatId ) {
        for ( var i = 0; i < messageModels.length; i++ ) {
            if ( messageModels[ i ].id === chatId ) {
                return messageModels[ i ];
            }
        }
        return undefined;
    }
    //
    //
    //
    property Component messageModel:null
    property var messageModels:[]
}
