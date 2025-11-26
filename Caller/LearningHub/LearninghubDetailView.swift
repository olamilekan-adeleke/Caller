// LearninghubDetailView.swift
//
// Created on 15/11/2025.
// Copyright (c) 2025 and Confidential to Sama All rights reserved.

import SwiftUI

struct LearninghubDetailView: View {
    @State var showShareSheet: Bool = false
    @State var isBookmarked: Bool = false
    @State var showFeebackSection: Bool = true
    @State var positiveFeedBack: Bool = false
    @State var negativeFeedBack: Bool = false
    @State private var pdfData: Data?
    @State private var isGeneratingPDF: Bool = false
    let item: ResourceItem?
    let relatedItems: [ResourceItem]
    let apiResponse = """
        Companies can encourage and teach employees how to innovate at work in a variety of ways.

        ## Flatten the hierarchy
        Successful innovation at work requires effective collaboration with leaders and [across different teams](https://google.com). These interactions are a catalyst for sharing knowledge and achieving successful breakthroughs.

        A flat structure allows employees at every level to be empowered to take action and decisions are made faster.

        ### Leverage diversity
        Diversity can push employees to be innovative at work. People with different backgrounds and perspectives bring different frames of reference to a problem. This sparks a dynamic exchange of ideas - a prerequisite for innovation which thrives when you hire for diversity and commit to building an inclusive environment where everyone has a voice.
        """

    var body: some View {
        ScrollView(showsIndicators: false) {
            if let category = item?.category, let duration = item?.duration, let date = item?.date {
                Text("\(category.uppercased()) · \(duration) MIN READ · \(date)")
                    .font(SamaCarbonateFontLibrary.Caption.small)
                    .foregroundColor(SamaCarbonateColorTheme.primaryTextColor)
                    .padding(.top)
            }

            if let title = item?.title {
                Text(title)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .font(SamaCarbonateFontLibrary.Title.xtralargeBold)
                    .foregroundColor(SamaCarbonateColorTheme.primaryTextColor)
                    .padding(.horizontal)
                    .padding(.top, 5)
            }

            headerImage

            if let subtitle = item?.subtitle {
                Text(subtitle)
                    .multilineTextAlignment(.leading)
                    .font(SamaCarbonateFontLibrary.Title.smallBold)
                    .foregroundColor(SamaCarbonateColorTheme.primaryTextColor)
                    .padding(.horizontal, 12)
            }

            if let markdownText = try? AttributedString(markdown: apiResponse) {
                Text(markdownText)
                    .tint(Color(Constants.Colors.primaryBlue))
                    .padding()
            }

            if showFeebackSection {
                feedbackSection
            }

            Text("you_might_also_like".localized())
                .font(SamaCarbonateFontLibrary.Title.largeBold)
                .foregroundColor(SamaCarbonateColorTheme.primaryTextColor)
                .padding()

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                alignment: .leading,
                spacing: 10
            ) {
                ForEach(relatedItems, id: \.id) { item in
                    RelatedLearningHubItemCard(
                        width: (UIScreen.main.bounds.width / 2) - 22,
                        category: item.category,
                        date: item.date,
                        hasBookmarked: item.isBookmarked,
                        title: item.title,
                        duration: item.duration,
                        imageUrl: URL(string: item.imageUrl)
                    ) {
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
                }
            }.padding()
        }
        .navigationBarTitle("")
        .navigationBarHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(alignment: .top) {
                    // Share - Export to pdf
                    Button(action: { generateAndSharePDF() }) {
                        if isGeneratingPDF {
                            ProgressView()
                                .scaleEffect(0.8)
                                .padding(.top, 2)
                        } else {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(.black))
                                .rotationEffect(.init(degrees: 180))
                                .padding(.top, 2)
                        }
                    }
                    .disabled(isGeneratingPDF)

                    // BookMark
                    Button(action: {
                        isBookmarked.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            _ = TopToasters.shared.present(
                                style: .info, text: isBookmarked ? "articleSaved".localized() : "articleRemoved".localized()
                            )
                        }
                    }) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(isBookmarked ? Constants.Colors.primaryOrange : .black))
                    }
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let pdfData = pdfData {
                let fileName = sanitizeFileName("article-\(item?.title ?? "article").pdf")
                let tempURL = createTemporaryPDFFile(data: pdfData, fileName: fileName)
                ShareSheet(items: [tempURL]) {
                    // Clean up temporary file after sharing completes
                    try? FileManager.default.removeItem(at: tempURL)
                }
            }
        }
    }

    // MARK: - PDF Generation
    private func generateAndSharePDF() {
        guard let item = item else {
            _ = TopToasters.shared.present(
                style: .warning,
                text: "Unable to generate PDF. Article data is missing."
            )
            return
        }

        isGeneratingPDF = true

        LearningHubPDFGenerator.generatePDF(
            title: item.title,
            subtitle: item.subtitle,
            category: item.category,
            date: item.date,
            duration: item.duration,
            imageUrl: item.imageUrl,
            markdownContent: apiResponse
        ) { result in
            isGeneratingPDF = false

            switch result {
            case .success(let data):
                pdfData = data
                showShareSheet = true

            case .failure(let error):
                _ = TopToasters.shared.present(
                    style: .warning,
                    text: "Failed to generate PDF: \(error.localizedDescription)"
                )
            }
        }
    }

    private func sanitizeFileName(_ fileName: String) -> String {
        let invalidCharacters = CharacterSet(charactersIn: ":/\\?%*|\"<>")
        let sanitized = fileName.components(separatedBy: invalidCharacters).joined(separator: "_")
        return String(sanitized.prefix(100)) // Limit length
    }

    private func createTemporaryPDFFile(data: Data, fileName: String) -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let tempURL = tempDirectory.appendingPathComponent(fileName)

        try? data.write(to: tempURL)

        return tempURL
    }

    private var headerImage: some View {
        AsyncImage(url: URL(string: item?.imageUrl ?? "")) { phase in
            switch phase {
            case .empty:
                ProgressView()

            case .success(let image):
                image
                    .resizable()
                    .frame(width: .infinity, height: UIScreen.main.bounds.height * 0.25)
                    .scaledToFit()

            case .failure:
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text("Failed to load")
                        .font(.caption)
                }

            @unknown default:
                EmptyView()
            }
        }.padding(.vertical)
    }

    private var feedbackSection: some View {
        VStack(alignment: .center) {
            Text("is_this_article_useful".localized())
                .font(SamaCarbonateFontLibrary.Title.smallBold)
                .foregroundColor(SamaCarbonateColorTheme.primaryTextColor)

            HStack(spacing: 8) {
                Spacer()
                FeedbackButton(
                    iconName: "hand.thumbsdown.fill",
                    isSelected: negativeFeedBack,
                    isThumbsUp: false
                ) {
                    negativeFeedBack.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            showFeebackSection = false
                        }
                    }
                }
                FeedbackButton(
                    iconName: "hand.thumbsup.fill",
                    isSelected: positiveFeedBack,
                    isThumbsUp: true
                ) {
                    positiveFeedBack.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            showFeebackSection = false
                        }
                    }
                }
                Spacer()
            }
        }
        .padding(.top)
    }
}

struct LearninghubDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LearninghubDetailView(
            item: ResourceItem(
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
            relatedItems: []
        )
    }
}
