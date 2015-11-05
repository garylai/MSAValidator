//
//  RulesTest.swift
//  MSAValidator
//
//  Created by GaryLai on 5/11/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import MSAValidator
import UIKit

class TextBasedRuleSpec: QuickSpec {
    override func spec() {
        describe("Text Based Rules") {
            var textField1: UITextField!;
            var textView1: UITextView!;
            var validator: Validator!;
            var textFieldRuleGetter: (() -> ((UITextField) -> ValidationResult))!;
            var textViewRuleGetter: (() -> ((UITextView) -> ValidationResult))!;
            
            func testFails(textField1Text textField1Text: String?, textView1Text: String?) {
                textField1.text = textField1Text;
                textView1.text = textView1Text;
                
                let result1 = textFieldRuleGetter()(textField1);
                let result2 = textViewRuleGetter()(textView1);
                
                expect(result1.passed).to(beFalse());
                expect(result1.failedReason!.count).to(equal(1));
                expect(result2.passed).to(beFalse());
                expect(result2.failedReason!.count).to(equal(1));
                
                validator.makeSure(textField1, textFieldRuleGetter());
                validator.makeSure(textView1, textViewRuleGetter());
                
                let result3 = validator.validate();
                expect(result3.valid).to(beEmpty());
                expect(result3.invalid.keys.count).to(equal(2));
                expect(result3.invalid.keys).to(contain(textField1, textView1));
                expect(result3.invalid.values.count).to(equal(2));
            }
            
            func testPasses(textField1Text textField1Text: String?, textView1Text: String?) {
                textField1.text = textField1Text;
                textView1.text = textView1Text;
                
                let result1 = textFieldRuleGetter()(textField1);
                let result2 = textViewRuleGetter()(textView1);
                
                expect(result1.passed).to(beTrue());
                expect(result1.failedReason!).to(beEmpty());
                expect(result2.passed).to(beTrue());
                expect(result2.failedReason!).to(beEmpty());
                
                validator.makeSure(textField1, textFieldRuleGetter());
                validator.makeSure(textView1, textViewRuleGetter());
                
                let result3 = validator.validate();
                expect(result3.valid.count).to(equal(2));
                expect(result3.valid).to(contain(textField1, textView1));
                expect(result3.invalid).to(beEmpty());
                
            }
            
            beforeEach {
                textField1 = UITextField();
                textView1 = UITextView();
                validator = Validator();
            }
            
            describe("Required Rule") {
                beforeEach {
                    textFieldRuleGetter = IsPresent;
                    textViewRuleGetter = IsPresent;
                }
                context("when target is empty"){
                    it("should return false"){
                        testFails(textField1Text: nil, textView1Text: nil);
                    }
                }
                context("when target is not emty"){
                    it("should return true"){
                        testPasses(textField1Text: "hello", textView1Text: "bye");
                    }
                }
            }
            
            describe("email Rule") {
                beforeEach {
                    textFieldRuleGetter = IsAnEmail;
                    textViewRuleGetter = IsAnEmail;
                }
                context("when target is empty"){
                    it("should return false"){
                        testFails(textField1Text: nil, textView1Text: nil);
                    }
                }
                context("when target is not an email"){
                    it("should return true"){
                        testFails(textField1Text: "hello", textView1Text: "bye");
                    }
                }
                context("when target is an email"){
                    it("should return true"){
                        testPasses(textField1Text: "a@b.com", textView1Text: "c@d.com");
                    }
                }
            }
            
            describe("max length Rule") {
                beforeEach {
                    textFieldRuleGetter = {() -> (UITextField) -> ValidationResult in
                        IsShorterThan(5);
                    }
                    textViewRuleGetter = {() -> (UITextView) -> ValidationResult in
                        IsShorterThan(5);
                    };
                }
                context("when target is empty"){
                    it("should return false"){
                        testPasses(textField1Text: nil, textView1Text: nil);
                    }
                }
                context("when target is longer than 5"){
                    it("should return true"){
                        testFails(textField1Text: "This is a string longer than 5 characters", textView1Text: "This is a string longer than 5 characters");
                    }
                }
                context("when target is an email"){
                    it("should return true"){
                        testPasses(textField1Text: "hello", textView1Text: "bye");
                    }
                }
            }

        }
    }
}