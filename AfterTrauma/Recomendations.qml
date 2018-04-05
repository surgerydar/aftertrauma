import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "recomendations"
    roles: [ 'category', 'minimum', 'maximum', 'recomendation', 'links' ]
    //
    //
    //
    Component.onCompleted: {
        //
        //
        //
        if ( count <= 0 ) {
            console.log( 'generating recomentation test data');
            var data = [
                        {
                            category: "body",
                            minimum: 0.0,
                            maximum: 0.25,
                            recomendation: "Body, not good",
                            links: [
                            ]
                        },
                        {
                            category: "body",
                            minimum: 0.25,
                            maximum: 0.5,
                            recomendation: "Body, not so bad",
                            links: [
                            ]
                        },
                        {
                            category: "body",
                            minimum: 0.5,
                            maximum: 0.75,
                            recomendation: "Body, good",
                            links: [
                            ]
                        },
                        {
                            category: "body",
                            minimum: 0.75,
                            maximum: 1.0,
                            recomendation: "Body, great!",
                            links: [
                            ]
                        },
                        {
                            category: "emotions",
                            minimum: 0.0,
                            maximum: 0.25,
                            recomendation: "Emotions, not good",
                            links: [
                            ]
                        },
                        {
                            category: "emotions",
                            minimum: 0.25,
                            maximum: 0.5,
                            recomendation: "Emotions, not so bad",
                            links: [
                            ]
                        },
                        {
                            category: "relationships",
                            minimum: 0.5,
                            maximum: 0.75,
                            recomendation: "Emotions, good",
                            links: [
                            ]
                        },
                        {
                            category: "emotions",
                            minimum: 0.75,
                            maximum: 1.0,
                            recomendation: "Emotions, great!",
                            links: [
                            ]
                        },
                        {
                            category: "relationships",
                            minimum: 0.0,
                            maximum: 0.25,
                            recomendation: "Relationships, not good",
                            links: [
                            ]
                        },
                        {
                            category: "relationships",
                            minimum: 0.25,
                            maximum: 0.5,
                            recomendation: "Relationships, not so bad",
                            links: [
                            ]
                        },
                        {
                            category: "relationships",
                            minimum: 0.5,
                            maximum: 0.75,
                            recomendation: "Relationships, good",
                            links: [
                            ]
                        },
                        {
                            category: "relationships",
                            minimum: 0.75,
                            maximum: 1.0,
                            recomendation: "Relationships, great!",
                            links: [
                            ]
                        },
                        {
                            category: "life",
                            minimum: 0.0,
                            maximum: 0.25,
                            recomendation: "Life, not good",
                            links: [
                            ]
                        },
                        {
                            category: "life",
                            minimum: 0.25,
                            maximum: 0.5,
                            recomendation: "Life, not so bad",
                            links: [
                            ]
                        },
                        {
                            category: "life",
                            minimum: 0.5,
                            maximum: 0.75,
                            recomendation: "Life, good",
                            links: [
                            ]
                        },
                        {
                            category: "life",
                            minimum: 0.75,
                            maximum: 1.0,
                            recomendation: "Life, great!",
                            links: [
                            ]
                        },
                        {
                            category: "confidence",
                            minimum: 0.0,
                            maximum: 0.25,
                            recomendation: "Confidence, not good",
                            links: [
                            ]
                        },
                        {
                            category: "confidence",
                            minimum: 0.25,
                            maximum: 0.5,
                            recomendation: "Confidence, not so bad",
                            links: [
                            ]
                        },
                        {
                            category: "confidence",
                            minimum: 0.5,
                            maximum: 0.75,
                            recomendation: "Confidence, good",
                            links: [
                            ]
                        },
                        {
                            category: "confidence",
                            minimum: 0.75,
                            maximum: 1.0,
                            recomendation: "Confidence, great!",
                            links: [
                            ]
                        }
                   ];
            beginBatch();
            data.forEach(function(datum) {
                //console.log( 'adding recommendation : ' + JSON.stringify(datum) );
                batchAdd(datum);
            });
            endBatch();
            save();
        }
    }
    //
    //
    //
    function getRecomendation( c ) {
        console.log( 'getRecomendation : get daily : ' + c );
        var daily = dailyModel.getToday();
        if ( !daily || !daily.values ) {
            console.log( 'getRecomendation : unable to find valid daily : ' + daily ? "undefined" : JSON.stringify(daily));
            return 'unable to find daily';
        }
        console.log( 'getRecomendation : daily : ' + JSON.stringify( daily ) );
        //
        // get category value
        //
        var value = 0.;
        for ( var i = 0; i < daily.values.length; i++ ) {
            if ( daily.values[ i ].label === c ) {
                value = daily.values[ i ].value;
                break;
            }
        }
        //
        // get category value recomendation
        //
        var query = { $and: [ { category: c }, { minimum: { $lte: value } }, { maximum: { $gt: value } } ]};
        console.log( 'getRecomendation : looking for : ' + JSON.stringify( query ) );
        var recomendation = findOne( query );
        //
        //
        //
        return recomendation ? recomendation.recomendation : 'Not sure what to say : ' + c;
    }
}
