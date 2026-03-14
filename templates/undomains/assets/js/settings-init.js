
"use strict"
// Check for saved theme from new toggle system (localStorage) first, then fall back to cookie
var savedTheme = localStorage.getItem('undomains_theme');
if (!savedTheme) {
    var bgCookie = document.cookie.match(/(?:^|;)\s*background=([^;]*)/);
    savedTheme = (bgCookie && bgCookie[1]) ? bgCookie[1] : 'dark';
}

var optionSettings = {
    layout:"wide",
    background: savedTheme,
    color:"pink",
    header:"fixed",
    font:"opensans",
    textDirection:"ltr",
    radius:"defaultradius",
    showSettings:"show",
};
new undomainsSettings(optionSettings);