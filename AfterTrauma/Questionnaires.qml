import QtQuick 2.6
import SodaControls 1.0
import "utils.js" as Utils
//
// TODO: sync questions with server
//
DatabaseList {
    id: model
    collection: "questionnaires"
    roles: [ "title", "category", "questions" ]

    Component.onCompleted: {
        //
        // load daily questionnaire
        // TODO: test for todays date
        //
        loadScores();
        //
        //
        //
        if ( count <= 0 ) {
            console.log( 'generating questionnaire test data');
            var data = [
                         {
                             title: "My body",
                             category: "body",
                             questions: [
                                 { question: "Muscle strength and endurance" },
                                 { question: "Moving my body (stiffness)" },
                                 { question: "Pain" }
                             ]
                         },
                         {
                             title: "My emotions and mind",
                             category: "emotions",
                             questions: [
                                 { question: "Managing stress or worry" },
                                 { question: "Controlling my emotions" },
                                 { question: "Concentration and memory" }
                             ]
                         },
                         {
                             title: "Relationships",
                             category: "relationships",
                             questions: [
                                 { question: "Relationships with my family" },
                                 { question: "Intimate relationships" },
                                 { question: "Health services and systems" }
                             ]
                         },
                         {
                             title: "Life and Services",
                             category: "life",
                             questions: [
                                 { question: "Walking" },
                                 { question: "Carrying out my daily routine" },
                                 { question: "Lifting and carrying objects" },
                                 { question: "Looking after finances" }
                             ]
                         },
                         {
                             title: "Confidence",
                             category: "confidence",
                             questions: [
                                 { question: "I can usually handle whatever comes my way" },
                                 { question: "It is easy for me to stick to my aims and accomplish my goals" },
                                 { question: "I can remain calm when facing difficulties because I can rely on my coping abilities" },
                                 { question: "I'm motivated and confident" }
                             ]
                         }
                    ];
             beginBatch();
            data.forEach(function(datum) {
                //console.log( 'adding questionnaire : ' + JSON.stringify(datum) );
                batchAdd(datum);
            });
            endBatch();
            save();
        }
    }
    //
    //
    //
    Component.onDestruction: {
        saveScores();
    }

    //
    //
    //
    function getScore(quesionnaireIndex, questionIndex ) {
        if ( scores[ quesionnaireIndex ] && scores[ quesionnaireIndex ][ questionIndex ] ) return scores[ quesionnaireIndex ][ questionIndex ];
        return 0.;
    }

    function putScore( category, quesionnaireIndex, questionIndex, score ) {
        if ( scores[quesionnaireIndex] === undefined ) {
            scores[ quesionnaireIndex ] = [];
        }
        if ( scores[ quesionnaireIndex ][ questionIndex ] === score ) return;
        //
        //
        //
        scores[ quesionnaireIndex ][ questionIndex ] = score;
        //
        // average scores
        //
        var questionnaire = get(quesionnaireIndex);
        var total = 0;
        var nQuestions = questionnaire.questions.length;
        for ( var i = 0; i < nQuestions; i++ ) {
            total += scores[ quesionnaireIndex ][ i ] || 0;
        }
        var average = total / nQuestions;
        //
        // update daily
        //
        //var today = dailyModel.getTodayAsObject();
        console.log( 'putScore : updating daily' );
        var today = dailyModel.getToday();
        for ( i = 0; i < today.values.length; i++ ) {
            console.log( 'putScore : updating daily : looking for ' + category + ' : found : ' + today.values[ i ].label );
            if ( today.values[ i ].label === category ) {
                console.log( 'putScore : updating daily : setting ' + category + ' : to : ' + average );
                today.values[ i ].value = average;
                dailyModel.update({ day: today.day, month: today.month, year: today.year }, { values: today.values });
                break;
            }
        }
        //
        // check if completed
        //
        if ( dailyCompleted() ) {
            //
            // schedule notification for a week hence
            //
            scheduleNotification();
        }
    }
    //
    //
    //
    function dailyCompleted() {
        if ( count === 0 ) return false;
        //
        // check for incomplete quesionnaires
        //
        for ( var i = 0; i < count; i++ ) {
            var questionCount = get( i ).questions.length;
            for ( var j = 0; j < questionCount; j++ ) {
                if ( getScore(i, j) <= 0 ) return false;
            }
        }
        return true;
    }
    //
    //
    //
    function loadScores() {
        var dailyScores = JSONFile.read('daily-questionnaire.json');
        if ( dailyScores &&  dailyScores.date === Utils.shortDate(Date.now(),true) ) {
            scores = dailyScores.scores;
        } else {
            scores = [];
            for ( var i = 0; i < count; i++ ) {
                scores.push([]);
                var questionCount = get( i ).questions.length;
                for ( var j = 0; j < questionCount; j++ ) {
                    scores[ i ].push( 0. );
                }
            }
            saveScores();
        }
        scoresChanged();
    }
    function saveScores() {
        if ( scores.length > 0 ) {
            JSONFile.write('daily-questionnaire.json', { date: Utils.shortDate(Date.now(),true), scores: scores });
        }
    }
    //
    //
    //
    function scheduleNotification( daily ) {
        NotificationManager.scheduleNotificationByPattern(0x1,0,"Don't forget to complete your Recovery Questionnaire",daily ? 3 : 4);
    }

    //
    //
    //
    property var scores: []
    property int notificationType: 0x1
}
