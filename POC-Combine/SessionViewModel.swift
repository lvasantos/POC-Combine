//
//  SessionViewModel.swift
//  POC-Combine
//
//  Created by Luciana Adrião on 11/09/23.
//

import Foundation
import Combine

// Define the model for a session
class Session {
    var name: String
    var theme: String

    init(name: String, theme: String) {
        self.name = name
        self.theme = theme
    }
}

class SessionViewModel: ObservableObject {
    // Published property for the list of sessions
    @Published var sessions: [Session] = [] {
        didSet {
            sessionPublisher.send(sessions)
        }
    }

    // Published property for the selected session
    @Published var selectedSession: Session?

    private var cancellables = Set<AnyCancellable>()

    // Combine subject to publish changes in the sessions list
    let sessionPublisher = PassthroughSubject<[Session], Never>()

    // Combine subject to publish changes in the selected session
    let selectedSessionPublisher = PassthroughSubject<Session, Never>()

    // Add a new session with a given name
    func addSession(name: String) {
        let newSession = Session(name: name, theme: "Theme")
        sessions.append(newSession)
    }

    // Update the name and theme of the selected session
    func updateSession(newName: String, newTheme: String) {
        selectedSession?.name = newName
        selectedSession?.theme = newTheme

        // Publish the updated sessions list
        sessionPublisher.send(sessions)
    }

    // Set the selected session
    func setSelectedSession(session: Session) {
        selectedSession = session
    }

    init() {
        // Subscribe to changes in the session list and publish them
        $sessions
            .flatMap { sessions in sessions.publisher }
            .sink { [weak self] newSession in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

}
