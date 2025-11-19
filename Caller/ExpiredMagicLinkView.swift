//
//  ExpiredMagicLinkView.swift
//  Caller
//
//  Created by Kod Engima on 20/08/2025.
//

import SwiftUI

struct ExpiredMagicLinkView: View {
    @ObservedObject private var viewModel: ExpiredMagicLinkViewModel
    
    init(viewModel: ExpiredMagicLinkViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                
                Image(uiImage: UIImage(named: "magicLinkSent") ?? UIImage())
                    .padding(.bottom, 32)
                    .frame(alignment: .center)
                
                Text(viewModel.checkInboxText)
                    .font(Font(UIFont.custom(type: .foundersGroteskBold, size: 30)))
                    .foregroundColor(SamaCarbonateColorTheme.primaryTextColor)
                    .padding(.bottom, 16)
                
                Text(viewModel.descriptionText)
                    .font(Font(UIFont.custom(type: .foundersGroteskSemibold, size: 18)))
                    .foregroundColor(SamaCarbonateColorTheme.primaryTextColor)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                PrimaryButton(
                    title: viewModel.buttonTitle,
                    style: .primary,
                    leftImage: UIImage(named: "mail_white"),
                    action: viewModel.discoverAvailableMailApps,
                )
                .padding(.vertical, 40)
                .padding(.top, 30)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        }
        .onAppear(perform: viewModel.sendAnotherMail)
        .alert(isPresented: $viewModel.shouldShowErrorAlert) {
            Alert(title: Text(""), message: Text(viewModel.errorMessage), dismissButton: .cancel())
        }
    }
    
}

#Preview {
    ExpiredMagicLinkView(viewModel: ExpiredMagicLinkViewModel(userMail: "olamilekanly66@gmail.com"))
}



/// A simple data model to represent a mail app that can be opened via a URL scheme.
struct MailClient: Identifiable {
    let id = UUID()
    let name: String
    let urlString: String
}

@MainActor
class ExpiredMagicLinkViewModel: ObservableObject {
    // MARK: - Published Properties (State for the View)
    
    @Published var pageTitle: String
    @Published var checkInboxText: String
    @Published var descriptionText: String
    @Published var buttonTitle: String
    
    /// Properties to control the presentation of an error alert in the view.
    @Published var shouldShowErrorAlert = false
    @Published var errorMessage = ""
    
    // MARK: - Private Properties
    
    private let userMail: String
    
    // MARK: - Initializer
    
    init(userMail: String) {
        self.userMail = userMail
        
        // Set initial text values from localization
        self.pageTitle = "expired_magic_link_screen_title".localized()
        self.checkInboxText = "Link has expired".localized()
        self.descriptionText = "Tap the button below to generate a new link in order to login to Sama"
        self.buttonTitle = "Check your inbox".localized()
    }
    
    // MARK: - Public Methods (Intents from the View)
    
    /// Triggers the action to resend the magic link email.
    /// This should be called from the view's `.onAppear` modifier.
    func sendAnotherMail() {
//        API.authMagic(email: userMail, success: {
//            self.handleAuthMagicSuccess()
//        }, failure: { errorCode in
//            self.handleAuthMagicError(errorCode: errorCode)
//        })
    }
    
    // MARK: - Private Helper Methods
    
    /// Checks for common mail apps using their URL schemes and populates the `availableMailApps` array.
    func discoverAvailableMailApps() {
        var detectedApps: [MailClient] = []
        
        let potentialApps = [
            MailClient(name: "Mail (\("default".localized()))", urlString: "message://"),
            MailClient(name: "Gmail", urlString: "googlegmail://"),
            MailClient(name: "Outlook", urlString: "ms-outlook://")
        ]
        
        for app in potentialApps {
            if let url = URL(string: app.urlString), UIApplication.shared.canOpenURL(url) {
                detectedApps.append(app)
            }
        }
        
        if detectedApps.count == 0 {
            self.errorMessage = "No mail app detected".localized()
            self.shouldShowErrorAlert = true
        }
    }
    
    private func handleAuthMagicError(errorCode: Int) {
        switch errorCode {
        case 403:
            self.errorMessage = "alert_toaster_wrong_login".localized()
            self.shouldShowErrorAlert = true
            
        default:
            // A generic error for other cases
            self.errorMessage = "server_error_retry".localized()
            self.shouldShowErrorAlert = true
        }
    }
    
    private func handleAuthMagicSuccess() {
        // This was empty in the original code.
        print("Successfully requested a new magic link.")
    }
}
