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

// Fenix 6, 6 Pro -- device-specific override constants

using Toybox.Graphics as Gfx;
using Toybox.Math as Math;

module DeviceOverride {

    // each 4-tuple is the start x,y coordinate and end x,y coordinate used to draw a line
    //   representing the hour markers around the watch face
    const HOUR_MARK_COORDS = [250,130,260,130, 233,190,242,195, 189,233,194,242, 130,250,130,260,
                              70,233,65,242,   27,190,18,195,   10,130,0,130,    27,71,18,66,
                              71,27,66,18,     130,10,130,0,    189,27,194,18,   233,70,242,65];

    // pixel locations for double marker at the top of the hour
    const TOP_HOUR_MARKER_HEIGHT = 15;
    const TOP_HOUR_MARKER_LEFT_X = 122;
    const TOP_HOUR_MARKER_RIGHT_X = 137;

    const HOUR_HAND_LENGTH = 60;    // length (in pixels) of the hour hand
    const MINUTE_HAND_LENGTH = 108; // length (in pixels) of the minute hand
    const SECOND_HAND_LENGTH = 117; // length (in pixels) of the second hand
    const SECOND_HAND_TAIL_LENGTH = Math.floor(SECOND_HAND_LENGTH*0.17);

    const DAY_OF_WEEK_X = 192;  // x-position for day of week string
    const DAY_OF_MONTH_X = 242; // x-position for day of month string
    const DATE_FONT = Gfx.FONT_SYSTEM_SMALL;    // font to use for date strings

    const BATTERY_GRAPH_Y = 230;    // y-position of battery graph
    const BATTERY_GRAPH_HEIGHT = 8; // height (in pixels) of battery graph
    const BATTERY_GRAPH_WIDTH = 56; // width (in pixels) of battery graph

}
