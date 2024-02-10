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

// Fenix 6X Pro -- device-specific override constants

using Toybox.Graphics as Gfx;
using Toybox.Math as Math;

module DeviceOverride {

    // each 4-tuple is the start x,y coordinate and end x,y coordinate used to draw a line
    //   representing the hour markers around the watch face
    const HOUR_MARK_COORDS = [270,140,280,140, 252,205,261,210, 204,252,209,261, 140,270,140,280,
                              75,252,70,261,   28,205,19,210,   10,140,0,140,    28,76,19,71,
                              76,28,71,19,     140,10,140,0,    204,28,209,19,   252,75,261,70];

    // pixel locations for double marker at the top of the hour
    const TOP_HOUR_MARKER_HEIGHT = 15;
    const TOP_HOUR_MARKER_LEFT_X = 132;
    const TOP_HOUR_MARKER_RIGHT_X = 148;

    const HOUR_HAND_LENGTH = 78;    // length (in pixels) of the hour hand
    const MINUTE_HAND_LENGTH = 126; // length (in pixels) of the minute hand
    const SECOND_HAND_LENGTH = 117; // length (in pixels) of the second hand
    const SECOND_HAND_TAIL_LENGTH = Math.floor(SECOND_HAND_LENGTH*0.17);

    const DAY_OF_WEEK_X = 206;  // x-position for day of week string
    const DAY_OF_MONTH_X = 262; // x-position for day of month string
    const DATE_FONT = Gfx.FONT_SYSTEM_SMALL;    // font to use for date strings

    const BATTERY_GRAPH_Y = 230;    // y-position of battery graph
    const BATTERY_GRAPH_HEIGHT = 8; // height (in pixels) of battery graph
    const BATTERY_GRAPH_WIDTH = 56; // width (in pixels) of battery graph

}
