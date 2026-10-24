import SwiftUI

public struct IncomingCallView: View {
    public let callerDisplay: CallerDisplay?
    public let onAnswer: () -> Void
    public let onDecline: () -> Void

    // Color Palette matching Figma 3056:13617
    private let callBrandGreen = Color(red: 33/255, green: 130/255, blue: 50/255)
    private let callBrandDarkGreen = Color(red: 18/255, green: 85/255, blue: 25/255)
    private let callDriverNameGreen = Color(red: 7/255, green: 136/255, blue: 71/255)
    private let callBadgeBackground = Color(red: 233/255, green: 242/255, blue: 237/255)
    private let callBadgeText = Color(red: 35/255, green: 82/255, blue: 52/255)
    private let callBadgeIcon = Color(red: 1/255, green: 153/255, blue: 77/255)
    private let callSubtitleGrey = Color(red: 141/255, green: 139/255, blue: 141/255)
    private let callAcceptGreen = Color(red: 50/255, green: 149/255, blue: 72/255)
    private let callDeclineRed = Color(red: 240/255, green: 62/255, blue: 55/255)
    private let callRippleStroke = Color(red: 234/255, green: 243/255, blue: 238/255)

    public init(
        callerDisplay: CallerDisplay?,
        onAnswer: @escaping () -> Void,
        onDecline: @escaping () -> Void
    ) {
        self.callerDisplay = callerDisplay
        self.onAnswer = onAnswer
        self.onDecline = onDecline
    }

    public var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            // Background Doodle Decoration matching Figma 3056:13617
            VStack {
                Spacer()
                HStack {
                    Image("CallingBgDoodle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 546, height: 221)
                        .opacity(0.35)
                        .offset(x: -88, y: -20)
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                Spacer().frame(height: 16)

                // Header Brand matching Figma 3056:13617
                VStack(spacing: 6) {
                    Image("MealMateLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 63, height: 62.4)

                    Text("مكالمة واردة")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(callBrandGreen)

                    Text("MealMate")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(callBrandDarkGreen)
                }

                Spacer()

                // Concentric Ripple Rings and Avatar (Figma exact layout: Rings up to 258, Avatar 133)
                ZStack {
                    Circle()
                        .stroke(callRippleStroke, lineWidth: 1)
                        .frame(width: 258, height: 258)
                    Circle()
                        .stroke(callRippleStroke, lineWidth: 1)
                        .frame(width: 222, height: 222)
                    Circle()
                        .stroke(callRippleStroke, lineWidth: 1)
                        .frame(width: 203, height: 203)
                    Circle()
                        .stroke(callRippleStroke, lineWidth: 1)
                        .frame(width: 169, height: 169)

                    Image("DriverAvatar")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 133, height: 133)
                        .clipShape(Circle())
                }
                .frame(height: 258)

                Spacer().frame(height: 16)

                // Driver Name, Role Badge, and Subtitle
                VStack(spacing: 8) {
                    Text(callerDisplay?.callerName ?? "محمد علي")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(callDriverNameGreen)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 6) {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .font(.system(size: 16))
                            .foregroundColor(callBadgeIcon)

                        Text(callerDisplay?.callerRole ?? "مندوب التوصيل")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(callBadgeText)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(callBadgeBackground)
                    .clipShape(Capsule())

                    Text("يتصل الآن...")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(callSubtitleGrey)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                // Action Buttons: Accept on right, Decline on left in RTL
                HStack(spacing: 60) {
                    // Accept Button (Right in RTL)
                    Button(action: onAnswer) {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(callAcceptGreen)
                                    .frame(width: 86, height: 86)
                                    .shadow(color: callAcceptGreen.opacity(0.3), radius: 8, x: 0, y: 4)

                                Image(systemName: "phone.fill")
                                    .font(.system(size: 38))
                                    .foregroundColor(.white)
                            }

                            Text("قبول")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(callAcceptGreen)
                        }
                    }

                    // Decline Button (Left in RTL)
                    Button(action: onDecline) {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(callDeclineRed)
                                    .frame(width: 86, height: 86)
                                    .shadow(color: callDeclineRed.opacity(0.3), radius: 8, x: 0, y: 4)

                                Image(systemName: "phone.down.fill")
                                    .font(.system(size: 38))
                                    .foregroundColor(.white)
                            }

                            Text("رفض")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(callDeclineRed)
                        }
                    }
                }
                .environment(\.layoutDirection, .rightToLeft)
                .padding(.bottom, 48)
            }
            .padding(.horizontal, 24)
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}
