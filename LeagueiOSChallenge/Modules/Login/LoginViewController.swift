//
//  LoginViewController.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 08/12/2025.
//

import UIKit

final class LoginViewController: UIViewController {

    private let viewModel: LoginViewModel

    // MARK: - UI Elements
    private let usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = NSLocalizedString("USERNAME", comment: "Username")
        tf.borderStyle = .roundedRect
        return tf
    }()

    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = NSLocalizedString("PASSWORD", comment: "Password")
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        return tf
    }()

    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(NSLocalizedString("LOGIN", comment: "Login"), for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return btn
    }()

    private let guestButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(NSLocalizedString("CONTINUE_AS_GUEST", comment: "Continue as Guest"), for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = .systemFont(ofSize: 18)
        return btn
    }()

    private let errorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemRed
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()

    // MARK: - Init
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Use init(viewModel:)")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        updateLoginButtonState()
    }

    // MARK: - Actions
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        guestButton.addTarget(self, action: #selector(didTapGuest), for: .touchUpInside)
        usernameField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
    }

    @objc private func didTapLogin() {
        viewModel.username = usernameField.text ?? ""
        viewModel.password = passwordField.text ?? ""
        viewModel.login()

        updateUIForLoading()
    }

    @objc private func didTapGuest() {
        viewModel.continueAsGuest()
    }
    
    @objc private func textFieldsDidChange() {
        updateLoginButtonState()
    }

    private func updateLoginButtonState() {
        let isValid = !(usernameField.text?.isEmpty ?? true) && !(passwordField.text?.isEmpty ?? true)

        loginButton.isEnabled = isValid
        loginButton.alpha = isValid ? 1.0 : 0.5
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground

        let stack = UIStackView(arrangedSubviews: [
            usernameField,
            passwordField,
            loginButton,
            guestButton,
            errorLabel
        ])
        stack.axis = .vertical
        stack.spacing = 16

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func updateUIForLoading() {
        if viewModel.isLoading {
            loginButton.isEnabled = false
            guestButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
            guestButton.isEnabled = true
        }
        errorLabel.text = viewModel.errorMessage
    }
}

