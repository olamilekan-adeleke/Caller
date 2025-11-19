//
//  Cmp.swift
//  Caller
//
//  Created by Kod Enigma on 11/02/2025.
//

import SwiftUI

struct SamaLabeledTextField: View {
    let title: String
    let hintText: String
    @Binding var text: String
    let backgroundColor: Color?
    
    init(title: String, hintText: String, text: Binding<String>, backgroundColor: Color? = nil) {
        self.title = title
        self.hintText = hintText
        self._text = text
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            TextField(hintText, text: $text)
                .padding()
                .background(backgroundColor ?? Color.clear)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: backgroundColor != nil ? 0 : 1)
                )
        }
        .padding(.bottom, 8)
    }
}

struct SamaDateOfBirthField: View {
    let title: String
    let hintText: String
    @Binding var selectedDate: Date
    @State private var isDatePickerShown = false
    @State private var temporaryDate: Date
    let backgroundColor: Color?
    let titleFont: Font?
    let titleColor: Color?
    let suffixIcon: AnyView?

    
    public init(
        title: String,
        hintText: String,
        selectedDate: Binding<Date>,
        backgroundColor: Color? = nil,
        titleFont: Font? = nil,
        titleColor: Color? = nil,
        suffixIcon: AnyView? = nil
    ) {
        self.title = title
        self.hintText = hintText
        self._selectedDate = selectedDate
        self._temporaryDate = State(initialValue: selectedDate.wrappedValue)
        self.backgroundColor = backgroundColor
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.suffixIcon = suffixIcon
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let currentDate = Date()
        let minDate = calendar.date(byAdding: .year, value: -120, to: currentDate)!
        return minDate...currentDate
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: SamaCarbonateSpacing.xxSmall) {
            Text(title)
                .font(titleFont ?? Font.headline)
                .foregroundColor(titleColor ?? .gray)
            
            Button(action: {
                temporaryDate = selectedDate
                isDatePickerShown = true
            }) {
                HStack {
                    Text(selectedDate == Date() ? hintText : dateFormatter.string(from: selectedDate))
                        .foregroundColor(selectedDate == Date() ? .gray : .primary)
                    Spacer()
                    if suffixIcon != nil { suffixIcon }
                }
                .padding()
                .background(backgroundColor ?? Color.clear)
                .cornerRadius(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: backgroundColor != nil ? 0 : 1)
                    )
            }
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $isDatePickerShown) {
            NavigationView {
                DatePicker(
                    "Select Date",
                    selection: $temporaryDate,
                    in: dateRange,
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)  // Compatible wi
                .navigationTitle("Date of Birth")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { isDatePickerShown = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            selectedDate = temporaryDate
                            isDatePickerShown = false
                        }
                    }
                }.padding()
            }
        }
    }
}

struct SamaMultiLabeledTextField: View {
    let title: String
    let hintText: String
    let items: [String]
    @Binding var selectedOptions: [String]
    
    @State private var showPicker = false
    @State private var pickerSelection = ""
    @State private var sheetHeight: CGFloat = .zero
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline).foregroundColor(.gray)
            
            Button(action: { showPicker = true }) {
                HStack {
                    Text(hintText).foregroundColor(selectedOptions.isEmpty ? .gray : .primary)
                    Spacer()
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray4), lineWidth: 1))
            }
            
            if !selectedOptions.isEmpty {
                TagCloudView(tags: selectedOptions, onDelete: { tag in
                    selectedOptions.removeAll { $0 == tag }
                })
            }
        }
        .padding(.bottom, 8)
        .sheet(isPresented: $showPicker) {
            PickerSheetView(
                items: items,
                selection: $pickerSelection,
                showPicker: $showPicker,
                onSelect: {
                    if !pickerSelection.isEmpty {
                        selectedOptions.append(pickerSelection)
                        pickerSelection = ""
                    }
                    showPicker = false
                }
            )
        }
    }
}
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { value = nextValue() }
}


