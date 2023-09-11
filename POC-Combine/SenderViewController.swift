//
//  SenderViewController.swift
//  POC-Combine
//
//  Created by Luciana Adrião on 11/09/23.
//


/*

 -> Tela principal com add bar/textfield(nome sala e tema sala)

    cria uma lista com as coisas criadas em tabbar e atualiza com o nome da sala, quando a sala é clicada entrada em outra view com textfields para alterar o nome do tema.

    é possível excluir a lista

 */
import UIKit
import Combine

class SenderViewController: UIViewController {
    var viewModel = SessionViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Escreva o nome da sala..."
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Criar sala", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24),
        ])

        view.addSubview(submitButton)
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 100),
            submitButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    @objc func submitButtonTapped() {

        if let name = nameTextField.text {
            viewModel.name = name
            // Navigate to ReceiverViewController
            let receiverVC = ReceiverViewController()
            receiverVC.viewModel = viewModel
            navigationController?.pushViewController(receiverVC, animated: true)

//             Clear the text field
            nameTextField.text = ""
        }
    }
}

