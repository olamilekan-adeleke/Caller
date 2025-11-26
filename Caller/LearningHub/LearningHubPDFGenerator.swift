// LearningHubPDFGenerator.swift
//
// Created on 15/11/2025.
// Copyright (c) 2025 and Confidential to Sama All rights reserved.

import CoreText
import PDFKit
import UIKit

class LearningHubPDFGenerator {
    // MARK: - Constants
    private static let pageMargin: CGFloat = 20
    private static let sectionSpacing: CGFloat = 10
    private static let imageHeight: CGFloat = 200
    private static let pageSize = CGSize(width: 595, height: 842) // A4 size in points

    // MARK: - Public Methods
    static func generatePDF(
        title: String?,
        subtitle: String?,
        category: String?,
        date: String?,
        duration: Int?,
        imageUrl: String?,
        markdownContent: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let pdfData = try createPDF(
                    title: title,
                    subtitle: subtitle,
                    category: category,
                    date: date,
                    duration: duration,
                    imageUrl: imageUrl,
                    markdownContent: markdownContent
                )
                DispatchQueue.main.async {
                    completion(.success(pdfData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: - Private Methods
    private static func createPDF(
        title: String?,
        subtitle: String?,
        category: String?,
        date: String?,
        duration: Int?,
        imageUrl: String?,
        markdownContent: String
    ) throws -> Data {
        let format = UIGraphicsPDFRendererFormat()
        let metaData = [
            kCGPDFContextCreator: "Sama Coachee",
            kCGPDFContextTitle: title ?? "Learning Hub Article"
        ]
        format.documentInfo = metaData as [String: Any]

        let pageRect = CGRect(origin: .zero, size: pageSize)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        return renderer.pdfData { context in
            var currentY: CGFloat = pageMargin
            var currentPage = 0

            // Helper function to add new page if needed
            func checkAndAddPage(requiredHeight: CGFloat) {
                if currentY + requiredHeight > pageSize.height - pageMargin {
                    context.beginPage()
                    currentPage += 1
                    currentY = pageMargin
                }
            }

            // Start first page
            context.beginPage()

            // Render metadata (category, duration, date)
            if let category = category, let duration = duration, let date = date {
                let metadataText = "\(category.uppercased()) · \(duration) MIN READ · \(date)"
                let metadataFont = UIFont.systemFont(ofSize: SamaCarbonateSize.Text.caption, weight: .medium)
                let metadataAttributes: [NSAttributedString.Key: Any] = [
                    .font: metadataFont,
                    .foregroundColor: UIColor.black
                ]
                let metadataAttributedString = NSAttributedString(string: metadataText, attributes: metadataAttributes)
                let metadataSize = metadataAttributedString.boundingRect(
                    with: CGSize(width: pageSize.width - (pageMargin * 2), height: .greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    context: nil
                ).size

                checkAndAddPage(requiredHeight: metadataSize.height + sectionSpacing)
                let metadataRect = CGRect(x: pageMargin, y: currentY, width: pageSize.width - (pageMargin * 2), height: metadataSize.height)
                metadataAttributedString.draw(with: metadataRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
                currentY += metadataSize.height + sectionSpacing
            }

            // Render title
            if let title = title {
                let titleFont = UIFont.systemFont(ofSize: SamaCarbonateSize.Text.xLarge, weight: .bold)
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: titleFont,
                    .foregroundColor: UIColor.black
                ]
                let titleAttributedString = NSAttributedString(string: title, attributes: titleAttributes)
                let titleSize = titleAttributedString.boundingRect(
                    with: CGSize(width: pageSize.width - (pageMargin * 2), height: .greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    context: nil
                ).size

                checkAndAddPage(requiredHeight: titleSize.height + sectionSpacing)
                let titleRect = CGRect(x: pageMargin, y: currentY, width: pageSize.width - (pageMargin * 2), height: titleSize.height)
                titleAttributedString.draw(with: titleRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
                currentY += titleSize.height + sectionSpacing
            }

            // Render header image
            if let imageUrlString = imageUrl, let imageUrl = URL(string: imageUrlString) {
                if let imageData = try? Data(contentsOf: imageUrl),
                   let image = UIImage(data: imageData) {
                    let imageWidth = pageSize.width - (pageMargin * 2)
                    let aspectRatio = image.size.height / image.size.width
                    let calculatedImageHeight = min(imageWidth * aspectRatio, Self.imageHeight)

                    checkAndAddPage(requiredHeight: calculatedImageHeight + sectionSpacing)
                    let imageRect = CGRect(x: pageMargin, y: currentY, width: imageWidth, height: calculatedImageHeight)
                    image.draw(in: imageRect)
                    currentY += calculatedImageHeight + sectionSpacing
                }
            }

            // Render subtitle
            if let subtitle = subtitle {
                let subtitleFont = UIFont.systemFont(ofSize: SamaCarbonateSize.Text.large, weight: .bold)
                let subtitleAttributes: [NSAttributedString.Key: Any] = [
                    .font: subtitleFont,
                    .foregroundColor: UIColor.black
                ]
                let subtitleAttributedString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
                let subtitleSize = subtitleAttributedString.boundingRect(
                    with: CGSize(width: pageSize.width - (pageMargin * 2), height: .greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    context: nil
                ).size

                checkAndAddPage(requiredHeight: subtitleSize.height + sectionSpacing)
                subtitleAttributedString.draw(at: CGPoint(x: pageMargin, y: currentY))
                currentY += subtitleSize.height + sectionSpacing
            }

            // Render markdown content
            let markdownAttributedString = parseMarkdownToAttributedString(markdownContent)
            let framesetter = CTFramesetterCreateWithAttributedString(markdownAttributedString)
            var currentRange = CFRange(location: 0, length: 0)
            var done = false

            while !done {
                var textRect = CGRect(
                    x: pageMargin,
                    y: currentY,
                    width: pageSize.width - (pageMargin * 2),
                    height: pageSize.height - currentY - pageMargin
                )

                let path = CGPath(rect: textRect, transform: nil)
                let frame = CTFramesetterCreateFrame(framesetter, currentRange, path, nil)
                let frameRange = CTFrameGetVisibleStringRange(frame)

                CTFrameDraw(frame, context.cgContext)

                currentRange.location += frameRange.length
                currentRange.length = 0

                if currentRange.location >= markdownAttributedString.length {
                    done = true
                } else {
                    // Need new page
                    context.beginPage()
                    currentPage += 1
                    currentY = pageMargin
                }
            }
        }
    }

    private static func parseMarkdownToAttributedString(_ markdown: String) -> NSAttributedString {
        let bodyFont = UIFont.systemFont(ofSize: SamaCarbonateSize.Text.regular)
        let boldFont = UIFont.systemFont(ofSize: SamaCarbonateSize.Text.regular, weight: .bold)
        let headerFont = UIFont.systemFont(ofSize: SamaCarbonateSize.Text.large, weight: .bold)
        let linkColor = Constants.Colors.primaryBlue

        let result = NSMutableAttributedString()
        let lines = markdown.components(separatedBy: .newlines)

        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)

            if trimmedLine.isEmpty {
                result.append(NSAttributedString(string: "\n", attributes: [.font: bodyFont]))
                continue
            }

            // Check for headers (##)
            if trimmedLine.hasPrefix("## ") {
                let headerText = String(trimmedLine.dropFirst(3))
                let headerAttributes: [NSAttributedString.Key: Any] = [
                    .font: headerFont,
                    .foregroundColor: UIColor.black
                ]
                result.append(NSAttributedString(string: headerText + "\n\n", attributes: headerAttributes))
                continue
            }

            // Parse links, bold text, and regular text
            var currentIndex = trimmedLine.startIndex
            var currentAttributes: [NSAttributedString.Key: Any] = [
                .font: bodyFont,
                .foregroundColor: UIColor.black
            ]

            while currentIndex < trimmedLine.endIndex {
                // Look for markdown links [text](url) first (links take priority)
                if let linkStart = trimmedLine.range(of: "[", range: currentIndex..<trimmedLine.endIndex),
                   let linkEnd = trimmedLine.range(of: "](", range: linkStart.upperBound..<trimmedLine.endIndex),
                   let urlEnd = trimmedLine.range(of: ")", range: linkEnd.upperBound..<trimmedLine.endIndex) {
                    // Add text before link (may contain bold)
                    if linkStart.lowerBound > currentIndex {
                        let beforeText = String(trimmedLine[currentIndex..<linkStart.lowerBound])
                        result.append(parseBoldText(beforeText, baseAttributes: currentAttributes))
                    }

                    // Add link text
                    let linkText = String(trimmedLine[linkStart.upperBound..<linkEnd.lowerBound])
                    let urlString = String(trimmedLine[linkEnd.upperBound..<urlEnd.lowerBound])

                    var linkAttributes = currentAttributes
                    linkAttributes[.foregroundColor] = linkColor
                    linkAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
                    if let url = URL(string: urlString) {
                        linkAttributes[.link] = url
                    }

                    result.append(NSAttributedString(string: linkText, attributes: linkAttributes))

                    currentIndex = urlEnd.upperBound
                } else {
                    // No more links, parse remaining text (may contain bold)
                    let remainingText = String(trimmedLine[currentIndex...])
                    result.append(parseBoldText(remainingText, baseAttributes: currentAttributes))
                    break
                }
            }

            result.append(NSAttributedString(string: "\n\n", attributes: [.font: bodyFont]))
        }

        return result
    }

    private static func parseBoldText(_ text: String, baseAttributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let bodyFont = UIFont.systemFont(ofSize: SamaCarbonateSize.Text.regular)
        let boldFont = UIFont.systemFont(ofSize: SamaCarbonateSize.Text.regular, weight: .bold)
        let result = NSMutableAttributedString()
        var currentIndex = text.startIndex

        while currentIndex < text.endIndex {
            // Look for **text** pattern
            if let boldStart = text.range(of: "**", range: currentIndex..<text.endIndex),
               let boldEnd = text.range(of: "**", range: boldStart.upperBound..<text.endIndex) {
                // Add text before bold
                if boldStart.lowerBound > currentIndex {
                    let beforeText = String(text[currentIndex..<boldStart.lowerBound])
                    var attributes = baseAttributes
                    attributes[.font] = bodyFont
                    result.append(NSAttributedString(string: beforeText, attributes: attributes))
                }

                // Add bold text
                let boldText = String(text[boldStart.upperBound..<boldEnd.lowerBound])
                var boldAttributes = baseAttributes
                boldAttributes[.font] = boldFont
                result.append(NSAttributedString(string: boldText, attributes: boldAttributes))

                currentIndex = boldEnd.upperBound
            } else if let boldStart = text.range(of: "__", range: currentIndex..<text.endIndex),
                      let boldEnd = text.range(of: "__", range: boldStart.upperBound..<text.endIndex) {
                // Add text before bold (__text__ pattern)
                if boldStart.lowerBound > currentIndex {
                    let beforeText = String(text[currentIndex..<boldStart.lowerBound])
                    var attributes = baseAttributes
                    attributes[.font] = bodyFont
                    result.append(NSAttributedString(string: beforeText, attributes: attributes))
                }

                // Add bold text
                let boldText = String(text[boldStart.upperBound..<boldEnd.lowerBound])
                var boldAttributes = baseAttributes
                boldAttributes[.font] = boldFont
                result.append(NSAttributedString(string: boldText, attributes: boldAttributes))

                currentIndex = boldEnd.upperBound
            } else {
                // No more bold patterns, add remaining text
                let remainingText = String(text[currentIndex...])
                var attributes = baseAttributes
                attributes[.font] = bodyFont
                result.append(NSAttributedString(string: remainingText, attributes: attributes))
                break
            }
        }

        return result
    }
}
