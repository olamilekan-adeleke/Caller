//
//  Constants.swift
//  Sama
//
//  Created by Alexis Semmama on 25/10/2021.
//  Copyright © 2021 Alexis Semmama. All rights reserved.
//

import UIKit

struct Constants {
    static var expectedApiVersion = 367

    static var serviceName = "coacheeIos"

    static var appStoreAppId = "id1520645244"

    static let defaultCountryCode = "GB"
    static let defaultSessionDurationInSeconds = 30.0 // must be a multiple of 15. Otherwise, you need to rework data sources in AvailabiltiesChoiceViewController
    static let maxMonthsRange = 6
    static let limitBeforeJoinSession = 5 // minutes
    static let samaEmailInfo = "support@sama.io"
    static let calendar = Calendar(identifier: .gregorian)

    struct Storyboard {
        struct Name {
            static let tabBarCommon = "TabBarCommon"
            static let videoCall = "VideoCall"
            static let notes = "Notes"
            static let goals = "Goals"
            static let tabBar = "TabBar"
            static let informationsSteps = "InformationsSteps"
        }

        struct ID {
            static let bookingViewController = "bookingViewController"
            static let videoCallViewController = "videoCallViewController"
            static let tasksViewController = "tasksViewController"
            static let notesListViewController = "notesListViewController"
            static let goalsViewController = "goalsViewController"
            static let guestManagementViewController = "GuestManagementViewController"
            static let checklistEventViewController = "checklistEventViewController"
            static let coachProfileDisplay = "coachProfileDisplay"
            static let checkinsViewController = "checkinsViewController"
            static let topValuesController = "topValuesController"
            static let personalValuesController = "personalValuesController"
            static let groupQuestionsViewController = "groupQuestionsViewController"
        }
    }

    static let minimumDate = Date()
    static var maximumDate: Date {
        Self.calendar.date(byAdding: .month, value: Self.maxMonthsRange, to: minimumDate)?.addingTimeInterval(-24 * 60 * 60) ?? Date()
    }

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    struct Colors {
        // MARK: - New colors

        static let primaryOrange = UIColor(rgb: 0xFF7558)
        static let disabledTextColor = UIColor(rgb: 0x83859A)
        static let primaryDarkBlue = UIColor(rgb: 0x10123A)
        static let primaryGreenColor = UIColor(rgb: 0x62B8A4)
        static let primaryRedColor = UIColor(rgb: 0xFF3B30)
        static let primaryBlue = UIColor(rgb: 0x2E7C8B)
        static let primaryGrey = UIColor(rgb: 0xA5A6B7)

        static let greyTextColor = UIColor(rgb: 0x828399)

        static let greyBorderColor = UIColor(rgb: 0xE9ECF0)
        static let greyBackgroundColor = UIColor(rgb: 0xF6F7F9)
        static let greyBackgroundColorTextfield = UIColor(rgb: 0xF4F6F8)
        static let orangeBackgroundColor = UIColor(rgb: 0xFFF7F6)
        static let orangeBackgroundDarkColor = UIColor(rgb: 0xFFF5F3)
        static let greyBlueBackgroundColor = UIColor(rgb: 0xF4F9F9)
        static let yellowBackgroundColor = UIColor(rgb: 0xFFF8ED)

        static let textViewBackgroundColor = UIColor(rgb: 0xDEE2E8).withAlphaComponent(0.3)
        static let shadowColor = UIColor(rgb: 0x111237).withAlphaComponent(0.1)

        static let disabledButtons = UIColor(rgb: 0xE7E7EB)

        static let resilienceColor = UIColor(rgb: 0xff6543)
        static let blueBackgroundColor = UIColor(rgb: 0x2e7c8b)
        static let motivationColor = UIColor(rgb: 0x82083b)
        static let alignmentColor = UIColor(rgb: 0x5090ae)
        static let efficacyColor = UIColor(rgb: 0x3d297f)

        static let errorColor = UIColor(rgb: 0xEF5659)

        // MARK: - Old colors

        static let bodyText = UIColor(rgb: 0x403E45)

        static let primarySalmon = UIColor(rgb: 0xffAd87)
        static let oldPrimaryOrange = UIColor(rgb: 0xff7d48)
        static let tertiaryOrange = UIColor(rgb: 0xff4343)
        static let containerInputField = UIColor(rgb: 0xf2f2f2)
        static let backgroundColor = UIColor(rgb: 0xffffff)
        static let containerReadMore = UIColor(rgb: 0xffd4c0, alpha: 0.1)
        static let placeholderText = UIColor(rgb: 0xcfcfcf)
        static let videoCallBorderColor = UIColor(rgb: 0x16b4a9)

        static let background = UIColor(rgb: 0xf9eee5, alpha: 0.3)
        static let backgroundCalendar = UIColor(rgb: 0xf9eee5)
        static let redError = UIColor(rgb: 0xc7112e)
        static let secondaryRedError = UIColor(rgb: 0xe94c4c)
        static let greySeparator = UIColor(rgb: 0xE8ECEF)
        static let blueBackground = UIColor(rgb: 0x2e7b8b)
        static let lightOrange = UIColor(rgb: 0xffefe3)

        static let disabledButtonGreyBackground = UIColor(rgb: 0xe5e5e9)
        static let disabledButtonGreyTitle = UIColor(rgb: 0x7b7c90)

        static let bookingPrimaryGreenColor = UIColor(rgb: 0x62b8a4)
        static let bookingSecondaryGreenColor = UIColor(rgb: 0xeefaf7)

        static let bookingPrimaryRedColor = UIColor(rgb: 0xff5858)
        static let bookingSecondaryRedColor = UIColor(rgb: 0xffeeee)

        static let primaryGreyColor = UIColor(rgb: 0xe2e2f1)

        static let primaryTurquoiseColor = UIColor(rgb: 0x007188)

        static let greyNewValidateButtonColor = UIColor(rgb: 0xc3c3cd)
    }

