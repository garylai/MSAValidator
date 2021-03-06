//
//  PickerViewRule.swift
//  MSAValidator
//
//  Created by GaryLai on 5/11/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import MSAValidator
import UIKit

class DummyPickerView : UIPickerView {
    var resultIndex: [Int: Int]!;
    override func selectedRowInComponent(component: Int) -> Int {
        if let selectedRow = resultIndex[component] {
            return selectedRow;
        }
        return -1;
    }
}

class PickerViewRuleSpec: QuickSpec {
    override func spec() {
        var pickerView : UIPickerView!;
        var validator : Validator!;
        beforeEach {
            pickerView = DummyPickerView();
            validator = Validator();
        }
        describe("Picker View Rule") {
            context("when selection is in range"){
                it("should return true"){
                    (pickerView as! DummyPickerView).resultIndex = [0:1, 1:2, 2:5];
                    
                    let result1 = Component(0, IsInRange: 1...5).validate(pickerView);
                    let result2 = Component(1, IsInRange: 1...5).validate(pickerView);
                    let result3 = Component(2, IsInRange: 1...5).validate(pickerView);
                    
                    expect(result1.passed).to(beTrue());
                    expect(result1.failedReason).to(beEmpty());
                    expect(result2.passed).to(beTrue());
                    expect(result2.failedReason).to(beEmpty());
                    expect(result3.passed).to(beTrue());
                    expect(result3.failedReason).to(beEmpty());
                    
                    validator.makeSure(pickerView, Component(0, IsInRange: 1...5), Component(1, IsInRange: 1...5), Component(2, IsInRange: 1...5));
                    let result4 = validator.validate();
                    
                    expect(result4.valid.count).to(equal(1));
                    expect(result4.valid).to(contain(pickerView));
                    expect(result4.invalid).to(beEmpty());
                }
            }
            context("when selection is not in range"){
                it("should return false"){
                    (pickerView as! DummyPickerView).resultIndex = [0:0, 1:6, 2:-1];
                    
                    let result1 = Component(0, IsInRange: 1...5).validate(pickerView);
                    let result2 = Component(1, IsInRange: 1...5).validate(pickerView);
                    let result3 = Component(2, IsInRange: 1...5).validate(pickerView);
                    
                    expect(result1.passed).to(beFalse());
                    expect(result1.failedReason.count).to(equal(1));
                    expect(result1.failedReason![0]).to(equal("Selected row in component no. 1 is not between 2 and 6"));
                    expect(result2.passed).to(beFalse());
                    expect(result2.failedReason.count).to(equal(1));
                    expect(result2.failedReason![0]).to(equal("Selected row in component no. 2 is not between 2 and 6"));
                    expect(result3.passed).to(beFalse());
                    expect(result3.failedReason.count).to(equal(1));
                    expect(result3.failedReason![0]).to(equal("Selected row in component no. 3 is not between 2 and 6"));
                    
                    validator.makeSure(pickerView, Component(0, IsInRange: 1...5).otherwise("testing 123"),
                                                    Component(1, IsInRange: 1...5).otherwise("testing 246"),
                                                    Component(2, IsInRange: 1...5).otherwise("testing 135"));
                    let result4 = validator.validate();
                    
                    expect(result4.valid).to(beEmpty());
                    expect(result4.invalid.count).to(equal(1));
                    expect(result4.invalid.keys).to(contain(pickerView));
                    expect(result4.invalid[pickerView]!.count).to(equal(3));
                    let pvErrors = result4.invalid[pickerView]!;
                    expect(pvErrors[0]).to(equal("testing 123"));
                    expect(pvErrors[1]).to(equal("testing 246"));
                    expect(pvErrors[2]).to(equal("testing 135"));

                }
            }
        }
    }
}
