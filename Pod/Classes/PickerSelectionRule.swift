//
//  PickerSelectionRule.swift
//  Pods
//
//  Created by GaryLai on 5/11/15.
//
//

import UIKit

private class PickerViewRule: MSARule, UIPickerViewRule {
    private let componentIndex: Int;
    private let validRange: Range<Int>;
    override var defaultErrorMessage :String {
        return "Selected row in component no. \(componentIndex + 1) is not between \(validRange.startIndex + 1) and \(validRange.endIndex)";
    }
    init(compmentIndex componentIndex: Int, validRange: Range<Int>){
        self.componentIndex = componentIndex;
        self.validRange = validRange;
    }
    func validate(pickerView: UIPickerView) -> ValidationResult {
        if validRange ~= pickerView.selectedRowInComponent(componentIndex) {
            return ValidationResult(true);
        }
        return ValidationResult(false, [errorMessage]);
    }
}

public func Component(componentIndex: Int, IsInRange validRange: Range<Int>) -> UIPickerViewRule {
    return PickerViewRule(compmentIndex: componentIndex, validRange: validRange);
}