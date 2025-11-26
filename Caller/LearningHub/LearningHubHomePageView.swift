import SwiftUI

struct LearningHubHomePageView: View {
    @State private var selectedItem: ResourceItem?
    @State private var showDetail: Bool = false

    let allItems: [ResourceItem] = [
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

    let relatedItems: [ResourceItem] = [
        ResourceItem(
            id: "5",
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
        VStack(alignment: .leading) {
            HStack {
                Text("Learning hub")
                    .font(SamaCarbonateFontLibrary.Title.smallBold)
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                    NotificationCenter.default.post(name: .displayTabBarIndex, object: 3)
                }) {
                    Text("View all").foregroundColor(Color(Constants.Colors.blueBackgroundColor))
                }.buttonStyle(.plain)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(allItems, id: \.id) { item in
                        ArticleCardView(
                            width: 290,
                            title: item.title,
                            duration: item.duration,
                            imageUrl: URL(
                                string: item.imageUrl
                            )
                        ) {
                            selectedItem = item
                            showDetail = true
                        }
                    }
                }
            }
        }
        .background(
            Group {
                Color.white
                NavigationLink(
                    destination: LearninghubDetailView(
                        item: selectedItem,
                        relatedItems: relatedItems
                    ),
                    isActive: $showDetail
                ) {
                    EmptyView()
                }.hidden()
            }
        )
    }
}

struct LearningHubHomePageView_Previews: PreviewProvider {
    static var previews: some View {
        LearningHubHomePageView()
    }
}
