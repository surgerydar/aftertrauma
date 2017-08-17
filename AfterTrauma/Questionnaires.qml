import QtQuick 2.6

ListModel {
    id: model

    Component.onCompleted: {
        var data = [
                    {
                        title: "My body and previous routine",
                        category: "body",
                        questions: [
                            { question: "My muscles are as strong as they used to be and I don’t feel weak at all" },
                            { question: "My joints in my body are as flexible as they were before my accident" },
                            { question: "I do not have any problems with pain" },
                            { question: "I have no problem changing my body position between a variety of positions such as lying down, sitting, standing or kneeling" },
                            { question: "I do not have any difficulty walking" },
                            { question: "I do not have any difficulty carrying out my daily routine" },
                            { question: "I have no problem using the toilet or any continence issues" }
                        ]
                    },
                    {
                        title: "My emotions and mood",
                        category: "emotions",
                        questions: [
                            { question: "I am able to manage stress and can manage a busy schedule at work or at home" },
                            { question: "I have difficulty managing my emotions and can feel a mix of emotions ranging from very sad to very angry" },
                            { question: "I sometimes struggle to make decisions or plan things in advance" },
                            { question: "I do not have any problems with my concentration or memory or solving complex problems" },
                            { question: "I feel motivated and do not lack energy to do the things that I want to do" }
                        ]
                    },
                    {
                        title: "Relationships",
                        category: "relationships",
                        questions: [
                            { question: "I have good relationships with my family which is similar to previous" },
                            { question: "I struggle to interact and talk to people and sometimes feel out of place to deal with complex interactions" },
                            { question: "My immediate family is very supportive in helping my recovery" },
                        ]
                    },
                    {
                        title: "Support and services",
                        category: "life",
                        questions: [
                            { question: "I do not have any problems getting enough food and medication when I need it" },
                            { question: "All the necessary health and rehabilitation services and systems are in place to help my rehabilitation and recovery" },
                            { question: "I have easy access to products and technology to help me carry out my daily routine, even if I do this differently from before" },
                            { question: "I have easy access to products and technology to help me move around indoors and outdoors, even if I do this differently from before" },
                        ]
                    },
                    {
                        title: "How Confident am I today?",
                        category: "mind",
                        questions: [
                            { question: "I can always manage to solve difficult problems if I try hard enough" },
                            { question: "If someone opposes me, I can find the means and ways to get what I want" },
                            { question: "It is easy for me to stick to my aims and accomplish my goals" },
                            { question: "I am confident that I could deal efficiently with unexpected events" },
                            { question: "Thanks to my resourcefulness, I know how to handle unforeseen situations" },
                            { question: "I can solve most problems if I invest the necessary effort" },
                            { question: "I can remain calm when facing difficulties because I can rely on my coping abilities" },
                            { question: "When I am confronted with a problem, I can usually find several solutions" },
                            { question: "If I am in trouble, I can usually think of a solution" },
                            { question: "I can usually handle whatever comes my way" }
                        ]
                    }
               ];
        model.clear();
        data.forEach(function(datum) {
            //console.log( 'adding questionnaire : ' + JSON.stringify(datum) );
            model.append(datum);
        });
        //
        // TODO: reset this at midnight each night
        //
        scores = [];
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
        var questionnaire = model.get(quesionnaireIndex);
        var total = 0;
        var nQuestions = questionnaire.questions.count;
        for ( var i = 0; i < nQuestions; i++ ) {
            total += scores[ quesionnaireIndex ][ i ] || 0;
        }
        var average = total / nQuestions;
        //
        // update daily
        //
        //var today = dailyModel.getTodayAsObject();
        var today = dailyModel.getToday();
        for ( i = 0; i < today.values.length; i++ ) {
            console.log( 'putScore : updating daily : looking for ' + category + ' : found : ' + today.values[ i ].label );
            if ( today.values[ i ].label === category ) {
                today.values[ i ].value = average;
                dailyModel.update({ date: today.date }, { values: today.values });
                break;
            }
        }

    }
    //
    //
    //
    function dailyCompleted() {
        //
        // average scores
        //
        var nQuesionnaires = model.count;
        for ( var i = 0; i < nQuesionnaires; i++ ) {
            var questionnaire = model.get(i);
            var nQuestions = questionnaire.questions.count;
            for ( var j = 0; j < nQuestions; j++ ) {
                if ( getScore(i, j) <= 0 ) return false;
            }
        }
        return true;
    }

    property var scores: []
}
