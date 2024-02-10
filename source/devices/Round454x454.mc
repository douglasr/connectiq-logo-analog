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

// 454x454 round devices (eg. Descent Mk3i (51mm), Epix 2 Pro (51mm), Forerunner 965)

using Toybox.Graphics as Gfx;
using Toybox.Math as Math;

module DeviceOverride {

    // each 4-tuple is the start x,y coordinate and end x,y coordinate used to draw a line
    //   representing the hour markers around the watch face
    const HOUR_MARK_COORDS = [  430,227,454,227,   402,328,423,340,   328,402,340,423,   227,430,227,454,
                                126,402,114,423,   52,328,31,340,     24,227,0,227,      52,126,31,114,
                                126,52,114,31,     227,24,227,0,      328,52,340,31,     402,126,423,114 ];

    // pixel locations for double marker at the top of the hour
    const TOP_HOUR_MARKER_HEIGHT = 24;
    const TOP_HOUR_MARKER_LEFT_X = 213;
    const TOP_HOUR_MARKER_RIGHT_X = 240;

    const HOUR_HAND_LENGTH = 132;    // length (in pixels) of the hour hand
    const MINUTE_HAND_LENGTH = 200; // length (in pixels) of the minute hand
    const SECOND_HAND_LENGTH = 218; // length (in pixels) of the second hand
    const SECOND_HAND_TAIL_LENGTH = Math.floor(SECOND_HAND_LENGTH*0.17);

    const DAY_OF_WEEK_X = 330;  // x-position for day of week string
    const DAY_OF_MONTH_X = 423; // x-position for day of month string
    const DATE_FONT = Gfx.FONT_SYSTEM_SMALL;    // font to use for date strings

    const BATTERY_GRAPH_Y = 430;    // y-position of battery graph
    const BATTERY_GRAPH_HEIGHT = 16; // height (in pixels) of battery graph
    const BATTERY_GRAPH_WIDTH = 84; // width (in pixels) of battery graph

}
