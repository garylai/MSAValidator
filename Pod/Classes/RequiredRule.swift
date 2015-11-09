//
//  RequiredRule.swift
//  myspendingapp
//
//  Created by GaryLai on 7/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

private class RequiredRule : MSARule, UITextFieldRule, UITextViewRule {
    override var defaultErrorMessage : String {
        return "This Field is required";
    }
    func validate(inputText : String?) -> ValidationResult {
        guard let text = inputText where !text.isEmpty else {
            return ValidationResult(false, [errorMessage]);
        }
        return ValidationResult(true);
    }
    func validate(textView : UITextView) -> ValidationResult {
        return validate(textView.text)
    }
    
    func validate(textField : UITextField) -> ValidationResult {
        return validate(textField.text);
    }
}

public func IsPresent() -> UITextFieldRule {
    return RequiredRule();
}

public func IsPresent() -> UITextViewRule {
    return RequiredRule();
}
 