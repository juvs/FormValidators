//
//  MainValidator.swift
//  Pods
//
//  Created by Juvenal Guzman on 6/27/17.
//
//

import Foundation

//-----------------------------------------------------------
// MARK: - FormValidator groups all validator...


open class FormValidator: ValidatorHandler {
    
    var fieldValidators: [FieldValidator] = []
    var anyObjectValidators: [AnyObjectValidator] = []

    func attach(textField: UITextField, fieldValidator: FieldValidator) {
        var localFieldValidator = fieldValidator
        if let index = fieldValidators.index(of: fieldValidator) {
            localFieldValidator = fieldValidators[index]
        } else {
            fieldValidators.append(localFieldValidator)
        }
        localFieldValidator.attachTo(textField)
    }
    
    public func attach(textField: UITextField, validators: [ValidatorType], domain: String? = nil, successStyleTransform: SucessStyleTransform? = nil, errorStyleTransform: ErrorStyleTransform? = nil, detailLabel: UILabel? = nil, returnCallback: ReturnCallback? = nil) {
        if validators.count == 0 {
            return
        }
        if let fieldValidator = textField.delegate as? FieldValidator {
            fieldValidator.validators = validators
            fieldValidator.successStyleTransform = successStyleTransform
            fieldValidator.errorStyleTransform = errorStyleTransform
            fieldValidator.returnCallback = returnCallback
            fieldValidator.domain = domain
            fieldValidator.detailLabel = detailLabel
            attach(textField: textField, fieldValidator: fieldValidator)
        } else {
            if textField.delegate != nil {
                debugPrint("Field already has delegate and is different from FieldValidator, couldn't attach validators")
            } else {
                let fieldValidator = FieldValidator(validators: validators, formValidator: self, domain: domain, detailLabel: detailLabel, successStyleTransform: successStyleTransform, errorStyleTransform: errorStyleTransform, returnCallback: returnCallback)
                fieldValidator.attachTo(textField)
                fieldValidators.append(fieldValidator)
            }
        }
    }
    
    public func attach(value: AnyObject, validators: [ValidatorType], domain: String? = nil, detailLabel: UILabel? = nil, successStyleTransform: SucessStyleTransform? = nil, errorStyleTransform: ErrorStyleTransform? = nil) {
        let anyObjectValidator = AnyObjectValidator(value, validators: validators, domain: domain, detailLabel: detailLabel, successStyleTransform: successStyleTransform, errorStyleTransform: errorStyleTransform)
        anyObjectValidators.append(anyObjectValidator)
    }
    
    public func setReturnCallback(textField: UITextField, callback: @escaping ReturnCallback) {
        if let fieldValidator = textField.delegate as? FieldValidator {
            fieldValidator.setReturnCallback(textField, callback: callback)
        } else {
            if textField.delegate != nil {
                debugPrint("Field already has delegate and is different from FieldValidator, couldn't attach return callback")
            } else {
                let fieldValidator = FieldValidator(formValidator: self)
                attach(textField: textField, fieldValidator: fieldValidator)
            }
        }
    }
    
    public func isValid(domain: String? = nil) -> Bool {
        var allIsValid = true
        var fValidators = fieldValidators
        var aValidators = anyObjectValidators
        
        if let domain = domain {
            if !domain.isEmpty {
                fValidators = fieldValidators.filter({$0.domain == domain})
                aValidators = anyObjectValidators.filter({$0.domain == domain})
            }
        }
        
        for fieldValidator in fValidators {
            let response = fieldValidator.isValid()
            if !response.valid {
                allIsValid = false
            }
        }
        

        for anyObjectValidator in aValidators {
            let response = anyObjectValidator.isValid()
            if !response.valid {
                allIsValid = false
            }
        }
        
        if allIsValid {
            if let onIsValid = self.onIsValid {
                onIsValid()
            } else if let onIsValid = SharedFormValidator.sharedManager().onIsValid {
                onIsValid()
            }
        } else {
            if let onIsInvalid = self.onIsInvalid {
                onIsInvalid()
            } else if let onIsInvalid = SharedFormValidator.sharedManager().onIsInvalid {
                onIsInvalid()
            }
        }
        return allIsValid
    }
}
