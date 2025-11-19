//
//  UpdatePasswordViewModel.swift
//  Caller
//
//  Created by Kod Engima on 24/08/2025.
//

import Foundation
import Combine
import SwiftUI


// MARK: - ViewModel
// The logic and state management for the UpdatePasswordView.

@MainActor
class UpdatePasswordViewModel: ObservableObject {
    // MARK: - State for the View
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var retypePassword: String = ""
    @Published var isLoading: Bool = false
    @Published var isContinueButtonEnabled: Bool = false
    
    // MARK: - Password Validation State
    @Published var newPasswordHasUppercase: Bool = false
    @Published var newPasswordHasNumber: Bool = false
    @Published var newPasswordHasSpecial: Bool = false
    @Published var newPasswordHasRequiredLength: Bool = false
    
    // MARK: - Error States
    @Published var currentPasswordError: String?
    @Published var retypePasswordError: String?
    
    // MARK: - Navigation State
    @Published var shouldNavigateToNextStep: Bool = false
    @Published var shouldDismiss: Bool = false
    @Published var navigationDestination: UpdatePasswordNavigationDestination = .none
    
    // MARK: - Alert State
    @Published var alertInfo: AlertInfo?
    
    // MARK: - Properties
    var tokens: TokensMapper?
    var comingFromAccount: Bool = false
    
    // MARK: - Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Content
    let titleText = "new_password_title".localized()
    let currentPasswordLabelText = "current_password_label".localized()
    let currentPasswordPlaceholderText = "current_password_placeholder".localized()
    let currentPasswordErrorText = "current_password_error_label".localized()
    let newPasswordLabelText = "new_password_label".localized()
    let newPasswordPlaceholderText = "new_password_placeholder".localized()
    let newPasswordUppercaseLabelText = "new_password_uppercase_label".localized()
    let newPasswordNumberLabelText = "new_password_number_label".localized()
    let newPasswordSpecialLabelText = "new_password_special_label".localized()
    let newPasswordLengthLabelText = "new_password_length_label".localized()
    let retypePasswordLabelText = "new_password_retype_label".localized()
    let retypePasswordPlaceholderText = "new_password_retype_placeholder".localized()
    let retypePasswordErrorText = "new_password_retype_error".localized()
    let saveButtonText = "save".localized()
    
    // MARK: - Initializer
    init(tokens: TokensMapper? = nil, comingFromAccount: Bool = false) {
        self.tokens = tokens
        self.comingFromAccount = comingFromAccount
        setupPublishers()
    }
    
