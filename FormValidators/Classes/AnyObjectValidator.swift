//
//  AnyObjectValidator.swift
//  Pods
//
//  Created by Juvenal Guzman on 6/27/17.
//
//

import Foundation

class AnyObjectValidator {
    
    var validators: [ValidatorType] = []
    var errorStyleTransform: ErrorStyleTransformAny?
    var successStyleTransform: SucessStyleTransformAny?
    var domain: String?
    let formValidator: FormValidator?
    let value: AnyObject!
    
    private var valid = true
    private var lastMessage = ""
    
    init(_ value: AnyObject, validators: [ValidatorType] = [], successStyleTransform: SucessStyleTransformAny? = nil, errorStyleTransform: ErrorStyleTransformAny? = nil, formValidator: FormValidator? = nil, domain: String? = nil) {
        self.validators = validators
        self.errorStyleTransform = errorStyleTransform
        self.successStyleTransform = successStyleTransform
        self.domain = domain
        self.formValidator = formValidator
        self.value = value
    }
    
    deinit {
    }
    
    func isValid() -> (valid: Bool, message: String) {
        validateField(valueToString())
        return (valid, lastMessage)
    }
    
    private func valueToString() -> String {
        return value as? String ?? ""
    }
    
    private func validateField(_ text: String) {
        lastMessage = ""
        valid = true
        for validator in validators {
            if !validator.isValid(text: text) {
                performErrorStyleTransform(validator)
                lastMessage = text
                valid = false
                break
            }
        }
        if valid {
            performSuccessStyleTransform()
        }
    }
    
    private func performSuccessStyleTransform() {
        if let successStyleTransform = self.successStyleTransform {
            successStyleTransform()
        }
    }
    
    private func performErrorStyleTransform(_ validator: ValidatorType) {
        if !validator.messageType.isNone {
            if let errorStyleTransform = self.errorStyleTransform {
                errorStyleTransform(validator)
            }
        }
    }
}
