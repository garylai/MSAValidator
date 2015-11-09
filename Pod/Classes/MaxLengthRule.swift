//
//  MaxLengthRule.swift
//  Pods
//
//  Created by GaryLai on 26/10/15.
//
//

import UIKit

private class MaxLengthRule : MSARule, UITextFieldRule, UITextViewRule {
    let _maxLength : Int;
    init (maxLength : Int, withErrorMessage errorMsg: String? = nil) {
        _maxLength = maxLength;
        super.init();
    }
    
    override var defaultErrorMessage : String {
        return "Input cannot be longer than \(_maxLength) characters";
    }
    
    func validate(inputText: String?) -> ValidationResult  {
        if let text = inputText where text.characters.count > _maxLength {
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

public func IsShorterThan(maxLength : Int) -> UITextFieldRule {
    return MaxLengthRule(maxLength: maxLength);
}

public func IsShorterThan(maxLength : Int) -> UITextViewRule {
    return MaxLengthRule(maxLength: maxLength);
}