    struct URL {
        static var terms: String {
            if let appLanguage = AppLanguageManager.shared.currentLanguageSet(), appLanguage == "fr" {
                return "https://sama.io/fr/modalites-et-conditions/?from_mobile=true"
            } else {
                return "https://sama.io/terms-and-conditions/?from_mobile=true"
            }
        }

        static var assessmentQuestionLink: String {
            if let appLanguage = AppLanguageManager.shared.currentLanguageSet(), appLanguage == "fr" {
                return "https://sama.io/quel-sujet-de-coaching-choisir/?source=ios_coachee_app&amp;userId=%s&amp;from_mobile=true"
            } else {
                return "https://sama.io/assessment/?source=ios_coachee_app&amp;userId=%s&amp;from_mobile=true"
            }
        }

        static var privacy: String {
            if let appLanguage = AppLanguageManager.shared.currentLanguageSet(), appLanguage == "fr" {
                return "https://sama.io/fr/politique-de-confidentialite/?from_mobile=true"
            } else {
                return "https://sama.io/privacy-policy/?from_mobile=true"
            }
        }

        static let email = "support@sama.io"

        static var base: String {
            guard let apiId = Constants.infoDictionary["api_base_url"] as? String else {
                fatalError("Base URL not set in plist for this environment")
            }

            return "https://\(apiId)"
        }

        static var baseWss: String {
            guard let apiId = Constants.infoDictionary["api_base_wss_url"] as? String else {
                fatalError("Base URL not set in plist for this environment")
            }

            return "wss://\(apiId)"
        }
    }

    struct Keys {
#if DEBUG
        static let mixPanel = "f22b45ea5cec675ad8e9a7a76d75a678"
        static let syncGoogleClientId = "714098363928-av6bckt66hv1q3j4lqilcqlr82softhg.apps.googleusercontent.com"
        static let syncGoogleServerId = "714098363928-qdhljuhn9239r0u1fo514m08767c7m1s.apps.googleusercontent.com"
        static let syncGoogleRedirectString = "com.samaeurope.sama-coach:com.googleusercontent.apps.714098363928-av6bckt66hv1q3j4lqilcqlr82softhg"
#else
        static let mixPanel = "f219edc3994925e79490dbb6908b2979"
        static let syncGoogleClientId = "368180102955-0oo3ehkr9cl8n8e2r8ljfv5poduo902e.apps.googleusercontent.com"
        static let syncGoogleServerId = "368180102955-1sbnk3nhn23kmap1k7aci6as45i5s6ol.apps.googleusercontent.com"
        static let syncGoogleRedirectString = "com.samaeurope.sama-coach:com.googleusercontent.apps.368180102955-0oo3ehkr9cl8n8e2r8ljfv5poduo902e"
#endif

        static var sentryDSN = "https://fd100db96d5c4b93a29830fd694a0e34@o784619.ingest.us.sentry.io/6112619"

        static var oneSignalApiKey: String {
            guard let apiId = Constants.infoDictionary["one_signal_api_key"] as? String else {
                fatalError("Key not set in plist for this environment")
            }

            return apiId
        }
    }

    struct Tracking {
        // VIDEO SESSION
        static let SESSION_LIVE_COACHING_ERROR = "session_live_coaching_error"
        static let SESSION_LIVE_COACHING_CONNECTED = "session_live_coaching_connected"
        static let VIDEO_CALL_DISCONNECTED = "video_call_disconnected"

