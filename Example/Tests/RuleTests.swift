//
//  RuleTests.swift
//  MSAValidator
//
//  Created by GaryLai on 12/11/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MSAValidator

class RuleTests: QuickSpec {
    override func spec() {
        describe("base rule"){
            context("when no custom error is set"){
                it("should return default message"){
                    let rule = MSARule();
                    expect(rule.errorMessage).to(equal(""));
                }
            }
            context("when custom error is set"){
                it("should return default message"){
                    let rule = MSARule();
                    rule.otherwise("hello")
                    expect(rule.errorMessage).to(equal("hello"));
                }
            }
        }
    }
}
