//
//  TypeAlias.swift
//  Pods
//
//  Created by Juvenal Guzman on 6/28/17.
//
//

import Foundation

public typealias ErrorStyleTransform = ((_ textField: UITextField?, _ labelDetail: UILabel?, _ validator: ValidatorType) -> Void)
public typealias SucessStyleTransform = ((_ textField: UITextField?, _ labelDetail: UILabel?) -> Void)

public typealias ReturnCallback = ((_ textField: UITextField, _ labelDetail: UILabel?) -> ())
public typealias OnIsValidCallback = (() -> ())
public typealias OnIsInvalidCallback = (() -> ())
