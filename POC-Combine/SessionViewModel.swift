//
//  SessionViewModel.swift
//  POC-Combine
//
//  Created by Luciana Adrião on 11/09/23.
//

import Foundation
import Combine

class SessionViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var theme: String = ""

    private var cancellables = Set<AnyCancellable>()

    // Combine to pass data between views
    let namePublisher = PassthroughSubject<String,Never>()
    let themePublisher = PassthroughSubject<String,Never>()

    init() {
        // Subscribe to the changes in the property name
        $name
            .sink { [weak self] newName in
                self?.namePublisher.send(newName)
            }
            .store(in: &cancellables)

        $theme
            .sink { [weak self] newTheme in
                self?.themePublisher.send(newTheme)
            }
            .store(in: &cancellables)
    }
}
