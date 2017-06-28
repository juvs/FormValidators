//
//  FormValidatorViewController.swift
//  Pods
//
//  Created by Juvenal Guzman on 6/27/17.
//
//

import UIKit

class FormValidatorViewController: UIViewController {
    var FORM_VALIDATOR_INVALID_MESSAGE = "Para continuar corrija los errores de captura"
    
    private var _invalidMessage: String = ""
    private var validator: FormValidator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initValidator()
    }

    internal func initValidator() {
        validator = FormValidator()
        validator.callbacks(isValid: nil, isInValid: {
            self.showAlert(message: self.getInvalidMessage(), title: "", doneTitle: "", doneHandler: nil)
        })
    }
    
    internal func getInvalidMessage() -> String {
        return !self._invalidMessage.isEmpty ? self._invalidMessage : self.FORM_VALIDATOR_INVALID_MESSAGE
    }
    
    func validateField(textField: UITextField, validators: [ValidatorType] = [], domain: String? = nil, successStyleTransform: SucessStyleTransform? = nil, errorStyleTransform: ErrorStyleTransform? = nil, returnCallback: ReturnCallback? = nil) {
        validator.attach(textField: textField,
                         validators: validators,
                         domain: domain,
                         successStyleTransform: successStyleTransform,
                         errorStyleTransform: errorStyleTransform,
                         returnCallback: returnCallback)
    }
    
    
    func setReturnCallback(textField: UITextField, callback: @escaping ReturnCallback) {
        validator.setReturnCallback(textField: textField, callback: callback)
    }
    
    func isValid(message: String = "", domain: String? = nil) -> Bool {
        _invalidMessage = message
        return validator.isValid(domain: domain)
    }

    func showAlert(message: String, title: String, doneTitle: String, doneHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: doneTitle, style: .default, handler: doneHandler))
        self.present(alert, animated: true, completion: nil)
    }
}
