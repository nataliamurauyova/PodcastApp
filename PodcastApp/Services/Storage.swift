//
//  Storage.swift
//  PodcastApp
//
//  Created by Nataliya Murauyova on 3/29/21.
//
import SwiftUI
import Foundation

struct RSSItemWrapper: Codable, Identifiable {
    var id = UUID()
    let title: String
    let destinationUrl: URL
}

struct SavedItems: Codable, Identifiable {
    var id = UUID()

    var savedPodcasts: [RSSItemWrapper]
}


class Saver: ObservableObject {
    @AppStorage("podcasts") var savedPodcasts: Data = Data()
    @Published var podcastsToShow = SavedItems(savedPodcasts: [])

    func saveItem(with title: String, location: URL) {
        let item = RSSItemWrapper(title: title, destinationUrl: location)
        var allItems = getPodcasts()
        allItems.savedPodcasts.append(item)
        do {
            let data = try JSONEncoder().encode(allItems)
        } catch {
            print("Encode error - \(error.localizedDescription)")
        }
        guard let newItems = try? JSONEncoder().encode(allItems) else { return }
        savedPodcasts = newItems
        DispatchQueue.main.async { [weak self] in
            self?.podcastsToShow = self?.getPodcasts() ?? SavedItems(savedPodcasts: [])
        }
    }

    func getPodcasts() -> SavedItems {
        guard let items = try? JSONDecoder().decode(SavedItems.self, from: savedPodcasts) else { return SavedItems(savedPodcasts: []) }
        return items
    }
}
