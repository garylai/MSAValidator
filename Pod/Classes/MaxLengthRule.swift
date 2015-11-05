//
//  MaxLengthRule.swift
//  Pods
//
//  Created by GaryLai on 26/10/15.
//
//

import UIKit

private class MaxLengthRule {
    private let _maxLength : Int;
    private init (maxLength : Int) {
        _maxLength = maxLength;
    }
    private var message : String {
        get {
            return "Input cannot be longer than \(_maxLength) characters";
        }
    }
    
    private func validate(inputText: String?) -> ValidationResult  {
        if let text = inputText where text.characters.count > _maxLength {
            return ValidationResult(false, [message]);
        } else {
            return ValidationResult(true);
        }
    }
    
    private func validate(textView : UITextView) -> ValidationResult {
        return validate(textView.text)
    }
    
    private func validate(textField : UITextField) -> ValidationResult {
        return validate(textField.text);
    }
}

public func IsShorterThan(maxLength : Int) -> (UITextField) -> ValidationResult {
    return MaxLengthRule(maxLength: maxLength).validate;
}

public func IsShorterThan(maxLength : Int) -> (UITextView) -> ValidationResult {
    return MaxLengthRule(maxLength: maxLength).validate;
}
