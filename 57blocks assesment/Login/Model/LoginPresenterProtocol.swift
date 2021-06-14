//
//  LoginPresenterProtocol.swift
//  57blocks assesment
//
//  Created by Sergio Gelves on 17/05/21.
//

protocol LoginPresenterProtocol {

    var view: LoginViewProtocol? { get }

    func validateLogin(user: String?, pass: String?)

    func isValidEmail(_ email: String) -> Bool
}
