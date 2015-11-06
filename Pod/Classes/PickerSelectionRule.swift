//
//  PickerSelectionRule.swift
//  Pods
//
//  Created by GaryLai on 5/11/15.
//
//

import UIKit

private class PickerViewRule {
    private let componentIndex: Int;
    private let validRange: Range<Int>;
    private var message :String {
        get {
            return "Selected row in component no. \(componentIndex + 1) is not between \(validRange.startIndex + 1) and \(validRange.endIndex + 1)";
        }
    }
    init(compmentIndex componentIndex: Int, validRange: Range<Int>){
        self.componentIndex = componentIndex;
        self.validRange = validRange;
    }
    private func validate(pickerView: UIPickerView) -> ValidationResult {
        if validRange ~= pickerView.selectedRowInComponent(componentIndex) {
            return ValidationResult(true);
        } else {
            return ValidationResult(false, [message]);
        }
    }
}

public func Component(componentIndex: Int, IsInRange validRange: Range<Int>) -> ((UIPickerView) -> ValidationResult){
    return PickerViewRule(compmentIndex: componentIndex, validRange: validRange).validate;
}