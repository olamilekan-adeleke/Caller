//
//  File.swift
//  Caller
//
//  Created by Kod Engima on 26/09/2025.
//

import SwiftUI


enum SessionStatus: String, Codable {
    case planned // upcoming
    case close // done
    case cancel // lateCancel
}


struct SessionHistory: Identifiable {
    let id = UUID()
    let status: SessionStatus
    let date: Date
    let type: String       // e.g. "Call", "Video"
    let duration: String   // e.g. "50 min", "25 min"
    let isComplete: Bool   // for “COMPLETED” or “INCOMPLETE”
    let hasNotes: Bool     // indicates if session notes are available
    var note: NotesMapper?
}

struct SessionRow: View {
    let session: SessionHistory
//    let coacheeMapper: CoacheeMapper
    @State private var isDetailActive = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                SessionStatusIcon(status: session.status)
                Spacer().frame(width: SamaCarbonateSpacing.xxSmall)
                HStack {
                    VStack(alignment: .leading) {
                        Text(statusText)
                            .font(SamaCarbonateFontLibrary.Body.small)
                            .foregroundColor(Color("disabledTextColor"))
                        // Middle rows: date + type/duration
                        Text(formattedDate(session.date))
                            .font(SamaCarbonateFontLibrary.Body.medium)
                            .foregroundColor(Color("primaryTextColor"))

                        Text("\(session.type) - \(session.duration)")
                            .font(SamaCarbonateFontLibrary.Body.small)
                            .foregroundColor(Color("disabledTextColor"))
                        
                            HStack(spacing: 4) {
                                Image("ai_star")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color("primaryOrange"))
                                
                                Text("Note-taker")
                                    .font(SamaCarbonateFontLibrary.Body.small)
                                    .foregroundColor(Color("primaryOrange"))
                            }

                        if let _ = session.note, session.status == .close {
                            HStack {
                                Button {
                                    isDetailActive = true
                                } label: {
                                    Text("sessionNotes".localized())
                                        .font(SamaCarbonateFontLibrary.Body.medium)
                                        .foregroundColor(Color.primaryBlue)
                                        .underline(true, color: Color.primaryBlue)
                                }
//                                NoteStatusBadgeView(isComplete: session.isComplete)
                            }
                            .font(SamaCarbonateFontLibrary.Caption.medium)
                            .padding(.vertical, 3)
                        }
                    }
                    if let note = session.note, session.status == .close {
//                        NavigationLink(
//                            destination: NoteDetailView(
//                                viewModel: NoteTabViewModel(note: note, coacheeMapper: coacheeMapper)
//                            ),
//                            isActive: $isDetailActive
//                        ) {
//                            EmptyView()
//                        }
//                        .frame(width: 1)
//                        .hidden() // completely removes its own UI
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }

    private var statusText: String {
        switch session.status {
            case .planned: return "upcoming".localized()
            case .close: return "done".localized()
            case .cancel: return "lateCancel".localized()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy" // e.g. "Mon, 18 Sep 2025"
        return formatter.string(from: date)
    }
}

struct SessionStatusIcon: View {
    let status: SessionStatus

    var body: some View {
        switch status {
            case .planned:
                Image("upcoming_icon")
                    .resizable()
                       .frame(width: 24, height: 24)
                       .padding(8)
                       .overlay(
                           RoundedRectangle(cornerRadius: 20)
                               .stroke(style: StrokeStyle(lineWidth: 2, dash: [4]))
                               .foregroundColor(Color(red: 215 / 255, green: 219 / 255, blue: 225 / 255))
                       )

            case .close:
            Circle().fill(Color.blue).frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(SamaCarbonateFontLibrary.Title.largeBold)
                            .foregroundColor(.white)
                    )

            case .cancel:
                Circle().fill(Color.primaryRed).frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "xmark")
                            .font(SamaCarbonateFontLibrary.Title.largeBold)
                            .foregroundColor(.white)
                    )
        }
    }
}


// Sample data for preview
struct SessionHistoryPreview: View {
    let sampleSessions: [SessionHistory] = [
        SessionHistory(
            status: .close,
            date: Date().addingTimeInterval(-86400 * 2), // 2 days ago
            type: "Video Call",
            duration: "50 min",
            isComplete: true,
            hasNotes: true,
//            note: NotesMapper(content: "Great session discussing goals")
        ),
        SessionHistory(
            status: .planned,
            date: Date().addingTimeInterval(86400 * 3), // 3 days from now
            type: "Phone Call",
            duration: "25 min",
            isComplete: false,
            hasNotes: false,
            note: nil
        ),
        SessionHistory(
            status: .cancel,
            date: Date().addingTimeInterval(-86400 * 7), // 1 week ago
            type: "Video Call",
            duration: "50 min",
            isComplete: false,
            hasNotes: false,
            note: nil
        ),
        SessionHistory(
            status: .close,
            date: Date().addingTimeInterval(-86400 * 14), // 2 weeks ago
            type: "Phone Call",
            duration: "30 min",
            isComplete: true,
            hasNotes: true,
//            note: NotesMapper(content: "Follow-up session")
        ),
        SessionHistory(
            status: .planned,
            date: Date().addingTimeInterval(86400), // Tomorrow
            type: "Video Call",
            duration: "45 min",
            isComplete: false,
            hasNotes: false,
            note: nil
        )
    ]
    
    var body: some View {
        NavigationView {
            List(sampleSessions) { session in
                SessionRow(session: session)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Session History")
        }
    }
}

// Preview
#Preview {
    SessionHistoryPreview()
}
