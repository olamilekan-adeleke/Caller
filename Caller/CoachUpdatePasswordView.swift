//
//  CoachUpdatePasswordView.swift
//  Caller
//
//  Created by Kod Engima on 28/08/2025.
//

import SwiftUI

struct CoachUpdatePasswordView: View {
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
    
    init(tokens: TokensMapper? = nil, comingFromAccount: Bool = false) {
        self.viewModel = UpdatePasswordViewModel(tokens: tokens, comingFromAccount: comingFromAccount)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Image("sama_logo").resizable().frame(width: 120, height: 42)
                
                Spacer(minLength: 20)
                
                VStack(spacing: 10) {
                    Text(viewModel.titleText)
                        .font(.system(size: 28))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("hint_password_label".localized())
                        .font(SamaCarbonateFontLibrary.Caption.regular)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
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
                
                Spacer(minLength: 20)
                
                PrimaryButton(title: viewModel.saveButtonText, style: continueButtonStyle) {
                    Task { await viewModel.continueAction() }
                }.padding(.bottom, 20)
                
            }.padding(.horizontal, 24)
        }
        .background(Color.white)
        .onTapGesture {
            focusedField = .none
            viewModel.dismissKeyboard()
        }
        .onAppear { viewModel.onAppear() }
        .alert(item: $viewModel.alertInfo) { alertInfo in
            Alert(title: Text(alertInfo.title), message: Text(alertInfo.message))
        }
        .background(
            Group {
                // Hidden navigation links for programmatic navigation
//                NavigationLink(
//                    destination: SignInStep0View(tokens: viewModel.tokens),
//                    isActive: .constant(viewModel.navigationDestination == .steps)
//                ) { EmptyView() }.hidden()
                
//                NavigationLink(
//                    destination: FindCoachView(),
//                    isActive: .constant(viewModel.navigationDestination == .findCoach)
//                ) { EmptyView() }.hidden()
                
//                NavigationLink(
//                    destination: TabBarView(),
//                    isActive: .constant(viewModel.navigationDestination == .tabBar)
//                ) { EmptyView() }.hidden()
            }
        )
        .onReceive(viewModel.$shouldDismiss) { shouldDismiss in
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
            ) {
                focusedField = nextFocus
                if nextFocus == .none && viewModel.isContinueButtonEnabled {
                    Task { await viewModel.continueAction() }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        CoachUpdatePasswordView(tokens: nil, comingFromAccount: false)
    }
}
