import SwiftUI

import SwiftUI

struct LearningHubItemCard: View {
    var width: CGFloat
    let isNew: Bool
    let hasBookmarked: Bool
    let bookmarkTap: (() -> Void)?
    let title: String
    let subtitle: String
    let duration: Int
    let imageUrl: URL?
    
    init(width: CGFloat, isNew: Bool = false, hasBookmarked: Bool = false, bookmarkTap: (() -> Void)? = {}, title: String, subtitle: String, duration: Int, imageUrl: URL? = nil) {
        self.width = width
        self.isNew = isNew
        self.hasBookmarked = hasBookmarked
        self.bookmarkTap = bookmarkTap
        self.title = title
        self.subtitle = subtitle
        self.duration = duration
        self.imageUrl = imageUrl
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                AsyncImageView(url: imageUrl, width: width, height: 145)
                
                HStack(alignment: .top) {
                    if isNew {
                        Text("NEW")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color(Constants.Colors.primaryOrange))
                            .clipShape(Rectangle())
                            .cornerRadius(6)
                            .padding(.top, 6)
                    }
                    
                    Button(action: { bookmarkTap?() }) {
                        Image(systemName: hasBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(hasBookmarked ? Constants.Colors.primaryOrange : .gray))
                            .padding(11)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                }
                .offset(x: -10, y: 10)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                
                Text(subtitle)
                    .font(SamaCarbonateFontLibrary.Caption.medium)
                    .foregroundColor(Color(Constants.Colors.greyTextColor))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Image(systemName: "clock").font(SamaCarbonateFontLibrary.Caption.medium)
                    Text("\(duration) MIN READ").font(SamaCarbonateFontLibrary.Caption.medium)
                }
                .foregroundColor(Color(Constants.Colors.bodyText))
            }
            .frame(width: width * 0.84)
            .padding(.top, 5)
            .padding(.horizontal)
        }
        .frame(width: width)
    }
}

struct AsyncImageView: View {
    @State private var image: UIImage?
    @State private var isLoading = false
    let url: URL?
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(url: URL?, width: CGFloat, height: CGFloat, cornerRadius: CGFloat = 20) {
        self.url = url
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipped()
                    .cornerRadius(cornerRadius)
            } else if isLoading {
                ProgressView()
                    .frame(width: width, height: height)
                    .background(Color.gray)
                    .cornerRadius(cornerRadius)
            } else {
                Color.gray
                    .frame(width: width, height: height)
                    .cornerRadius(cornerRadius)
            }
        }
        .onAppear { loadImage() }
    }
    
    private func loadImage() {
        guard let url = url else { return }
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                isLoading = false
                if let data = data {
                    image = UIImage(data: data)
                }
            }
        }.resume()
    }
}

// MARK: - Usage Example
#Preview {
    LearningHubItemCard(
        width: 300,
        isNew: true,
        hasBookmarked: false,
        bookmarkTap: { print("Bookmarked!") },
        title: "SwiftUI Mastery",
        subtitle: "Learn advanced SwiftUI patterns and best practices",
        duration: 12,
        imageUrl: URL(string: "https://images.pexels.com/photos/6424586/pexels-photo-6424586.jpeg?auto=compress&cs=tinysrgb&w=400")
    )
}

struct ArticleCardView: View {
    var width: CGFloat

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImageView(
                url: URL(string: "https://images.pexels.com/photos/6424586/pexels-photo-6424586.jpeg?auto=compress&cs=tinysrgb&w=400"),
                width: width,
                height: 140,
                cornerRadius: 0
            )
            
            Text("Learn how companies can foster innovation at work and at home with these 20 steps")
                .font(.headline)
                .lineLimit(3)
                .padding(.top, 5)
                .padding(.horizontal)
                .multilineTextAlignment(.leading)

            HStack {
                Image(systemName: "clock").font(.caption)
                Text("\(3) MIN READ").font(SamaCarbonateFontLibrary.Caption.medium)
            }
            .foregroundColor(.gray)
            .padding(.top, 2)
            .padding(.horizontal)
        }
        .frame(width: width)
        .padding(.bottom, 10)
        .background(Color(Constants.Colors.greyBlueBackgroundColor))
        .cornerRadius(10)
    }
}
