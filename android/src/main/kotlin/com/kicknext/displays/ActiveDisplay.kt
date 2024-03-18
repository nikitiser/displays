package com.kicknext.displays

import android.app.Presentation
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.Display
import android.view.ViewGroup
import android.widget.FrameLayout
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngineCache

class ActiveDisplay(context: Context, private val tag: String, display: Display) :
    Presentation(context, display){
    override fun onCreate(savedInstanceState: Bundle?) {
            super.onCreate(savedInstanceState)

            val flContainer = FrameLayout(context)
            val params = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
            flContainer.layoutParams = params

            setContentView(flContainer)

            val flutterView = FlutterView(context)
            flContainer.addView(flutterView, params)
            val flutterEngine = FlutterEngineCache.getInstance().get(tag)
            if (flutterEngine != null) {
                flutterView.attachToFlutterEngine(flutterEngine)
            } else {
                Log.e("Displays", "Can't find the FlutterEngine with cache name $tag")
            }
        }

    override fun onStop() {
        FlutterEngineCache.getInstance().get(tag)!!.let {
            it.lifecycleChannel.appIsInactive()
            it.lifecycleChannel.appIsPaused()
            it.lifecycleChannel.appIsDetached()
            it.destroy()
        }
        FlutterEngineCache.getInstance().remove(tag)
        ownerActivity?.finish()
        super.onStop()
    }

}