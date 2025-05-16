//
//  EditInfoView.swift
//  Caller
//
//  Created by Kod Enigma on 11/02/2025.
//

import SwiftUI

struct EditInfoView: View {
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var selectedGender: String = "Male"
    @State private var city: String = ""
    @State private var educationLevel: String = ""
    @State private var hoursPerWeek: String = ""
    @State private var phoneNumber = ""
    
    @State private var selectedNativeLanguages = [String]()
    @State private var selectedCoachingLanguages = [String]()
    let languageOptions = ["Apple", "Banana", "Orange", "Grapes", "Mango"]
    
    let allCountries = ["United States", "Canada", "Mexico", "Germany", "France", "Japan", /* ... more countries */ ]
       @State private var selectedCountry: String? = nil

    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: SamaCarbonateSpacing.xxSmall) {
//                Text("Personal Information").font(.system(size: 50)).fontWeight(.bold).opacity(0.6)
//                
//                SamaLabeledTextField(title: "First Name", hintText: "Enter your first name", text: $firstname)
//                SamaLabeledTextField(title: "Last Name", hintText: "Enter your last name", text: $lastname)
//                
//                SamaDateOfBirthField(title: "Date of Birth", hintText: "Select your birth date", selectedDate: $dateOfBirth)
//
//                Text("Phone number").font(.headline).foregroundColor(.gray)
//                Rectangle().frame(height: 50).cornerRadius(4)
//                
//                VStack(alignment: .leading) {
//                    Text("Gender").font(.headline).foregroundColor(.gray)
//                    genderButtonView(gender: "Male")
//                    genderButtonView(gender: "Female")
//                    genderButtonView(gender: "Prefer not to say")
//                }
                
                Spacer().frame(height: 12)
                SingleSelectCountryPicker(
                    title: "Select Country",
                    countries: allCountries,
                    selectedCountry: $selectedCountry
                )
                
                SamaLabeledTextField(title: "City", hintText: "Enter your city", text: $city)
                
                SamaMultiLabeledTextField(
                    title: "Native Language",
                    hintText: "Choose your Language",
                    items: languageOptions,
                    selectedOptions: $selectedNativeLanguages
                )
                
                SamaMultiLabeledTextField(
                    title: "Coaching Language",
                    hintText: "Choose your Language",
                    items: languageOptions,
                    selectedOptions: $selectedCoachingLanguages
                )
                
                SamaLabeledTextField(title: "Highest Education Level", hintText: "Enter your highest education level", text: $educationLevel)
                
                SamaLabeledTextField(
                    title: "Maximum Hours Available Per Week",
                    hintText: "e.g., 30",
                    text: $hoursPerWeek
                ).keyboardType(.numberPad)
                
                Button("Save", action: ontap)
                    .font(SamaCarbonateFontLibrary.Button.boldPrimary)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color("primaryOrange")))
                    .cornerRadius(8)
            }
        }
        .padding()
        .onAppear{ }
    }
    
    func ontap(){}
    
    @ViewBuilder func genderButtonView( gender: String) -> some View {
        Button(action: { selectedGender = gender }) {
            Text(gender)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(selectedGender == gender ? .white : .primary)
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(selectedGender == gender ? Color("primaryOrange") : .white)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("primaryOrange"), lineWidth: 2))
                )
        }
    }
}


#Preview {
    EditInfoView()
}
