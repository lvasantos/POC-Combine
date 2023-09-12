//
//  ViewController.swift
//  POC-Combine
//
//  Created by Luciana Adrião on 05/09/23.
//

import UIKit
import Combine

class ReceiverViewController: UIViewController {
    var viewModel: SessionViewModel!
    private var cancellables = Set<AnyCancellable>()

    private var sessionName: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Session Name"
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    private var sessionTheme: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Session Theme"
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    private var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()

        // Bind the session's properties to the text fields
        viewModel.$selectedSession
            .sink { [weak self] selectedSession in
                // Update the text fields with selected session data
                self?.sessionName.text = selectedSession?.name
                self?.sessionTheme.text = selectedSession?.theme
            }
            .store(in: &cancellables)

        // Add a target for the Save button
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    private func setupView() {
        // Add subviews and set up constraints
        view.addSubview(sessionName)
        NSLayoutConstraint.activate([
            sessionName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sessionName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        view.addSubview(sessionTheme)
        NSLayoutConstraint.activate([
            sessionTheme.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sessionTheme.topAnchor.constraint(equalTo: sessionName.bottomAnchor, constant: 12),
        ])

        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc func saveButtonTapped() {
        if let name = sessionName.text, let theme = sessionTheme.text {
            // Update the selected session with the new values
            viewModel.updateSession(newName: name, newTheme: theme)
        }
        dismiss(animated: true)
    }
}
