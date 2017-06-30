//
//  ValidatorObjectContainer.swift
//  Pods
//
//  Created by Juvenal Guzman on 6/29/17.
//
//

import Foundation

class ValidatorObjectContainer {
    
    var object: AnyObject!
    var property: String! = ""
    
    init(_ object: AnyObject, property: String) {
        self.object = object
        self.property = property
    }
    
    func getValue() -> String {
        var value = ""
        
        if !(property ?? "").isEmpty {
            if let val = getValueForProperty(object, prop: property) {
                value = valueToString(val)
            }
        } else {
            value = valueToString(object)
        }
        return value
    }
    
    private func getValueForProperty(_ object: AnyObject, prop: String) -> AnyObject? {
        if prop.contains(".") {
            let inners = prop.components(separatedBy: ".")
            var innerObj: AnyObject = object
            for inner in inners {
                innerObj = _getValue(innerObj, prop: inner) as AnyObject
            }
            return innerObj
        } else {
        
            return _getValue(object, prop: prop)
        }
        
    }
    
    private func _getValue(_ object: AnyObject, prop: String) -> AnyObject? {
        let objectMirror = Mirror(reflecting: object)
//        for (name, value) in objectMirror.children {
//            guard let name = name else { continue }
//            print("\(name): \(type(of: value)) = '\(value)'")
//        }
        let child = objectMirror.children.first(where: { $0.label == prop })
        if let attribute = child {
            return attribute.value as AnyObject 
        } else {
            return nil
        }
    }
    
    private func valueToString(_ value: Any) -> String {
        let _val = String(describing: value)
        return _val != "<null>" ? _val : ""
    }
}
