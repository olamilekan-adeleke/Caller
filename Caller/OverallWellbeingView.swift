//
//  Top5ValuesView.swift
//  Caller
//
//  Created by Kod Enigma on 30/04/2025.
//

import SwiftUI

struct OverallWellbeingView: View {
    enum ViewPadding {
        static let bodyTopPadding: CGFloat = 30
        static let horizontalPadding: CGFloat = 20
    }
    
    let userFirstName: String
    let personalValues: [String: Int]?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(wellbeingCategories, id: \.0) { category, score in
                HStack {
                    Text("\(category):")
                        .font(SamaCarbonateFontLibrary.Body.medium)
                    Spacer()
                    HStack {
                        Text("\(score)").font(SamaCarbonateFontLibrary.Title.regularBold)
                        Text("/ 5").font(SamaCarbonateFontLibrary.Body.medium)
                    }
                }
                .padding(.horizontal, ViewPadding.horizontalPadding)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, ViewPadding.bodyTopPadding)
        .background(Color.white)
        .navigationBarTitle(
            "\(userFirstName) overall wellbeing",
            displayMode: .inline
        )
        .navigationBarBackButtonHidden(false)
    }
    
    let staticValue =  [
        
                    "career": "User Career",
        
                    "fin": "Finance Data",
        
                    "p_d": "Personal Development",
        
                    "pur": "Purpose",
        
                    "health": "Health Data"
        
                ]
    private var wellbeingCategories: [(key: String, value: Int)] {
        guard let personalValues = personalValues, !personalValues.isEmpty, !staticValue.isEmpty else {
              return []
          }

          return personalValues.compactMap { (key, value) in
              if let name = staticValue[key] {
                  return (key: name, value: value)
              }
              return nil
          }
    }
}

#Preview {
    OverallWellbeingView(
        userFirstName: "Ola",
        personalValues: [
            
                "career": 3,
            
                "fin": 4,
            
                      "p_d": 2,
            
                       "pur": 3,
            
                       "health": 3
            
                    ]
    )
}
