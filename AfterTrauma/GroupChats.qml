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
    function indexOfChat( id ) {
        for ( var i = 0; i < count; i++ ) {
            if ( get(i).id === id ) return i;
        }
        return -1;
    }
    function findPrivateChatWithUser( id ) {
        console.log( 'GroupChats.findPrivateChatWithUser(' + id + ')')
        for ( var i = 0; i < count; i++ ) {
            var chat = get(i);
            //console.log( 'GroupChats.findPrivateChatWithUser : testing chat : ' + chat.id + ' public=' + chat['public'] + ' members=' + JSON.stringify(chat.members) );
            if ( !chat['public'] && chat.members.length === 1 && chat.members.indexOf(id) >= 0 ) return chat;
        }
        return undefined;
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
                //
                // JONS: not sure about this logic, the database is rebuilt each time the user logs in so could probably do with a separate file containing unread count for each chat
                //
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
    function openChat( chatId, join ) {
        var chat = chatModel.findOne({id:chatId});
        var command;
        if ( chat ) {
            if ( chat.owner !== userProfile.id ) {
                //
                // check if we have accepted invite
                //
                if ( chat.active === undefined || chat.active.indexOf(userProfile.id) < 0 ) { // TODO: remove legacy chat support

                    if ( chat.invited !== undefined && chat.invited.indexOf(userProfile.id) >= 0 ) { // TODO: remove legacy chat support
                        //
                        // invited so accept
                        //
                        command = {
                            command: 'groupacceptinvite',
                            token: userProfile.token,
                            chatid: chat.id,
                            userid: userProfile.id
                        };

                    } else if ( chat["public"] ) {
                        console.log( 'GroupChatManager.openChat : joining public chat : ' + chat.id );
                        //
                        // public so join
                        //
                        command = {
                            command: 'groupjoinchat',
                            token: userProfile.token,
                            chatid: chat.id,
                            userid: userProfile.id
                        };
                    }
                    if ( command ) {
                        chatChannel.send(command);
                    } else {
                        console.log( 'GroupChatManager.openChat : unable to load chat ' + JSON.stringify(chat ) );
                        return;
                    }
                }
            }
            console.log( 'GroupChatManager.openChat : loading chat : ' + chat.subject );
            var properties = {
                chatId:chat.id,
                messages:chatModel.getMessageModel(chat.id),
                subject: chat.subject + ( chat["public"] ?  ' ( public )' : '' )
            };
            stack.push( "qrc:///GroupChat.qml", properties);
        } else if ( join ) {
            //
            // join chat
            //
            command = {
                command: 'groupjoinchat',
                token: userProfile.token,
                chatid: chatId,
                userid: userProfile.id,
                show: true
            };
            chatChannel.send(command);
        }
    }
    //
    //
    //
    function updateTagDatabase( chat ) {
        //
        // update tag database
        //
        if ( chat.tags ) {
            chat.tags.forEach( function(tag) {
                tagsModel.updateTag( tag.toLowerCase(), { section: "chats", document: chat.id } );
            });
            tagsModel.save();
        }
    }
    //
    //
    //
    property Component messageModel:null
    property var messageModels:[]
    property int notificationType: 0x4
}
