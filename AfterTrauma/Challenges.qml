import QtQuick 2.6

ListModel {
    id: model
    //
    //
    //
    function findChallenge(name) {
        var nChallenges = model.count;
        for ( var i = 0; i < nChallenges; i++ ) {
            var challenge = model.get(i);
            if ( challenge.name === name ) return challenge;
        }
        return undefined;
    }
}
