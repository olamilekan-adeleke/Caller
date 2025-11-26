//
//  CallerApp.swift
//  Caller
//
//  Created by Kod Enigma on 23/10/2024.
//

import SwiftUI



enum SamaCarbonateColorTheme {
    static let primaryOrange = Color("primaryOrange")
    static let primaryRedColor = Color("primaryRedColor")
    static let darkBlueBackgroundColor = Color("darkBlueBackgroundColor")
    static let primaryBlue = Color("primaryBlue")
    static let primaryDarkBlue = Color("primaryDarkBlue")
    static let disabledTextColor = Color("disabledTextColor")
    static let primaryTextColor = Color("primaryTextColor")
    static let textViewBackgroundColor = Color("textViewBackgroundColor")
    static let blueBackgroundColor = Color("blueBackgroundColor")
    static let greyBorderColor = Color("greyBorderColor")
    static let greyBackgroundColor = Color("greyBackgroundColor")
    static let altYellow = Color("altYellow")
    static let navyBlue = Color("navyBlue")
    static let primaryGreenColor = Color("primaryGreenColor")
    static let primaryGrey = Color("primaryGrey")
    static let disabledButtons = Color("disabledButtons")
    static let greyBlueBackgroundColor = Color("greyBlueBackgroundColor")
    static let primaryGreen = Color("primaryGreen")
    static let inactiveGray = Color("inactiveGray")
}


extension String {
    func localized() -> String {
        // We force what we previously found from API
        if let appLanguage = AppLanguageManager.shared.currentLanguageSet(),
           let langPath = Bundle.main.path(forResource: appLanguage, ofType: "lproj"),
           let bundle = Bundle(path: langPath) {
            return bundle.localizedString(forKey: self, value: "", table: nil)
        }
        return NSLocalizedString(self, comment: "")
    }
}

enum CustomFont: String {
    case foundersGroteskBold = "FoundersGrotesk-Bold"
    case foundersGroteskLight = "FoundersGrotesk-Light"
    case foundersGroteskMedium = "FoundersGrotesk-Medium"
    case foundersGroteskRegular = "FoundersGrotesk-Regular"
    case foundersGroteskSemibold = "FoundersGrotesk-Semibold"
}

extension UIFont {
    static func custom(type: CustomFont, size: CGFloat) -> UIFont {
        UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}


@main
struct CallerApp: App {
    var body: some Scene {
        WindowGroup {
            ProfileView()
        }
    }
}


enum SamaCarbonateSpacing {
    /// Size 10
    static let xxSmall: CGFloat = 10
    /// Size 20
    static let xSmall: CGFloat = 20
    /// Size 30
    static let small: CGFloat = 30
    
    static let medium: CGFloat = 45
}


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}



/// Naming convenstion is Size + Weight
enum SamaCarbonateFontLibrary {
    enum Title {
        /// 30pt Bold
        static let xtralargeBold = Font.system(size: SamaCarbonateSize.Text.xLarge, weight: .bold)
        /// 30pt regular
        static let xtralargeMedium = Font.system(size: SamaCarbonateSize.Text.xLarge, weight: .medium)
        
        static let bigMedium = Font.system(size: SamaCarbonateSize.Text.xLarge, weight: .medium)
        /// 17pt Bold
        static let largeBold = Font.system(size: SamaCarbonateSize.Text.large, weight: .bold)
        /// 17pt  regular
        static let regularBold = Font.system(size: SamaCarbonateSize.Text.regular, weight: .bold)
        /// 17pt Medium
        static let regularMedium = Font.system(size: SamaCarbonateSize.Text.regular, weight: .medium)
        /// 15pt Bold
        static let smallBold = Font.system(size: SamaCarbonateSize.Text.small, weight: .bold)
    }

    enum Body {
        /// 17pt Regular
        static let large = Font.system(size: SamaCarbonateSize.Text.large)
        /// 15pt Regular
        static let medium = Font.system(size: SamaCarbonateSize.Text.regular)
        /// 13pt Regular
        static let small = Font.system(size: SamaCarbonateSize.Text.small)
        /// 17pt  regular
        static let regularBold = Font.system(size: SamaCarbonateSize.Text.regular, weight: .bold)
    }

    enum Button {
        /// 17pt Semibold
        static let boldPrimary = Font.system(size: SamaCarbonateSize.Text.regular, weight: .semibold)
        static let primary = Font.system(size: SamaCarbonateSize.Text.regular, weight: .regular)
        /// 15pt Medium
        static let secondary = Font.system(size: SamaCarbonateSize.Text.small, weight: .regular)
    }

    enum Caption {
        static let small = Font.system(size: SamaCarbonateSize.Text.caption, weight: .medium)
        static let smallBold = Font.system(size: SamaCarbonateSize.Text.caption, weight: .bold)
        /// 13pt Regular
        static let regular = Font.system(size: SamaCarbonateSize.Text.xSmall)
        /// 13pt Medium
        static let medium = Font.system(size: SamaCarbonateSize.Text.xSmall, weight: .medium)
    }
}


enum SamaCarbonateSize {
    enum Text {
        static let caption: CGFloat = 11
        static let xSmall: CGFloat = 13
        static let small: CGFloat = 15
        static let regular: CGFloat = 16
        static let large: CGFloat = 20
        static let xLarge: CGFloat = 30
    }
}

struct SamaButtonStyle: ButtonStyle {
    var enabledState = false
    var activeColor = Color.primaryOrange
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .center)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .background(enabledState ? activeColor : Color(UIColor.lightGray.withAlphaComponent(0.2)))
            .cornerRadius(40)
            .padding(10)
    }
}




struct LoadingView: View {
    var tintColor: Color
    
    init(tint: Color = SamaCarbonateColorTheme.primaryOrange) {
        tintColor = tint
    }
    
    var body: some View {
        Group {
            if #available(iOS 14.0, *) {
                // iOS 14+ uses ProgressView
                ProgressView("")
                    .progressViewStyle(CircularProgressViewStyle(
                        tint: tintColor
                    ))
            } else {
                // iOS 13 fallback
                VStack(spacing: 8) {
                    UIKitActivityIndicator(isAnimating: true, style: .large)
                    Text("")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// A SwiftUI wrapper for `UIActivityIndicatorView`.
struct UIKitActivityIndicator: UIViewRepresentable {
    var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.startAnimating() // Automatically start animating
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

#Preview {
    LoadingView()
}
