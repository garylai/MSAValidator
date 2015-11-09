//
//  Validator.swift
//  myspendingapp
//
//  Created by GaryLai on 7/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

public enum ValidationError : ErrorType {
    case FieldNotRegistered
}

public struct ValidationResult {
    public var passed: Bool!;
    public var failedReason: [String]!;
    public init(_ passed : Bool = true, _ failedReason : [String] = [String]()){
        self.passed = passed;
        self.failedReason = failedReason;
    }
}

public func + (left :ValidationResult, right : ValidationResult) -> ValidationResult {
    var result = ValidationResult();
    result.passed = left.passed! && right.passed!;
    result.failedReason.appendContentsOf(left.failedReason);
    result.failedReason.appendContentsOf(right.failedReason);
    return result;
}

public func += (inout left : ValidationResult, right: ValidationResult) {
    left = left + right;
}

private protocol ValidationEntryInfo{
    func validate() -> ValidationResult;
}

private class ValidationEntry<T : UIView> : ValidationEntryInfo{
    let target: T!;
    var rules: [(T) -> ValidationResult]!;
    init(_ target: T) {
        self.target = target;
        rules = Array<(T) -> ValidationResult>();
    }
    func validate() -> ValidationResult {
        var validationResult = ValidationResult();
        for r in rules {
            validationResult += r(target);
        }
        return validationResult;
    }
}

public class Validator {
    
    private var validationEntryDict: [UIView: ValidationEntryInfo]!;
    
    public func makeSure<T : UIView>(target: T, _ rules: [(T) -> ValidationResult]){
        if validationEntryDict[target] == nil {
            validationEntryDict[target] = ValidationEntry<T>(target);
        }
        (validationEntryDict[target] as! ValidationEntry<T>).rules.appendContentsOf(rules);
    }
    
    // TODO: refactor these 3 duplicating methods
    public func makeSure(target: UITextView, _ rules: UITextViewRule...) {
        makeSure(target, rules.map({ (r) -> ((UITextView) -> ValidationResult) in
            r.validate;
        }));
    }
    public func makeSure(target: UITextField, _ rules: UITextFieldRule...) {
        makeSure(target, rules.map({ (r) -> ((UITextField) -> ValidationResult) in
            r.validate;
        }));
    }
    public func makeSure(target: UIPickerView, _ rules: UIPickerViewRule...) {
        makeSure(target, rules.map({ (r) -> ((UIPickerView) -> ValidationResult) in
            r.validate;
        }));
    }
    
    public func makeSure<T : UIView>(target: T, _ rules: (T) -> ValidationResult...){
        makeSure(target, rules);
    }
    
    public init () {
        validationEntryDict = [UIView : ValidationEntryInfo]();
    }

    public func validate(field targetTextField : UIView) throws -> ValidationResult {
        guard let validationEntry = validationEntryDict[targetTextField] else {
            throw ValidationError.FieldNotRegistered;
        }
        return validationEntry.validate();
    }

    public func validate() -> (valid: [UIView], invalid: [UIView : [String]]) {
        var invalidFields = [UIView : [String]]();
        var validFields = [UIView]();
        for element in validationEntryDict {
            let targetField = element.0;
            let validationEntry = element.1;
            
            let validationResult = validationEntry.validate();
            if validationResult.passed == true {
                validFields.append(targetField);
            } else {
                invalidFields[targetField] = validationResult.failedReason;
            }
        }
        return (valid: validFields, invalid: invalidFields);
    }
}
