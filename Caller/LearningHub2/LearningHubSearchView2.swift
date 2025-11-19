import SwiftUI

struct LearningHubSearchView2: View {
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
                VStack(spacing: 15) {
                    ForEach(0..<8) { _ in
                        SearchItemCardView2(width: 290)
                    }
                }.padding(.horizontal)
            }
        }
    }
}

private struct SearchItemCardView2: View {
    var width: CGFloat
    
    var body: some View {
        HStack(spacing: 10) {
            Image("placeholder_image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .background(Color(Constants.Colors.greyBlueBackgroundColor))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 5) {
                    Text("PERFORMANCE")
                        .font(SamaCarbonateFontLibrary.Caption.bold)
                        .foregroundColor(Color(Constants.Colors.blueBackground))
                    
                    Text("- 23 OCT, 2025")
                        .font(SamaCarbonateFontLibrary.Caption.medium)
                        .foregroundColor(Color(Constants.Colors.greyTextColor))
                }
                
                Text("Learn how companies can foster innovation at work and at home with these 20 steps")
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Image(systemName: "clock").font(.caption)
                    Text("\(3) MIN").font(SamaCarbonateFontLibrary.Caption.medium)
                }
                .foregroundColor(.gray)
            }
        }
        .padding(.bottom, 10)
    }
}

struct LearningHubSearchView2_Previews: PreviewProvider {
    static var previews: some View {
        LearningHubSearchView2()
    }
}
