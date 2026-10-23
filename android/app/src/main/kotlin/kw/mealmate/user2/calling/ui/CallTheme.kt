package kw.mealmate.user2.calling.ui

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

val CallBrandGreen = Color(0xFF218232)
val CallBrandDarkGreen = Color(0xFF125519)
val CallDriverNameGreen = Color(0xFF078847)
val CallBadgeBackground = Color(0xFFE9F2ED)
val CallBadgeText = Color(0xFF235234)
val CallBadgeIcon = Color(0xFF01994D)
val CallSubtitleGrey = Color(0xFF8D8B8D)
val CallAcceptGreen = Color(0xFF329548)
val CallDeclineRed = Color(0xFFF03E37)
val CallEndRed = Color(0xFFED363D)
val CallActionBackground = Color(0xFFDBEDE1)
val CallActionIcon = Color(0xFF1B8E2F)
val CallRippleStroke = Color(0xFFEAF3EE)
val CallCardBorder = Color(0xFFDEDEDE)

val CallPrimary = CallBrandGreen
val CallBackground = Color(0xFFFFFFFF)
val CallSurface = Color(0xFFFFFFFF)
val CallTextPrimary = Color(0xFF17151C)
val CallTextSecondary = Color(0xFF878685)
val CallAnswerGreen = CallAcceptGreen

private val CallColorScheme = lightColorScheme(
    primary = CallBrandGreen,
    background = CallBackground,
    surface = CallSurface,
    onPrimary = Color.White,
    onBackground = CallTextPrimary,
    onSurface = CallTextPrimary
)

@Composable
fun CallTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = CallColorScheme,
        content = content
    )
}
