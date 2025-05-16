//
//  ContentView.swift
//  Caller
//
//  Created by Kod Enigma on 23/10/2024.
//

import UIKit
import SwiftUI

struct ProfileView: View {
    enum ViewPadding {
        static let bodyTopPadding: CGFloat = 10
    }
//    12345678!!Ss
    // 12345678Ss!
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer().frame(height: SamaCarbonateSpacing.small)
                    
                    ZStack(alignment: .bottomTrailing) {
                        Circle().frame(width: 100, height: 100)
                        Image(systemName: "pencil")
                            .padding(6).background(Color.white).cornerRadius(100)
                            .offset(x: -5, y: -5)
                    }
                    Spacer().frame(height: SamaCarbonateSpacing.xxSmall)
                    Text("Jespers Dahlqvist").fontWeight(.regular)
                }
                
//                Spacer().frame(height: SamaCarbonateSpacing.small)
//                ProfilePersonalInformation()
//                
//                Spacer().frame(height: SamaCarbonateSpacing.small)
//                ProfileExperienceView()
//                
//                Spacer().frame(height: SamaCarbonateSpacing.small)
//                ProfilePreferencesView()
                
                Spacer().frame(height: SamaCarbonateSpacing.small)
                ProfileAccountSettingView()
            }
            .padding(.top, ViewPadding.bodyTopPadding)
            .background(Color.white)
        }
    }
}

struct ProfileAccountSettingView: View {
    enum ViewPadding {
        static let bodyHorizontal: CGFloat  = 20
        static let vStackHorizontal: CGFloat = 16
        static let vStackVertical: CGFloat  = 12
        static let preferencesItemVertical: CGFloat = 5
    }
    
    enum TextSize {
        static let title3: CGFloat = 20
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Account").bold()
            Rectangle().foregroundColor(.orange).frame(width: 35, height: 2)
            Spacer().frame(height: 10)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Sync calender with: ").font(SamaCarbonateFontLibrary.Body.large)
                    
                    Text("Sign in")
                        .font(SamaCarbonateFontLibrary.Body.medium)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background(Color.white)
                        .cornerRadius(4)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                }
                
                Spacer().frame(height: SamaCarbonateSpacing.small)
                Text("Change password").font(SamaCarbonateFontLibrary.Body.large)
                
                Spacer().frame(height: SamaCarbonateSpacing.small)
                Text("Log Out").font(SamaCarbonateFontLibrary.Body.large)
                
                Rectangle().frame(height: 1).foregroundColor(Color.clear)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, ViewPadding.vStackHorizontal)
            .padding(.vertical, ViewPadding.vStackVertical)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, ViewPadding.bodyHorizontal)
    }
}

struct ProfileExperienceView: View {
    enum ViewPadding {
        static let bodyHorizontal: CGFloat  = 20
        static let vStackHorizontal: CGFloat = 16
        static let vStackVertical: CGFloat  = 12
        static let preferencesItemVertical: CGFloat = 5
    }
    
    struct ExperienceLevel: Identifiable {
        let id = UUID()
        let role: String
        let years: Int
    }
    
    let experiences = [
        ExperienceLevel(role: "C-Suite / Executive", years: 5),
        ExperienceLevel(role: "Senior professional", years: 3),
        ExperienceLevel(role: "Manager", years: 2),
        ExperienceLevel(role: "Associate", years: 10),
        ExperienceLevel(role: "Operation and Administration", years: 5)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Coaching experience").bold().foregroundColor(Color("primaryBlue"))
                Spacer()
                Image(systemName: "pencil").padding(6).cornerRadius(100).foregroundColor(Color("primaryBlue"))
            }
            Rectangle().foregroundColor(.orange).frame(width: 35, height: 2)
            Spacer().frame(height: SamaCarbonateSpacing.xxSmall)
            
            VStack(alignment: .leading) {
                preferencesItem(title: "Bio", value: "Just bail it")
                Divider()
                preferencesItem(title: "Years started caching", value: "2000")
                Divider()
                preferencesItem(title: "Area of coaching competencies", value: "Financial Service", vertical: true)
                Divider()
                preferencesItem(
                    title: "Coaching accreditation/Certifications",
                    value: "AC - Professional Coach/Excutive",
                    vertical: true
                )
                Divider()
                preferencesItem(
                    title: "Membership",
                    value: "BACP - British Assocaiation for counselling and psychotherpy",
                    vertical: true
                )
                Divider()
                preferencesItem(
                    title: "Industry experience (coaching in)",
                    value: "Financial Service",
                    vertical: true
                )
                Divider()
                preferencesItem(
                    title: "Functional experience (coaching in)",
                    value: "Finance",
                    vertical: true
                )
                Divider()
                Spacer().frame(height: SamaCarbonateSpacing.xSmall)
                HStack {
                    Text("Experience working with").font(.footnote).fontWeight(.semibold)
                    Spacer()
                    Text("Number of years").foregroundColor(.gray).font(.footnote).fontWeight(.bold)
                }
                
                Spacer().frame(height: SamaCarbonateSpacing.xSmall)
                ForEach(experiences) { experience in
                    experienceLevelRow(role: experience.role, years: experience.years)
                }
            }
            .padding(.horizontal, ViewPadding.vStackHorizontal)
            .padding(.vertical, ViewPadding.vStackVertical)
            .overlay(
                RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }.padding(.horizontal, ViewPadding.bodyHorizontal)
    }
    
    @ViewBuilder func preferencesItem(title: String, value: String, vertical: Bool = false) -> some View {
        Group {
            if vertical {
                VStack(alignment: .leading) {
                    Text(title).font(SamaCarbonateFontLibrary.Body.medium).opacity(0.6)
                    Spacer().frame(height: SamaCarbonateSpacing.xxSmall)
                    Text(value).font(SamaCarbonateFontLibrary.Body.medium).opacity(0.8)
                }
            }else {
                HStack {
                    Text(title).font(SamaCarbonateFontLibrary.Body.medium).opacity(0.6)
                    Spacer()
                    Text(value).font(SamaCarbonateFontLibrary.Body.medium).opacity(0.8)
                }
            }
        }.padding(.vertical, ViewPadding.preferencesItemVertical)
    }
    
    @ViewBuilder func experienceLevelRow(role: String, years: Int) -> some View {
        HStack {
            Text(role).foregroundColor(.gray).font(.system(size: 16)).padding()
            Spacer()
            Text("\(years)").font(.system(size: 16, weight: .medium))
                .padding(.horizontal, SamaCarbonateSpacing.xSmall)
                .frame(maxWidth: 60, maxHeight: .infinity)
                .background(
                    Color.gray.opacity(0.1)
//                    Color("disabledTextColor").opacity(0.1)
                        .clipShape(RoundedCorner(radius: 8, corners: [.topRight, .bottomRight]))
                )
        }.background(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 0.7))
    }
}

