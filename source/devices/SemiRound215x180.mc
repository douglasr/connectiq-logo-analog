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

// Forerunner 230/235 -- device-specific override constants

using Toybox.Graphics as Gfx;
using Toybox.Math as Math;

module DeviceOverride {

    // each 4-tuple is the start x,y coordinate and end x,y coordinate used to draw a line
    //   representing the hour markers around the watch face
    const HOUR_MARK_COORDS = [206,90,216,90, 192,139,201,144, 156,175,161,184, 107,189,107,199,
                              58,175,53,184, 22,139,13,144,   8,90,-2,90,      22,41,13,36,
                              58,5,53,-4,    107,-9,107,-19,  156,5,161,-4,    192,41,201,36];

    // pixel locations for double marker at the top of the hour
    const TOP_HOUR_MARKER_HEIGHT = 10;
    const TOP_HOUR_MARKER_LEFT_X = 100;
    const TOP_HOUR_MARKER_RIGHT_X = 115;

    const HOUR_HAND_LENGTH = 50;    // length (in pixels) of the hour hand
    const MINUTE_HAND_LENGTH = 85;  // length (in pixels) of the minute hand
    const SECOND_HAND_LENGTH = 88;  // length (in pixels) of the second hand
    const SECOND_HAND_TAIL_LENGTH = Math.floor(SECOND_HAND_LENGTH*0.17);

    const DAY_OF_WEEK_X = 160;  // x-position for day of week string
    const DAY_OF_MONTH_X = 202; // x-position for day of month string
    const DATE_FONT = Gfx.FONT_SYSTEM_MEDIUM;   // font to use for date strings

    const BATTERY_GRAPH_Y = 146;    // y-position of battery graph
    const BATTERY_GRAPH_HEIGHT = 6; // height (in pixels) of battery graph
    const BATTERY_GRAPH_WIDTH = 50; // width (in pixels) of battery graph

}