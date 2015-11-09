//
//  Rule.swift
//  Pods
//
//  Created by GaryLai on 6/11/15.
//
//

import Foundation

public class MSARule : Rule {
    internal var defaultErrorMessage: String {
        return "";
    }
    
    internal var customErrorMessage: String?;
    
    internal var errorMessage: String {
        if let msg = customErrorMessage {
            return msg;
        }
        return defaultErrorMessage;
    }
    
    public func otherwise(errorMessage: String) -> Self{
        customErrorMessage = errorMessage;
        return self;
    }
}

public protocol Rule {
    func otherwise(errorMessage: String) -> Self;
}

public protocol UITextFieldRule : Rule{
    func validate(textField : UITextField) -> ValidationResult;
}

public protocol UITextViewRule : Rule{
    func validate(textField : UITextView) -> ValidationResult;
}

public protocol UIPickerViewRule : Rule{
    func validate(textField : UIPickerView) -> ValidationResult;
}