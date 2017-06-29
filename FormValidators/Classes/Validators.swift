//
//  Validators.swift
//  Pods
//
//  Created by Juvenal Guzman on 6/27/17.
//
//

import Foundation

//-----------------------------------------------------------
//MARK: - Protocols...

public enum ValidatorMessage {
    case byDefault
    case none
}

public protocol ValidatorType {
    func isValid(text: String) -> Bool
    var name: String { get }
    var messageType: ValidatorMessageType { get }
    var message: String { get }
    var value: Int { get }
}

//open class BaseValidator {
//    private var bundle : Bundle!
//    
//    func getString(_ key: String) -> String {
//        if let bundlePath = Bundle.main.path(forResource: "Validators", ofType: "bundle") {
//            self.bundle = Bundle(path: bundlePath) ?? Bundle.main
//        }
//        return NSLocalizedString(key, bundle: bundle, comment: "")
//    }
//}

extension ValidatorMessage: ValidatorMessageType {
    public var isDefault: Bool {
        switch self {
        case .byDefault:
            return true
        default:
            return false
        }
    }
    
    public var isNone: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
}

public protocol ValidatorMessageType {
    var isDefault: Bool { get }
    var isNone: Bool { get }
}

//-----------------------------------------------------------
//MARK: - Built-in validators...

open class NotEmpty: ValidatorType {
    private var msg: String
    private var msgType: ValidatorMessageType
    
    public init(message: String = "Campo obligatorio", type: ValidatorMessage = .byDefault) {
        self.msg = message
        self.msgType = type
    }
    
    public func isValid(text: String) -> Bool {
        return !text.isEmpty
    }
    
    public var name: String { return "NotEmpty" }
    
    public var messageType: ValidatorMessageType { return self.msgType }
    
    public var message: String { return self.msg }
    
    public var value: Int { return  0 }
}

open class ValidEmail: ValidatorType {
    private let msg: String
    private let msgType: ValidatorMessageType
    
    public init(message: String = "Email incorrecto", type: ValidatorMessage = .byDefault) {
        self.msg = message
        self.msgType = type
    }
    
    public func isValid(text: String) -> Bool {
        let VALIDATOR_EMAIL_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let test = NSPredicate(format: "SELF MATCHES %@", VALIDATOR_EMAIL_REGEX)
        return test.evaluate(with: text)
    }
    
    public var name: String { return "ValidEmail" }
    
    public var messageType: ValidatorMessageType { return self.msgType }
    
    public var message: String { return self.msg }
    
    public var value: Int { return  0 }
}

open class MinLength: ValidatorType {
    private let min: Int
    private let msg: String
    private let msgType: ValidatorMessageType
    
    public init(min: Int, message: String = "", type: ValidatorMessage = .byDefault) {
        let characters = min > 1 ? "caracter(es)" : "caracter"
        self.min = min
        self.msg = message.isEmpty ? "Al menos \(min) \(characters)" : message
        self.msgType = type
    }
    
    public func isValid(text: String) -> Bool {
        return text.characters.count >= value
    }
    
    public var name: String { return "MinLength" }
    
    public var messageType: ValidatorMessageType { return self.msgType }
    
    public var message: String { return self.msg }
    
    public var value: Int { return self.min }
}

open class MaxLength: ValidatorType {
    private let max: Int
    private let msg: String
    private let msgType: ValidatorMessageType
    
    public init(max: Int, message: String = "", type: ValidatorMessage = .byDefault) {
        let characters = max > 1 ? "caracter(es)" : "caracter"
        self.max = max
        self.msg = message.isEmpty ? "Máximo \(max) \(characters)" : message
        self.msgType = type
    }
    
    public func isValid(text: String) -> Bool {
        return text.characters.count <= value
    }
    
    public var name: String { return "MaxLength" }
    
    public var messageType: ValidatorMessageType { return self.msgType }
    
    public var message: String { return self.msg }
    
    public var value: Int { return self.max }
}

open class ExactLength: ValidatorType {
    private let len: Int
    private let msg: String
    private let msgType: ValidatorMessageType
    
    public init(len: Int, message: String = "", type: ValidatorMessage = .byDefault) {
        let characters = len > 1 ? "caracter(es)" : "caracter"
        self.len = len
        self.msg = message.isEmpty ? "Capture \(len) \(characters)": message
        self.msgType = type
    }
    
