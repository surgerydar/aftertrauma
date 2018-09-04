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
                            recomendation: "Some difficulties. Need some help?",
                            links: [
                            ]
                        },
                        {
                            category: "body",
                            minimum: 0.25,
                            maximum: 0.5,
                            recomendation: "Some difficulties. Need some help?",
                            links: [
                            ]
                        },
                        {
                            category: "body",
                            minimum: 0.5,
                            maximum: 0.75,
                            recomendation: "You’re making good progress! Keep it up!",
                            links: [
                            ]
                        },
                        {
                            category: "body",
                            minimum: 0.75,
                            maximum: 1.0,
                            recomendation: "You’re making good progress! Keep it up!",
                            links: [
                            ]
                        },
                        {
                            category: "emotions",
                            minimum: 0.0,
                            maximum: 0.25,
                            recomendation: "Some difficulties. Need some help?",
                            links: [
                            ]
                        },
                        {
                            category: "emotions",
                            minimum: 0.25,
                            maximum: 0.5,
                            recomendation: "Some difficulties. Need some help?",
                            links: [
                            ]
                        },
                        {
                            category: "emotions",
                            minimum: 0.5,
                            maximum: 0.75,
                            recomendation: "You’re making good progress! Keep it up!",
                            links: [
                            ]
                        },
                        {
                            category: "emotions",
                            minimum: 0.75,
                            maximum: 1.0,
                            recomendation: "You’re making good progress! Keep it up!",
                            links: [
                            ]
                        },
                        {
                            category: "relationships",
                            minimum: 0.0,
                            maximum: 0.25,
                            recomendation: "Some difficulties. Need some help?",
                            links: [
                            ]
                        },
                        {
                            category: "relationships",
                            minimum: 0.25,
                            maximum: 0.5,
                            recomendation: "Some difficulties. Need some help?",
                            links: [
                            ]
                        },
                        {
                            category: "relationships",
                            minimum: 0.5,
                            maximum: 0.75,
                            recomendation: "You’re making good progress! Keep it up!",
                            links: [
                            ]
                        },
                        {
                            category: "relationships",
                            minimum: 0.75,
                            maximum: 1.0,
                            recomendation: "You’re making good progress! Keep it up!",
                            links: [
                            ]
                        },
                        {
                            category: "life",
                            minimum: 0.0,
                            maximum: 0.25,
                            recomendation: "Some difficulties. Need some help?",
                            links: [
                            ]
                        },
                        {
                            category: "life",
                            minimum: 0.25,
                            maximum: 0.5,
                            recomendation: "Some difficulties. Need some help?",
                            links: [
                            ]
                        },
                        {
                            category: "life",
                            minimum: 0.5,
                            maximum: 0.75,
                            recomendation: "You’re making good progress! Keep it up!",
                            links: [
                            ]
                        },
                        {
                            category: "life",
                            minimum: 0.75,
                            maximum: 1.0,
                            recomendation: "You’re making good progress! Keep it up!",
                            links: [
                            ]
                        },
                        {
                            category: "confidence",
                            minimum: 0.0,
                            maximum: 0.25,
                            recomendation: "Some difficulties. Need some help?",
                            links: [
                            ]
                        },
                        {
                            category: "confidence",
                            minimum: 0.25,
                            maximum: 0.5,
                            recomendation: "Some difficulties. Need some help?",
                            links: [
                            ]
                        },
                        {
                            category: "confidence",
                            minimum: 0.5,
                            maximum: 0.75,
                            recomendation: "You’re making good progress! Keep it up!",
                            links: [
                            ]
                        },
                        {
                            category: "confidence",
                            minimum: 0.75,
                            maximum: 1.0,
                            recomendation: "You’re making good progress! Keep it up!",
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
            return 'unable to find daily results';
        }
        console.log( 'getRecomendation : daily : ' + JSON.stringify( daily.values ) );
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
        var query = { $and: [ { category: c }, { minimum: { $lte: value } }, { maximum: { $gte: value } } ]};
        console.log( 'getRecomendation : looking for : ' + JSON.stringify( query ) );
        var recomendation = findOne( query );
        var text;
        if ( recomendation ) {
            text = recomendation.recomendation;
            if ( value < .5 ) {
                text += '<br/><a class="recommendation" href="link://' + c + '">' + c + ' resources</a>';
            }
        } else {
            text = 'Insufficient information to assess : ' + c;
        }
        //
        //
        //
        return text;
    }
}
