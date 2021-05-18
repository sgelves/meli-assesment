//
//  LoginViewProtocol.swift
//  57blocks assesment
//
//  Created by Sergio Gelves on 17/05/21.
//

protocol LoginViewProtocol: AnyObject {

    var presenter: LoginPresenter { get }

    func logincValidateResult(result: Result<Any?, LoginError>)
}
