/*
MIT License

Copyright (c) 2018 Douglas Robertson (douglas@edgeoftheearth.com)

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

// MARQ -- device-specific override constants for all MARQ devices

using Toybox.Graphics as Gfx;
using Toybox.Math as Math;

module DeviceOverride {

    // each 4-tuple is the start x,y coordinate and end x,y coordinate used to draw a line
    //   representing the hour markers around the watch face
    const HOUR_MARK_COORDS = [228,120,240,120, 213,174,223,180, 173,213,179,223, 120,228,120,240,
                              66,213,60,223,   27,173,17,179,   12,120,0,120,    27,66,17,60,
                              67,27,61,17,     120,12,120,0,    174,27,180,17,   213,67,223,61];

    // pixel locations for double marker at the top of the hour
    const TOP_HOUR_MARKER_HEIGHT = 14;
    const TOP_HOUR_MARKER_LEFT_X = 112;
    const TOP_HOUR_MARKER_RIGHT_X = 127;

    const HOUR_HAND_LENGTH = 60;    // length (in pixels) of the hour hand
    const MINUTE_HAND_LENGTH = 108; // length (in pixels) of the minute hand
    const SECOND_HAND_LENGTH = 117; // length (in pixels) of the second hand
    const SECOND_HAND_TAIL_LENGTH = Math.floor(SECOND_HAND_LENGTH*0.17);

    const DAY_OF_WEEK_X = 178;  // x-position for day of week string
    const DAY_OF_MONTH_X = 225; // x-position for day of month string
    const DATE_FONT = Gfx.FONT_SYSTEM_SMALL;    // font to use for date strings

    const BATTERY_GRAPH_Y = 204;    // y-position of battery graph
    const BATTERY_GRAPH_HEIGHT = 8; // height (in pixels) of battery graph
    const BATTERY_GRAPH_WIDTH = 56; // width (in pixels) of battery graph

}
