/*
MIT License

Copyright (c) 2018-2024 Douglas Robertson (douglas@edgeoftheearth.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

// 390x390 round devices (eg. Venu, D2 Air)

using Toybox.Graphics as Gfx;
using Toybox.Math as Math;

module DeviceOverride {

    // each 4-tuple is the start x,y coordinate and end x,y coordinate used to draw a line
    //   representing the hour markers around the watch face
    const HOUR_MARK_COORDS = [ 380,195,390,195,  355,287,363,292,  287,355,292,363,  195,380,195,390,
                               103,355,98,363,   35,287,27,292,    10,195,0,195,     35,103,27,98,
                               103,35,98,27,     195,10,195,0,     287,35,292,27,    355,103,363,98 ];

    // pixel locations for double marker at the top of the hour
    const TOP_HOUR_MARKER_HEIGHT = 22;
    const TOP_HOUR_MARKER_LEFT_X = 184;
    const TOP_HOUR_MARKER_RIGHT_X = 207;

    const HOUR_HAND_LENGTH = 108;    // length (in pixels) of the hour hand
    const MINUTE_HAND_LENGTH = 176; // length (in pixels) of the minute hand
    const SECOND_HAND_LENGTH = 190; // length (in pixels) of the second hand
    const SECOND_HAND_TAIL_LENGTH = Math.floor(SECOND_HAND_LENGTH*0.17);

    const DAY_OF_WEEK_X = 292;  // x-position for day of week string
    const DAY_OF_MONTH_X = 365; // x-position for day of month string
    const DATE_FONT = Gfx.FONT_SYSTEM_SMALL;    // font to use for date strings

    const BATTERY_GRAPH_Y = 372;    // y-position of battery graph
    const BATTERY_GRAPH_HEIGHT = 14; // height (in pixels) of battery graph
    const BATTERY_GRAPH_WIDTH = 70; // width (in pixels) of battery graph

}
