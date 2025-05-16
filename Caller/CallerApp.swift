//
//  CallerApp.swift
//  Caller
//
//  Created by Kod Enigma on 23/10/2024.
//

import SwiftUI

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
    }
    
    enum Button {
        /// 17pt Semibold
        static let boldPrimary = Font.system(size: SamaCarbonateSize.Text.regular, weight: .semibold)
        static let primary = Font.system(size: SamaCarbonateSize.Text.regular, weight: .regular)
        /// 15pt Medium
        static let secondary = Font.system(size: SamaCarbonateSize.Text.small, weight: .regular)
    }
    
    enum Caption {
        /// 13pt Regular
        static let regular = Font.system(size: SamaCarbonateSize.Text.xSmall)
        /// 13pt Medium
        static let medium = Font.system(size: SamaCarbonateSize.Text.xSmall, weight: .medium)
        /// 13pt Bold
        static let bold = Font.system(size: SamaCarbonateSize.Text.xSmall, weight: .bold)
    }
}


enum SamaCarbonateSize {
    enum Text {
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

