//
//  TextField.swift
//  Caller
//
//  Created by Kod Engima on 24/08/2025.
//

import SwiftUI

struct UnderlinedTextField: View {
    let placeholder: String
    let keyboardType: UIKeyboardType
    let padding: CGFloat
    let isSecureType: Bool
    @Binding var text: String
    @Binding var isFocused: Bool
    var onCommit: () -> Void = {}

    init(
        placeholder: String,
        keyboardType: UIKeyboardType,
        padding: CGFloat? = nil,
        isSecureType: Bool = false,
        text: Binding<String>,
        isFocused: Binding<Bool>,
        onCommit: @escaping () -> Void
    ) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.padding = padding ?? 18
        self.isSecureType = isSecureType
        self._text = text
        self._isFocused = isFocused
        self.onCommit = onCommit
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isSecureType {
                SecureField(placeholder, text: $text, onCommit: onCommit)
                    .font(Font(UIFont.custom(type: .foundersGroteskRegular, size: 18)))
                    .padding(padding)
                    .background(SamaCarbonateColorTheme.greyBlueBackgroundColor)
                    .keyboardType(keyboardType)
            } else {
                TextField(placeholder, text: $text, onEditingChanged: { isEditing in
                    // Update the binding when the focus state changes.
                    isFocused = isEditing
                }, onCommit: onCommit)
                .font(Font(UIFont.custom(type: .foundersGroteskRegular, size: 18)))
                .padding(padding)
                .background(SamaCarbonateColorTheme.greyBlueBackgroundColor)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .keyboardType(keyboardType)
            }

            // The underline's color changes based on the focus state.
            Rectangle()
                .frame(height: 1)
                .foregroundColor(isFocused ? SamaCarbonateColorTheme.primaryOrange : SamaCarbonateColorTheme.primaryGrey)
        }
    }
}

#Preview {
    @State var email: String = ""
    @State var isEmailFieldFocused: Bool = false

    UnderlinedTextField(
        placeholder: "Business email address",
        keyboardType: .emailAddress,
        text: $email,
        isFocused: $isEmailFieldFocused
    ) {
        print("is edited")
    }
}