private struct PickerSheetView: View {
    let items: [String]
    @Binding var selection: String
    @Binding var showPicker: Bool
    let onSelect: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select", selection: $selection) {
                    ForEach(items, id: \.self) {
                        Text($0).tag($0)
                    }
                }
                .pickerStyle(.wheel)
                .padding()
            }
            .navigationTitle("Select Option")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {showPicker = false}
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: onSelect)
                }
            }
            .onAppear { if selection.isEmpty { selection = items.first ?? "" } }
        }
    }
}

private struct TagCloudView: View {
    let tags: [String]
    let onDelete: (String) -> Void
    @State private var totalHeight: CGFloat = .zero
    
    var body: some View {
        GeometryReader { self.generateContent(in: $0) }
            .frame(height: totalHeight)
            .onPreferenceChange(ViewHeightKey.self) {
                self.totalHeight = $0
            }
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                TagView(tag: tag, onDelete: onDelete)
                    .padding(.vertical, 4)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == self.tags.last! {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tag == self.tags.last! { height = 0 }
                        return result
                    })
            }
        }
        .background(GeometryReader { proxy in
            Color.clear.preference(key: ViewHeightKey.self, value: proxy.size.height)
        })
    }
}

private struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private struct TagView: View {
    let tag: String
    let onDelete: (String) -> Void
    
    var body: some View {
        HStack(spacing: SamaCarbonateSpacing.xxSmall) {
            Text(tag).font(SamaCarbonateFontLibrary.Title.regularMedium)
                .foregroundColor(Color("primaryOrange"))
            Button(action: { onDelete(tag) }) {
                Image(systemName: "xmark.circle.fill").foregroundColor(Color("primaryOrange"))
            }
        }
        .padding(.horizontal, SamaCarbonateSpacing.xxSmall)
        .padding(.vertical, SamaCarbonateSpacing.xxSmall)
        .cornerRadius(8)
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color("primaryOrange"), lineWidth: 1))
    }
}


struct SingleSelectCountryPicker: View {
    let title: String
    let countries: [String]
    @Binding var selectedCountry: String? // Make selectedCountry optional
    
    @State private var showPicker = false
    @State private var searchText = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline).foregroundColor(.gray)
            
            Button(action: { showPicker = true }) {
                HStack {
                    Text(selectedCountry ?? "Select Country") // Display "Select Country" if nil
                        .foregroundColor(selectedCountry == nil ? .gray : .primary)
                    Spacer()
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray4), lineWidth: 1))
            }
        }
        .padding(.bottom, 8)
        .sheet(isPresented: $showPicker) {
            SingleCountryPickerSheet(
                countries: countries,
                selectedCountry: $selectedCountry,
                showPicker: $showPicker
            )
        }
    }
}

struct SingleCountryPickerSheet: View {
    let countries: [String]
    @Binding var selectedCountry: String?
    @Binding var showPicker: Bool
    @State private var searchText = ""
    
    var filteredCountries: [String] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                SearchBar(text: $searchText, placeholder: "Search Countries").padding(.vertical)
                
                ForEach(filteredCountries, id: \.self) { country in
                    VStack {
                        HStack {
                            Text(country).font(.system(size: 18))
                            Spacer()
                            if selectedCountry == country {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 16))
                            }
                        }
                        .padding( SamaCarbonateSpacing.xxSmall)
                        if filteredCountries.last != country { Divider() }
                    }
                    .onTapGesture {
                        selectedCountry = country
                        showPicker = false
                    }
                }
            }
            .navigationBarTitle("Select Country", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancle") { showPicker = false },
                trailing: Button("Done") { showPicker = false }
            )
        }
    }
}


struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
        }
        .padding(.horizontal, 8)
    }
}

struct PrimaryButton: View {
    // Enum to define the various styles of the button.
    enum Style: Equatable {
        case primary
        case secondary
        case tertiary
        case disabled
        case loading
    }

    let title: String
    let style: Style
    let rightImage: UIImage?
    let leftImage: UIImage?
    let isCompact: Bool
    let action: () -> Void

    init(
        title: String,
        style: Style,
        isCompact: Bool = false,
        leftImage: UIImage? = nil,
        rightImage: UIImage? = nil,
        action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.leftImage = leftImage
        self.rightImage = rightImage
        self.isCompact = isCompact
        self.action = action
    }

    // Determine if the button should be disabled based on its style.
    private var isButtonDisabled: Bool {
        style == .disabled || style == .loading
    }

