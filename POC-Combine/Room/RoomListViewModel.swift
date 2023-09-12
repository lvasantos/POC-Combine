//
//  RoomListViewModel.swift
//  POC-Combine
//
//  Created by Luciana Adrião on 11/09/23.
//

import Foundation
import Combine

class RoomListViewModel: ObservableObject {
    @Published var rooms: [Room] = []

    // Funções para adicionar, atualizar e excluir salas
    func addRoom(name: String, theme: String) {
        let room = Room(name: name, theme: theme)
        rooms.append(room)
    }

    func updateRoomTheme(room: Room, newTheme: String) {
        if let index = rooms.firstIndex(where: { $0.name == room.name }) {
            rooms[index].theme = newTheme
        }
    }

    func deleteRoom(room: Room) {
        if let index = rooms.firstIndex(where: { $0.name == room.name }) {
            rooms.remove(at: index)
        }
    }

    // Outras lógicas de negócios relacionadas à lista de salas
}
