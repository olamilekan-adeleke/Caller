//
//  TESTV.swift
//  Caller
//
//  Created by Kod Enigma on 27/02/2025.
//

import SwiftUI
import UIKit
import Combine


enum ModifyFrom {
    case cancel
    case reschedule
}



struct NotesMapper {
    let main: String?
    let keyChallenge: String?
    let personalChallenge: String?
    let careerChange: String?
    let coachingArea: String?
    let id: String?
    let createdAt: Date?
}


struct TESTV: View {
    @State private var showingReasonSheet = false
    @State private var showingOptions = false
    @State private var selection = "None"
    @State private var showingReasonActionSheet = false
    
    @State var showActionSheet = false
    @State var coffeeConsumptionTime = "Select Reason"
    
    @State var otherReasonText = ""
    
    var modifyFrom: ModifyFrom = .reschedule
    
    
    var pageTitle: String {
        var localisedString: String
        
        if modifyFrom == .reschedule {
            localisedString = "reschedule_session_header"
        } else {
            localisedString = "cancel_session_header"
        }
        return localisedString
    }
    
    var buttonTitle: String {
        var localisedString: String
        
        if modifyFrom == .reschedule {
            localisedString = "reschedule_button"
        } else {
            localisedString = "cancel_button"
        }
        return localisedString
    }
    
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: SamaCarbonateSpacing.xxSmall) {
                Text("reschedule_reason_header").font(SamaCarbonateFontLibrary.Title.regularMedium)
                
                Spacer().frame(height: 20)
                
                //
                Button { self.showActionSheet = true } label: {
                    HStack {
                        Text(coffeeConsumptionTime)
                            .foregroundColor(.black)
                            .font(SamaCarbonateFontLibrary.Title.regularBold)
                            .padding(.leading, 10)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color("primaryOrange"))
                            .padding(.trailing, 10)
                    }
                    .padding(.vertical, 18)
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                    
                }.actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(
                        title: Text("Reason for change or reschedule"), message: nil, buttons: [
                            .default(Text("reschedule_work_conflict_reason").foregroundColor(Color.orange), action: {
                                self.coffeeConsumptionTime = "Morning"
                            }),
                            .default(Text("reschedule_illness_reason").foregroundColor(Color("primaryOrange")), action: {
                                self.coffeeConsumptionTime = "Afternoon"
                            }),
                            .default(Text("reschedule_emergency_reason").foregroundColor(Color("primaryOrange")), action: {
                                self.coffeeConsumptionTime = "Afternoon"
                            }),
                            .default(Text("reschedule_technical_reason").foregroundColor(Color("primaryOrange")), action: {
                                self.coffeeConsumptionTime = "Afternoon"
                            }),
                            .default(Text("reschedule_other_reason").foregroundColor(Color("primaryOrange")), action: {
                                self.coffeeConsumptionTime = "other"
                            }),
//                            .cancel()
                        ]
                    )
                }
                
                Spacer().frame(height: 20)
                // Dropdown selector that opens the sheet
//                Button(action: {
//                    showingReasonSheet = true
//                }) {
//                    HStack {
//                        Text(coffeeConsumptionTime)
//                            .foregroundColor(.black)
//                            .font(SamaCarbonateFontLibrary.Button.primary)
//                            .padding(.leading, 10)
//                        
//                        Spacer()
//                        
//                        Image(systemName: "chevron.down")
//                            .foregroundColor(.gray)
//                            .padding(.trailing, 10)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 45)
//                    .background(Color(white: 246.0 / 255.0))
//                    .cornerRadius(8)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                    )
//                    
//                }.padding(.horizontal)
//                
                if coffeeConsumptionTime == "other" {
                    Text("reschedule_specify_text")
                        .font(SamaCarbonateFontLibrary.Title.regularBold)
                        .padding(.top, 10)
                    
                    TextField("reschedule_specify_placeholder", text: $otherReasonText)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color(white: 246.0 / 255.0))
                        .overlay(
                            Rectangle().stroke(Color.primaryOrange, lineWidth: 2.0).frame(height: 1),
                            alignment: .bottom
                        )
                }
            }
            
        }.padding(.horizontal)
            .onAppear{
                UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "primaryOrange")
            }
    }
}


#Preview {
    TESTV()
}



