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

//===========================================================================
// Logo Analog watch face
//---------------------------------------------------------------------------
// Download this watch face from the Garmin Connect IQ store at:
// https://apps.garmin.com/en-CA/apps/13226d6b-0755-4da1-b575-0d7235d88003
//

using Toybox.Application as App;
using Toybox.WatchUi as Ui;

var gDeviceSettings;            // quick access to settings on the device
var gSettingsChanged = true;    // flag as to whether or not the app settings have changed
var gPartialUpdatesAllowed;     // whether or not to allow partial updates (ie. 1Hz always on second hand)

class LogoAnalogApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
        $.gDeviceSettings = System.getDeviceSettings();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // new app settings have been received so trigger a UI update and set flag
    function onSettingsChanged() {
        $.gSettingsChanged = true;  // set global flag so the View object knows to reload settings and adjust accordingly
        $.gDeviceSettings = System.getDeviceSettings();     // probably a good time to refresh the device settings also
        Ui.requestUpdate();
    }

    // return the initial view
    function getInitialView() {
        if (Toybox.Graphics has :BufferedBitmap) {
            // if the CIQ VM supports a BufferedBitmap then return a view as well
            //   as a delegate (in case of power budget exceeded)
            $.gPartialUpdatesAllowed = true;
            return [ new LogoAnalogView(), new LogoAnalogDelegate() ];
        } else {
            // otherwise, only return a view object
            $.gPartialUpdatesAllowed = false;
            return [ new LogoAnalogView() ];
        }
    }

    // returns a config property as a boolean object
    function getBooleanProperty(key, initial) {
        var value = getProperty(key);
        if (value != null) {
            if (value instanceof Lang.Boolean) {
                return value;
            } else if (value instanceof Lang.String) {
                return value.toNumber() != 0;
            }
        }
        return initial;
    }

    // returns a config property as a Number object
    function getNumberProperty(key, initial) {
        var value = getProperty(key);
        if (value != null) {
            if (value instanceof Lang.Number) {
                return value;
            } else if (value instanceof Lang.Long || value instanceof Lang.String) {
                return value.toNumber();
            }
        }
        return initial;
    }

}
