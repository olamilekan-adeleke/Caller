//
//  Top5ValuesView.swift
//  Caller
//
//  Created by Kod Enigma on 30/04/2025.
//

import SwiftUI

struct Top5ValuesView: View {
    enum ViewPadding {
        static let bodyTopPadding: CGFloat = 30
        static let horizontalPadding: CGFloat = 20
    }
    
    let userFirstName: String
    let topValues: [String]?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(wellbeingCategories, id: \.self) { category in
                Text(category).font(SamaCarbonateFontLibrary.Body.medium)
                    .padding(.horizontal, ViewPadding.horizontalPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.top, ViewPadding.bodyTopPadding)
        .background(Color.white)
        .navigationBarTitle(
            "\(userFirstName) Top 5 Values",
            displayMode: .inline
        )
        .navigationBarBackButtonHidden(false)
    }
    
    let staticValue = [
        "career": "User Career",
        "fin": "Finance Data",
        "p_d": "Personal Development",
        "pur": "Purpose",
        "health": "Health Data"
    ]
    private var wellbeingCategories: [String] {
        guard let topValues = topValues, !topValues.isEmpty, !staticValue.isEmpty else {
            return []
        }
        
        return topValues.compactMap { key in
            if let name = staticValue[key] {
                return name
            }
            return nil
        }
    }
}

#Preview {
    Top5ValuesView(
        userFirstName: "Ola",
        topValues: [ "career", "fin", "p_d", "pur", "health" ]
    )
}
