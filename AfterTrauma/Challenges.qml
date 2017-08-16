import QtQuick 2.6

ListModel {
    id: model
    //
    //
    //
    Component.onCompleted: {
        Database.find(table,{},{date: -1});
    }
    //
    //
    //
    signal updated();
    //
    //
    //
    function databaseSuccess( collection, operation, result ) {
        if ( collection === table ) {
            if ( operation === 'find' ) {
                console.log( 'Challenges : loading challenges' );
                model.clear();
                result.forEach( function(challenge) {
                    model.append(challenge);
                });
                model.updated();
            } else if ( operation === 'update' ) {
                console.log( 'Challenges : updated : ' + JSON.stringify(result) );
            }
        }
    }
    function databaseError( collection, operation, error ) {
        console.log( 'database error : ' + collection + ' : ' + operation + ' : ' + error );
    }
    //
    //
    //
    function add(challenge) {
        challenge.count = 0;
        challenge.date = Date.now();
        var result = Database.insert(table,challenge);
        if ( result ) {
            model.append(result);
            Database.save();
        }
    }
    function remove(challenge) {
        var nChallenges = model.count;
        for ( var i = 0; i < nChallenges; i++ ) {
            if ( model.get(i).name === challenge.name ) {
                var query = {
                    _id: challenge._id
                };
                Database.remove(table,query);
                Database.save();
                model.remove(i);
                break;
            }
        }
    }
    function findChallenge(name) {
        var nChallenges = model.count;
        for ( var i = 0; i < nChallenges; i++ ) {
            var challenge = model.get(i);
            if ( challenge.name === name ) return challenge;
        }
        return undefined;
    }
    function updateCount(index,count) {
        model.setProperty(index,"count",count);
    }
    //
    //
    //
    property string table: "challenge"
}