        // BOOKING
        static let SESSION_BOOKED = "session_booked"
        static let SESSION_CANCELLED = "session_cancelled"
        static let SESSION_RESCHEDULED = "session_rescheduled"

        // CHAT
        static let CHAT_MESSAGING_OPEN = "chat_messaging_open"
        static let CHAT_MESSAGING_CLOSED = "chat_messaging_closed"
        static let CHAT_MESSAGE_SENT = " chat_message_sent"
        static let CHAT_MESSAGING_ITEM_CLICKED = "chat_messaging_item_clicked"

        // TASKS
        static let TASK_GIVEN_PERFORMED = "task_given_performed"
        static let TASK_ADDED = "task_added"

        // RATING
        static let VIDEO_QUALITY_RATING = "video_quality_rating"
        static let COACH_RATING = "coach_rating"

        // MATCHING
        static let MATCHING = "matching"

        // NOTEPADS
        static let GOALS_SAVED = "my_note_saved"
        static let GOALS_VIEWED = "my_notes_viewed"

        // ONBOARDING
        static let ONBOARDING = "onboarding"

        // OUTCOME ASSESSMENT
        static let OUTCOME_ASSESSMENT = "outcome_assessment"

        // CHECKLIST EVENT
        static let ONBOARDING_CHECKLIST = "OnboardingCheckList"

        // SCROLLING
        static let SCROLL_COMPLETED = "scroll_completed"

        // GUEST MANAGEMENT
        static let GUEST_MANAGEMENT_OPENED = "guest_management_opened"
        static let GUEST_MANAGEMENT_CLOSED = "guest_management_closed"
        static let GUEST_MANAGEMENT_INVITED = "guest_management_invited"
        static let GUEST_MANAGEMENT_UNINVITED = "guest_management_uninvited"

        // GOALS
        static let GOALS_LIST_OPENED = "goal_list_opened"
        static let GOALS_LIST_CLOSED = "goal_list_closed"
        static let GOALS_LIST_FILTER_SELECTED = "goal_list_filter"
        static let GOAL_CREATE_OPENED = "goal_create_opened"
        static let GOAL_CREATE_CLOSED = "goal_create_closed"
        static let GOAL_CREATE_SAVED = "goal_create_saved"
        static let GOAL_EDIT_OPENED = "goal_edit_opened"
        static let GOAL_EDIT_CLOSED = "goal_edit_closed"
        static let GOAL_EDIT_DELETED = "goal_deleted"
        static let GOAL_EDIT_SAVED = "goal_edit_saved"
        static let GOAL_VIEW_OPENED = "goal_view_opened"
        static let GOAL_VIEW_CLOSED = "goal_view_closed"

        static let UPDATED_TOP_VALUES = "updated_top_values"
        static let UPDATED_PERSONAL_VALUES = "updated_personal_values"
        static let UPDATED_PHONE_NUMBER = "updated_phone_number"
        static let UPDATED_AGE_RANGE = "updated_age_range"
        static let UPDATED_INDUSTRY = "updated_industry"
        static let UPDATED_FUNCTION = "updated_function"
        static let UPDATED_GENDER = "updated_gender"
        static let UPDATED_POSITION = "updated_position"
        static let UPDATED_APP_LANGUAGE = "updated_app_language"

        static let UPDATED_AREA_OF_COACHING = "updated_area_of_coaching"
        static let UPDATED_PREFERRED_COACH_GENDER = "updated_preferred_coach_gender"
        static let UPDATED_COACHING_LANGUAGE = "updated_coaching_language"

        // SMRating
        static let SM_RATING_OPENED = "rating"

        // ROI
        static let ROI_SCREEN_EVENT_GROUP = "question_groups"

        // Note Taker Events
        static let NOTE_TAKER_PERMISSIONS = "note_taker_permissions"
        static let NOTE_TAKER_SETTINGS = "note_taker_settings"
        static let NOTE_TAKER_RECORDING = "note_taker_recording"
        static let NOTE_TRACKER_SUMMARY = "note_tracker_summary"
        static let NOTE_TRACKER_TRANSCRIPTION = "note_tracker_transcription"
        static let NOTE_TRACKER_NOTES = "note_tracker_notes"
        static let NOTE_TRACKER_FEEDBACK = "note_tracker_feedback"
    }
}



extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
   }

    convenience init(white: Int, alpha: CGFloat = 1) {
        assert(white >= 0 && white <= 255, "Invalid red component")

        self.init(white: CGFloat(white) / 255.0, alpha: alpha)
    }

   convenience init(rgb: Int, alpha: CGFloat = 1) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF,
           alpha: alpha
       )
   }
}
