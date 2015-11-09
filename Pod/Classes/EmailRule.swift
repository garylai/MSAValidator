//
//  EmailRule.swift
//  myspendingapp
//
//  Created by GaryLai on 7/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

private class EmailRule : MSARule, UITextFieldRule, UITextViewRule {
    static let REGEX_STR = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$";
    static let REGEX = try! NSRegularExpression(pattern: REGEX_STR, options: []);
    override var defaultErrorMessage : String {
        return "Input is not a valid email adress";
    }
    
    func validate(inputText : String) -> ValidationResult {
        let matches = EmailRule.REGEX.matchesInString(inputText,
                options: [],
                range: NSRange(location: 0, length: inputText.characters.count));
        if matches.count == 1 {
            return ValidationResult(true);
        }
        return ValidationResult(false, [errorMessage]);
    }
    
    func validate(textView : UITextView) -> ValidationResult {
        return validate(textView.text)
    }
    
    func validate(textField : UITextField) -> ValidationResult {
        return validate(textField.text!);
    }
}

public func IsAnEmail() -> UITextFieldRule {
    return EmailRule();
}

public func IsAnEmail() -> UITextViewRule{
    return EmailRule();
}