struct ProfilePersonalInformation: View {
    enum ViewPadding {
        static let bodyHorizontal: CGFloat  = 20
        static let vStackHorizontal: CGFloat = 16
        static let vStackVertical: CGFloat  = 12
        static let preferencesItemVertical: CGFloat = 5
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Personal information").bold().foregroundColor(Color("primaryBlue"))
                Spacer()
                Image(systemName: "pencil").padding(6).cornerRadius(100).foregroundColor(Color("primaryBlue"))
            }
            Rectangle().foregroundColor(.orange).frame(width: 35, height: 2)
            Spacer().frame(height: SamaCarbonateSpacing.xxSmall)
            
            VStack {
                preferencesItem(title: "Date of birth", value: "7 Oct, 1990")
                Divider()
                preferencesItem(title: "Phone number", value: "+44 765432123445")
                Divider()
                preferencesItem(title: "Gender", value: "Prefer not to say")
                Divider()
                preferencesItem(title: "Country", value: "France")
                Divider()
                preferencesItem(title: "City", value: "Neuilly Cur Sei")
                Divider()
                preferencesItem(title: "Native Language (s)", value: "French")
                Divider()
                preferencesItem(title: "Coaching Language (s)", value: "French")
                Divider()
                preferencesItem(title: "Highest education level", value: "Doctor Degree")
                Divider()
                preferencesItem(title: "Maximun hour available per week", value: "150")
            }
            .padding(.horizontal, ViewPadding.vStackHorizontal)
            .padding(.vertical, ViewPadding.vStackVertical)
            .overlay(
                RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }.padding(.horizontal, ViewPadding.bodyHorizontal)
    }
    
    @ViewBuilder func preferencesItem(title: String, value: String) -> some View {
        HStack {
            Text(title).font(SamaCarbonateFontLibrary.Body.medium).opacity(0.7)
            Spacer()
            Text(value).font(SamaCarbonateFontLibrary.Body.medium).opacity(0.8)
        }.padding(.vertical, ViewPadding.preferencesItemVertical)
    }
}

struct ProfilePreferencesView: View {
    enum ViewPadding {
        static let bodyHorizontal: CGFloat  = 20
        static let vStackHorizontal: CGFloat = 16
        static let vStackVertical: CGFloat  = 12
        static let preferencesItemVertical: CGFloat = 5
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: SamaCarbonateSpacing.xxSmall) {
            VStack(alignment: .leading) {
                HStack{
                    Text("Professional experience").bold()
                    Spacer()
                    Image(systemName: "pencil").padding(6).cornerRadius(100).foregroundColor(Color("primaryBlue"))
                }
                Rectangle().foregroundColor(.orange).frame(width: 35, height: 2)
            }
            
            VStack(alignment: .leading) {
                preferencesItem(title: "Total years of prefessional experience", value: "10", vertical: true)
                Divider()
                preferencesItem(title: "Industry experience", value: "Financial Service")
                Divider()
                preferencesItem(title: "Functional experience", value: "Finance")
                Divider()
                preferencesItem(title: "Countries worked in", value: "Canada")
            }
            .padding(.horizontal, ViewPadding.vStackHorizontal)
            .padding(.vertical, ViewPadding.vStackVertical)
            .overlay(
                RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }.padding(.horizontal, ViewPadding.bodyHorizontal)
    }
    
    @ViewBuilder func preferencesItem(title: String, value: String, vertical: Bool = false) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title).font(SamaCarbonateFontLibrary.Body.medium).opacity(0.7)
                Spacer().frame(height: SamaCarbonateSpacing.xxSmall)
                Text(value).font(SamaCarbonateFontLibrary.Body.medium).opacity(0.8)
            }
        }.padding(.vertical, ViewPadding.preferencesItemVertical)
    }
}

#Preview {
    ProfileView()
}
