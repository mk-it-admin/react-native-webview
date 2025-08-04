package com.reactnativecommunity.webview.events

import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event
import com.facebook.react.uimanager.events.RCTEventEmitter

/**
 * Event emitted when minkasu initialization is done.
 */
class TopMinkasu2FAInitEvent(viewId: Int, private val mEventData: WritableMap) :
    Event<TopMinkasu2FAInitEvent>(viewId) {
    companion object {
        const val EVENT_NAME = "topMinkasu2FAInit"
    }

    override fun getEventName(): String = EVENT_NAME

    override fun canCoalesce(): Boolean = false

    override fun getCoalescingKey(): Short = 0

    override fun dispatch(rctEventEmitter: RCTEventEmitter) =
        rctEventEmitter.receiveEvent(viewTag, eventName, mEventData)
}
