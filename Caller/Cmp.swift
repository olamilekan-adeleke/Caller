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