    var body: some View {
        Button(action: action) {
            // The content of the button changes based on the style.
            ZStack {
                HStack {
                    if let image = leftImage {
                        Image(uiImage: image)
                            .frame(width: 20, height: 20)
                    }

                    Text(getTitle(for: style))
                        .font(Font(UIFont.custom(type: .foundersGroteskSemibold, size: 20)))

                    if let image = rightImage {
                        Image(uiImage: image)
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .font(.headline)
            .foregroundColor(foregroundColor(for: style))
            .padding(.vertical, 20)
            .padding(.horizontal, 32)
            .if(!isCompact) { view in
                view.frame(maxWidth: .infinity)
            }
            .background(Capsule().fill(backgroundColor(for: style)))
        }
        .disabled(isButtonDisabled)
        .animation(.easeInOut, value: style)
    }

    // Helper function to get the background color for a given style.
    private func backgroundColor(for style: Style) -> Color {
        switch style {
        case .primary, .loading:
            return SamaCarbonateColorTheme.primaryGreen

        case .secondary:
            return SamaCarbonateColorTheme.primaryGrey

        case .tertiary:
            return .white

        case .disabled:
            return SamaCarbonateColorTheme.inactiveGray
        }
    }

    // Helper function to get the foreground (text) color for a given style.
    private func foregroundColor(for style: Style) -> Color {
        switch style {
        case .primary, .secondary, .loading, .disabled:
            return .white

        case .tertiary:
            return SamaCarbonateColorTheme.primaryGreen
        }
    }

    private func getTitle(for style: Style) -> String {
        switch style {
        case .loading:
            return "in_progress".localized()

        default:
            return title
        }
    }
}

#Preview {
    VStack {
        PrimaryButton(title: "Next", style: .primary, isCompact: true) {
            print("tapped")
        }

        PrimaryButton(title: "Next", style: .primary) {
            print("tapped")
        }

        PrimaryButton(title: "Next", style: .secondary, isCompact: true) {
            print("tapped")
        }

        PrimaryButton(title: "Next", style: .secondary) {
            print("tapped")
        }

        PrimaryButton(title: "Next", style: .tertiary, isCompact: true) {
            print("tapped")
        }

        PrimaryButton(title: "Next", style: .tertiary) {
            print("tapped")
        }

        PrimaryButton(title: "Next", style: .disabled, isCompact: true) {
            print("tapped")
        }

        PrimaryButton(title: "Next", style: .disabled) {
            print("tapped")
        }
    }
}



// Remove default cell padding
extension View {
    func listRowInsets(_ insets: EdgeInsets) -> some View {
        self.transformEnvironment(\.defaultMinListRowHeight) { _ in }
            .padding(insets)
    }

    @ViewBuilder
    func conditionalListRowSeparator() -> some View {
        if #available(iOS 15.0, *) {
            self.listRowSeparator(.hidden)
        } else {
            self
        }
    }

    @ViewBuilder
    func conditionalIgnoresSafeArea() -> some View {
        if #available(iOS 14.0, *) {
            self.ignoresSafeArea(.keyboard)
        } else {
            self
        }
    }

    /// Applies a modifier conditionally.
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Applies one of two modifiers conditionally.
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
}

/// Represents an alert to be shown in the UI.
struct AlertInfo: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}


struct TokensMapper {
    let accessToken: String
    let refreshToken: String
    var awaiting2fa: Bool
    var isPhoneNeeded: Bool
    let phoneNumber2fa: String?
    let numberOfOnboardingQuestions: Int?
    let isPasswordGenerated: Bool?
    let onboardingQuestions: OnboardingQuestionsMapper?
}

extension TokensMapper: Decodable, Encodable {
    enum TokensDecodableKeys: String, CodingKey {
        case accessToken, refreshToken, awaiting2fa, isPhoneNeeded, phoneNumber2fa, numberOfOnboardingQuestions, isPasswordGenerated, onboardingQuestions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TokensDecodableKeys.self)

