import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "unread"
    roles: [ "id", "unread" ]
    //
    //
    //
    Component.onCompleted: {
        updateTotalCount();
    }
    //
    //
    //
    function updateTotalCount() {
        //
        // update total count
        //
        var total = 0;
        for ( var i = 0; i < count; i++ ) {
            total += get(i).unread;
        }
        totalUnread = total;
    }
    //
    //
    //
    function addMessage( chatId ) {
        var existing = findOne({id:chatId});
        if ( existing ) {
            update({id:chatId},{unread:existing.unread+1});
        } else {
            add({id:chatId,unread:1});
        }
        save();
        updateTotalCount();
    }
    //
    //
    //
    function markAsRead( chatId ) {
        remove({id:chatId});
        save();
        updateTotalCount();
    }
    //
    //
    //
    function getUnreadCount( chatId ) {
        var entry = findOne({id:chatId});
        if ( entry ) {
            return entry.unread;
        }
        return 0;
    }

    function getUnreadCountText( chatId ) {
        var entry = findOne({id:chatId});
        if ( entry ) {
            console.log('UnreadChats.getUnreadCountText ' + chatId + ' = ' + entry.unread );
            return entry.unread > 0 ? entry.unread.toString() : ""
        }
        return "";
    }
    //
    //
    //
    property int totalUnread: 0
}
