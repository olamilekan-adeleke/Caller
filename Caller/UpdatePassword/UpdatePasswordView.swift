// UpdatePasswordView.swift
//
// Created on 20/08/2025.
// Copyright (c) 2025 and Confidential to Sama All rights reserved.

import SwiftUI


enum Field: Hashable {
    case currentPassword
    case newPassword
    case retypePassword
    case none
}

extension Binding where Value: Equatable {
    func equals(_ value: Value) -> Binding<Bool> {
        Binding<Bool>(
            get: { self.wrappedValue == value },
            set: { isOn in
                if isOn {
                    self.wrappedValue = value
                } else if self.wrappedValue == value {
                    if let defaultValue = Value.self as? Field.Type {
                        self.wrappedValue = defaultValue.none as! Value
                    }
                }
            }
        )
    }
}

struct UpdatePasswordView: View {
    // MARK: - ViewModel
    @ObservedObject private var viewModel: UpdatePasswordViewModel
    @State private var focusedField: Field = .none

    private var continueButtonStyle: PrimaryButton.Style {
        if viewModel.isLoading {
            return .loading
        } else if viewModel.isContinueButtonEnabled {
            return .primary
        } else {
            return .disabled
        }
    }

    // MARK: - Initializer
    init(tokens: TokensMapper? = nil, comingFromAccount: Bool = false) {
        self.viewModel = UpdatePasswordViewModel(tokens: tokens, comingFromAccount: comingFromAccount)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Spacer(minLength: 10)

                VStack(alignment: .leading, spacing: 8) {
                    labeledTextField(
                        label: viewModel.currentPasswordLabelText,
                        placeholder: viewModel.currentPasswordPlaceholderText,
                        text: $viewModel.currentPassword,
                        focusField: .currentPassword,
                        nextFocus: .newPassword
                    )

                    
                    if let errorMessage = viewModel.currentPasswordError {
                        PasswordRequirementRow(text: errorMessage, infoType: .error)
                    }
                }
                
                // New Password Section
                VStack(alignment: .leading, spacing: 8) {
                    labeledTextField(
                        label: viewModel.newPasswordLabelText,
                        placeholder: viewModel.newPasswordPlaceholderText,
                        text: $viewModel.newPassword,
                        focusField: .newPassword,
                        nextFocus: .retypePassword
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        PasswordRequirementRow(text: viewModel.newPasswordUppercaseLabelText, isValid: viewModel.newPasswordHasUppercase)
                        PasswordRequirementRow(text: viewModel.newPasswordNumberLabelText, isValid: viewModel.newPasswordHasNumber)
                        PasswordRequirementRow(text: viewModel.newPasswordSpecialLabelText, isValid: viewModel.newPasswordHasSpecial)
                        PasswordRequirementRow(text: viewModel.newPasswordLengthLabelText, isValid: viewModel.newPasswordHasRequiredLength)
                    }.padding(.top, 8)
                }
                
                // Retype Password Section
                VStack(alignment: .leading, spacing: 8) {
                    labeledTextField(
                        label: viewModel.retypePasswordLabelText,
                        placeholder: viewModel.retypePasswordPlaceholderText,
                        text: $viewModel.retypePassword,
                        focusField: .retypePassword,
                        nextFocus: .none
                    )
                       
                    if let errorMessage = viewModel.retypePasswordError {
                        PasswordRequirementRow(text: errorMessage, infoType: .error)
                    }
                }
                
                Spacer(minLength: 10)
                
                PrimaryButton(title: viewModel.saveButtonText, style: continueButtonStyle) {
                    Task { await viewModel.continueAction() }
                }.padding(.bottom, 20)

            }.padding(.horizontal, 24)
        }
        .background(Color.white)
        .onTapGesture { viewModel.dismissKeyboard() }
        .onAppear { viewModel.onAppear() }
        .alert(item: $viewModel.alertInfo) { alertInfo in
            Alert(title: Text(alertInfo.title), message: Text(alertInfo.message))
        }
        .background(
            Group {
//                // Hidden navigation links for programmatic navigation
//                NavigationLink(
//                    destination: TabBarView(),
//                    isActive: .constant(viewModel.navigationDestination == .tabBar)
//                ) { EmptyView() }.hidden()
            }
        )
        .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
            if shouldDismiss { viewModel.resetNavigationState() }
        }
    }
    
    @ViewBuilder
    private func labeledTextField(label: String, placeholder: String, text: Binding<String>, focusField: Field, nextFocus: Field) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(Font(UIFont.custom(type: .foundersGroteskRegular, size: 16)))
                .foregroundColor(SamaCarbonateColorTheme.primaryTextColor)
            
            UnderlinedTextField(
                placeholder: placeholder,
                keyboardType: .default,
                isSecureType: true,
                text: text,
                isFocused: $focusedField.equals(focusField)
            ) { focusedField = nextFocus }
        }
    }
}

// MARK: - Supporting Views

struct PasswordRequirementRow: View {
    enum InfoType { case info, error, valid }
    
    let text: String
    let isValid: Bool
    let infoType: InfoType
    
    init(text: String, isValid: Bool = false, infoType: InfoType = .info) {
        self.text = text
        self.isValid = isValid
        self.infoType = infoType
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(uiImage: UIImage(named: isValid ? "check_box_turquoise_filled" : "exclamation_mark_orange_filled") ?? UIImage())
                .resizable()
                .frame(width: 16, height: 16)
            
            Text(text)
                .font(Font(UIFont.custom(type: .foundersGroteskRegular, size: 12)))
                .foregroundColor(getColor())
            
            Spacer()
        }
    }
    
    func getColor() -> Color {
        switch infoType {
        case .info: Color.gray
        case .error: Color.resilience
        case .valid: Color.primaryBlue
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        UpdatePasswordView()
    }
}