        accessToken = try container.decode(String.self, forKey: .accessToken)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        awaiting2fa = try container.decode(Bool.self, forKey: .awaiting2fa)
        isPhoneNeeded = try container.decode(Bool.self, forKey: .isPhoneNeeded)
        phoneNumber2fa = try container.decodeIfPresent(String.self, forKey: .phoneNumber2fa)
        numberOfOnboardingQuestions = try container.decodeIfPresent(Int.self, forKey: .numberOfOnboardingQuestions)
        isPasswordGenerated = try container.decodeIfPresent(Bool.self, forKey: .isPasswordGenerated)
        onboardingQuestions = try container.decodeIfPresent(OnboardingQuestionsMapper.self, forKey: .onboardingQuestions)
    }
}

struct OnboardingQuestionsMapper {
    let ageRange: EnabledMapper?
    let gender: EnabledMapper?
}

extension OnboardingQuestionsMapper: Decodable, Encodable {
    enum OnboardingQuestionsDecodableKeys: String, CodingKey {
        case ageRange, gender
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OnboardingQuestionsDecodableKeys.self)

        ageRange = try container.decodeIfPresent(EnabledMapper.self, forKey: .ageRange)
        gender = try container.decodeIfPresent(EnabledMapper.self, forKey: .gender)
    }
}

struct EnabledMapper {
    let enabled: Bool?
}

extension EnabledMapper: Decodable, Encodable {
    enum EnabledDecodableKeys: String, CodingKey {
        case enabled
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EnabledDecodableKeys.self)

        enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled)
    }
}


class AppLanguageManager {
    // MARK: - Properties
    static var shared = AppLanguageManager()
    private let languageSetKey = "language_set"
    let acceptedLanguages = ["fr", "en"]

    // MARK: - Lifecycle
    // MARK: - Publics
    func isLangugageSet() -> Bool {
        UserDefaults.standard.string(forKey: languageSetKey) != nil
    }

    func currentLanguageSet() -> String? {
        UserDefaults.standard.string(forKey: languageSetKey) ?? Locale.current.languageCode
    }

    func updateLanguageSet(language: String) {
        if acceptedLanguages.contains(language) {
            DispatchQueue.main.async {
                UserDefaults.standard.setValue(language, forKey: self.languageSetKey)
                NotificationCenter.default.post(name: .appLanguageUpdated, object: nil)
            }
        }
    }

    // MARK: - Privates
    // MARK: - Actions
}


struct PushInfo {
    let storyboard: String
    let viewController: String
    let params: Any?
}

extension Notification.Name {
    static let coachProfileUpdated = Notification.Name("coachProfileUpdated")

    static let pushFromRoot = Notification.Name("pushFromRoot")
    static let displayTabBarIndex = Notification.Name("displayTabBarIndex")

    static let chatMergedChannelsPopulated = Notification.Name("chatMergedChannelsPopulated")
    static let chatChannelsUpdated = Notification.Name("chatChannelsUpdated")
    static let chatNewMessage = Notification.Name("chatNewMessage")
    static let chatMessageDeleted = Notification.Name("chatMessageDeleted")
    static let chatLoadingError = Notification.Name("chatLoadingError")
    static let typingStarted = Notification.Name("typingStarted")
    static let typingEnded = Notification.Name("typingEnded")

    static let bookingNeedsRefresh = Notification.Name("bookingNeedsRefresh")
    static let bookingReceived = Notification.Name("bookingReceived")

    static let unreadMessagesUpdated = Notification.Name("unreadMessagesUpdated")
    static let oktaLoginSuccess = Notification.Name("oktaLoginSuccess")

    static let audioMessagePlay = Notification.Name("audioMessagePlay")
    static let audioMessagePause = Notification.Name("audioMessagePause")
    static let audioMessageStop = Notification.Name("audioMessageStop")
    static let audioMessageDurationsUpdated = Notification.Name("audioMessageDurationsUpdated")

    static let mediaMessageStartLoading = Notification.Name("mediaMessageStartLoading")
    static let mediaMessageStopLoading = Notification.Name("mediaMessageStopLoading")

    static let appLanguageUpdated = Notification.Name("appLanguageUpdated")

    static let UserDidGoogleSignIn = Notification.Name("UserDidGoogleSignIn")

    static let completedCheckins = Notification.Name("completedCheckins")

    static let checklistNeedsUpdate = Notification.Name("checklistNeedsUpdate")
}

