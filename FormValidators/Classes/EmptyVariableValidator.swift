//
//  EmptyVariableValidator.swift
//  Pods
//
//  Created by Juvenal Guzman on 6/27/17.
//
//

import Foundation

class EmptyVariableValidator: VariableValidator {
    let objectoToEvaluate: AnyObject?
    let message: String
    var _domain: String?
    
    init(objectoToEvaluate: AnyObject?, message: String = "Object is null", domain: String? = nil) {
        self.objectoToEvaluate = objectoToEvaluate
        self.message = message
        self._domain = domain
    }
    
    var domain: String? {
        return self._domain
    }
    
    func isValid() -> (valid: Bool, message: String) {
        return (objectoToEvaluate != nil, message)
    }
}
