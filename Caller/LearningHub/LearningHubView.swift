import SwiftUI

struct LearningHubFullScreenView: View {
    @State private var searchText = ""
    @State private var showFilterSheet = false
    @State private var selectedCategory: String? = "Show All"
    @State private var shouldNavigateLearningResources = false
    @State private var selectedItem: ResourceItem?
    @State private var showDetail: Bool = false

    let categories = [
        "Show All",
        "Leadership",
        "Career Growth",
        "Wellbeing",
        "Mental Health",
        "Physical Fitness",
        "Nutrition",
        "Sleep Quality",
        "Work-Life Balance",
        "Mindfulness Practices",
        "Guided Meditation",
        "Breathing Exercises"
    ]

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
        VStack {
            VStack(spacing: 20) {
                header()
                searchBarView()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(allItems, id: \.id) { item in
                        LearningHubItemCard(
                            width: UIScreen.main.bounds.width - 30,
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
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(relatedItems, id: \.id) { item in
                                RelatedLearningHubItemCard(
                                    width: (UIScreen.main.bounds.width / 2) - 30,
                                    category: item.category,
                                    date: item.date,
                                    hasBookmarked: item.isBookmarked,
                                    title: item.title,
                                    duration: item.duration,
                                    imageUrl: URL(string: item.imageUrl),
                                    shouldShowTypeAndDate: false
                                ) { }
                            }
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal)
            }
        }
        .background(
            Group {
                Color.white
                // This NavigationLink is hidden but will be triggered programmatically.
                NavigationLink(
                    destination: LearningHubResources(),
                    isActive: $shouldNavigateLearningResources
                ) { EmptyView() }.hidden()

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
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .sheet(isPresented: $showFilterSheet) {
            FilterCategoriesSheet(
                isPresented: $showFilterSheet,
                selectedCategory: $selectedCategory,
                categories: categories
            )
        }
    }

    @ViewBuilder
    func searchBarView() -> some View {
        HStack(spacing: 6) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Discover resources", text: $searchText)
                    .padding(.vertical, 12)
            }
            .padding(.horizontal, 14)
            .background(Color(Constants.Colors.background))
            .cornerRadius(60)

            Button(action: { showFilterSheet = true }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color(Constants.Colors.background))
                    .clipShape(Circle())
            }
        }.padding(.horizontal)
    }

    @ViewBuilder
    func header() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Learning hub")
                    .font(SamaCarbonateFontLibrary.Title.largeBold)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                Spacer()
                Button {
                    shouldNavigateLearningResources = true
                } label: {
                    Image(systemName: "doc.append")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }.buttonStyle(.plain)
            }

            Rectangle()
                .fill(Color(Constants.Colors.placeholderText).opacity(0.5))
                .frame(width: 40, height: 4)
                .cornerRadius(2)
        }.padding(.horizontal)
    }
}

struct LearningHubFullScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LearningHubFullScreenView()
        }
    }
}
