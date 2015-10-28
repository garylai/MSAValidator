//
//  RequiredRule.swift
//  myspendingapp
//
//  Created by GaryLai on 7/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

private class RequiredRule {
    private static let MESSAGE = "This Field is required";
    private func validate(inputText : String?) -> ValidationResult {
        guard let text = inputText where !text.isEmpty else {
            return ValidationResult(false, [RequiredRule.MESSAGE]);
        }
        return ValidationResult(true);
    }
    private func validate(textView : UITextView) -> ValidationResult {
        return validate(textView.text)
    }
    
    private func validate(textField : UITextField) -> ValidationResult {
        return validate(textField.text);
    }
}

public func IsPresent() -> (textView : UITextView) -> ValidationResult {
    return RequiredRule().validate;
}

public func IsPresent() -> (textField : UITextField) -> ValidationResult {
    return RequiredRule().validate;
}
 