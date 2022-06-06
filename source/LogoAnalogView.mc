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

using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class LogoAnalogView extends Ui.WatchFace {

    static const RAD_90_DEG = 1.570796; // constant to save calculating it each time
    static const HOUR_TICK_LENGTH = 10; // length of the accent colour on each hour tick
    static const ARC_MAX = 52;          // length of the arc for the step and move indicators

    var cDisplaySecondHand;     // config: display second hand [0 off, 1 on gesture, 2 always on]
    var cDisplayStepsIndicator; // config: display steps graph, including move indicator [boolean]
    var cDisplayBatteryGraph;   // config: display battery graph [boolean]
    var cAccentColor;           // config: accent colour [RGB hex number]
    var cSecondHandColor;       // config: second hand colour [RGB hex number]

    var middleX;            // middle (X-axis) of the watch display
    var middleY;            // middle (Y-axis) of the watch display
    var deviceStyle;        // screen shape; used to determine where/how to display the step and move indicators
    var clockTime;          //

    var dcOffscreenBuffer;  // offscreen buffer for the main watch face
    var dcDateBarBuffer;    // offscreen buffer for the date bar
    var dcCurClip;          // array of the current clip coordinates
    var resBackground;      // background image resource

    var updateSeconds = false;  // whether or not to display the second hand on update

    // all the cool initialization happens here; un-cool initialization code need not apply
    function initialize() {
        WatchFace.initialize();
        middleX = $.gDeviceSettings.screenWidth/2;
        middleY = $.gDeviceSettings.screenHeight/2;
        deviceStyle = $.gDeviceSettings.screenShape;
        retrieveSettings();     // retrieve the user's settings for this watch face
    }

    // set up everything needed to render the watch face
    function onLayout(dc) {
        // if the watch supports BufferedBitmap objects then allocate it
        // CAUTION: some devices support BufferedBitmap objects but not the 1Hz updates, which is
        //    why those devices don't have the "Always" configuration setting for "Display Second Hand"
        if (Toybox.Graphics has :BufferedBitmap) {
            allocateOffscreenBuffer(dc);
        } else {
            deallocateOffscreenBuffer();
        }
        // now's a great time to load the background image
        resBackground = Ui.loadResource(Rez.Drawables.Background);
    }

    // This onShow() function can be commented out or removed as it's empty, but is left here as a
    //   reminder should it be needed for any actions prior to displaying the watch face
    function onShow() {
    }

    // this onHide() function can be commented out or removed as it's empty, but is left here as a
    //   reminder should it be needed for any actions prior to hiding the watch face
    function onHide() {
    }

    // the watch is about to go into high power mode (with updates every second) due to hand gesture
    function onExitSleep() {
        // only need to turn the second hand on if not set to "off"
        if (cDisplaySecondHand >= 1) {
            updateSeconds = true;
            WatchUi.requestUpdate();    // this is probably redundant but better safe than sorry (or so they say)
        }
    }

    // the watch is about to go back into low power mode (with updates every minute, on the minute)
    function onEnterSleep() {
        updateSeconds = false;
        WatchUi.requestUpdate();    // this is probably redundant but better safe than sorry (or so they say, I think)
    }

    // update the watch face view
    function onUpdate(dc) {
        // if the settings are flagged as having changed (which is set in the AppBase object),
        //   then retrieve the settings again
        if ($.gSettingsChanged) {
            $.gSettingsChanged = false;
            retrieveSettings();
        }

        // use anti-aliased drawing for primitives (if available)
        if (dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }

        // handle allocation or deallocation of the off-screen buffers, as required, based on any changes
        //   to settings and/or time issues rendering
        if (Toybox.Graphics has :BufferedBitmap) {
            if (cDisplaySecondHand == 2 && $.gPartialUpdatesAllowed && dcOffscreenBuffer == null) {
                // if configured for always on, and it's allowed and the buffer is null then the
                //   user may have switched so allocate the required buffers
                allocateOffscreenBuffer(dc);
            } else if (cDisplaySecondHand < 2 || !$.gPartialUpdatesAllowed) {
                // clear any DC clipping and deallocate the off-screen buffers if they are not
                // (or are no longer) needed
                dc.clearClip();
                deallocateOffscreenBuffer();
            }
        }

        // get local time
        var timeNow = Time.now();
        var localTimeInfo = Time.Gregorian.info(timeNow, Time.FORMAT_MEDIUM);
        clockTime = localTimeInfo;

        // set the day of week and day of month strings
        var dayOfWeekStr = localTimeInfo.day_of_week.substring(0,3).toUpper();
        var dayOfMonthStr = localTimeInfo.day.format("%02d");

        // set the targetDc object to use for rendering; if doing the always on second hand then
        //   we want to ensure that we update the offscreen buffer, since we have an updated minute
        //   hand (and potentially the hour hand also)
        var targetDc;
        if (dcOffscreenBuffer != null && $.gPartialUpdatesAllowed) {
            dc.clearClip();
            dcCurClip = null;
            targetDc = dcOffscreenBuffer.getDc();
        } else {
            targetDc = dc;
        }

        // clear the screen
        targetDc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
        targetDc.clear();

        // draw the background
        targetDc.drawBitmap(0,0,resBackground);

        // draw the 12 o'clock marker
        targetDc.setPenWidth(9);
        targetDc.setColor(cAccentColor, Gfx.COLOR_TRANSPARENT);
        targetDc.drawLine(DeviceOverride.TOP_HOUR_MARKER_LEFT_X,0,DeviceOverride.TOP_HOUR_MARKER_LEFT_X,DeviceOverride.TOP_HOUR_MARKER_HEIGHT);
        targetDc.drawLine(DeviceOverride.TOP_HOUR_MARKER_RIGHT_X,0,DeviceOverride.TOP_HOUR_MARKER_RIGHT_X,DeviceOverride.TOP_HOUR_MARKER_HEIGHT);

        // draw the larger hour marks
        targetDc.setColor(cAccentColor, Gfx.COLOR_TRANSPARENT);
        targetDc.setPenWidth(5);
        for (var i=0; i < 12; i++) {
            // skip the mark at the top of the hour and the three o'clock positions
            if (i == 9 || i == 0) {
                // 9 == top of hour, 0 == 3 o'clock
                continue;
            }
            targetDc.drawLine(DeviceOverride.HOUR_MARK_COORDS[i*4+0],DeviceOverride.HOUR_MARK_COORDS[i*4+1],DeviceOverride.HOUR_MARK_COORDS[i*4+2],DeviceOverride.HOUR_MARK_COORDS[i*4+3]);
        }

        // draw the date bar with day of week/month
        drawDateBar(targetDc, dayOfWeekStr, dayOfMonthStr);

        // if activity tracking is on, manually draw/update the steps and move indicators (if so configured)
        if ($.gDeviceSettings.activityTrackingOn) {
            if (cDisplayStepsIndicator) {
                var activityInfo = Toybox.ActivityMonitor.getInfo();
                var stepPercent = activityInfo.steps.toFloat()/activityInfo.stepGoal.toFloat();
                drawStepsIndicator(targetDc,stepPercent);
            }
            drawMoveWarning(targetDc);
        }
        // manually draw/update the battery indicator bars (if so configured)
        if (App.getApp().getBooleanProperty("DisplayBatteryIndicator",true)) {
            updateBatteryLevel(targetDc);
        }

        // draw the background and hands
        drawBackground(dc);
        drawHands(dc, middleX, middleY, clockTime);

        if (updateSeconds || ($.gPartialUpdatesAllowed && dcOffscreenBuffer != null)) {
            // draw the second hand, if configured
            drawHandCenter(dc, middleX, middleY, true);
            drawSecondHand(dc, middleX, middleY, clockTime);
        } else {
            // otherwise, just draw the center rings
            drawHandCenter(dc, middleX, middleY, false);
        }

    }

    // this function is called every second to allow for "always on" watch faces;
    //   the code must run quickly and utilize off-screen buffer(s) in order to
    //   satisfy the power budget requirements (so as to preserve battery life).
    function onPartialUpdate(dc) {
        // no need to do anything if partial updates aren't allowed or if we
        //   don't have an off-screen buffer allocated
        if (!$.gPartialUpdatesAllowed || dcOffscreenBuffer == null) {
            return;
        }

        // use anti-aliased drawing for primitives (if available)
        if (dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }

        drawBackground(dc);
        clockTime = System.getClockTime();
        drawHands(dc, middleX, middleY, clockTime);
        dcCurClip = calculateSecondHandClip(clockTime.sec);
        dc.setClip(dcCurClip[0], dcCurClip[1], dcCurClip[2], dcCurClip[3]);
        // replicated code from drawHandCenter() method for slightly faster code, rather
        //   calling the function as such: drawHandCenter(dc, middleX, middleY, true);
        dc.setPenWidth(2);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawCircle(middleX, middleY, 10);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.drawCircle(middleX, middleY, 8);
        drawSecondHand(dc, middleX, middleY, clockTime);
    }

    // calculate the bounding box for the second hand clipped area, which allows dynamic 1Hz update of
    //   the clipped area while simply redrawing the rest using the saved offscreen buffer
    function calculateSecondHandClip(seconds) {
        var angle = (seconds / 60.0) * Math.PI * 2 - RAD_90_DEG;
        var points = [
            middleX+(Math.cos(angle) * DeviceOverride.SECOND_HAND_LENGTH),
            middleY+(Math.sin(angle) * DeviceOverride.SECOND_HAND_LENGTH),
            middleX+(Math.cos(angle+Math.PI) * DeviceOverride.SECOND_HAND_LENGTH * 0.17),   // add PI to get 180 deg (opposite dir)
            middleY+(Math.sin(angle+Math.PI) * DeviceOverride.SECOND_HAND_LENGTH * 0.17)    // add PI to get 180 deg
        ];
        var bbox = [
            (points[0] < points[2] ? points[0] : points[2])-2,
            (points[1] < points[3] ? points[1] : points[3])-2,
            (points[0]-points[2]).abs()+4,
            (points[1]-points[3]).abs()+4
        ];
        points = null;
        // need to adjust the bounding box to handle the tail and the hand centers
        if (bbox[0] > middleX-13) {
            bbox[0] = middleX-13;
            bbox[2] += 13;
        }
        if (bbox[1] > middleY-13) {
            bbox[1] = middleY-13;
            bbox[3] += 13;
        }
        if (bbox[0]+bbox[2] < middleX+13) {
            bbox[2] = middleX+13-bbox[0];
        }
        if (bbox[1]+bbox[3] < middleY+13) {
            bbox[3] = middleY+13-bbox[1];
        }
        return (bbox);
    }

    // draw the offscreen buffers of the watch face background and the date bar onto the
    //   specified Dc object; if partial updates aren't allowed then simply return as drawing
    //   of the background will have been done in the onUpdate() function
    function drawBackground(dc) {
        if (!$.gPartialUpdatesAllowed || dcOffscreenBuffer == null) {
            return;
        }
        dc.drawBitmap(0, 0, dcOffscreenBuffer);
        dc.drawBitmap(middleX,middleY-(dcDateBarBuffer.getDc().getHeight()/2), dcDateBarBuffer);
    }

    // draw the hour and minute hands
    function drawHands(dc, xPos, yPos, clockTime) {
        var hourHand;
        var minuteHand;

        // draw the hour hand; convert it to minutes and compute the angle.
        hourHand = (((clockTime.hour % 12) * 60) + clockTime.min);
        hourHand = hourHand / (12 * 60.0);
        hourHand = hourHand * Math.PI * 2 - RAD_90_DEG;
        drawHand(dc, xPos, yPos, hourHand, DeviceOverride.HOUR_HAND_LENGTH, 7, Gfx.COLOR_WHITE);

        // draw a separator around the minute hand centre
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawCircle(xPos, yPos, 11);

        // draw the minute hand
        minuteHand = (clockTime.min / 60.0) * Math.PI * 2 - RAD_90_DEG;
        drawHand(dc, xPos, yPos, minuteHand, DeviceOverride.MINUTE_HAND_LENGTH, 6, Gfx.COLOR_WHITE);
    }

    // draw the second hand
    function drawSecondHand(dc, xPos, yPos, clockTime) {
        var secondHand = (clockTime.sec / 60.0) * Math.PI * 2 - RAD_90_DEG;
        drawHand(dc, xPos, yPos, secondHand, DeviceOverride.SECOND_HAND_LENGTH, 2, cSecondHandColor);
        // add Math.PI to get 180 deg (opposite direction)
        drawHand(dc, xPos, yPos, secondHand+Math.PI, DeviceOverride.SECOND_HAND_TAIL_LENGTH, 2, cSecondHandColor);
        // clean up the center
        dc.setColor(cSecondHandColor, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(xPos, yPos, 6);
        dc.drawCircle(xPos, yPos, 6);
    }

    // common function to draw a generic clock hand of a given length/width
    function drawHand(dc, xPos, yPos, angle, length, width, color) {
        var endX = Math.cos(angle) * length;
        var endY = Math.sin(angle) * length;
        dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(width+2);
        dc.drawLine(xPos, yPos, xPos+endX, yPos+endY);
        dc.setColor(color,Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(width);
        dc.drawLine(xPos, yPos, xPos+endX, yPos+endY);
    }

    // clean up the center of the hands to give a "3D-like" appearance as
    //   would be associated with multiple hands layered on top of each other
    function drawHandCenter(dc, xPos, yPos, displaySeconds) {
        if (displaySeconds) {
            // this code is replicated in the onPartialUpdate() method (so as
            // improve the redraw speed/time on the device)
            dc.setPenWidth(2);
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            dc.drawCircle(xPos, yPos, 10);
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            dc.drawCircle(xPos, yPos, 8);
        } else {
            dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
            dc.fillCircle(xPos, yPos, 10);
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            dc.setPenWidth(4);
            dc.drawCircle(xPos, yPos, 8);
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            dc.setPenWidth(2);
            dc.drawCircle(xPos, yPos, 10);
        }
    }

    // draw the date bar with specified day of week and day of month strings
    function drawDateBar(dc, dayOfWeekStr, dayOfMonthStr) {
        var targetDc;
        var posDayX, posMonthX, posY;
        if (dcOffscreenBuffer != null) {
            targetDc = dcDateBarBuffer.getDc();
            targetDc.clearClip();
            targetDc.drawBitmap(-middleX, -middleY+targetDc.getHeight()/2, dcOffscreenBuffer);
            posDayX = DeviceOverride.DAY_OF_WEEK_X-(dc.getWidth()/2);
            posMonthX = DeviceOverride.DAY_OF_MONTH_X-(dc.getWidth()/2);
            posY = targetDc.getHeight()/2;
        } else {
            targetDc = dc;
            posDayX = DeviceOverride.DAY_OF_WEEK_X;
            posMonthX = DeviceOverride.DAY_OF_MONTH_X;
            posY = middleY;
        }
        targetDc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        targetDc.drawText(posDayX, posY-1, DeviceOverride.DATE_FONT, dayOfWeekStr, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
        targetDc.drawText(posMonthX, posY-1, DeviceOverride.DATE_FONT, dayOfMonthStr, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }

    // draw the steps indicator/graph as a percentage towards the step goal
    function drawStepsIndicator(dc,stepPercent) {
        var fillPercent = stepPercent;
        var borderColor = Gfx.COLOR_DK_GRAY;
        var fillColor = Gfx.COLOR_LT_GRAY;

        // don't let the percentage complete exceed 100%
        if (fillPercent > 1.0) {
            fillPercent = 1.0;
        }

        var x = $.gDeviceSettings.screenWidth/2;
        var y = $.gDeviceSettings.screenHeight/2;
        var r = x-1;
        // erase the background (if any)
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.setPenWidth(5);
        dc.drawArc(x, y, r-3, Gfx.ARC_CLOCKWISE, 207, 153);

        if (fillPercent > 0) {
            var arcSize = fillPercent*ARC_MAX;
            // only show a completed step bar if we've reached our goal
            if (arcSize > ARC_MAX-1 && arcSize != ARC_MAX && fillPercent != 1.0) {
                arcSize = ARC_MAX-1;
            } else if (arcSize <= 0.51) {
                arcSize = 1;
            }
            dc.setColor(fillColor, Gfx.COLOR_TRANSPARENT);
            dc.setPenWidth(5);
            dc.drawArc(x, y, r-3, Gfx.ARC_CLOCKWISE, 206, 206-arcSize);
        }
        dc.setColor(borderColor, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        // draw the outer and inner arc borders
        dc.drawArc(x, y, r, Gfx.ARC_CLOCKWISE, 207, 153);
        dc.drawArc(x, y, r-5, Gfx.ARC_CLOCKWISE, 207, 153);
        // draw the top and bottom borders
        for (var i=0; i < 5; i++) {
            dc.drawArc(x, y, r-i, Gfx.ARC_CLOCKWISE, 154, 153);
            dc.drawArc(x, y, r-i, Gfx.ARC_CLOCKWISE, 207, 206);
        }
    }

    // draw the move indicator (if required)
    function drawMoveWarning(dc) {
        var moveBarLevel = Toybox.ActivityMonitor.getInfo().moveBarLevel;
        // if the move bar level is above the minimum then display the indicator...
        if (moveBarLevel > Toybox.ActivityMonitor.MOVE_BAR_LEVEL_MIN) {
            dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);

            var x = $.gDeviceSettings.screenWidth/2;
            var y = $.gDeviceSettings.screenHeight/2;
            var r = x-5;
            dc.setPenWidth(5);
            for (var i=1; i < moveBarLevel; i++) {
                dc.drawArc(x, y, x-3, Gfx.ARC_COUNTER_CLOCKWISE, 3+i*5, 6+i*5);
            }
            dc.drawArc(x, y, x-3, Gfx.ARC_COUNTER_CLOCKWISE, 333, 351);
            dc.setPenWidth(1);
        }
    }

    // draw the battery graph as a percentage
    function updateBatteryLevel(dc) {
        var batteryLevel = System.getSystemStats().battery;
        var x = $.gDeviceSettings.screenWidth/2-(DeviceOverride.BATTERY_GRAPH_WIDTH/2);
        var y = DeviceOverride.BATTERY_GRAPH_Y;
        var w = DeviceOverride.BATTERY_GRAPH_WIDTH;
        var h = DeviceOverride.BATTERY_GRAPH_HEIGHT;

        dc.setPenWidth(1);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.fillRectangle(x-1, y-1, w, h);
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(x, y, batteryLevel/100*(w-2), h-2);
        dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_TRANSPARENT);
        dc.drawRectangle(x-1, y-1, w, h);
    }

    // retrieve the configuration settings (both for the watch and for the watch face)
    function retrieveSettings() {
        $.gDeviceSettings = System.getDeviceSettings();
        cDisplaySecondHand = App.getApp().getNumberProperty("DisplaySecondHand",2);
        cDisplayStepsIndicator = App.getApp().getBooleanProperty("DisplayStepsIndicator",true);
        cDisplayBatteryGraph = App.getApp().getBooleanProperty("DisplayBatteryGraph",true);
        cAccentColor = App.getApp().getProperty("AccentColor");
        if (cAccentColor == null) {
            cAccentColor = Graphics.COLOR_RED;
        }
        var confSecondHandColor = App.getApp().getProperty("SecondHandColor");
        if (confSecondHandColor == 1) {
            cSecondHandColor = Graphics.COLOR_LT_GRAY;
        } else if (confSecondHandColor == 2) {
            cSecondHandColor = cAccentColor;
        } else {
            cSecondHandColor = Graphics.COLOR_RED;
        }
    }

    function allocateOffscreenBuffer(dc) {
        dcOffscreenBuffer = new Gfx.BufferedBitmap({
            :width=>dc.getWidth(),
            :height=>dc.getHeight(),
            :palette=> [
                Gfx.COLOR_DK_GRAY,
                Gfx.COLOR_LT_GRAY,
                Gfx.COLOR_BLACK,
                Gfx.COLOR_WHITE,
                Gfx.COLOR_DK_RED,
                Gfx.COLOR_BLUE,
                Gfx.COLOR_DK_BLUE,
                cAccentColor        // need to be able to buffer the accent color
            ]
        });
        dcDateBarBuffer = new Gfx.BufferedBitmap({
            :width=>dc.getWidth()/2,
            :height=>dc.getFontHeight(DeviceOverride.DATE_FONT)
        });
        dcCurClip = null;
    }

    function deallocateOffscreenBuffer() {
        dcOffscreenBuffer = null;
        dcDateBarBuffer = null;
        dcCurClip = null;
    }

}

class LogoAnalogDelegate extends Ui.WatchFaceDelegate {
    function initialize() {
       WatchFaceDelegate.initialize(); 
    }
    // The onPowerBudgetExceeded callback is called by the system if the
    // onPartialUpdate method exceeds the allowed power budget. If this occurs,
    // the system will stop invoking onPartialUpdate each second, so we set the
    // partialUpdatesAllowed flag here to let the rendering methods know they
    // should not be rendering a second hand.
    function onPowerBudgetExceeded(powerInfo) {
        System.println( "Average execution time: " + powerInfo.executionTimeAverage );
        System.println( "Allowed execution time: " + powerInfo.executionTimeLimit );
        $.gPartialUpdatesAllowed = false;
    }
}
