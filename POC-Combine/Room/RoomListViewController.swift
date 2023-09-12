//
//  RoomListViewController.swift
//  POC-Combine
//
//  Created by Luciana Adrião on 11/09/23.
//

import UIKit

class RoomListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var viewModel = RoomListViewModel()

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Salas"

        // Configurar a tabela
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)

        // Adicionar botão de adição na barra de navegação
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRoom))
    }

    @objc func addRoom() {
        let alertController = UIAlertController(title: "Nova Sala", message: nil, preferredStyle: .alert)
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Nome da Sala"
        }
        alertController.addTextField { (themeTextField) in
            themeTextField.placeholder = "Tema da Sala"
        }

        let addAction = UIAlertAction(title: "Adicionar", style: .default) { (_) in
            guard let nameTextField = alertController.textFields?.first,
                  let themeTextField = alertController.textFields?.last,
                  let name = nameTextField.text,
                  let theme = themeTextField.text else {
                return
            }
            self.viewModel.addRoom(name: name, theme: theme)
            self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let room = viewModel.rooms[indexPath.row]
        cell.textLabel?.text = room.name
        return cell
    }

    // MARK: - UITableViewDelegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = viewModel.rooms[indexPath.row]

        let alertController = UIAlertController(title: "Editar Sala", message: nil, preferredStyle: .alert)
        alertController.addTextField { (themeTextField) in
            themeTextField.placeholder = "Novo Tema"
            themeTextField.text = room.theme
        }

        let updateAction = UIAlertAction(title: "Atualizar", style: .default) { (_) in
            guard let themeTextField = alertController.textFields?.first,
                  let newTheme = themeTextField.text else {
                return
            }
            self.viewModel.updateRoomTheme(room: room, newTheme: newTheme)
            self.tableView.reloadData()
        }

        let deleteAction = UIAlertAction(title: "Excluir", style: .destructive) { (_) in
            self.viewModel.deleteRoom(room: room)
            self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}
