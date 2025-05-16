//
//  AskNoteTakerView.swift
//  Caller
//
//  Created by Kod Enigma on 03/04/2025.
//

import SwiftUI

struct NoteTakerView: View {
    @State private var isNoteTakerEnabled = false
    
    var body: some View {
        VStack(spacing: SamaCarbonateSpacing.small) {
            VStack(spacing: SamaCarbonateSpacing.xxSmall) {
                Text("Your session, your words. Securely captured.")
                    .font(Font.system(size: SamaCarbonateSize.Text.xLarge, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, SamaCarbonateSpacing.xSmall)
            }
            .padding(.top, SamaCarbonateSpacing.small)
            
            VStack(alignment: .leading, spacing: SamaCarbonateSpacing.small) {
                FeatureRow(
                    icon: "doc.text.fill",
                    title: "Enhanced coaching experience",
                    description: "Sama note taker helps both you and your coach stay present, boosting reflection, trust, and goal-setting."
                )
                
                FeatureRow(
                    icon: "bubble.left.fill",
                    title: "Consent and audio handling",
                    description: "Audio is transcribed and permanently deleted to keep the focus on the session."
                )
                
                FeatureRow(
                    icon: "shield.fill",
                    title: "Confidential & secure",
                    description: "Your notes are strictly confidential and securely stored in full compliance with GDPR."
                )
                
                FeatureRow(
                    icon: "person.fill",
                    title: "Personalized experience",
                    description: "Insights from note-taking help refine and enhance your coaching journey."
                )
            }
            .padding(.horizontal, SamaCarbonateSpacing.xSmall)
            .padding(.trailing, SamaCarbonateSpacing.xSmall)
            
            Spacer()
            
            VStack(spacing: SamaCarbonateSpacing.xxSmall) {
                Button(action: { isNoteTakerEnabled = true }) {
                    Text("Enable note taker")
                        .font(SamaCarbonateFontLibrary.Button.boldPrimary)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.primaryBlue)
                        )
                        .padding(.horizontal, SamaCarbonateSpacing.xSmall)
                }.buttonStyle(SamaButtonStyle(enabledState: true, activeColor: .primaryBlue))
                
                Button(action: { isNoteTakerEnabled = false }) {
                    Text("Disable note taker")
                        .font(SamaCarbonateFontLibrary.Title.regularBold)
                        .foregroundColor(.primaryOrange)
                }
                
                Text("The note taker will start once all participants have given their consent.")
                    .font(SamaCarbonateFontLibrary.Caption.regular)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 80)
                    .padding(.bottom, SamaCarbonateSpacing.xSmall)
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: SamaCarbonateSpacing.xSmall) {
            Image(systemName: icon)
                .font(.system(size: SamaCarbonateSize.Text.large))
                .foregroundColor(Color.black)
                .frame(width: 24, height: 24)
                .padding(6)
                .background(Color.primaryOrange.opacity(0.1))
                .cornerRadius(100)

            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(SamaCarbonateFontLibrary.Title.smallBold)
                
                Text(description)
                    .font(SamaCarbonateFontLibrary.Body.small)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .offset(y: 4)
        }
    }
}

struct NoteTakerView_Previews: PreviewProvider {
    static var previews: some View {
        NoteTakerView()
    }
}
