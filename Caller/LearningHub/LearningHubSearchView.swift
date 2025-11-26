import SwiftUI

struct LearningHubSearchView: View {
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 20) {
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

                Button(action: {}) {
                    Text("cancel".localized())
                        .font(SamaCarbonateFontLibrary.Caption.medium)
                        .foregroundColor(Color(Constants.Colors.primaryOrange))
                }
            }.padding(.horizontal)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(0..<4) { _ in
                        SearchItemCardView(width: 120)
                    }
                }.padding(.horizontal)
            }
        }
    }
}

private struct SearchItemCardView: View {
    var width: CGFloat
    var hasBookmarked: Bool
    
    init(width: CGFloat, hasBookmarked: Bool = true) {
        self.width = width
        self.hasBookmarked = hasBookmarked
    }

    var body: some View {
        HStack(spacing: 15) {
            ZStack(alignment: .topTrailing) {
                AsyncImageView(
                    url: URL(string: "https://images.pexels.com/photos/6424586/pexels-photo-6424586.jpeg?auto=compress&cs=tinysrgb&w=400"),
                    width: width,
                    height: 120,
                )
                
                HStack(alignment: .top) {
                    Image(systemName: hasBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color(hasBookmarked ? Constants.Colors.primaryOrange : .gray))
                        .padding(6)
                        .background(Color.white)
                        .clipShape(Circle())
                }.offset(x: -8, y: 8)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 5) {
                    Text("PERFORMANCE")
                        .font(SamaCarbonateFontLibrary.Caption.smallBold)
                        .foregroundColor(Color(Constants.Colors.blueBackground))

                    Text("- 23 OCT, 2025")
                        .font(SamaCarbonateFontLibrary.Caption.small)
                        .foregroundColor(Color(Constants.Colors.greyTextColor))
                }

                Text("How organisations can ensure a successful work place curture")
                    .font(SamaCarbonateFontLibrary.Title.regularBold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack {
                    Image(systemName: "clock").font(SamaCarbonateFontLibrary.Caption.small)
                    Text("\(3) MIN").font(SamaCarbonateFontLibrary.Caption.small)
                }
                .foregroundColor(.gray)
            }
        }
        .padding(.bottom, 10)
    }
}

struct LearningHubSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LearningHubSearchView()
    }
}
