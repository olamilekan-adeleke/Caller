import SwiftUI

struct LearningHubHomePageView2: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Learning hub")
                    .font(SamaCarbonateFontLibrary.Title.smallBold)
                    .foregroundColor(.black)
                Spacer()
                NavigationLink(destination: LearningHubFullScreenView()) {
                    Text("View all").foregroundColor(Color(Constants.Colors.blueBackgroundColor))
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<5) { _ in
                        ArticleCardView2(width: 290)
                    }
                }
            }
        }.background(Color.white)
    }
}

struct LearningHubHomePageView2_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LearningHubHomePageView2()
        }
    }
}
