//
//  SavedPodcastsView.swift
//  PodcastApp
//
//  Created by Nataliya Murauyova on 3/29/21.
//
import FeedKit
import SwiftUI
import AVFoundation

struct SavedPodcastsView: View {
    @ObservedObject var storage: Saver = Saver()
    @State var audioPlayer: AVAudioPlayer?

    var body: some View {
        NavigationView {
            VStack {
                List(storage.getPodcasts().savedPodcasts) { item in
                    HStack {
                        Text(item.title)
                    }
                    .onTapGesture {
                        playPodacast(from: item.destinationUrl)
                    }
                }
            }
            .navigationBarTitle("Saved podcasts")
        }
    }

    func playPodacast(from url: URL) {
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.volume = 1.0
        audioPlayer?.play()
    }
}

struct SavedPodcasts_Previews: PreviewProvider {
    static var previews: some View {
        SavedPodcastsView()
    }
}
