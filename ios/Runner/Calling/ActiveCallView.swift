import SwiftUI
import Combine

public struct ActiveCallView: View {
    public let callerDisplay: CallerDisplay?
    @State public var elapsedSeconds: Int
    @State public var isMuted: BooleanLiteralType
    @State public var isSpeaker: BooleanLiteralType
    public let onToggleMute: () -> Void
    public let onToggleSpeaker: () -> Void
    public let onEndCall: () -> Void

    @State private var timerSubscription: Cancellable?

    // Color Palette matching Flutter
    private let callBrandGreen = Color(red: 33/255, green: 130/255, blue: 50/255)
    private let callBrandDarkGreen = Color(red: 18/255, green: 85/255, blue: 25/255)
    private let callDriverNameGreen = Color(red: 7/255, green: 136/255, blue: 71/255)
    private let callBadgeBackground = Color(red: 233/255, green: 242/255, blue: 237/255)
    private let callBadgeText = Color(red: 35/255, green: 82/255, blue: 52/255)
    private let callBadgeIcon = Color(red: 1/255, green: 153/255, blue: 77/255)
    private let callEndRed = Color(red: 237/255, green: 54/255, blue: 61/255)
    private let callActionBackground = Color(red: 219/255, green: 237/255, blue: 225/255)
    private let callActionIcon = Color(red: 27/255, green: 142/255, blue: 47/255)
    private let callRippleStroke = Color(red: 234/255, green: 243/255, blue: 238/255)
    private let callCardBorder = Color(red: 222/255, green: 222/255, blue: 222/255)

    public init(
        callerDisplay: CallerDisplay?,
        elapsedSeconds: Int,
        isMuted: Bool,
        isSpeaker: Bool,
        onToggleMute: @escaping () -> Void,
        onToggleSpeaker: @escaping () -> Void,
        onEndCall: @escaping () -> Void
    ) {
        self.callerDisplay = callerDisplay
        self._elapsedSeconds = State(initialValue: elapsedSeconds)
        self._isMuted = State(initialValue: isMuted)
        self._isSpeaker = State(initialValue: isSpeaker)
        self.onToggleMute = onToggleMute
        self.onToggleSpeaker = onToggleSpeaker
        self.onEndCall = onEndCall
    }

    private var timeFormatted: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    public var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header Brand
                    VStack(spacing: 6) {
                        Image(systemName: "fork.knife.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 58, height: 58)
                            .foregroundColor(callActionIcon)

                        Text("مكالمة جارية")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(callBrandGreen)

                        Text("MealMate")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(callBrandDarkGreen)

                        Text(timeFormatted)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(callBrandGreen)
                    }
                    .padding(.top, 16)

                    // Concentric Rings and Avatar
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

                        Circle()
                            .fill(callActionBackground)
                            .frame(width: 133, height: 133)

                        let initialLetter = String((callerDisplay?.callerName.trimmingCharacters(in: .whitespacesAndNewlines).first ?? "D")).uppercased()
                        Text(initialLetter)
                            .font(.system(size: 54, weight: .bold))
                            .foregroundColor(callActionIcon)
                    }
                    .frame(height: 258)

                    // Driver Name & Role Badge
                    VStack(spacing: 8) {
                        Text(callerDisplay?.callerName ?? "يحيى سواق")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(callDriverNameGreen)
                            .multilineTextAlignment(.center)

                        HStack(spacing: 6) {
                            Image(systemName: "person.crop.circle.badge.checkmark")
                                .font(.system(size: 16))
                                .foregroundColor(callBadgeIcon)

                            Text(callerDisplay?.callerRole ?? "سائق التوصيل")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(callBadgeText)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(callBadgeBackground)
                        .clipShape(Capsule())
                    }

                    // Delivery / Order Card
                    VStack(spacing: 6) {
                        HStack(spacing: 6) {
                            Text("طلب توصيل")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(callActionIcon)

                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 13))
                                .foregroundColor(callActionIcon)
                        }

                        let orderDetails = (callerDisplay?.orderNumber?.isEmpty == false) ? "طلب رقم #\(callerDisplay!.orderNumber!)" : "مبنى 12، شارع فهد الأحمد، الكويت"
                        Text(orderDetails)
                            .font(.system(size: 13))
                            .foregroundColor(Color(red: 23/255, green: 21/255, blue: 28/255))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(width: 304)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 17))
                    .overlay(
                        RoundedRectangle(cornerRadius: 17)
                            .stroke(callCardBorder, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)

                    // Action Buttons
                    VStack(spacing: 16) {
                        HStack(spacing: 40) {
                            // Mute Button
                            Button(action: {
                                isMuted.toggle()
                                onToggleMute()
                            }) {
                                VStack(spacing: 6) {
                                    ZStack {
                                        Circle()
                                            .fill(isMuted ? callActionIcon : callActionBackground)
                                            .frame(width: 66, height: 66)

                                        Image(systemName: isMuted ? "mic.slash.fill" : "mic.fill")
                                            .font(.system(size: 26))
                                            .foregroundColor(isMuted ? .white : callActionIcon)
                                    }

                                    Text(isMuted ? "المايك مغلق" : "كتم المايك")
                                        .font(.system(size: 11))
                                        .foregroundColor(Color.black)
                                }
                            }

                            // Speaker Button
                            Button(action: {
                                isSpeaker.toggle()
                                onToggleSpeaker()
                            }) {
                                VStack(spacing: 6) {
                                    ZStack {
                                        Circle()
                                            .fill(isSpeaker ? callActionIcon : callActionBackground)
                                            .frame(width: 66, height: 66)

                                        Image(systemName: isSpeaker ? "speaker.wave.3.fill" : "speaker.wave.2")
                                            .font(.system(size: 26))
                                            .foregroundColor(isSpeaker ? .white : callActionIcon)
                                    }

                                    Text(isSpeaker ? "المكبر يعمل" : "مكبر الصوت")
                                        .font(.system(size: 11))
                                        .foregroundColor(Color.black)
                                }
                            }
                        }

                        // End Call Button
                        Button(action: onEndCall) {
                            VStack(spacing: 6) {
                                ZStack {
                                    Circle()
                                        .fill(callEndRed)
                                        .frame(width: 83, height: 83)
                                        .shadow(color: callEndRed.opacity(0.35), radius: 8, x: 0, y: 4)

                                    Image(systemName: "phone.down.fill")
                                        .font(.system(size: 34))
                                        .foregroundColor(.white)
                                }

                                Text("إنهاء المكالمة")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(callEndRed)
                            }
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 24)
            }
        }
        .onAppear {
            // Problem 2: Live second-by-second ticker
            timerSubscription = Timer.publish(every: 1.0, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    self.elapsedSeconds += 1
                }
        }
        .onDisappear {
            timerSubscription?.cancel()
        }
    }
}
