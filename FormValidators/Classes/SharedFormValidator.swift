//
//  MainValidatorHandler.swift
//  Pods
//
//  Created by Juvenal Guzman on 6/27/17.
//
//

import Foundation

public class SharedFormValidator: ValidatorHandler {
    
    public class func sharedManager() -> SharedFormValidator {
        struct Static {
            static let instance = SharedFormValidator()
        }
        return Static.instance
    }
    
    private override init() {}
    
}
