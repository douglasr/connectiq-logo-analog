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

// 416x416 round devices (eg. Venu 2, Venu 2 Plus, Epix, D2 Air X10, D2 Mach 1)

using Toybox.Graphics as Gfx;
using Toybox.Math as Math;

module DeviceOverride {

    // each 4-tuple is the start x,y coordinate and end x,y coordinate used to draw a line
    //   representing the hour markers around the watch face
    const HOUR_MARK_COORDS = [ 398,208,416,208,   372,303,388,312,  302,372,311,388,  208,398,208,416,
                               113,372,104,388,   44,303,28,312,    18,208,0,208,     44,114,28,105,
                               114,44,105,28,     208,18,208,0,     302,44,311,28,    372,113,388,104 ];

    // pixel locations for double marker at the top of the hour
    const TOP_HOUR_MARKER_HEIGHT = 22;
    const TOP_HOUR_MARKER_LEFT_X = 196;
    const TOP_HOUR_MARKER_RIGHT_X = 220;

    const HOUR_HAND_LENGTH = 108;    // length (in pixels) of the hour hand
    const MINUTE_HAND_LENGTH = 176; // length (in pixels) of the minute hand
    const SECOND_HAND_LENGTH = 190; // length (in pixels) of the second hand
    const SECOND_HAND_TAIL_LENGTH = Math.floor(SECOND_HAND_LENGTH*0.17);

    const DAY_OF_WEEK_X = 308;  // x-position for day of week string
    const DAY_OF_MONTH_X = 390; // x-position for day of month string
    const DATE_FONT = Gfx.FONT_SYSTEM_SMALL;    // font to use for date strings

    const BATTERY_GRAPH_Y = 372;    // y-position of battery graph
    const BATTERY_GRAPH_HEIGHT = 14; // height (in pixels) of battery graph
    const BATTERY_GRAPH_WIDTH = 70; // width (in pixels) of battery graph

}
