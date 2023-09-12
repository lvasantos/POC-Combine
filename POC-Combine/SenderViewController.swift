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
        textField.placeholder = "Session Name..."
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Session", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTable()

        // Reload the table view whenever sessions change
        viewModel.sessionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func setupView() {
        // Add and configure UI elements
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24),
        ])

        view.addSubview(submitButton)
        NSLayoutConstraint.activate([
            submitButton.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor),
            submitButton.leadingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: 24),
            submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc func submitButtonTapped() {
        if let name = nameTextField.text, !name.isEmpty {
            viewModel.addSession(name: name)

            // Clear the text field
            nameTextField.text = ""
        }
    }
}

extension SenderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sessions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let session = viewModel.sessions[indexPath.row]
        cell.textLabel?.text = "\(session.name): \(session.theme)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let session = viewModel.sessions[indexPath.row]
        viewModel.selectedSession = session
        tableView.deselectRow(at: indexPath, animated: true)

        let receiverVC = ReceiverViewController()
        receiverVC.viewModel = viewModel
        navigationController?.present(receiverVC, animated: true)
    }
}
