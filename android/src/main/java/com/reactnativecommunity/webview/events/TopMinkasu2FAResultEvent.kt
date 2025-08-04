package com.reactnativecommunity.webview.events

import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event
import com.facebook.react.uimanager.events.RCTEventEmitter

class TopMinkasu2FAResultEvent(viewId: Int, private val mEventData: WritableMap) :
    Event<TopMinkasu2FAResultEvent>(viewId) {
    companion object {
        const val EVENT_NAME = "topMinkasu2FAResult"
    }

    override fun getEventName(): String = EVENT_NAME

    override fun canCoalesce(): Boolean = false

    override fun getCoalescingKey(): Short = 0

    override fun dispatch(rctEventEmitter: RCTEventEmitter) =
        rctEventEmitter.receiveEvent(viewTag, eventName, mEventData)
}
