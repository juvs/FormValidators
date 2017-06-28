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

enum ValidatorMessage {
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

public protocol VariableValidator {
    func isValid() -> (valid: Bool, message: String)
    var domain: String? { get }
}

extension ValidatorMessage: ValidatorMessageType {
    var isDefault: Bool {
        switch self {
        case .byDefault:
            return true
        default:
            return false
        }
    }
    
    var isNone: Bool {
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

class NotEmpty: ValidatorType {
    private let msg: String
    private let msgType: ValidatorMessageType
    
    init(message: String = "Campo obligatorio", type: ValidatorMessage = .byDefault) {
        self.msg = message
        self.msgType = type
    }
    
    func isValid(text: String) -> Bool {
        return !text.isEmpty
    }
    
    var name: String { return "NotEmpty" }
    
    var messageType: ValidatorMessageType { return self.msgType }
    
    var message: String { return self.msg }
    
    var value: Int { return  0 }
}

class ValidEmail: ValidatorType {
    private let msg: String
    private let msgType: ValidatorMessageType
    
    init(message: String = "Email incorrecto", type: ValidatorMessage = .byDefault) {
        self.msg = message
        self.msgType = type
    }
    
    func isValid(text: String) -> Bool {
        let VALIDATOR_EMAIL_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let test = NSPredicate(format: "SELF MATCHES %@", VALIDATOR_EMAIL_REGEX)
        return test.evaluate(with: text)
    }
    
    var name: String { return "ValidEmail" }
    
    var messageType: ValidatorMessageType { return self.msgType }
    
    var message: String { return self.msg }
    
    var value: Int { return  0 }
}

class MinLength: ValidatorType {
    private let min: Int
    private let msg: String
    private let msgType: ValidatorMessageType
    
    init(min: Int, message: String = "", type: ValidatorMessage = .byDefault) {
        let characters = min > 1 ? "caracter(es)" : "caracter"
        self.min = min
        self.msg = message.isEmpty ? "Al menos \(min) \(characters)" : message
        self.msgType = type
    }
    
    func isValid(text: String) -> Bool {
        return text.characters.count >= value
    }
    
    var name: String { return "MinLength" }
    
    var messageType: ValidatorMessageType { return self.msgType }
    
    var message: String { return self.msg }
    
    var value: Int { return self.min }
}

class MaxLength: ValidatorType {
    private let max: Int
    private let msg: String
    private let msgType: ValidatorMessageType
    
    init(max: Int, message: String = "", type: ValidatorMessage = .byDefault) {
        let characters = max > 1 ? "caracter(es)" : "caracter"
        self.max = max
        self.msg = message.isEmpty ? "Máximo \(max) \(characters)" : message
        self.msgType = type
    }
    
    func isValid(text: String) -> Bool {
        return text.characters.count <= value
    }
    
    var name: String { return "MaxLength" }
    
    var messageType: ValidatorMessageType { return self.msgType }
    
    var message: String { return self.msg }
    
    var value: Int { return self.max }
}

class ExactLength: ValidatorType {
    private let len: Int
    private let msg: String
    private let msgType: ValidatorMessageType
    
    init(len: Int, message: String = "", type: ValidatorMessage = .byDefault) {
        let characters = len > 1 ? "caracter(es)" : "caracter"
        self.len = len
        self.msg = message.isEmpty ? "Capture \(len) \(characters)": message
        self.msgType = type
    }
    
    func isValid(text: String) -> Bool {
        return text.characters.count == value
    }
    
    var name: String { return "ExactLength" }
    
    var messageType: ValidatorMessageType { return self.msgType }
    
    var message: String { return self.msg }
    
    var value: Int { return self.len }
}

class MatchRegex: ValidatorType {
    private let regex: String
    private let msg: String
    private let msgType: ValidatorMessageType
    
    init(regex: String, message: String = "Email incorrecto", type: ValidatorMessage = .byDefault) {
        self.regex = regex
        self.msg = message
        self.msgType = type
    }
    
    func isValid(text: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", self.regex)
        return test.evaluate(with: text)
    }
    
    var name: String { return "MatchRegex" }
    
    var messageType: ValidatorMessageType { return self.msgType }
    
    var message: String { return self.msg }
    
    var value: Int { return  0 }
}

class CheckPasswords: ValidatorType {
    private let msg: String
    private let msgType: ValidatorMessageType
    private let password: UITextField!
    
    init(password: UITextField, message: String = "Las contraseñas no coinciden", type: ValidatorMessage = .byDefault) {
        self.password = password
        self.msg = message
        self.msgType = type
    }
    
    func isValid(text: String) -> Bool {
        return self.password.text == text
    }
    
    var name: String { return "CheckPasswords" }
    
    var messageType: ValidatorMessageType { return self.msgType }
    
    var message: String { return self.msg }
    
    var value: Int { return  0 }
}

class CreditCardDueDateCheck: ValidatorType {
    private let msg: String
    private let msgType: ValidatorMessageType
    
    init(message: String = "Fecha incorrecta", type: ValidatorMessage = .byDefault) {
        self.msg = message
        self.msgType = type
    }
    
    func isValid(text: String) -> Bool {
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
    
    var name: String { return "CreditCardDueDateCheck" }
    
    var messageType: ValidatorMessageType { return self.msgType }
    
    var message: String { return self.msg }
    
    var value: Int { return  0 }
}

class CreditCardCheck: ValidatorType {
    private let cleanText: Bool
    private let len: Int
    private let msg: String
    private let msgType: ValidatorMessageType
    
    init(len: Int = 16, cleanText: Bool = true, message: String = "Tarjeta incorrecta", type: ValidatorMessage = .byDefault) {
        self.msg = message
        self.cleanText = cleanText
        self.len = len
        self.msgType = type
    }
    
    func isValid(text: String) -> Bool {
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
    
    var name: String { return "CreditCardCheck" }
    
    var messageType: ValidatorMessageType { return self.msgType }
    
    var message: String { return self.msg }
    
    var value: Int { return len }
}