    public func isValid(text: String) -> Bool {
        return text.characters.count == value
    }
    
    public var name: String { return "ExactLength" }
    
    public var messageType: ValidatorMessageType { return self.msgType }
    
    public var message: String { return self.msg }
    
    public var value: Int { return self.len }
}

open class MatchRegex: ValidatorType {
    private let regex: String
    private let msg: String
    private let msgType: ValidatorMessageType
    
    public init(regex: String, message: String = "Valor incorrecto", type: ValidatorMessage = .byDefault) {
        self.regex = regex
        self.msg = message
        self.msgType = type
    }
    
    public func isValid(text: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", self.regex)
        return test.evaluate(with: text)
    }
    
    public var name: String { return "MatchRegex" }
    
    public var messageType: ValidatorMessageType { return self.msgType }
    
    public var message: String { return self.msg }
    
    public var value: Int { return  0 }
}

open class CheckPasswords: ValidatorType {
    private let msg: String
    private let msgType: ValidatorMessageType
    private let password: UITextField!
    
    public init(password: UITextField, message: String = "Las contraseñas no coinciden", type: ValidatorMessage = .byDefault) {
        self.password = password
        self.msg = message
        self.msgType = type
    }
    
    public func isValid(text: String) -> Bool {
        return self.password.text == text
    }
    
    public var name: String { return "CheckPasswords" }
    
    public var messageType: ValidatorMessageType { return self.msgType }
    
    public var message: String { return self.msg }
    
    public var value: Int { return  0 }
}

open class CreditCardDueDateCheck: ValidatorType {
    private let msg: String
    private let msgType: ValidatorMessageType
    
    public init(message: String = "Fecha incorrecta", type: ValidatorMessage = .byDefault) {
        self.msg = message
        self.msgType = type
    }
    
    public func isValid(text: String) -> Bool {
        return checkRegex(text) && isValidDate(text)
    }
    
    private func checkRegex(_ text: String) -> Bool {
        let VALIDATOR_EMAIL_REGEX = "^((0?[1-9])|(1?[0-2]))/((1[6-9])|([2-9][0-9]))$"
        let test = NSPredicate(format: "SELF MATCHES %@", VALIDATOR_EMAIL_REGEX)
        return test.evaluate(with: text)
    }
    
    private func isValidDate(_ text: String) -> Bool {
        var dateComponents = DateComponents()
        var dateArr = text.components(separatedBy: "/")
        
        //Para enviar la fecha correcta
        dateComponents.year = 2000 + Int(dateArr[1])!
        dateComponents.month = Int(dateArr[0])!
        dateComponents.day = 1
        
        let userCalendar = Calendar.current // user calendar
        let dueDate = userCalendar.date(from: dateComponents)
        
        // para la fecha actual
        let currDate = Date()
        return dueDate!.compare(currDate) == .orderedDescending
    }
    
    public var name: String { return "CreditCardDueDateCheck" }
    
    public var messageType: ValidatorMessageType { return self.msgType }
    
    public var message: String { return self.msg }
    
    public var value: Int { return  0 }
}

open class CreditCardCheck: ValidatorType {
    private let cleanText: Bool
    private let len: Int
    private let msg: String
    private let msgType: ValidatorMessageType
    
    public init(len: Int = 16, cleanText: Bool = true, message: String = "Tarjeta incorrecta", type: ValidatorMessage = .byDefault) {
        self.msg = message
        self.cleanText = cleanText
        self.len = len
        self.msgType = type
    }
    
    public func isValid(text: String) -> Bool {
        let number = cleanText ? text.replacingOccurrences(of: " ", with: "", options: .caseInsensitive) : text
        return number.characters.count == len && luhnCheck(number)
    }
    
    private func luhnCheck(_ cardNumber: String) -> Bool {
        var sum = 0
        let reversedCharacters = cardNumber.characters.reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else { return false }
            switch ((idx % 2 == 1), digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }
    
    public var name: String { return "CreditCardCheck" }
    
    public var messageType: ValidatorMessageType { return self.msgType }
    
    public var message: String { return self.msg }
    
    public var value: Int { return len }
}
