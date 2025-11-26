import SwiftUI

struct LearningHubFullScreenView2: View {
    @State private var searchText = ""
    @State private var showFilterSheet = false
    @State private var selectedCategory: String? = "Show All"
    
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
    
    var body: some View {
        VStack(spacing: 20) {
            header()
            searchBarView()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(0..<5) { idx in
                        LearningHubItemCard2(
                            width: UIScreen.main.bounds.width - 30,
                            isNew: idx == 0,
                            hasBookmarked: idx % 2 == 0,
                            bookmarkTap: {},
                            title: "10 habits to improve your focus",
                            subtitle: "Achieving a healthy work-life balance can feel like an impossible task. With the demands of work and other stuf like that",
                            duration: 3,
                            imageUrl: URL(string: "https://images.pexels.com/photos/6424586/pexels-photo-6424586.jpeg?auto=compress&cs=tinysrgb&w=400")
                        )
                    }
                }.padding(.horizontal)
            }
        }
        .background(Color.white)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .sheet(isPresented: $showFilterSheet) {
            FilterCategoriesSheet2(
                isPresented: $showFilterSheet,
                selectedCategory: $selectedCategory,
                categories: categories
            )
        }
    }
    
    @ViewBuilder
    func searchBarView()  -> some View {
        HStack(spacing: 6) {
            NavigationLink(destination: LearningHubSearchView2()) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Discover resources", text: $searchText)
                        .padding(.vertical, 12)
                    Spacer()
                }
                .padding(.horizontal, 14)
                .background(Color(Constants.Colors.background))
                .cornerRadius(60)
            }
            
            Button(action: { showFilterSheet = true  }) {
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
    func header()  -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Learning hub")
                    .font(SamaCarbonateFontLibrary.Title.largeBold)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "doc.append")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                
            }
            
            Rectangle()
                .fill(Color(Constants.Colors.placeholderText).opacity(0.5))
                .frame(width: 40, height: 4)
                .cornerRadius(2)
        }.padding(.horizontal)
    }
}

struct LearningHubFullScreenView2_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LearningHubFullScreenView2()
        }
    }
}
