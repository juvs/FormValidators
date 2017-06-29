//
//  ValidatorHandler.swift
//  Pods
//
//  Created by Juvenal Guzman on 6/27/17.
//
//

import Foundation

open class ValidatorHandler {
    public var errorStyleTransform: ErrorStyleTransform? = nil
    public var successStyleTransform: SucessStyleTransform? = nil
    public var onIsValid: OnIsValidCallback? = nil
    public var onIsInvalid: OnIsInvalidCallback? = nil
    
    public init() {
        
    }
    
    public func transformers(success: SucessStyleTransform? = nil, error: ErrorStyleTransform?) {
        self.successStyleTransform = success
        self.errorStyleTransform = error
    }
    
    public func callbacks(isValid: OnIsValidCallback? = nil, isInValid: OnIsInvalidCallback? = nil) {
        self.onIsValid = isValid
        self.onIsInvalid = isInValid
    }
}
