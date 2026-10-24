package kw.mealmate.user2.calling.ui

import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
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
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.LayoutDirection
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

    CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Rtl) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(CallBackground)
                .statusBarsPadding()
                .navigationBarsPadding()
        ) {
            // Calling Background Doodle Decoration matching Figma 3056:13662
            Image(
                painter = painterResource(id = R.drawable.ic_calling_bg_doodle),
                contentDescription = null,
                modifier = Modifier
                    .align(Alignment.BottomStart)
                    .offset(x = (-88).dp, y = (-20).dp)
                    .size(width = 546.dp, height = 221.dp)
                    .alpha(0.35f),
                contentScale = ContentScale.Fit
            )

            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .verticalScroll(rememberScrollState())
                    .padding(horizontal = 24.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Spacer(modifier = Modifier.height(16.dp))

                // CallingHeaderBrand matching Figma
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_mealmate_logo),
                        contentDescription = "MealMate Logo",
                        modifier = Modifier.size(width = 63.dp, height = 62.4.dp),
                        tint = Color.Unspecified
                    )

                    Spacer(modifier = Modifier.height(8.dp))

                    Text(
                        text = "مكالمة جارية",
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Medium,
                        fontFamily = Alexandria,
                        color = CallBrandGreen,
                        textAlign = TextAlign.Center
                    )

                    Spacer(modifier = Modifier.height(4.dp))

                    Text(
                        text = "MealMate",
                        fontSize = 22.sp,
                        fontWeight = FontWeight.Bold,
                        fontFamily = Alexandria,
                        color = CallBrandDarkGreen,
                        textAlign = TextAlign.Center
                    )

                    Spacer(modifier = Modifier.height(4.dp))

                    Text(
                        text = timeFormatted,
                        fontSize = 13.sp,
                        fontWeight = FontWeight.Medium,
                        fontFamily = Alexandria,
                        color = CallBrandGreen,
                        textAlign = TextAlign.Center
                    )
                }

                Spacer(modifier = Modifier.height(20.dp))

                // Concentric Rings with Driver Avatar (Figma exact)
                Box(
                    modifier = Modifier.size(258.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Box(
                        modifier = Modifier
                            .size(258.dp)
                            .border(1.dp, CallRippleStroke, CircleShape)
                    )
                    Box(
                        modifier = Modifier
                            .size(222.dp)
                            .border(1.dp, CallRippleStroke, CircleShape)
                    )
                    Box(
                        modifier = Modifier
                            .size(203.dp)
                            .border(1.dp, CallRippleStroke, CircleShape)
                    )
                    Box(
                        modifier = Modifier
                            .size(169.dp)
                            .border(1.dp, CallRippleStroke, CircleShape)
                    )
                    // Real Driver Avatar image from Figma
                    Image(
                        painter = painterResource(id = R.drawable.ic_call_driver_avatar_default),
                        contentDescription = "Driver Avatar",
                        modifier = Modifier
                            .size(133.dp)
                            .clip(CircleShape),
                        contentScale = ContentScale.Crop
                    )
                }

                Spacer(modifier = Modifier.height(16.dp))

                val displayName = if (!callerDisplay?.callerName.isNullOrBlank()) {
                    callerDisplay.callerName
                } else {
                    "محمد علي"
                }

                Text(
                    text = displayName,
                    fontSize = 26.sp,
                    fontWeight = FontWeight.Bold,
                    fontFamily = Alexandria,
                    color = CallDriverNameGreen,
                    textAlign = TextAlign.Center
                )

                Spacer(modifier = Modifier.height(6.dp))

                val displayRole = if (!callerDisplay?.callerRole.isNullOrBlank()) {
                    callerDisplay.callerRole
                } else {
                    "مندوب التوصيل"
                }

                // Role Badge matching Figma
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
                        modifier = Modifier.size(22.dp),
                        tint = CallBadgeIcon
                    )
                    Spacer(modifier = Modifier.width(6.dp))
                    Text(
                        text = displayRole,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Bold,
                        fontFamily = Alexandria,
                        color = CallBadgeText
                    )
                }

                Spacer(modifier = Modifier.height(16.dp))

                // Address Card matching Figma 3056:13662
                val addressTitle = if (!callerDisplay?.addressTitle.isNullOrBlank()) {
                    callerDisplay.addressTitle
                } else {
                    "عنوان التوصيل"
                }
                val deliveryAddress = if (!callerDisplay?.deliveryAddress.isNullOrBlank()) {
                    callerDisplay.deliveryAddress
                } else if (!callerDisplay?.orderNumber.isNullOrBlank()) {
                    "طلب رقم #${callerDisplay.orderNumber}"
                } else {
                    "الكويت، الروضة، قطعة 1، شارع 10، مبنى 5"
                }

                Card(
                    modifier = Modifier
                        .width(304.dp)
                        .defaultMinSize(minHeight = 100.dp)
                        .shadow(elevation = 3.dp, shape = RoundedCornerShape(17.dp)),
                    shape = RoundedCornerShape(17.dp),
                    colors = CardDefaults.cardColors(containerColor = Color.White),
                    border = androidx.compose.foundation.BorderStroke(1.dp, CallCardBorder)
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 16.dp, vertical = 10.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.Center
                        ) {
                            Text(
                                text = addressTitle,
                                fontSize = 12.sp,
                                fontWeight = FontWeight.SemiBold,
                                fontFamily = Alexandria,
                                color = CallActionIcon
                            )
                            Spacer(modifier = Modifier.width(4.dp))
                            Icon(
                                painter = painterResource(id = R.drawable.ic_call_location_pin),
                                contentDescription = null,
                                modifier = Modifier.size(15.dp),
                                tint = CallActionIcon
                            )
                        }

                        Spacer(modifier = Modifier.height(6.dp))

                        Text(
                            text = deliveryAddress,
                            fontSize = 13.sp,
                            fontWeight = FontWeight.Normal,
                            fontFamily = Alexandria,
                            color = CallTextPrimary,
                            textAlign = TextAlign.Center
                        )
                    }
                }

                Spacer(modifier = Modifier.height(24.dp))

                // Active Call Controls matching Figma 3056:13662
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(bottom = 28.dp)
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.Center,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        // Mute Button matching Figma
                        val muteBg by animateColorAsState(
                            targetValue = if (isMuted) CallActionIcon else CallActionBackground,
                            animationSpec = tween(200)
                        )
                        val muteIconTint by animateColorAsState(
                            targetValue = if (isMuted) Color.White else CallActionIcon,
                            animationSpec = tween(200)
                        )
                        Column(
                            horizontalAlignment = Alignment.CenterHorizontally,
                            modifier = Modifier.clickable(
                                interactionSource = remember { MutableInteractionSource() },
                                indication = null,
                                onClick = onToggleMute
                            )
                        ) {
                            Box(
                                modifier = Modifier
                                    .size(66.dp)
                                    .clip(CircleShape)
                                    .background(muteBg),
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(
                                    painter = painterResource(id = R.drawable.ic_call_mic_mute),
                                    contentDescription = "كتم المايك",
                                    modifier = Modifier.size(27.3.dp),
                                    tint = muteIconTint
                                )
                            }
                            Spacer(modifier = Modifier.height(4.dp))
                            Text(
                                text = if (isMuted) "المايك مغلق" else "كتم المايك",
                                fontSize = 10.sp,
                                fontWeight = FontWeight.Normal,
                                fontFamily = Alexandria,
                                color = Color.Black,
                                textAlign = TextAlign.Center
                            )
                        }

                        Spacer(modifier = Modifier.width(40.dp))

                        // Speaker Button matching Figma
                        val speakerBg by animateColorAsState(
                            targetValue = if (isSpeaker) CallActionIcon else CallActionBackground,
                            animationSpec = tween(200)
                        )
                        val speakerIconTint by animateColorAsState(
                            targetValue = if (isSpeaker) Color.White else CallActionIcon,
                            animationSpec = tween(200)
                        )
                        Column(
                            horizontalAlignment = Alignment.CenterHorizontally,
                            modifier = Modifier.clickable(
                                interactionSource = remember { MutableInteractionSource() },
                                indication = null,
                                onClick = onToggleSpeaker
                            )
                        ) {
                            Box(
                                modifier = Modifier
                                    .size(66.dp)
                                    .clip(CircleShape)
                                    .background(speakerBg),
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(
                                    painter = painterResource(id = R.drawable.ic_call_speaker),
                                    contentDescription = "مكبر الصوت",
                                    modifier = Modifier.size(27.3.dp),
                                    tint = speakerIconTint
                                )
                            }
                            Spacer(modifier = Modifier.height(4.dp))
                            Text(
                                text = if (isSpeaker) "المكبر يعمل" else "مكبر الصوت",
                                fontSize = 10.sp,
                                fontWeight = FontWeight.Normal,
                                fontFamily = Alexandria,
                                color = Color.Black,
                                textAlign = TextAlign.Center
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    // End Call Button matching Figma
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        modifier = Modifier.clickable(
                            interactionSource = remember { MutableInteractionSource() },
                            indication = null,
                            onClick = onEndCall
                        )
                    ) {
                        Box(
                            modifier = Modifier
                                .size(83.dp)
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
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            text = "إنهاء المكالمة",
                            fontSize = 11.sp,
                            fontWeight = FontWeight.Normal,
                            fontFamily = Alexandria,
                            color = CallEndRed,
                            textAlign = TextAlign.Center
                        )
                    }
                }
            }
        }
    }
}
