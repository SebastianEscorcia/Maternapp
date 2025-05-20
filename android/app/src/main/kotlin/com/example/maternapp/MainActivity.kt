package com.example.maternapp

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.Wearable

class MainActivity : FlutterActivity(), MessageClient.OnMessageReceivedListener {
    private val CHANNEL = "com.example.watch/wearable"

override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
        when (call.method) {
            "sendMessage" -> {
                val message = call.argument<String>("message")
                if (message != null) {
                    sendMessageToWearable(message)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "Message is null", null)
                }
            }
            "getConnectedNodes" -> {
                getConnectedNodes(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Wearable.getMessageClient(this).addListener(this)
    }

    override fun onDestroy() {
        super.onDestroy()
        Wearable.getMessageClient(this).removeListener(this)
    }

    override fun onMessageReceived(messageEvent: MessageEvent) {
        if (messageEvent.path == "/message") {
            val message = String(messageEvent.data)
            val binaryMessenger = flutterEngine?.dartExecutor?.binaryMessenger
            if (binaryMessenger != null) {
                MethodChannel(binaryMessenger, CHANNEL).invokeMethod(
                    "onMessageReceived",
                    message
                )
            } else {
                android.util.Log.e("Wearable", "BinaryMessenger is null, cannot send message to Flutter")
            }
        }
    }

    private fun sendMessageToWearable(message: String) {
        val nodeClient = Wearable.getNodeClient(this)
        val messageClient = Wearable.getMessageClient(this)

        nodeClient.connectedNodes.addOnSuccessListener { nodes ->
            for (node in nodes) {
                messageClient.sendMessage(node.id, "/message", message.toByteArray())
                    .addOnSuccessListener {
                          android.util.Log.d(
                            "Wearable",
                            "Message sent successfully to nodeId=${node.id}, nodeName=${node.displayName}"
                        )
                    }
                    .addOnFailureListener {
                      android.util.Log.e(
                           "Wearable",
                           "Failed to send message to nodeId=${node.id}, nodeName=${node.displayName}",it
                         )
                    }
            }
        }
    }

    private fun getConnectedNodes(result: MethodChannel.Result) {
        val nodeClient = Wearable.getNodeClient(this)
        nodeClient.connectedNodes.addOnSuccessListener { nodes ->
            val nodeList = nodes.map { node ->
                mapOf(
                    "id" to node.id,
                    "displayName" to node.displayName
                )
            }
            result.success(nodeList)
        }.addOnFailureListener { e ->
            result.error("NODE_ERROR", "Failed to get connected nodes: ${e.message}", null)
        }
    }


}