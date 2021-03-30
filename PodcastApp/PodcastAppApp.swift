//
//  PodcastAppApp.swift
//  PodcastApp
//
//  Created by Nataliya Murauyova on 2/21/21.
//

import SwiftUI

@main
struct PodcastAppApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                AllPodcastsView()
                    .tabItem {
                        Image(systemName: "music.note.list")
                        Text("Feed")
                    }

                SavedPodcastsView()
                    .tabItem {
                        Image(systemName: "tray.and.arrow.down")
                        Text("Your Podcasts")
                    }
            }
        }
    }
}
