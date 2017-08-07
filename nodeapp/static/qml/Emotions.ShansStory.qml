import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtMultimedia 5.8
import "Blocks"

VisualItemModel {
    TextBlock {
        media: "Shan was hit by a car almost 2 years ago, and her multiple injuries were so severe she was given a 6% chance of survival. She shares her remarkable recovery story with you, including the emotional issues she dealt with."
    }
    VideoBlock {
        media:"media/video/ShansStory.mp4"
    }
}