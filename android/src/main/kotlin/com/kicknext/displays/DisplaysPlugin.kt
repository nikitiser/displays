package com.kicknext.displays

import android.content.ContentValues.TAG
import android.content.Context
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplayConfig
import android.util.Log
import android.view.Display
import android.view.Surface
import com.kicknext.displays.gen.CreateVirtualDisplayRequest
import com.kicknext.displays.gen.DisplaysPluginApi
import com.kicknext.displays.gen.DisplaysPluginReceiverApi
import com.kicknext.displays.gen.GetDisplaysRequest
import com.kicknext.displays.gen.PluginDisplay
import com.kicknext.displays.gen.SetDisplayRequest
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** DisplaysPlugin */
class DisplaysPlugin: FlutterPlugin, DisplaysPluginApi, ActivityAware {

  private lateinit var context: Context
  private var receiver: DisplaysPluginReceiverApi? = null
  private var displayManager: DisplayManager? = null
  private val activeDisplays: MutableMap<String, ActiveDisplay> = mutableMapOf()
  private val activeVirtualDisplays: MutableMap<String, ActiveVirtualDisplay> = mutableMapOf()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    DisplaysPluginApi.setUp(flutterPluginBinding.binaryMessenger, this)
    receiver = DisplaysPluginReceiverApi(flutterPluginBinding.binaryMessenger)
    displayManager = flutterPluginBinding.applicationContext.getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
    context = flutterPluginBinding.applicationContext
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    DisplaysPluginApi.setUp(binding.binaryMessenger, null)
    receiver = null
  }

  override fun getDisplays(
    request: GetDisplaysRequest,
    callback: (Result<List<PluginDisplay>>) -> Unit
  )  {
    try {
      val pluginDisplays = ArrayList<PluginDisplay>()
      val category = request.category ?: DisplayManager.DISPLAY_CATEGORY_PRESENTATION
      val displays = displayManager?.getDisplays(category)
      if (displays != null) {
        for (display: Display in displays) {
          Log.i(TAG, "display: $display")
          val d = PluginDisplay(
            displayId = display.displayId.toLong(),
            flag = display.flags.toLong(),
            rotation = display.rotation.toLong(),
            name = display.name
          )
          pluginDisplays.add(d)
        }
      }
      callback(Result.success(pluginDisplays))
    } catch (platformError: Throwable) {
      callback(Result.failure(platformError))
    }
  }

  override fun startDisplay(request: SetDisplayRequest, callback: (Result<Boolean>) -> Unit) {
    try {
      if (activeDisplays.containsKey(request.tag)) {
        activeDisplays[request.tag]?.dismiss()
        activeDisplays.remove(request.tag)
        FlutterEngineCache.getInstance().get(request.tag)?.destroy()
        FlutterEngineCache.getInstance().remove(request.tag)

      }
      val display = displayManager?.getDisplay(request.displayId.toInt())
      if (display != null) {
        val flutterEngine = createFlutterEngine(request.entryPointFunctionName, request.tag)
        flutterEngine?.let {
//          flutterEngineChannel = MethodChannel(
//            it.dartExecutor.binaryMessenger,
//            "${viewTypeId}_engine"
//          )
          val newDisplay =
            ActiveDisplay(context, request.tag, display)
          newDisplay.show()
          activeDisplays[request.tag] = newDisplay
          callback(Result.success(true))
        } ?: callback(Result.failure(Throwable("Can't find FlutterEngine")))
      } else {
        callback(Result.failure(Throwable("Can't find display with displayId is ${request.displayId}")))
      }
    } catch (e: Throwable) {
      callback(Result.failure(e))
    }
  }

  override fun removeDisplay(tag: String, callback: (Result<Boolean>) -> Unit) {
    try {
      if (activeDisplays.containsKey(tag)){
        activeDisplays[tag]?.dismiss()
        activeDisplays.remove(tag)
        callback(Result.success(true))}
      else {
        callback(Result.failure(Throwable("Don't find display with tag: $tag")))
      }
    } catch (e: Throwable) {
      callback(Result.failure(e))
    }
  }

  override fun createVirtualDisplay(
    request: CreateVirtualDisplayRequest,
    callback: (Result<Boolean>) -> Unit
  ) {
    try {
      if (activeDisplays.containsKey(request.tag)) {
        activeDisplays[request.tag]?.dismiss()
        activeDisplays.remove(request.tag)
        FlutterEngineCache.getInstance().get(request.tag)?.destroy()
        FlutterEngineCache.getInstance().remove(request.tag)

      }
      val display = displayManager?.createVirtualDisplay(request.tag, request.width.toInt(), request.height.toInt(), request.dpi.toInt(), null, DisplayManager.VIRTUAL_DISPLAY_FLAG_PRESENTATION,)
      if (display != null) {
        val flutterEngine = createFlutterEngine(request.entryPointFunctionName, request.tag)
        flutterEngine?.let {
//          flutterEngineChannel = MethodChannel(
//            it.dartExecutor.binaryMessenger,
//            "${viewTypeId}_engine"
//          )
          val newDisplay =
            ActiveVirtualDisplay(context, request.tag, display)
          newDisplay.show()
          activeVirtualDisplays[request.tag] = newDisplay
          callback(Result.success(true))
        } ?: callback(Result.failure(Throwable("Can't find FlutterEngine")))
      } else {
        callback(Result.failure(Throwable("Can't create virtual display with tag is ${request.tag}")))
      }
    } catch (e: Throwable) {
      callback(Result.failure(e))
    }
  }

  private fun createFlutterEngine(entryPointFunctionName: String, tag: String): FlutterEngine? {
    if (FlutterEngineCache.getInstance().get(tag) == null) {
      val flutterEngine = FlutterEngine(context)
      FlutterInjector.instance().flutterLoader().startInitialization(context)
      val path = FlutterInjector.instance().flutterLoader().findAppBundlePath();
      val entrypoint = DartExecutor.DartEntrypoint(
        path,
        entryPointFunctionName
      )
      flutterEngine.dartExecutor.executeDartEntrypoint(entrypoint, mutableListOf(tag, tag, tag))
      flutterEngine.lifecycleChannel.appIsResumed()
      FlutterEngineCache.getInstance().put(tag, flutterEngine)
    }
    return FlutterEngineCache.getInstance().get(tag)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.context = binding.activity
    this.displayManager = context.getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.context = binding.activity
    this.displayManager = context.getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
  }

  override fun onDetachedFromActivity() {
    displayManager = null
  }
}
