//
//  AreaOfCoachingView.swift
//  Caller
//
//  Created by Kod Enigma on 27/02/2025.
//

import SwiftUI

struct AreaOfCoachingView: View {
    @State private var areaOfCoaching: String = ""
    @State private var automatedSummary: String = ""
    @State private var coachNotes: String = ""
    @State private var keyChallengesAtWork: String = ""
    @State private var keyPersonalChallenges: String = ""
    
    let note: NotesMapper
    let title: String
    
    var body: some View {
        ScrollView{
            VStack(spacing: 25) {
                
                SamaDropDownTextField(
                    title: "Area od caoching",
                    text: $areaOfCoaching
                )
                
                SamaMultiLineTextField(
                    title: "Automated summary",
                    hintText:"Enter automated summary",
                    text: $automatedSummary
                )
                
                VStack{
                    HStack{
                        Text("Jesper Dahlqvist's notes").font(SamaCarbonateFontLibrary.Title.regularBold)
                        Spacer()
                        Text("Insert today's date")
                            .font(SamaCarbonateFontLibrary.Body.medium)
                            .foregroundColor(Color("primaryOrange"))
                        
                    }.padding(.horizontal)
                    
                    SamaMultiLineTextField(
                        title: nil,
                        hintText: "Enter coach notes",
                        text: $coachNotes
                    )
                }
                
                SamaMultiLineTextField(
                    title: "Key challenges at work",
                    hintText: "Enter key challenges at work",
                    text: $keyChallengesAtWork
                )
                
                SamaMultiLineTextField(
                    title: "Key personal challenges",
                    hintText: "Enter key personal challenges",
                    text: $keyPersonalChallenges
                )
                
                Button("Save", action: ontap)
                    .font(SamaCarbonateFontLibrary.Button.boldPrimary)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color("primaryOrange")))
                    .cornerRadius(8)
                    .padding()
            }
        }
        .navigationTitle(title)
        .onAppear{
            areaOfCoaching = note.coachingArea ?? ""
            automatedSummary = note.main ?? ""
            coachNotes = note.main ?? ""
            keyChallengesAtWork = note.keyChallenge ?? ""
            keyPersonalChallenges = note.personalChallenge ?? ""
        }
    }
    
    func ontap() {}
}

#Preview {
    let note = NotesMapper(
        main: "Has made a lot of progress. She's really stoked to get started working in her new position as Head of Dogs",
        keyChallenge: "Has made a lot of progress.",
        personalChallenge: "Learn how to play tiki-taka sufficiently on a football pitch",
        careerChange: nil,
        coachingArea: "Life Balance",
        id: UUID().uuidString,
        createdAt: Date()
    )

    AreaOfCoachingView(note: note, title: "Session on Fri, 18 Aug 2025")
}


private struct SamaMultiLineTextField: View {
    let title: String?
    let hintText: String
    @Binding var text: String
    
    
    var body: some View {
        VStack(alignment: .leading) {
            if title != nil {
                Text(title!).font(SamaCarbonateFontLibrary.Title.regularBold)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color("disabledTextColor").opacity(0.1))
                
                CustomMulitiLineUIKitTextEditor(text: $text, backgroundColor: .clear)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .frame(height: 102)
            }.frame(height: 102)
        }.padding(.horizontal)
        
    }
    
}


struct SamaDropDownTextField: View {
    var title: String
    @Binding var text: String
    var onTap: (()-> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(SamaCarbonateFontLibrary.Title.regularBold)
            
            Button(action: { onTap?() } )  {
                HStack {
                    Text(text)
                        .foregroundColor(.black)
                        .font(SamaCarbonateFontLibrary.Body.medium)
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color("primaryOrange"))
                        .padding(.trailing, 10)
                }
                .padding(.vertical, 18)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity)
                .background(Color("disabledTextColor").opacity(0.1))
                .cornerRadius(8)
            }
        }.padding(.horizontal)
    }
}


struct CustomMulitiLineUIKitTextEditor: UIViewRepresentable {
    @Binding var text: String
    var backgroundColor: UIColor
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.backgroundColor = backgroundColor
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.autocapitalizationType = .sentences
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.backgroundColor = backgroundColor
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomMulitiLineUIKitTextEditor
        
        init(_ parent: CustomMulitiLineUIKitTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}


