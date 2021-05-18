//
//  LoginPresenter.swift
//  57blocks assesment
//
//  Created by Sergio Gelves on 14/05/21.
//

import Foundation

class LoginPresenter: LoginPresenterProtocol {

    weak var view: LoginViewProtocol?

    func validateLogin(user: String?, pass: String?) {

        var validUser = false
        if user?.isEmpty ?? true {
            self.view?.logincValidateResult(result: .failure(.emptyEmail))
        } else if !isValidEmail(user!) {
            self.view?.logincValidateResult(result: .failure(.invalidEmail))
        } else {
            validUser = true
        }

        var validPass = false
        if pass?.isEmpty ?? true {
            self.view?.logincValidateResult(result: .failure(.emptyPassword))
        } else {
            validPass = true
        }

        if validUser && validPass {
            self.view?.logincValidateResult(result: .success(nil))
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
