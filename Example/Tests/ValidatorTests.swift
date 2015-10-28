// https://github.com/Quick/Quick

import Quick
import Nimble
import MSAValidator
import UIKit

private class MyRule<T : UIView> {
    var ranAgainst: [UIView];
    init() {
        ranAgainst = [UIView]();
    }
    func validate(target: T) -> ValidationResult {
        ranAgainst.append(target);
        return ValidationResult(true);
    }
}

private class FailedRule<T : UIView> {
    let message : String!;
    init (_ message : String) {
        self.message = message;
    }
    func validate(target: T) -> ValidationResult {
        return ValidationResult(false, [message]);
    }
}

private class PassedRule<T : UIView> {
    func validate(target: T) -> ValidationResult {
        return ValidationResult(true);
    }
}

class ValidatorSpec: QuickSpec {
    override func spec() {
        describe("Validator") {
            var validator: Validator!;
            
            var textField1 : UITextField!;
            var textField2 : UITextField!;
            var textField3 : UITextField!;
            var textView1 : UITextView!;
            var textView2 : UITextView!;
            beforeEach {
                validator = Validator();
                
                textField1 = UITextField();
                textField2 = UITextField();
                textField3 = UITextField();
                textView1 = UITextView();
                textView2 = UITextView();
            }
            afterEach {
                
            }
            
            context("when validating all registered fields") {
                it("should run all rules agianst registered targets") {
                    let textFieldRule1 = MyRule<UITextField>();
                    let textFieldRule2 = MyRule<UITextField>();
                    let textViewRule1 = MyRule<UITextView>();
                    
                    validator.makeSure(textField1, textFieldRule1.validate, textFieldRule2.validate);
                    validator.makeSure(textField2, textFieldRule2.validate);
                    validator.makeSure(textView1, textViewRule1.validate);
                    
                    validator.validate();
                    
                    expect(textFieldRule1.ranAgainst).to(contain(textField1));
                    expect(textFieldRule1.ranAgainst.count).to(equal(1));
                    expect(textFieldRule2.ranAgainst).to(contain(textField1, textField2));
                    expect(textFieldRule2.ranAgainst.count).to(equal(2));
                    expect(textViewRule1.ranAgainst).to(contain(textView1));
                    expect(textViewRule1.ranAgainst.count).to(equal(1));
                }
                
                context("when all rule passed") {
                    it("should return an empty invalid array and an valid array will all the registered fields"){
                        let textFieldRule1 = PassedRule<UITextField>();
                        let textFieldRule2 = PassedRule<UITextField>();
                        let textViewRule1 = PassedRule<UITextView>();
                        
                        validator.makeSure(textField1, textFieldRule1.validate, textFieldRule2.validate);
                        validator.makeSure(textView1, textViewRule1.validate);
                        
                        let result = validator.validate();
                        
                        expect(result.valid.count).to(equal(2));
                        expect(result.valid).to(contain(textField1, textView1));
                        expect(result.invalid.count).to(equal(0));
                    }
                }
                
                context("when some of the rules failed"){
                    it("should return validated fields in valid array and all failed fields in invalid with resons"){
                        let textFieldRule1 = PassedRule<UITextField>();
                        let textFieldRule2 = PassedRule<UITextField>();
                        let textFieldRule3 = PassedRule<UITextField>();
                        let textFieldRule4 = FailedRule<UITextField>("failed 1");
                        let textFieldRule5 = FailedRule<UITextField>("failed 2");
                        let textFieldRule6 = FailedRule<UITextField>("failed 3");
                        let textViewRule1 = PassedRule<UITextView>();
                        let textViewRule2 = FailedRule<UITextView>("failed 4");
                        
                        validator.makeSure(textField1, textFieldRule1.validate, textFieldRule2.validate);
                        validator.makeSure(textField2, textFieldRule3.validate, textFieldRule4.validate);
                        validator.makeSure(textField3, textFieldRule5.validate, textFieldRule6.validate);
                        validator.makeSure(textView1, textViewRule1.validate);
                        validator.makeSure(textView2, textViewRule2.validate);
                        
                        let result = validator.validate();
                        
                        expect(result.valid.count).to(equal(2));
                        expect(result.valid).to(contain(textField1, textView1));
                        expect(result.invalid.count).to(equal(3));
                        expect(Array(result.invalid.keys)).to(contain(textField2, textField3, textView2));
                        expect(result.invalid[textField2]!.count).to(equal(1));
                        expect(result.invalid[textField2]!).to(contain("failed 1"));
                        expect(result.invalid[textField3]!.count).to(equal(2));
                        expect(result.invalid[textField3]!).to(contain("failed 2", "failed 3"));
                        expect(result.invalid[textView2]!.count).to(equal(1));
                        expect(result.invalid[textView2]!).to(contain("failed 4"));
                    }
                }
            }
            
            context("when validating a specific field") {
                context("when the field not registered"){
                    it("should throw error"){
                        expect { try validator.validate(field: textField1) }.to(throwError(ValidationError.FieldNotRegistered));
                    }
                }
                
                context("when all rules pass"){
                    it("should return ture and an empty array in the ValidationResult object"){
                        let textFieldRule1 = PassedRule<UITextField>();
                        let textFieldRule2 = PassedRule<UITextField>();
                        let textFieldRule3 = PassedRule<UITextField>();
                        let textFieldRule4 = FailedRule<UITextField>("failed 1");
                        
                        validator.makeSure(textField1, textFieldRule1.validate, textFieldRule2.validate);
                        validator.makeSure(textField2, textFieldRule3.validate, textFieldRule4.validate);
                        
                        let result = try! validator.validate(field: textField1);
                        
                        expect(result.passed).to(beTrue());
                        expect(result.failedReason).to(beEmpty());
                    }

                }
                
                context("when some rules fail"){
                    it("should return fail and an array of reasons in the ValidationResult object"){
                        let textFieldRule1 = PassedRule<UITextField>();
                        let textFieldRule2 = PassedRule<UITextField>();
                        let textFieldRule3 = PassedRule<UITextField>();
                        let textFieldRule4 = FailedRule<UITextField>("failed 1");
                        
                        validator.makeSure(textField1, textFieldRule1.validate, textFieldRule2.validate);
                        validator.makeSure(textField2, textFieldRule3.validate, textFieldRule4.validate);
                        
                        let result = try! validator.validate(field: textField2);
                        
                        expect(result.passed).to(beFalse());
                        expect(result.failedReason!.count).to(equal(1));
                        expect(result.failedReason!).to(contain("failed 1"));
                    }
                    
                }
            }
            
            
        }
    }
}