    // MARK: - Private Setup
    private func setupPublishers() {
        $newPassword
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] password in
                self?.validateNewPassword(password)
            }.store(in: &cancellables)
        
        $currentPassword
            .dropFirst()
            .sink { [weak self] _ in
                if self?.currentPasswordError != nil {
                    self?.currentPasswordError = nil
                }
            }.store(in: &cancellables)
        
        Publishers.CombineLatest($newPassword, $retypePassword)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] newPassword, retypePassword in
                self?.validateRetypePassword(newPassword: newPassword, retypePassword: retypePassword)
            }.store(in: &cancellables)
        
        Publishers.CombineLatest4($currentPassword, $newPassword, $retypePassword, $newPasswordHasUppercase)
            .combineLatest(Publishers.CombineLatest4($newPasswordHasNumber, $newPasswordHasSpecial, $newPasswordHasRequiredLength, $isLoading))
            .sink { [weak self] values in
                let ((currentPassword, newPassword, retypePassword, hasUppercase), (hasNumber, hasSpecial, hasRequiredLength, isLoading)) = values
                self?.updateContinueButtonState(
                    currentPassword: currentPassword,
                    newPassword: newPassword,
                    retypePassword: retypePassword,
                    hasUppercase: hasUppercase,
                    hasNumber: hasNumber,
                    hasSpecial: hasSpecial,
                    hasRequiredLength: hasRequiredLength,
                    isLoading: isLoading
                )
            }.store(in: &cancellables)
    }
    
    // MARK: - Public Intents (Called from the View)
    
    /// Call this when the view appears.
    func onAppear() {
//        TrackScreen.common.changePassword()
    }
    
    /// Handle continue button tap.
    func continueAction() async {
        guard isContinueButtonEnabled, !isLoading else { return }
        dismissKeyboard()
        
        do {
            // Wait for keyboard dismissal
            try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
            isLoading = true
            
            if (tokens?.isPasswordGenerated ?? false) && (tokens?.awaiting2fa ?? false) {
                try await updateGeneratedPassword()
            } else {
                try await updatePassword()
            }
            
            handleSuccess()
        } catch {
            handleUpdatePasswordError(error: error)
        }
    }
    
    /// Dismiss keyboard manually.
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// Reset navigation state.
    func resetNavigationState() {
        navigationDestination = .none
        shouldNavigateToNextStep = false
        shouldDismiss = false
    }
    
    // MARK: - Private Validation Logic
    
    private func validateNewPassword(_ password: String) {
        newPasswordHasUppercase = password != password.lowercased()
        newPasswordHasNumber = password.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
        
        let characterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        newPasswordHasSpecial = password.rangeOfCharacter(from: characterSet.inverted) != nil
        
        newPasswordHasRequiredLength = password.count >= 10
    }
    
    private func validateRetypePassword(newPassword: String, retypePassword: String) {
        if !retypePassword.isEmpty && newPasswordValid() && newPassword != retypePassword {
            retypePasswordError = retypePasswordErrorText
        } else {
            retypePasswordError = nil
        }
    }
    
    private func updateContinueButtonState(
        currentPassword: String,
        newPassword: String,
        retypePassword: String,
        hasUppercase: Bool,
        hasNumber: Bool,
        hasSpecial: Bool,
        hasRequiredLength: Bool,
        isLoading: Bool
    ) {
        let currentPasswordValid = currentPassword.isPasswordValid()
        let newPasswordValid = hasUppercase && hasNumber && hasSpecial && hasRequiredLength
        let passwordsMatch = !newPassword.isEmpty && newPasswordValid && newPassword == retypePassword
        
        isContinueButtonEnabled = !isLoading && currentPasswordValid && newPasswordValid && passwordsMatch
    }
    
    private func currentPasswordValid() -> Bool {
        return currentPassword.isPasswordValid()
    }
    
    private func newPasswordValid() -> Bool {
        return newPasswordHasUppercase && newPasswordHasNumber && newPasswordHasSpecial && newPasswordHasRequiredLength
    }
    
    private func passwordsMatch() -> Bool {
        return !newPassword.isEmpty && newPasswordValid() && newPassword == retypePassword
    }
    
    // MARK: - Network Logic
    private func updatePassword() async throws {
//        try await API.updatePassword(oldPassword: currentPassword, password: newPassword)
    }
    
    private func updateGeneratedPassword() async throws {
//        try await API.resetGeneratedPassword(
//            accessToken: tokens?.accessToken ?? "",
//            oldPassword: currentPassword,
//            password: newPassword
//        )
    }
    
    private func handleSuccess() {
        isLoading = false
        
        if comingFromAccount {
            shouldDismiss = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                _ = TopToasters.shared.present(style: .info, text: "password_updated_confirmation".localized())
            }
        } else {
            handleCoacheeSuccess()
        }
    }
    
    private func handleUpdatePasswordError(error: Error) {
        isLoading = false
        let errorCode = (error as NSError).code
        
        switch errorCode {
        case 403: currentPasswordError = currentPasswordErrorText
        case 409: retypePasswordError = "current_password_same_has_new_one".localized()
        case 411: alertInfo = AlertInfo(title: "Warning", message: "password_100_times_hibp".localized())
        default: alertInfo = AlertInfo(title: "error".localized(), message: "server_error_retry".localized())
        }
    }
    
    private func handleCoacheeSuccess() {
//        guard let coacheeMapper = Coachee.shared.coacheeMapper else {
//            navigationDestination = .steps
//            return
//        }
//        
//        if !coacheeMapper.isStepsValid() {
//            navigationDestination = .steps
//        } else if coacheeMapper.currentCoach == nil {
//            navigationDestination = .findCoach
//        } else {
//            navigationDestination = .tabBar
//        }
    }
    
    private func handleCoachSuccess() {
//        guard let coachMapper = Coach.shared.coachMapper else { return }
//        if !coachMapper.isStepsValid() {
//            navigationDestination = .steps
//        } else {
//            navigationDestination = .tabBar
//        }
    }
}

// MARK: - Supporting Types

/// Represents the possible navigation destinations from this screen.
enum UpdatePasswordNavigationDestination: Equatable, Identifiable {
    case none
    case steps
    case findCoach
    case tabBar
    
    var id: String {
        switch self {
        case .none: return "none"
        case .steps: return "steps"
        case .findCoach: return "findCoach"
        case .tabBar: return "tabBar"
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
