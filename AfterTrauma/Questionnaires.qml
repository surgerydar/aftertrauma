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
                        category: "support and services",
                        questions: [
                            { question: "I do not have any problems getting enough food and medication when I need it" },
                            { question: "All the necessary health and rehabilitation services and systems are in place to help my rehabilitation and recovery" },
                            { question: "I have easy access to products and technology to help me carry out my daily routine, even if I do this differently from before" },
                            { question: "I have easy access to products and technology to help me move around indoors and outdoors, even if I do this differently from before" },
                        ]
                    }
               ];
        model.clear();
        data.forEach(function(datum) {
            console.log( 'adding questionnaire : ' + JSON.stringify(datum) );
            model.append(datum);
        });
    }
}
