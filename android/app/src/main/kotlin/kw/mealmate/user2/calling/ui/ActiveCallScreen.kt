package kw.mealmate.user2.calling.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.delay
import kw.mealmate.user2.R
import kw.mealmate.user2.calling.CallerDisplay

@Composable
fun ActiveCallScreen(
    callerDisplay: CallerDisplay?,
    elapsedSeconds: Int,
    isMuted: Boolean,
    isSpeaker: Boolean,
    onToggleMute: () -> Unit,
    onToggleSpeaker: () -> Unit,
    onEndCall: () -> Unit
) {
    // Problem 2: Ensure local counter ticks smoothly every second without jumping
    var currentElapsed by remember { mutableIntStateOf(elapsedSeconds) }

    LaunchedEffect(elapsedSeconds) {
        if (elapsedSeconds > currentElapsed || (currentElapsed - elapsedSeconds) > 2) {
            currentElapsed = elapsedSeconds
        }
    }

    LaunchedEffect(Unit) {
        while (true) {
            delay(1000L)
            currentElapsed++
        }
    }

    val minutes = currentElapsed / 60
    val seconds = currentElapsed % 60
    val timeFormatted = String.format("%02d:%02d", minutes, seconds)

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(CallBackground)
            .statusBarsPadding()
            .navigationBarsPadding(),
        contentAlignment = Alignment.TopCenter
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 24.dp, vertical = 16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            // Header Brand
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier.fillMaxWidth()
            ) {
                Icon(
                    painter = painterResource(id = R.drawable.ic_mealmate_logo),
                    contentDescription = "MealMate Logo",
                    modifier = Modifier.size(width = 63.dp, height = 62.dp),
                    tint = Color.Unspecified
                )

                Spacer(modifier = Modifier.height(10.dp))

                Text(
                    text = "مكالمة جارية",
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Medium,
                    color = CallBrandGreen
                )

                Spacer(modifier = Modifier.height(4.dp))

                Text(
                    text = "MealMate",
                    fontSize = 22.sp,
                    fontWeight = FontWeight.Bold,
                    color = CallBrandDarkGreen
                )

                Spacer(modifier = Modifier.height(4.dp))

                Text(
                    text = timeFormatted,
                    fontSize = 13.sp,
                    fontWeight = FontWeight.Medium,
                    color = CallBrandGreen
                )
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Concentric Rings and Avatar
            Box(
                modifier = Modifier.size(258.dp),
                contentAlignment = Alignment.Center
            ) {
                // Ripple 4
                Box(
                    modifier = Modifier
                        .size(258.dp)
                        .border(1.dp, CallRippleStroke, CircleShape)
                )
                // Ripple 3
                Box(
                    modifier = Modifier
                        .size(222.dp)
                        .border(1.dp, CallRippleStroke, CircleShape)
                )
                // Ripple 2
                Box(
                    modifier = Modifier
                        .size(203.dp)
                        .border(1.dp, CallRippleStroke, CircleShape)
                )
                // Ripple 1
                Box(
                    modifier = Modifier
                        .size(169.dp)
                        .border(1.dp, CallRippleStroke, CircleShape)
                )
                // Inner Avatar Circle
                Box(
                    modifier = Modifier
                        .size(133.dp)
                        .clip(CircleShape)
                        .background(CallActionBackground),
                    contentAlignment = Alignment.Center
                ) {
                    val initialLetter = (callerDisplay?.callerName?.trim()?.take(1) ?: "D").uppercase()
                    Text(
                        text = initialLetter,
                        fontSize = 54.sp,
                        fontWeight = FontWeight.Bold,
                        color = CallActionIcon
                    )
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Driver Name & Role Badge
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier.fillMaxWidth()
            ) {
                val displayName = if (!callerDisplay?.callerName.isNullOrBlank()) {
                    callerDisplay!!.callerName
                } else {
                    "يحيى سواق"
                }

                Text(
                    text = displayName,
                    fontSize = 26.sp,
                    fontWeight = FontWeight.Bold,
                    color = CallDriverNameGreen,
                    textAlign = TextAlign.Center
                )

                Spacer(modifier = Modifier.height(8.dp))

                val displayRole = if (!callerDisplay?.callerRole.isNullOrBlank()) {
                    callerDisplay!!.callerRole!!
                } else {
                    "سائق التوصيل"
                }

                Row(
                    modifier = Modifier
                        .clip(RoundedCornerShape(18.dp))
                        .background(CallBadgeBackground)
                        .padding(horizontal = 16.dp, vertical = 8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_call_driver_badge),
                        contentDescription = null,
                        modifier = Modifier.size(20.dp),
                        tint = CallBadgeIcon
                    )
                    Spacer(modifier = Modifier.width(6.dp))
                    Text(
                        text = displayRole,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Bold,
                        color = CallBadgeText
                    )
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Address / Delivery Card
            Card(
                modifier = Modifier
                    .width(304.dp)
                    .shadow(elevation = 3.dp, shape = RoundedCornerShape(17.dp)),
                shape = RoundedCornerShape(17.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White),
                border = androidx.compose.foundation.BorderStroke(1.dp, CallCardBorder)
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 12.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = "طلب توصيل",
                            fontSize = 12.sp,
                            fontWeight = FontWeight.SemiBold,
                            color = CallActionIcon
                        )
                        Spacer(modifier = Modifier.width(6.dp))
                        Icon(
                            painter = painterResource(id = R.drawable.ic_call_location_pin),
                            contentDescription = null,
                            modifier = Modifier.size(15.dp),
                            tint = CallActionIcon
                        )
                    }
                    Spacer(modifier = Modifier.height(4.dp))
                    val orderDetails = if (!callerDisplay?.orderNumber.isNullOrBlank()) {
                        "طلب رقم #${callerDisplay!!.orderNumber}"
                    } else {
                        "طلب توصيل وجبة نشط"
                    }
                    Text(
                        text = orderDetails,
                        fontSize = 13.sp,
                        color = CallTextPrimary,
                        textAlign = TextAlign.Center
                    )
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Action Controls
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier.fillMaxWidth()
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.Center,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    // Mute Button
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        modifier = Modifier
                            .clip(RoundedCornerShape(12.dp))
                            .clickable(onClick = onToggleMute)
                            .padding(8.dp)
                    ) {
                        Box(
                            modifier = Modifier
                                .size(66.dp)
                                .clip(CircleShape)
                                .background(if (isMuted) CallActionIcon else CallActionBackground),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                painter = painterResource(id = R.drawable.ic_call_mic_mute),
                                contentDescription = "كتم المايك",
                                modifier = Modifier.size(28.dp),
                                tint = if (isMuted) Color.White else CallActionIcon
                            )
                        }
                        Spacer(modifier = Modifier.height(6.dp))
                        Text(
                            text = if (isMuted) "المايك مغلق" else "كتم المايك",
                            fontSize = 11.sp,
                            color = CallTextPrimary
                        )
                    }

                    Spacer(modifier = Modifier.width(40.dp))

                    // Speaker Button
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        modifier = Modifier
                            .clip(RoundedCornerShape(12.dp))
                            .clickable(onClick = onToggleSpeaker)
                            .padding(8.dp)
                    ) {
                        Box(
                            modifier = Modifier
                                .size(66.dp)
                                .clip(CircleShape)
                                .background(if (isSpeaker) CallActionIcon else CallActionBackground),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                painter = painterResource(id = R.drawable.ic_call_speaker),
                                contentDescription = "مكبر الصوت",
                                modifier = Modifier.size(28.dp),
                                tint = if (isSpeaker) Color.White else CallActionIcon
                            )
                        }
                        Spacer(modifier = Modifier.height(6.dp))
                        Text(
                            text = if (isSpeaker) "المكبر يعمل" else "مكبر الصوت",
                            fontSize = 11.sp,
                            color = CallTextPrimary
                        )
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                // End Call Button
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    modifier = Modifier
                        .clip(RoundedCornerShape(16.dp))
                        .clickable(onClick = onEndCall)
                        .padding(8.dp)
                ) {
                    Box(
                        modifier = Modifier
                            .size(83.dp)
                            .shadow(elevation = 6.dp, shape = CircleShape)
                            .clip(CircleShape)
                            .background(CallEndRed),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            painter = painterResource(id = R.drawable.ic_call_end),
                            contentDescription = "إنهاء المكالمة",
                            modifier = Modifier.size(36.dp),
                            tint = Color.White
                        )
                    }
                    Spacer(modifier = Modifier.height(6.dp))
                    Text(
                        text = "إنهاء المكالمة",
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Medium,
                        color = CallEndRed
                    )
                }
            }
        }
    }
}
