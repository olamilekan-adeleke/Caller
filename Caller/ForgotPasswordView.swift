import SwiftUI

struct ForgotPasswordView: View {
    enum Field: Hashable { case email, none }
    
    @StateObject private var viewModel = ForgotPasswordViewModel()
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Image("sama_logo").resizable().frame(width: 120, height: 42)
            
            Spacer()
            
            Text(viewModel.titleText)
                .font(.system(size: 28))
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                labeledTextField(
                    label: viewModel.emailLabelText,
                    placeholder: viewModel.emailPlaceholderText,
                    text: $viewModel.email,
                    focusField: .email,
                    nextFocus: .none
                )
                
                if let errMsg = viewModel.emailError {
                    PasswordRequirementRow(text: errMsg, infoType: .error)
                }
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                PrimaryButton(title: viewModel.continueButtonText, style: continueButtonStyle) {
                    Task { await viewModel.continueAction() }
                }
                
                PrimaryButton(title: viewModel.cancelButtonText, style: .tertiary) {
                    // dismiss()
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .background(Color.white)
        .onTapGesture {
            focusedField = .none
            viewModel.dismissKeyboard()
        }
        .onAppear { viewModel.onAppear() }
        .alert(item: $viewModel.alertInfo) { alertInfo in
            Alert(title: Text(alertInfo.title), message: Text(alertInfo.message))
        }
        .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
            if shouldDismiss {
                // dismiss()
                viewModel.resetNavigationState()
            }
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
                keyboardType: .emailAddress,
                isSecureType: false,
                text: text,
                isFocused: $focusedField.equals(focusField)
            ) {
                focusedField = nextFocus
                if nextFocus == .none && viewModel.isContinueButtonEnabled {
                    Task { await viewModel.continueAction() }
                }
            }
        }
        .onChange(of: text.wrappedValue) { _ in
            viewModel.validateEmail()
        }
    }
}


class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var emailError: String?
    @Published var isLoading: Bool = false
    @Published var alertInfo: AlertInfo?
    @Published var shouldDismiss: Bool = false
    
    private let comingFromAccount: Bool
    
    // MARK: - Computed Properties
    var isContinueButtonEnabled: Bool {
        !email.isEmpty && email.isEmailValid() && !isLoading
    }
    
    var emailLabelText: String { "email".localized() }
    
    var emailPlaceholderText: String { "sign_in_email_placeholder".localized() }
    
    var continueButtonText: String { "continue".localized() }
    
    var cancelButtonText: String { "cancel".localized() }
    
    var titleText: String { "forget_password_title".localized() }
    
    // MARK: - Initializer
    init(comingFromAccount: Bool = false) {
        self.comingFromAccount = comingFromAccount
    }
    
    // MARK: - Actions
    @MainActor
    func continueAction() async {
        guard !email.isEmpty else { return }
        
        isLoading = true
        emailError = nil
        
        //        API.resetPassword(email: email, success: { [weak self] in
        //            DispatchQueue.main.async {
        //                self?.isLoading = false
        //                self?.shouldDismiss = true
        //                TopToasters.shared.present(style: .warning, text: "password_email_sent".localized())
        //            }
        //        }, failure: { [weak self] errorCode in
        //            DispatchQueue.main.async {
        //                self?.isLoading = false
        //
        //                if errorCode == 404 {
        //                    self?.shouldDismiss = true
        //                    TopToasters.shared.present(style: .warning, text: "password_email_sent".localized())
        //                } else {
        //                    TopToasters.shared.present(style: .warning, text: "server_error_retry".localized())
        //                }
        //            }
        //        })
    }
    
    func validateEmail() {
        if !email.isEmpty && !email.isEmailValid() {
            emailError = "textfield_format_error".localized()
        } else {
            emailError = nil
        }
    }
    
    func dismissKeyboard() {
        // This will be handled by the view's focus state
    }
    
    func onAppear() {
        //        TrackScreen.common.resetPassword()
    }
    
    func resetNavigationState() {
        shouldDismiss = false
    }
}


#Preview {
    NavigationView {
        ForgotPasswordView()
    }
}
