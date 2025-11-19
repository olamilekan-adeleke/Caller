//
//  StringExt.swift
//  Caller
//
//  Created by Kod Engima on 24/08/2025.
//

import Foundation

extension String {
    var isoStringToDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return dateFormatter.date(from: self)
    }

    var isoStringWithoutSecondesToDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter.date(from: self)
    }

    var isNotEmpty: Bool {
        !self.isEmpty
    }

    func isEmailValid() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+\\-']+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    func isPasswordValid() -> Bool {
        let emailRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!#$%§±¡™£¢∞¶•ªº–\"'æ«…¬˚≤≥µ˜√ç≈Ωåß∂`ƒ©~˙∆πøˆ¨¥†®´^&*()_+{}|\"?><:,.\\/'\\;\\]@\\[=])[A-Za-z\\d!#$%§±¡™£¢∞¶•ªº–\"'æ«…¬˚≤≥µ˜√ç≈Ωåß∂`ƒ©~˙∆πøˆ¨¥†®´^&*()_+{}|\"?><:,.\'\\;\\]@\\[=]{10,}$"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

extension StringProtocol {
    var words: [SubSequence] {
        split { !$0.isLetter }
    }
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}
