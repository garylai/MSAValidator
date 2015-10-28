//
//  EmailRule.swift
//  myspendingapp
//
//  Created by GaryLai on 7/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

private class EmailRule {
    private static let REGEX_STR = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$";
    private static let REGEX = try! NSRegularExpression(pattern: REGEX_STR, options: []);
    private static let MESSAGE = "Please enter a valid email adress";
    
    private func validate(inputText : String?) -> ValidationResult {
        if let text = inputText {
            let matches = EmailRule.REGEX.matchesInString(text,
                options: [],
                range: NSRange(location: 0, length: text.characters.count));
            if matches.count == 1 {
                return ValidationResult(true);
            } else {
                return ValidationResult(false, [EmailRule.MESSAGE]);
            }
        } else {
            return ValidationResult(false, [EmailRule.MESSAGE]);
        }
    }
    
    private func validate(textView : UITextView) -> ValidationResult {
        return validate(textView.text)
    }
    
    private func validate(textField : UITextField) -> ValidationResult {
        return validate(textField.text);
    }
}

public func IsAnEmail() -> (textView : UITextView) -> ValidationResult {
    return EmailRule().validate;
}

public func IsAnEmail() -> (textField : UITextField) -> ValidationResult {
    return EmailRule().validate;
}
