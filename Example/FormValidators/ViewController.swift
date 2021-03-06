//
//  ViewController.swift
//  FormValidators
//
//  Created by Juvenal Guzman on 06/27/2017.
//  Copyright (c) 2017 Juvenal Guzman. All rights reserved.
//

import UIKit
import FormValidators

class ViewController: UIViewController {

    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var fullNameDetail: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var emailDetail: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var selectCityButton: UIButton!
    @IBOutlet weak var cityDetails: UILabel!
    
    var user = User()
    var formValidator = FormValidator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFormValidator()
        initSelectCityButton()
        initDoneButton()
    }

}

extension ViewController {
    fileprivate func initFormValidator() {
        
        formValidator.attach(textField: fullName, validators: [NotEmpty()], successStyleTransform: { _, _ in
            self.fullNameDetail.text = ""
        }, errorStyleTransform: { _, _, validator in
            self.fullNameDetail.text = validator.message
        })
        
        formValidator.attach(textField: email, validators: [ValidEmail()], detailLabel: emailDetail, returnCallback: { _, _ in
            self.handleDoneButton(sender: nil)
        })
        
        formValidator.attach(object: user, property: "city.id", validators: [NotEmpty()], detailLabel: cityDetails)
        
        formValidator.callbacks(isValid: nil, isInValid: {
            self.showAlert(message: "Correct errors in fields to continue", title: "Warning", doneTitle: "Ok")
        })
    }
    
    fileprivate func initDoneButton() {
        doneButton.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
    }
    
    fileprivate func initSelectCityButton() {
        selectCityButton.setTitle("Select city...", for: .normal)
        selectCityButton.backgroundColor = .clear
        selectCityButton.layer.cornerRadius = 5
        selectCityButton.layer.borderWidth = 1
        selectCityButton.layer.borderColor = UIColor.lightGray.cgColor
        selectCityButton.addTarget(self, action: #selector(handleSelectCityButton), for: .touchUpInside)
    }
}

extension ViewController {
    @objc
    fileprivate func handleDoneButton(sender: UIButton?) {
        if formValidator.isValid() {
            showAlert(message: "All valid!", title: "Success", doneTitle: "Ok")
        }
    }
    
    @objc
    fileprivate func handleSelectCityButton(sender: UIButton?) {
        performSegue(withIdentifier: "toSelectCity", sender: self)
    }
    
    @IBAction func selectedCity(segue: UIStoryboardSegue) {
        let controller = segue.source as! CitiesTableViewController
        if let city = controller.selectedCity {
            user.city = city
            selectCityButton.setTitle(city.name, for: .normal)
            cityDetails.text = "" //Make sure to clear any error
        }
    }
    
    func showAlert(message: String, title: String, doneTitle: String, doneHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: doneTitle, style: .default, handler: doneHandler))
        self.present(alert, animated: true, completion: nil)
    }
    
}
