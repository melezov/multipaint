// Type definitions for jquery.repeatedclick.js v1.0.5
// Project: https://github.com/alexandrz/jQuery-repeatedclick-plugin
// Definitions by: Marko Elezovic <https://github.com/melezov>
// Definitions: https://github.com/borisyankov/DefinitelyTyped

/// <reference path="jquery.d.ts"/>

interface JQuery {
    /**
     * Bind an event handler to the "repeatedclick" JavaScript event.
     *
     * @param handler A function to execute each time the event is triggered, or a repeated click timing interval has passed.
     */
    repeatedclick(handler: (eventObject: JQueryEventObject) => any): JQuery;

    /**
     * Bind an event handler to the "repeatedclick" JavaScript event
     *
     * @param handler A function to execute each time the event is triggered, or a repeated click timing interval has passed.
     * @param options Override default timings for triggering repeated clicks.
     */
    repeatedclick(handler: (eventObject: JQueryEventObject) => any, options: JQueryRepeatedclickOptions): JQuery;
}

interface JQueryRepeatedclickOptions {
    duration?: number;
    speed?: number;
    min?: number;
}
