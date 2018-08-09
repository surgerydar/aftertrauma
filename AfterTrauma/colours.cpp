#include "colours.h"

Colours* Colours::s_shared = nullptr;

QMap< QString, QColor > Colours::s_colours = {
    { QString( "darkGreen" ), QColor("#03BD5B") },
    { QString( "lightGreen" ), QColor("#9DBF1C") },
    { QString( "blue" ), QColor("#2191FB") },
    { QString( "darkPurple" ), QColor("#A939B9") },
    { QString( "lightPurple" ), QColor("#FF48B8") },
    { QString( "red" ), QColor("#BA274A") },
    { QString( "darkOrange" ), QColor("#EB5E28") },
    { QString( "lightOrange" ), QColor("#F6AA1C") },
    { QString( "veryDarkSlate" ), QColor("#202C35") },
    { QString( "darkSlate" ), QColor("#202C35") },
    { QString( "mediumDarkSlate" ), QColor("#3B6064") },
    { QString( "slate" ), QColor("#55828B") },
    { QString( "mediumLightSlate" ), QColor("#8DA9C4") },
    { QString( "lightSlate" ), QColor("#B8CADA") },
    { QString( "veryLightSlate" ), QColor("#E5EBF1") },
    { QString( "almostWhite" ), QColor("#F5F7FA") }
};

QVector< QColor > Colours::s_categoryColours = {
    Colours::s_colours["darkGreen"],
    Colours::s_colours["darkPurple"],
    Colours::s_colours["blue"],
    Colours::s_colours["darkOrange"],
    Colours::s_colours["lightPurple"],
    Colours::s_colours["lightGreen"],
    Colours::s_colours["red"],
    Colours::s_colours["lightOrange"]
};

Colours::Colours(QObject *parent) : QObject(parent) {

}

Colours* Colours::shared() {
    if ( s_shared == nullptr ) {
        s_shared = new Colours;
    }
    return s_shared;
}
