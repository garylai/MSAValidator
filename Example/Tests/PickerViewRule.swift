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

class PickerViewRuleSpec: QuickSpec {
    override func spec() {
        var pickerView : UIPickerView!;
        var validator : Validator!;
        beforeEach {
            pickerView = UIPickerView();
            validator = Validator();
        }
        describe("Picker View Rule") {
            context("when selection is in range"){
                it("should return true"){
                    
                }
            }
            context("when selection is not in range"){
                it("should return false"){
                    
                }
            }
        }
    }
}
