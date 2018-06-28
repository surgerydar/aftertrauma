import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "chats"
    roles: [ "id", "date", "title", "from", "to", "fromUsername", "toUsername", "messages", "status" ]
    //sort: { "date": -1 }
    sort: { "status": 1, "date": -1 }
    //
    //
    //
    Component.onCompleted: {
        //
        // test data
        //
        if ( false ) {//count <= 0 ) {
            beginBatch();
            for ( var i = 0; i < 6; i++ ) {
                var chat = {
                    id: GuidGenerator.generate(),
                    date: Date.now(),
                    title: "Chat " + i,
                    to: ( i % 2 ? "{9470fa33-2758-4cad-9b3e-9d10f039f072}" : "{5f9ba729-6a16-48c6-81a2-2de6d3db69ca}" ),
                    from: ( i % 2 ? "{5f9ba729-6a16-48c6-81a2-2de6d3db69ca}" : "{9470fa33-2758-4cad-9b3e-9d10f039f072}" ),
                    fromUsername: ( i % 2 ? "Me" : "You" ),
                    toUsername: ( i % 2 ? "You" : "Me" ),
                    messages: [],
                    status: ( i % 2 ? "invite" : "active" )
                }
                for ( var j = 0; j < ( Math.random() * 10 ) + 1; j++ ) {
                    chat.messages.push( {
                                      from: ( j % 2 ? "{9470fa33-2758-4cad-9b3e-9d10f039f072}" : "{5f9ba729-6a16-48c6-81a2-2de6d3db69ca}" ),
                                      message: "message " + ( j % 2 ? "{9470fa33-2758-4cad-9b3e-9d10f039f072}" : "{5f9ba729-6a16-48c6-81a2-2de6d3db69ca}" )
                                  } );
                }
                batchAdd(chat);
            }
            endBatch();
            save();
        }
        //
        //
        //
        messageModel = Qt.createComponent("MessageModel.qml");
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
            cached.model.append(message);
        } else {
            var chat = findOne({id:chatId});
            if ( chat ) {
                chat.messages.push(message);
                update({id:chatId},{messages:chat.messages});
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
                        cached.model.append(message);
                    });
                }
                //
                // connect to sync changes
                //
                cached.model.rowsInserted.connect( function( index, first, last ) {
                    console.log( 'messages inserted ' + first + ' : ' + last );
                    var chat = findOne({id: chatId});
                    if ( chat ) {
                        for ( var i = first; i <= last; i++ ) {
                            chat.messages[ i ] = cached.model.get(i);
                        }
                        update( {id: chatId},{messages: chat.messages});
                        save();
                    }
                });
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
