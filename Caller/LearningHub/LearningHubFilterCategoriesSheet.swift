//
//  LearningHubFilterCategoriesSheet.swift
//  Caller
//
//  Created by Kod Engima on 02/11/2025.
//

import SwiftUI

struct FilterCategoriesSheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedCategory: String?
    let categories: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Categories").font(.system(size: 18, weight: .bold))
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
            }
            .padding(.top)

            ScrollView(.vertical, showsIndicators: false) {
                ForEach(Array(categories.enumerated()), id: \.element) { index, category in
                    VStack(alignment: .center) {
                        HStack( spacing: 12) {
                            CircularCheckbox(isSelected: selectedCategory == category)
                            Text(category)
                                .font(SamaCarbonateFontLibrary.Title.regularMedium)

                            Spacer()
                        }
                        .padding(.top, 2)
                        .onTapGesture {
                            selectedCategory = category
                            isPresented = false
                        }

                        if index < categories.count - 1 {
                            Divider().padding(.vertical, 5)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal)
        .background(Color.white)
    }
}

struct CircularCheckbox: View {
    let isSelected: Bool
    let size: CGFloat = 28

    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .stroke(isSelected ? Color(red: 0.9, green: 0.4, blue: 0.4) : Color.gray.opacity(0.3), lineWidth: 2)
                .background(
                    Circle()
                        .fill(isSelected ? Color(red: 0.9, green: 0.4, blue: 0.4) : Color.white)
                )
                .frame(width: size, height: size)

            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.leading, 4)
    }
}
