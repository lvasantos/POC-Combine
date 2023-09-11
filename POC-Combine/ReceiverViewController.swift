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
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.backgroundColor = .cyan
        label.textColor = .black
        label.text = "Texto aqui"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.$name
            .sink { [weak self] newName in
                self?.label.text = newName
            }
            .store(in: &cancellables)

        view.backgroundColor = .white
        setupView()
    }

    private func setupView() {
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}

