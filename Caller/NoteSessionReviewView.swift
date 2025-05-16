//
//  NewNoteVoew.swift
//  Caller
//
//  Created by Kod Enigma on 04/03/2025.
//

import SwiftUI

struct NoteSessionReviewView: View {
    let circleRadius: CGFloat = 200
    let expansionAmount: CGFloat = 50
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            ZStack {
                Circle()
                    .fill(Color("primaryOrange").opacity(0.1))
                    .frame(width: circleRadius * 2 + expansionAmount * 2, height: circleRadius * 2 + expansionAmount * 2)
                    .position(x: screenWidth / 2, y: 0)
                
                ScrollView(showsIndicators: false){
                    VStack(alignment: .leading) {
                        PreviewCardView()
                        Spacer().frame(height: SamaCarbonateSpacing.small)
                        
                        Text("NOTES")
                            .font(SamaCarbonateFontLibrary.Caption.regular)
                            .foregroundColor(Color.gray)
                        Spacer().frame(height: SamaCarbonateSpacing.xxSmall)
                        
                        VStack(spacing: 16) {
                            SessionCardView(day: "Fri", date: "18 Aug 2025", time: "10:00 AM", duration: "25 min", status: "INCOMPLETE")
                            SessionCardView(day: "Mon", date: "21 Aug 2025", time: "11:30 AM", duration: "30 min", status: "COMPLETEED")
                            SessionCardView(day: "Wed", date: "23 Aug 2025", time: "09:00 AM", duration: "45 min", status: "INCOMPLETE")
                            SessionCardView(day: "Thu", date: "24 Aug 2025", time: "02:00 PM", duration: "60 min", status: "COMPLETEED")
                        }
                    }
                    .padding(.horizontal)
                    .navigationTitle("Jesper notes")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

struct SessionCardView: View {
    enum Style {
        static let cardCornerRadius: CGFloat = 30
        static let statusBackgroundOpacity: CGFloat = 0.05
        static let statusBorderWidth: CGFloat = 1
    }
    
    let day: String
    let date: String
    let time: String
    let duration: String
    let status: String
    
    var body: some View {
        VStack{
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Session on \(day), \(date)")
                        .font(SamaCarbonateFontLibrary.Title.regularBold)
                    
                    Text("\(time) - \(duration)")
                        .font(SamaCarbonateFontLibrary.Body.medium)
                        .foregroundColor(.gray)
                    
                    Text(status)
                        .font(SamaCarbonateFontLibrary.Caption.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: Style.cardCornerRadius)
                                .fill(status == "INCOMPLETE" ? Color("primaryOrange").opacity(Style.statusBackgroundOpacity) : Color("primaryGreenColor").opacity(Style.statusBackgroundOpacity))
                                .overlay(
                                    RoundedRectangle(cornerRadius: Style.cardCornerRadius)
                                        .stroke(status == "INCOMPLETE" ? Color.red : Color("primaryGreenColor"), lineWidth: Style.statusBorderWidth)
                                )
                        )
                        .foregroundColor(status == "INCOMPLETE" ? Color("primaryOrange") : Color("primaryGreenColor"))
                }
                Spacer()
                Image("enterArrow")
            }
            
            Spacer().frame(height: SamaCarbonateSpacing.xSmall)
            Divider()
        }
        .frame(maxWidth: .infinity)
    }
}





// PREVIEW

struct PreviewCardView: View {
    enum Style {
        static let cardCornerRadius: CGFloat = 8
        static let cardBackgroundColor: Color = .white
        static let cardShadowColor: Color = .gray.opacity(0.3)
        static let cardShadowRadius: CGFloat = 4
        static let cardShadowX: CGFloat = 0
        static let cardShadowY: CGFloat = 2
        static let contentHorizontalPadding: CGFloat = 18
        static let contentVerticalPadding: CGFloat = 24
    }
    
    @State private var nextSession: Date = Date()
    @State private var selectedOption: String?
    let options = ["Yes", "No", "Maybe"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: SamaCarbonateSpacing.xxSmall) {
            HStack {
                Text("Please Review")
                    .font(SamaCarbonateFontLibrary.Title.smallBold)
                Spacer()
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: SamaCarbonateSpacing.small, height: SamaCarbonateSpacing.small)
            }
            
            SamaDateOfBirthField(
                title: "Proposed next session",
                hintText: "13 Oct 2025",
                selectedDate: $nextSession,
                backgroundColor: Color("disabledTextColor").opacity(0.1),
                titleFont: SamaCarbonateFontLibrary.Title.smallBold,
                titleColor: Color.black,
                suffixIcon: AnyView(
                    Image(systemName: "square.and.pencil").foregroundColor(Color("primaryOrange"))
                )
            )
            
            Text("Employee considering a career change?")
                .font(SamaCarbonateFontLibrary.Title.smallBold)
            
            HStack {
                ForEach(options, id: \.self) { option in
                    OptionButton(text: option, selectedOption: $selectedOption, optionValue: option)
                }
            }
            
            Text("Unknow")
                .font(SamaCarbonateFontLibrary.Caption.bold)
                .foregroundColor(Color("primaryOrange"))
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, Style.contentHorizontalPadding)
        .padding(.vertical, Style.contentVerticalPadding)
        .background(
            RoundedRectangle(cornerRadius: Style.cardCornerRadius)
                .fill(Style.cardBackgroundColor)
                .shadow(color: Style.cardShadowColor, radius: Style.cardShadowRadius, x: Style.cardShadowX, y: Style.cardShadowY)
        )
    }
}
struct OptionButton: View {
    enum Style {
        static let cornerRadius: CGFloat = 100
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 12
        static let selectedBackgroundColor: Color = Color("primaryTextColor")
        static let unselectedBackgroundColor: Color = Color("primaryOrange").opacity(0.1)
        static let selectedTextColor: Color = .white
        static let unselectedTextColor: Color = Color("primaryOrange")
    }
    
    let text: String
    @Binding var selectedOption: String?
    let optionValue: String
    
    var body: some View {
        Button(action: {
            selectedOption = (selectedOption == optionValue) ? nil : optionValue
        }) {
            HStack(spacing: 4) {
                if selectedOption == optionValue {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Style.selectedTextColor)
                }
                Text(text)
                    .font(.system(size: 16))
                    .foregroundColor(selectedOption == optionValue ? Style.selectedTextColor : Style.unselectedTextColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Style.horizontalPadding)
            .padding(.vertical, Style.verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: Style.cornerRadius)
                    .fill(selectedOption == optionValue ? Style.selectedBackgroundColor : Style.unselectedBackgroundColor)
            )
        }
        .cornerRadius(Style.cornerRadius)
    }
}


#Preview {
    NoteSessionReviewView()
}
