//
//  LoginVC.swift
//  meli assesment
//
//  Created by Sergio Gelves on 14/05/21.
//

import UIKit

protocol LoginViewProtocol: AnyObject {

    var presenter: LoginPresenter { get }

    func logincValidateResult(result: Result<Any?, LoginError>)
}

class LoginVC: UIViewController {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    var presenter = LoginPresenter()

    var errorViews: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
    }

    @IBAction func loginPressed(_ sender: Any) {

        self.removeFieldsError()

        self.presenter.validateLogin(user: userField.text, pass: passField.text)
    }

    func setError(forField field: UITextField) {
        field.layer.borderColor = UIColor.red.cgColor
        field.layer.borderWidth = 1.0
        field.layer.cornerRadius = 5
        field.clipsToBounds = true
    }

    func removeFieldsError() {

        userField.layer.borderWidth = 0
        passField.layer.borderWidth = 0

        for view in errorViews {
            view.removeFromSuperview()
        }

        errorViews.removeAll()
    }
}

extension LoginVC: LoginViewProtocol {

    func logincValidateResult(result: Result<Any?, LoginError>) {

        switch result {

        case .success:
            break

        case .failure(let error):

            switch error {
            case .invalidEmail:
                self.setError(forField: userField)
            case .emptyEmail:
                self.setError(forField: userField)
            case .emptyPassword:
                self.setError(forField: passField)
            }
        }
    }
}
