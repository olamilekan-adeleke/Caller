// LearningHubResources.swift
//
// Created on 03/11/2025.
// Copyright (c) 2025 and Confidential to Sama All rights reserved.

import SwiftUI

enum ResourceTab: String, CaseIterable, Identifiable {
    case bookmarks
    case history

    var id: String { self.rawValue }

    var localizedName: String {
        switch self {
        case .bookmarks:
            return "bookmarks".localized()

        case .history:
            return "history".localized()
        }
    }
}

struct ResourceItem {
    let id: String
    let title: String
    let subtitle: String
    let category: String
    let date: String
    let duration: Int
    let isNew: Bool
    let isBookmarked: Bool
    let imageUrl: String
}

struct LearningHubResources: View {
    @State private var selectedTab: ResourceTab = .bookmarks
    @State private var selectedItem: ResourceItem?
    @State private var showDetail: Bool = false

    let bookmarkedItems: [ResourceItem] = [
        ResourceItem(
            id: "1",
            title: "10 habits to improve your focus",
            subtitle: "Achieving a healthy work-life balance can feel like an impossible task. With the demands of work and other stuf like that",
            category: "PRODUCTIVITY",
            date: "SEP 5, 2025",
            duration: 5,
            isNew: true,
            isBookmarked: true,
            imageUrl: "https://images.pexels.com/photos/6424586/pexels-photo-6424586.jpeg?auto=compress&cs=tinysrgb&w=400"
        ),
        ResourceItem(
            id: "2",
            title: "Learn how companies can foster innovation at work",
            subtitle: "Learn practical strategies to maintain mental strength and adaptability when facing difficult situations",
            category: "PRODUCTIVITY",
            date: "SEP 5, 2025",
            duration: 7,
            isNew: false,
            isBookmarked: true,
            imageUrl: "https://images.pexels.com/photos/6424586/pexels-photo-6424586.jpeg?auto=compress&cs=tinysrgb&w=400"
        ),
        ResourceItem(
            id: "3",
            title: "Mindfulness practices for daily life",
            subtitle: "Discover simple techniques to incorporate mindfulness into your everyday routine and reduce stress",
            category: "PRODUCTIVITY",
            date: "SEP 5, 2025",
            duration: 4,
            isNew: true,
            isBookmarked: true,
            imageUrl: "https://images.pexels.com/photos/6424586/pexels-photo-6424586.jpeg?auto=compress&cs=tinysrgb&w=400"
        ),
        ResourceItem(
            id: "4",
            title: "Effective communication strategies",
            subtitle: "Improve your relationships and professional interactions with proven communication techniques",
            category: "PRODUCTIVITY",
            date: "SEP 5, 2025",
            duration: 6,
            isNew: false,
            isBookmarked: true,
            imageUrl: "https://images.pexels.com/photos/6424586/pexels-photo-6424586.jpeg?auto=compress&cs=tinysrgb&w=400"
        )
    ]

    let historyItems: [ResourceItem] = [
        ResourceItem(
            id: "5",
            title: "Time management essentials",
            subtitle: "Master the art of prioritizing tasks and maximizing productivity throughout your day",
            category: "PRODUCTIVITY",
            date: "SEP 5, 2025",
            duration: 3,
            isNew: false,
            isBookmarked: false,
            imageUrl: "https://images.pexels.com/photos/6424586/pexels-photo-6424586.jpeg?auto=compress&cs=tinysrgb&w=400"
        ),
        ResourceItem(
            id: "6",
            title: "Stress reduction techniques",
            subtitle: "Explore various methods to manage and reduce stress in your personal and professional life",
            category: "PRODUCTIVITY",
            date: "SEP 5, 2025",
            duration: 5,
            isNew: false,
            isBookmarked: false,
            imageUrl: "https://images.pexels.com/photos/6424586/pexels-photo-6424586.jpeg?auto=compress&cs=tinysrgb&w=400"
        ),
        ResourceItem(
            id: "7",
            title: "Goal setting and achievement",
            subtitle: "Learn how to set meaningful goals and develop a systematic approach to achieving them",
            category: "PRODUCTIVITY",
            date: "SEP 5, 2025",
            duration: 4,
            isNew: true,
            isBookmarked: false,
            imageUrl: "https://images.pexels.com/photos/6424586/pexels-photo-6424586.jpeg?auto=compress&cs=tinysrgb&w=400"
        ),
        ResourceItem(
            id: "8",
            title: "Goal setting and achievement",
            subtitle: "Learn how to set meaningful goals and develop a systematic approach to achieving them",
            category: "PRODUCTIVITY",
            date: "SEP 5, 2025",
            duration: 4,
            isNew: true,
            isBookmarked: false,
            imageUrl: "https://images.pexels.com/photos/6424586/pexels-photo-6424586.jpeg?auto=compress&cs=tinysrgb&w=400"
        )
    ]

    var body: some View {
        VStack(spacing: 20) {
            CustomSegmentedPicker(selection: $selectedTab, tabs: [ResourceTab.bookmarks, ResourceTab.history]) { tab in
                tab.localizedName
            }
            .padding(.horizontal, 50)
            .padding(.top, 10)

            ScrollView(.vertical, showsIndicators: false) {
                GeometryReader { geometry in
                    let cardWidth = geometry.size.width - 30
                    let currentItems = selectedTab == .bookmarks ? bookmarkedItems : historyItems

                    Group {
                        if #available(iOS 14.0, *) {
                            LazyVStack(spacing: 20) {
                                listContent(cardWidth: cardWidth, currentItems: currentItems)
                            }
                        } else {
                            VStack(spacing: 20) {
                                listContent(cardWidth: cardWidth, currentItems: currentItems)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(width: geometry.size.width)
                }
                .frame(minHeight: UIScreen.main.bounds.height + 300)
            }
        }
        .background(
            Group {
                Color.white
                NavigationLink(
                    destination: LearninghubDetailView(
                        item: selectedItem,
                        relatedItems: historyItems
                    ),
                    isActive: $showDetail
                ) {
                    EmptyView()
                }.hidden()
            }
        )
        .navigationBarTitle("my_resources".localized())
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    func listContent(cardWidth: CGFloat, currentItems: [ResourceItem]) -> some View {
        if currentItems.isEmpty {
            VStack {
                Spacer()
                Text(selectedTab == .bookmarks ? "no_bookmarks_yet".localized() : "no_history_yet".localized())
                    .font(SamaCarbonateFontLibrary.Body.medium)
                    .foregroundColor(Color(Constants.Colors.greyTextColor))
                Spacer()
            }
            .frame(height: 200)
        } else {
            ForEach(currentItems, id: \.id) { item in
                LearningHubItemCard(
                    width: cardWidth,
                    isNew: item.isNew,
                    hasBookmarked: item.isBookmarked,
                    bookmarkTap: {},
                    title: item.title,
                    subtitle: item.subtitle,
                    duration: item.duration,
                    imageUrl: URL(string: item.imageUrl)
                ) {
                    selectedItem = item
                    showDetail = true
                }
            }
        }
    }
}


#Preview {
    NavigationView {
        LearningHubResources()
    }
}
