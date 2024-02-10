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

// 360x360 round devices (eg. Venu 2S)

using Toybox.Graphics as Gfx;
using Toybox.Math as Math;

module DeviceOverride {

    // each 4-tuple is the start x,y coordinate and end x,y coordinate used to draw a line
    //   representing the hour markers around the watch face
    const HOUR_MARK_COORDS = [ 346,180,360,180,  323,263,335,270,  262,323,269,335,  180,346,180,360,
                               97,323,90,335,    37,263,25,270,    14,180,0,180,     37,98,25,91,
                               98,37,91,25,      180,14,180,0,     262,37,269,25,    323,97,335,90];

    // pixel locations for double marker at the top of the hour
    const TOP_HOUR_MARKER_HEIGHT = 21;
    const TOP_HOUR_MARKER_LEFT_X = 170;
    const TOP_HOUR_MARKER_RIGHT_X = 191;

    const HOUR_HAND_LENGTH = 108;    // length (in pixels) of the hour hand
    const MINUTE_HAND_LENGTH = 176; // length (in pixels) of the minute hand
    const SECOND_HAND_LENGTH = 190; // length (in pixels) of the second hand
    const SECOND_HAND_TAIL_LENGTH = Math.floor(SECOND_HAND_LENGTH*0.17);

    const DAY_OF_WEEK_X = 265;  // x-position for day of week string
    const DAY_OF_MONTH_X = 337; // x-position for day of month string
    const DATE_FONT = Gfx.FONT_SYSTEM_SMALL;    // font to use for date strings

    const BATTERY_GRAPH_Y = 372;    // y-position of battery graph
    const BATTERY_GRAPH_HEIGHT = 14; // height (in pixels) of battery graph
    const BATTERY_GRAPH_WIDTH = 70; // width (in pixels) of battery graph

}
