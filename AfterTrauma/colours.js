.pragma library

var darkGreen = "#03BD5B";
var lightGreen = "#9DBF1C";
var blue = "#2191FB";
var darkPurple = "#A939B9";
var lightPurple = "#FF48B8";
var red = "#BA274A";
var darkOrange = "#EB5E28";
var lightOrange = "#F6AA1C";
var veryDarkSlate = "#202C35";
var darkSlate = "#202C35";
var mediumDarkSlate = "#3B6064";
var slate = "#55828B";
var mediumLightSlate = "#8DA9C4";
var lightSlate = "#B8CADA";
var veryLightSlate = "#E5EBF1";
var almostWhite = "#F5F7FA";

var categoryColours = [
            darkGreen,
            darkPurple,
            blue,
            darkOrange,
            lightPurple,
            lightGreen,
            red,
            lightOrange
        ];
function categoryColour( index ) {
    return categoryColours[ index % categoryColours.length ];
}
