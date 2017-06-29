//
//  AnyObjectValidator.swift
//  Pods
//
//  Created by Juvenal Guzman on 6/27/17.
//
//

import Foundation

open class AnyObjectValidator {
    
    var validators: [ValidatorType] = []
    var errorStyleTransform: ErrorStyleTransform?
    var successStyleTransform: SucessStyleTransform?
    var domain: String?
    var detailLabel: UILabel?
    let formValidator: FormValidator?
    let value: AnyObject!
    
    private var valid = true
    private var lastMessage = ""
    
    init(_ value: AnyObject, validators: [ValidatorType] = [], domain: String? = nil, detailLabel: UILabel? = nil, formValidator: FormValidator? = nil, successStyleTransform: SucessStyleTransform? = nil, errorStyleTransform: ErrorStyleTransform? = nil) {
        self.validators = validators
        self.errorStyleTransform = errorStyleTransform
        self.successStyleTransform = successStyleTransform
        self.domain = domain
        self.formValidator = formValidator
        self.value = value
        self.detailLabel = detailLabel
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
                if let label = self.detailLabel {
                    label.text = text
                }
                performErrorStyleTransform(validator)
                lastMessage = text
                valid = false
                break
            }
        }
        if valid {
            if let label = self.detailLabel {
                label.text = ""
            }
            performSuccessStyleTransform()
        }
    }
    
    private func performSuccessStyleTransform() {
        if let successStyleTransform = self.successStyleTransform {
            successStyleTransform(nil, self.detailLabel)
        } else if let successStyleTransform = self.formValidator?.successStyleTransform {
            successStyleTransform(nil, self.detailLabel)
        } else if let successStyleTransform = SharedFormValidator.sharedManager().successStyleTransform {
            successStyleTransform(nil, self.detailLabel)
        }
    }
    
    private func performErrorStyleTransform(_ validator: ValidatorType) {
        if !validator.messageType.isNone {
            if let errorStyleTransform = self.errorStyleTransform {
                errorStyleTransform(nil, self.detailLabel, validator)
            } else if let errorStyleTransform = self.formValidator?.errorStyleTransform {
                errorStyleTransform(nil, self.detailLabel, validator)
            } else if let errorStyleTransform = SharedFormValidator.sharedManager().errorStyleTransform {
                errorStyleTransform(nil, self.detailLabel, validator)
            }
        }
    }
}
