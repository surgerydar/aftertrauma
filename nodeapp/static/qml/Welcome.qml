import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtMultimedia 5.8
import "Blocks"

VisualItemModel {
    TextBlock {
        media: "<p>Welcome to the After Trauma app, our tool to help you recover from traumatic injury. We are clinical trauma specialists at Queen Mary University, steered by a team of patient advisors.</p><p>To get expert advice, hear from other survivors, set and track your progress towards recovery goals and get support from other patients please <a href='#login'>register here</a>. You can browse our database of <a href='#knowledgebase'>resources</a> without registration.</p>"
    }
    ImageBlock {
        media: "media/images/HowToHelpALovedOne.jpg"
    }
    TextBlock {
        media: "<h1>EXPERT ADVICE...</h1><p>Our <a href='#knowledgebase'>knowledge base</a> contains a wealth of advice ranging from building body strength to dealing with changes in family relationships. For example here are some sage words on dealing with emotional issues after suffering traumatic injury...</p>"
    }
    ImageBlock {
        media: "media/images/HelpfulOrganisations.png"
    }
    TextBlock {
        media: "<i>After an unexpected event it is quite common to experience a whole host of different emotions.  There is no right and wrong way to feel.  Both family member and patients can experience these emotional roller coasters.  It is quite common for family members to go through this in the first instance while their loved one is in hospital. This is often due to the lack of communication in the hospital and living with uncertainty while patients in hospital are desperately trying to get better. The hospital is an unfamiliar environment for many people and dealing with the daily commute to come and see your loved one, working, and sorting out the rest of the family can be quite challenging. Feelings of worry and helplessness are also quite common. However, we all respond to these events differently. Some people will refer to these feelings as stress and others will call it worry. Regardless of the words, these are very common emotions to go through. In the subsequent section we provide more information on stress and worry and tips for dealing with this for both carers and patients.</i>"
    }
    TextBlock {
        media: "<h1>HEAR FROM SURVIVORS...</h1><p>Shan was hit by a car almost 2 years ago, and her multiple injuries were so severe she was given a 6% chance of survival. She shares her remarkable recovery story with you, including the emotional issues she dealt with.</p>"
    }
    //
    //
    //
    VideoBlock {
        media: "media/video/ShansStory.mp4"
    }
    TextBlock {
        media: "<h1>TRACKER and DIARY...</h1><p>The tracker allows you to visually and intuitively track your progress over time with interactive graphs. Here we have an example of progress revealed in a flower graph</p>"
    }
    ImageBlock {
        media: "media/images/MyBodyFlowerGraph.png"
    }
    TextBlock {
        media: "<p>And here a more conventional line graph</p>"
    }
    ImageBlock {
        media: "media/images/MyBodyLinearGraph.png"
    }
    TextBlock {
        media: "<h1>MESSAGING TOOL...</h1><p>Our messaging tool allows you to browse, search and contribute to a public messaging forum to ask questions and see what others are saying. You can also join or form small closed groups to discuss particular topics or privately message other people using the app.</p>"
    }
    ImageBlock {
        media: "media/images/message-bubble-left.png"
    }
}
