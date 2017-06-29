//
//  FieldValidator.swift
//  Pods
//
//  Created by Juvenal Guzman on 6/27/17.
//
//

import Foundation

//-----------------------------------------------------------
//MARK: - TextFieldValidator encapsulates logic...

open class FieldValidator: NSObject, UITextFieldDelegate  {
    
    private var maxLength: Int
    private var textField: UITextField!
    
    private var lastText: String?
    private var validated = false
    private var valid = true
    private var lastMessage = ""
    
    var validators: [ValidatorType] = []
    var errorStyleTransform: ErrorStyleTransform?
    var successStyleTransform: SucessStyleTransform?
    var returnCallback: ReturnCallback?
    var domain: String?
    var formValidator: FormValidator?
    var detailLabel: UILabel?
    
    
    init(validators: [ValidatorType] = [], formValidator: FormValidator? = nil, domain: String? = nil, detailLabel: UILabel? = nil, successStyleTransform: SucessStyleTransform? = nil, errorStyleTransform: ErrorStyleTransform? = nil, returnCallback: ReturnCallback? = nil) {
        self.maxLength = 0
        self.validators = validators
        self.errorStyleTransform = errorStyleTransform
        self.successStyleTransform = successStyleTransform
        self.formValidator = formValidator
        self.returnCallback = returnCallback
        self.domain = domain
        self.detailLabel = detailLabel
        
        for validator in validators {
            if validator.name == "MaxLength" { //On max length limits text input characters
                self.maxLength = validator.value
                break
            }
        }
    }
    
    deinit {
    }
    
    func attachTo(_ textField: UITextField) {
        self.textField = textField
        if self.textField.delegate == nil {
            self.textField.delegate = self
        }
    }
    
    func setReturnCallback(_ textField: UITextField, callback: @escaping ReturnCallback) {
        attachTo(textField)
        self.returnCallback = callback
    }
    
    func isValid() -> (valid: Bool, message: String) {
        let text = self.textField.text!
        validateField(text)
        return (valid, lastMessage)
    }
    
    private func validateField(_ text: String) {
        lastText = text
        lastMessage = ""
        valid = true
        for validator in validators {
            if !validator.isValid(text: text) {
                if let label = self.detailLabel {
                    label.text = validator.message
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
            successStyleTransform(self.textField, self.detailLabel)
        } else if let successStyleTransform = self.formValidator?.successStyleTransform {
            successStyleTransform(self.textField, self.detailLabel)
        } else if let successStyleTransform = SharedFormValidator.sharedManager().successStyleTransform {
            successStyleTransform(self.textField, self.detailLabel)
        }
    }
    
    private func performErrorStyleTransform(_ validator: ValidatorType) {
        if !validator.messageType.isNone {
            if let errorStyleTransform = self.errorStyleTransform {
                errorStyleTransform(self.textField, self.detailLabel, validator)
            } else if let errorStyleTransform = self.formValidator?.errorStyleTransform {
                errorStyleTransform(self.textField, self.detailLabel, validator)
            } else if let errorStyleTransform = SharedFormValidator.sharedManager().errorStyleTransform {
                errorStyleTransform(self.textField, self.detailLabel, validator)
            }
        }
    }
    
    ///----------------------------------------------
    /// MARK: UITextField/UITextView delegates
    ///----------------------------------------------
    
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.maxLength <= 0 {
            return true
        }
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= maxLength
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isSecureTextEntry {
            validated = false
        } else {
            validated = lastText == nil ? false : lastText! == textField.text!
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text!
        validateField(text)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder();
        if let returnCallback = self.returnCallback {
            returnCallback(textField, self.detailLabel)
        }
        return true;
    }
}
