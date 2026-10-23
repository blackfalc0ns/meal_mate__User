package kw.mealmate.user2.calling

import android.content.ComponentName
import android.content.Context
import android.media.AudioManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.telecom.PhoneAccount
import android.telecom.PhoneAccountHandle
import android.telecom.TelecomManager

class TelecomCallController(private val context: Context) {
    private val telecomManager =
        context.getSystemService(Context.TELECOM_SERVICE) as? TelecomManager
    private val audioManager =
        context.getSystemService(Context.AUDIO_SERVICE) as? AudioManager

    private val phoneAccountHandle: PhoneAccountHandle? by lazy {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val component = ComponentName(context, context.packageName)
            PhoneAccountHandle(component, "mealmate_calling_account")
        } else null
    }

    init {
        registerPhoneAccount()
    }

    private fun registerPhoneAccount() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && telecomManager != null && phoneAccountHandle != null) {
            try {
                val account = PhoneAccount.builder(phoneAccountHandle, "MealMate")
                    .setCapabilities(PhoneAccount.CAPABILITY_SELF_MANAGED)
                    .setIcon(android.graphics.drawable.Icon.createWithResource(context, android.R.drawable.ic_menu_call))
                    .build()
                telecomManager.registerPhoneAccount(account)
            } catch (_: Exception) {}
        }
    }

    fun addIncomingCall(callId: String, callerName: String) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && telecomManager != null && phoneAccountHandle != null) {
            try {
                val extras = Bundle().apply {
                    putParcelable(TelecomManager.EXTRA_PHONE_ACCOUNT_HANDLE, phoneAccountHandle)
                    putParcelable(
                        TelecomManager.EXTRA_INCOMING_CALL_ADDRESS,
                        Uri.fromParts("tel", callerName, null)
                    )
                    putString("callId", callId)
                }
                telecomManager.addNewIncomingCall(phoneAccountHandle, extras)
            } catch (_: Exception) {}
        }
    }

    fun setAudioRoute(routeId: String) {
        audioManager?.let { am ->
            when (routeId.lowercase()) {
                "speaker" -> {
                    am.isSpeakerphoneOn = true
                }
                "earpiece" -> {
                    am.isSpeakerphoneOn = false
                }
                "bluetooth" -> {
                    am.startBluetoothSco()
                    am.isBluetoothScoOn = true
                }
                else -> {}
            }
        }
    }

    fun disconnect(callId: String?) {
        audioManager?.let { am ->
            if (am.isBluetoothScoOn) {
                am.stopBluetoothSco()
                am.isBluetoothScoOn = false
            }
            am.isSpeakerphoneOn = false
        }
    }
}
