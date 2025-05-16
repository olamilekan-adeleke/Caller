//
//  EditProfilePreferencesView.swift
//  Caller
//
//  Created by Kod Enigma on 12/02/2025.
//

import SwiftUI

struct EditProfilePreferencesView: View {
    @State private var yearsExperience = ""
    @State private var selectedIndustries: [String] = []
    @State private var selectedFunctions: [String] = []
    @State private var selectedCountries: [String] = []
    
    let industries = ["Financial Service", "Healthcare", "Technology", "Education", "Manufacturing", "Retail", "Consulting"]
    let functions = ["Finance", "HR", "Operations", "Marketing", "Sales", "IT", "Management"]
    let countries = ["Canada", "United States", "United Kingdom", "Australia", "Germany", "France", "Japan", "Singapore"]
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SamaCarbonateSpacing.xxSmall) {
                Text("Professional experience").font(.system(size: 50)).fontWeight(.bold).opacity(0.6)
                Spacer().frame(height: SamaCarbonateSpacing.xxSmall)
                
                SamaLabeledTextField(
                    title: "Total Years of Professional Experience",
                    hintText: "Enter years",
                    text: $yearsExperience
                ).keyboardType(.numberPad)
                
                SamaMultiLabeledTextField(
                    title: "Industry Experience",
                    hintText: "Select industries",
                    items: industries,
                    selectedOptions: $selectedIndustries
                )
                
                SamaMultiLabeledTextField(
                    title: "Functional Experience",
                    hintText: "Select functions",
                    items: functions,
                    selectedOptions: $selectedFunctions
                )
                
                SamaMultiLabeledTextField(
                    title: "Countries Worked In",
                    hintText: "Select countries",
                    items: countries,
                    selectedOptions: $selectedCountries
                )
                
                Button("Save", action: ontap)
                    .font(SamaCarbonateFontLibrary.Button.boldPrimary)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color("primaryOrange")))
                    .cornerRadius(8)
            }.padding()
        }
    }
    
    func ontap() {}
}

#Preview {
    EditProfilePreferencesView()
}
