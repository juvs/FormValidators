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

class FieldValidator: NSObject, UITextFieldDelegate  {
    
    private var maxLength: Int
    
    var validators: [ValidatorType] = []
    var errorStyleTransform: ErrorStyleTransform?
    var successStyleTransform: SucessStyleTransform?
    var returnCallback: ReturnCallback?
    var domain: String?
    let formValidator: FormValidator?
    
    private var textField: UITextField!
    private var lastText: String?
    private var validated = false
    
    private var valid = true
    private var lastMessage = ""
    
    init(validators: [ValidatorType] = [], successStyleTransform: SucessStyleTransform? = nil, errorStyleTransform: ErrorStyleTransform? = nil, returnCallback: ReturnCallback? = nil, formValidator: FormValidator? = nil, domain: String? = nil) {
        self.maxLength = 0
        self.validators = validators
        self.errorStyleTransform = errorStyleTransform
        self.successStyleTransform = successStyleTransform
        self.formValidator = formValidator
        self.returnCallback = returnCallback
        self.domain = domain
        
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
            successStyleTransform(self.textField)
        } else if let successStyleTransform = self.formValidator?.successStyleTransform {
            successStyleTransform(self.textField)
        } else if let successStyleTransform = SharedFormValidator.sharedManager().successStyleTransform {
            successStyleTransform(self.textField)
        }
    }
    
    private func performErrorStyleTransform(_ validator: ValidatorType) {
        if !validator.messageType.isNone {
            if let errorStyleTransform = self.errorStyleTransform {
                errorStyleTransform(self.textField, validator)
            } else if let errorStyleTransform = self.formValidator?.errorStyleTransform {
                errorStyleTransform(self.textField, validator)
            } else if let errorStyleTransform = SharedFormValidator.sharedManager().errorStyleTransform {
                errorStyleTransform(self.textField, validator)
            }
        }
    }
    
    ///----------------------------------------------
    /// MARK: UITextField/UITextView delegates
    ///----------------------------------------------
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //        print("TextField should begin editing method called")
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        print("TextField did begin editing method called")
        if textField.isSecureTextEntry {
            validated = false
        } else {
            validated = lastText == nil ? false : lastText! == textField.text!
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        print("TextField did end editing method called")
        let text = textField.text!
        validateField(text)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //        print("TextField should clear method called")
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //        print("TextField should end editing method called")
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        print("TextField should return method called")
        //textField.resignFirstResponder();
        if let returnCallback = self.returnCallback {
            returnCallback(textField)
        }
        return true;
    }
}
