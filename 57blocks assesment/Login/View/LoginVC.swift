//
//  LoginVC.swift
//  meli assesment
//
//  Created by Sergio Gelves on 14/05/21.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var userError: UILabel!
    @IBOutlet weak var passwordError: UILabel!

    var presenter = LoginPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter.view = self

        self.setLocalizedTexts()
    }

    private func setLocalizedTexts() {
        self.userLabel.text = Localized.emailLabel.toLocalized()
        self.passLabel.text = Localized.passwordLabel.toLocalized()
        self.loginButton.setTitle(Localized.loginButton.toLocalized(), for: .normal)
    }

    func setError(forField field: UITextField, label: UILabel, andMessage msg: String) {

        UIView.animate(withDuration: 0.5) {

            field.layer.borderColor = UIColor.red.cgColor
            field.layer.borderWidth = 1.0
            field.layer.cornerRadius = 5
            field.clipsToBounds = true

            label.text = msg
            label.isHidden = false
        }
    }

    func removeFieldsError() {

        UIView.animate(withDuration: 0.5) {
            self.userField.layer.borderWidth = 0
            self.passField.layer.borderWidth = 0

            self.userError.isHidden = true
            self.passwordError.isHidden = true
        }
    }

    @IBAction func loginPressed(_ sender: Any) {

        self.removeFieldsError()

        self.presenter.validateLogin(user: userField.text, pass: passField.text)
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
                self.setError(forField: userField,
                              label: userError,
                              andMessage: Localized.emailInvalidError.toLocalized())
            case .emptyEmail:
                self.setError(forField: userField,
                              label: userError,
                              andMessage: Localized.emailEmptyError.toLocalized())
            case .emptyPassword:
                self.setError(forField: passField,
                              label: passwordError,
                              andMessage: Localized.passwordEmptyError.toLocalized())
            }
        }
    }
}
