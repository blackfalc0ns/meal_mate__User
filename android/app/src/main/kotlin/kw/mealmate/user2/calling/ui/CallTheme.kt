package kw.mealmate.user2.calling.ui

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import kw.mealmate.user2.R

val Alexandria = FontFamily(
    Font(R.font.alexandria_regular, FontWeight.Normal),
    Font(R.font.alexandria_medium, FontWeight.Medium),
    Font(R.font.alexandria_semibold, FontWeight.SemiBold),
    Font(R.font.alexandria_bold, FontWeight.Bold)
)

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

private val CallTypography = Typography(
    bodyLarge = TextStyle(fontFamily = Alexandria),
    bodyMedium = TextStyle(fontFamily = Alexandria),
    bodySmall = TextStyle(fontFamily = Alexandria),
    titleLarge = TextStyle(fontFamily = Alexandria),
    titleMedium = TextStyle(fontFamily = Alexandria),
    titleSmall = TextStyle(fontFamily = Alexandria),
    labelLarge = TextStyle(fontFamily = Alexandria),
    labelMedium = TextStyle(fontFamily = Alexandria),
    labelSmall = TextStyle(fontFamily = Alexandria)
)

@Composable
fun CallTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = CallColorScheme,
        typography = CallTypography,
        content = content
    )
}

