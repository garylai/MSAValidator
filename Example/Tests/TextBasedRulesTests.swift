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
            beforeEach {
                textField1 = UITextField(frame: CGRectMake(0, 0, 100, 100));
                textView1 = UITextView();
                validator = Validator();
            }
            
            describe("Required Rule") {
                context("when target is empty"){
                    it("should return false"){
                        textField1.text = nil;
                        textView1.text = nil;
                        
                        let result1 = IsPresent().validate(textField1);
                        let result2 = IsPresent().validate(textView1);
                        
                        expect(result1.passed).to(beFalse());
                        expect(result1.failedReason!.count).to(equal(1));
                        expect(result1.failedReason![0]).to(equal("This Field is required"));
                        expect(result2.passed).to(beFalse());
                        expect(result2.failedReason!.count).to(equal(1));
                        expect(result2.failedReason![0]).to(equal("This Field is required"));
                        
                        validator.makeSure(textField1, IsPresent().otherwise("testing 123"));
                        validator.makeSure(textView1, IsPresent().otherwise("testing 246"));
                        
                        let result3 = validator.validate();
                        expect(result3.valid).to(beEmpty());
                        expect(result3.invalid.keys.count).to(equal(2));
                        expect(result3.invalid.keys).to(contain(textField1, textView1));
                        expect(result3.invalid.values.count).to(equal(2));
                        let tfErrors = result3.invalid[textField1]!;
                        expect(tfErrors[0]).to(equal("testing 123"));
                        let tvErrors = result3.invalid[textView1]!;
                        expect(tvErrors[0]).to(equal("testing 246"));
                    }
                }
                context("when target is not emty"){
                    it("should return true"){
                        textField1.text = "hello";
                        textView1.text = "bye";
                        
                        let result1 = IsPresent().validate(textField1);
                        let result2 = IsPresent().validate(textView1);
                        
                        expect(result1.passed).to(beTrue());
                        expect(result1.failedReason!).to(beEmpty());
                        expect(result2.passed).to(beTrue());
                        expect(result2.failedReason!).to(beEmpty());
                        
                        validator.makeSure(textField1, IsPresent().otherwise("testing 123"));
                        validator.makeSure(textView1, IsPresent().otherwise("testing 246"));
                        
                        let result3 = validator.validate();
                        expect(result3.valid.count).to(equal(2));
                        expect(result3.valid).to(contain(textField1, textView1));
                        expect(result3.invalid).to(beEmpty());
                    }
                }
            }
            
            describe("email Rule") {
                context("when target is empty"){
                    it("should return false"){
                        textField1.text = nil;
                        textView1.text = nil;
                        
                        let result1 = IsAnEmail().validate(textField1);
                        let result2 = IsAnEmail().validate(textView1);
                        
                        expect(result1.passed).to(beFalse());
                        expect(result1.failedReason!.count).to(equal(1));
                        expect(result1.failedReason![0]).to(equal("Input is not a valid email adress"));
                        expect(result2.passed).to(beFalse());
                        expect(result2.failedReason!.count).to(equal(1));
                        expect(result2.failedReason![0]).to(equal("Input is not a valid email adress"));
                        
                        validator.makeSure(textField1, IsAnEmail().otherwise("testing 123"));
                        validator.makeSure(textView1, IsAnEmail().otherwise("testing 246"));
                        
                        let result3 = validator.validate();
                        expect(result3.valid).to(beEmpty());
                        expect(result3.invalid.keys.count).to(equal(2));
                        expect(result3.invalid.keys).to(contain(textField1, textView1));
                        expect(result3.invalid.values.count).to(equal(2));
                        let tfErrors = result3.invalid[textField1]!;
                        expect(tfErrors[0]).to(equal("testing 123"));
                        let tvErrors = result3.invalid[textView1]!;
                        expect(tvErrors[0]).to(equal("testing 246"));
                    }
                }
                context("when target is not an email"){
                    it("should return true"){
                        textField1.text = "hello";
                        textView1.text = "bye";
                        
                        let result1 = IsAnEmail().validate(textField1);
                        let result2 = IsAnEmail().validate(textView1);
                        
                        expect(result1.passed).to(beFalse());
                        expect(result1.failedReason!.count).to(equal(1));
                        expect(result1.failedReason![0]).to(equal("Input is not a valid email adress"));
                        expect(result2.passed).to(beFalse());
                        expect(result2.failedReason!.count).to(equal(1));
                        expect(result2.failedReason![0]).to(equal("Input is not a valid email adress"));
                        
                        validator.makeSure(textField1, IsAnEmail().otherwise("testing 123"));
                        validator.makeSure(textView1, IsAnEmail().otherwise("testing 246"));
                        
                        let result3 = validator.validate();
                        expect(result3.valid).to(beEmpty());
                        expect(result3.invalid.keys.count).to(equal(2));
                        expect(result3.invalid.keys).to(contain(textField1, textView1));
                        expect(result3.invalid.values.count).to(equal(2));
                        let tfErrors = result3.invalid[textField1]!;
                        expect(tfErrors[0]).to(equal("testing 123"));
                        let tvErrors = result3.invalid[textView1]!;
                        expect(tvErrors[0]).to(equal("testing 246"));
                    }
                }
                context("when target is an email"){
                    it("should return true"){
                        textField1.text = "a@b.com";
                        textView1.text = "c@d.com";
                        
                        let result1 = IsAnEmail().validate(textField1);
                        let result2 = IsAnEmail().validate(textView1);
                        
                        expect(result1.passed).to(beTrue());
                        expect(result1.failedReason!).to(beEmpty());
                        expect(result2.passed).to(beTrue());
                        expect(result2.failedReason!).to(beEmpty());
                        
                        validator.makeSure(textField1, IsAnEmail().otherwise("testing 123"));
                        validator.makeSure(textView1, IsAnEmail().otherwise("testing 246"));
                        
                        let result3 = validator.validate();
                        expect(result3.valid.count).to(equal(2));
                        expect(result3.valid).to(contain(textField1, textView1));
                        expect(result3.invalid).to(beEmpty());
                    }
                }
            }
            
            describe("max length Rule") {
                context("when target is empty"){
                    it("should return true"){
                        let result1 = IsShorterThan(5).validate(textField1);
                        let result2 = IsShorterThan(5).validate(textView1);
                        
                        expect(result1.passed).to(beTrue());
                        expect(result1.failedReason!).to(beEmpty());
                        expect(result2.passed).to(beTrue());
                        expect(result2.failedReason!).to(beEmpty());
                        
                        validator.makeSure(textField1, IsShorterThan(5).otherwise("testing 123"));
                        validator.makeSure(textView1, IsShorterThan(5).otherwise("testing 246"));
                        
                        let result3 = validator.validate();
                        expect(result3.valid.count).to(equal(2));
                        expect(result3.valid).to(contain(textField1, textView1));
                        expect(result3.invalid).to(beEmpty());
                    }
                }
                context("when target is longer than 5"){
                    it("should return false"){
                        textField1.text = "This is a string longer than 5 characters";
                        textView1.text = "This is a string longer than 5 characters";
                        
                        let result1 = IsShorterThan(5).validate(textField1);
                        let result2 = IsShorterThan(5).validate(textView1);
                        
                        expect(result1.passed).to(beFalse());
                        expect(result1.failedReason!.count).to(equal(1));
                        expect(result1.failedReason![0]).to(equal("Input cannot be longer than 5 characters"));
                        expect(result2.passed).to(beFalse());
                        expect(result2.failedReason!.count).to(equal(1));
                        expect(result2.failedReason![0]).to(equal("Input cannot be longer than 5 characters"));
                        
                        validator.makeSure(textField1, IsShorterThan(5).otherwise("testing 123"));
                        validator.makeSure(textView1, IsShorterThan(5).otherwise("testing 246"));
                        
                        let result3 = validator.validate();
                        expect(result3.valid).to(beEmpty());
                        expect(result3.invalid.keys.count).to(equal(2));
                        expect(result3.invalid.keys).to(contain(textField1, textView1));
                        expect(result3.invalid.values.count).to(equal(2));
                        let tfErrors = result3.invalid[textField1]!;
                        expect(tfErrors[0]).to(equal("testing 123"));
                        let tvErrors = result3.invalid[textView1]!;
                        expect(tvErrors[0]).to(equal("testing 246"));
                    }
                }
                context("when target is shorter than 5"){
                    it("should return true"){
                        textField1.text = "hello";
                        textView1.text = "bye";
                        
                        let result1 = IsShorterThan(5).validate(textField1);
                        let result2 = IsShorterThan(5).validate(textView1);
                        
                        expect(result1.passed).to(beTrue());
                        expect(result1.failedReason!).to(beEmpty());
                        expect(result2.passed).to(beTrue());
                        expect(result2.failedReason!).to(beEmpty());
                        
                        validator.makeSure(textField1, IsShorterThan(5).otherwise("testing 123"));
                        validator.makeSure(textView1, IsShorterThan(5).otherwise("testing 246"));
                        
                        let result3 = validator.validate();
                        expect(result3.valid.count).to(equal(2));
                        expect(result3.valid).to(contain(textField1, textView1));
                        expect(result3.invalid).to(beEmpty());
                    }
                }
            }

        }
    }
}