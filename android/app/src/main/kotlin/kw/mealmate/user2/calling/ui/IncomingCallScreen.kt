package kw.mealmate.user2.calling.ui

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.LayoutDirection
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kw.mealmate.user2.R
import kw.mealmate.user2.calling.CallerDisplay

@Composable
fun IncomingCallScreen(
    callerDisplay: CallerDisplay?,
    onAnswer: () -> Unit,
    onDecline: () -> Unit
) {
    CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Rtl) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(CallBackground)
                .statusBarsPadding()
                .navigationBarsPadding()
        ) {
            // Calling Background Doodle Decoration matching Figma 3056:13617
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
                        text = "مكالمة واردة",
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
                }

                Spacer(modifier = Modifier.weight(1f))

                // Concentric Ripple Rings with Driver Avatar (Figma exact: Avatar 133dp, Rings up to 258dp)
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

                // Spacing below the rings to place Driver Name cleanly outside the circles
                Spacer(modifier = Modifier.height(16.dp))

                val displayName = if (!callerDisplay?.callerName.isNullOrBlank()) {
                    callerDisplay.callerName
                } else {
                    "محمد علي"
                }

                Text(
                    text = displayName,
                    fontSize = 28.sp,
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

                // Driver Role Badge matching Figma
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

                Spacer(modifier = Modifier.height(8.dp))

                Text(
                    text = "يتصل الآن...",
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Normal,
                    fontFamily = Alexandria,
                    color = CallSubtitleGrey,
                    textAlign = TextAlign.Center
                )

                Spacer(modifier = Modifier.weight(1.2f))

                // Action Buttons: Accept on right (first in RTL), Decline on left (second in RTL)
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(bottom = 36.dp),
                    horizontalArrangement = Arrangement.SpaceEvenly,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    // Accept Button (Right in RTL)
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        modifier = Modifier.clickable(
                            interactionSource = remember { MutableInteractionSource() },
                            indication = null,
                            onClick = onAnswer
                        )
                    ) {
                        Box(
                            modifier = Modifier
                                .size(86.dp)
                                .clip(CircleShape)
                                .background(CallAcceptGreen),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                painter = painterResource(id = R.drawable.ic_call_accept),
                                contentDescription = "قبول",
                                modifier = Modifier.size(42.dp),
                                tint = Color.White
                            )
                        }
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "قبول",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            fontFamily = Alexandria,
                            color = CallAcceptGreen
                        )
                    }

                    // Decline Button (Left in RTL)
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        modifier = Modifier.clickable(
                            interactionSource = remember { MutableInteractionSource() },
                            indication = null,
                            onClick = onDecline
                        )
                    ) {
                        Box(
                            modifier = Modifier
                                .size(86.dp)
                                .clip(CircleShape)
                                .background(CallDeclineRed),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                painter = painterResource(id = R.drawable.ic_call_end),
                                contentDescription = "رفض",
                                modifier = Modifier.size(42.dp),
                                tint = Color.White
                            )
                        }
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "رفض",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            fontFamily = Alexandria,
                            color = CallDeclineRed
                        )
                    }
                }
            }
        }
    }
}
