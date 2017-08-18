import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtMultimedia 5.8
import "Blocks"

VisualItemModel {
    TextBlock {
        media: "Evi's story. Evi was in a car accident, and suffered multiple severe injuries. She bravely shares her recovery story with you, including how she struggled with and overcame depression."
    }
    VideoBlock {
        media:"media/video/EvisStory.mp4"
    }
}