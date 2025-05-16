//
//  EditProfileExperienceView.swift
//  Caller
//
//  Created by Kod Enigma on 12/02/2025.
//

import SwiftUI

struct EditProfileExperienceView: View {
    @State private var bio = ""
    @State private var yearsStarted = ""
    @State private var selectedCoachingAreas: [String] = []
    @State private var selectedCertifications: [String] = []
    @State private var selectedMemberships: [String] = []
    @State private var selectedIndustries: [String] = []
    @State private var selectedFunctions: [String] = []
    
    @State private var experiences: [ExperienceLevel] = [
        ExperienceLevel(role: "C-Suite / Executive", years: 5),
        ExperienceLevel(role: "Senior professional", years: 3),
        ExperienceLevel(role: "Manager", years: 2),
        ExperienceLevel(role: "Associate", years: 10),
        ExperienceLevel(role: "Operation and Administration", years: 5)
    ]
    
    // Sample options arrays
    let coachingAreas = ["Financial Service", "Healthcare", "Technology", "Education", "Manufacturing"]
    let certifications = ["AC - Professional Coach/Executive", "ICF - PCC", "ICF - ACC", "ICF - MCC"]
    let memberships = [
        "BACP - British Association for Counselling and Psychotherapy",
        "ICF - International Coach Federation",
        "EMCC - European Mentoring and Coaching Council"
    ]
    let industries = ["Financial Service", "Healthcare", "Technology", "Education", "Manufacturing"]
    let functions = ["Finance", "HR", "Operations", "Marketing", "Sales", "IT"]
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: SamaCarbonateSpacing.xxSmall) {
                Text("Coaching experience").font(.system(size: 50)).fontWeight(.bold).opacity(1.6)
                Spacer().frame(height: SamaCarbonateSpacing.xxSmall)
                
                SamaLabeledTextField(
                    title: "Years Started Coaching",
                    hintText: "Enter year",
                    text: $yearsStarted
                )
                
                SamaMultiLabeledTextField(
                    title: "Area of Coaching Competencies",
                    hintText: "Select your coaching areas",
                    items: coachingAreas,
                    selectedOptions: $selectedCoachingAreas
                )
                
                SamaMultiLabeledTextField(
                    title: "Coaching Accreditation/Certifications",
                    hintText: "Select your certifications",
                    items: certifications,
                    selectedOptions: $selectedCertifications
                )
                
                SamaMultiLabeledTextField(
                    title: "Membership",
                    hintText: "Select your memberships",
                    items: memberships,
                    selectedOptions: $selectedMemberships
                )
                
                SamaMultiLabeledTextField(
                    title: "Industry Experience (coaching in)",
                    hintText: "Select industries",
                    items: industries,
                    selectedOptions: $selectedIndustries
                )
                
                SamaMultiLabeledTextField(
                    title: "Functional Experience (coaching in)",
                    hintText: "Select functions",
                    items: functions,
                    selectedOptions: $selectedFunctions
                )
                
                HStack {
                    Text("Experience working with").font(.footnote).fontWeight(.semibold)
                    Spacer()
                    Text("Number of years").foregroundColor(.gray).font(.footnote).fontWeight(.bold)
                }
                
                ForEach(experiences.indices, id: \.self) { index in
                    experienceLevelRow(
                        role: experiences[index].role,
                        years: Binding(
                            get: { experiences[index].years },
                            set: { experiences[index].years = $0 }
                        )
                    )
                }
                
                Spacer().frame(height: SamaCarbonateSpacing.xSmall)
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
    
    
    @ViewBuilder func experienceLevelRow(role: String, years: Binding<Int>) -> some View {
        HStack {
            Text(role)
                .foregroundColor(.gray)
                .font(.system(size: 16))
                .padding()
            
            Spacer()
            
            TextField("", value: years, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, SamaCarbonateSpacing.xSmall)
                .frame(maxWidth: 80, maxHeight: .infinity)
                .background(Color("disabledTextColor").opacity(0.1).clipShape(RoundedCorner(radius: 8, corners: [.topRight, .bottomRight])))
        }
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 0.7))
    }
}



struct ExperienceLevel: Identifiable {
    let id = UUID()
    let role: String
    var years: Int
}


#Preview {
    EditProfileExperienceView()
}
