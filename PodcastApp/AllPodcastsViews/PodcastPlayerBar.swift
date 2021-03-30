//
//  PodcastPlayerBar.swift
//  PodcastApp
//
//  Created by Nataliya Murauyova on 3/29/21.
//
import FeedKit
import SwiftUI
import AVFoundation

struct PodcastPlayerBar: View {
    let namespace: Namespace.ID
    @State var audioPlayer: AVPlayer?
    let rssItem: RSSFeedItem?

    var body: some View {
        HStack {
            Image(systemName: "star")
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
                .matchedGeometryEffect(id: "animation", in: namespace)
            Text(rssItem?.title ?? "No podcast selected")
                .font(.headline)
            Spacer()

            Image(systemName: "play.fill")
                .onTapGesture {
                    playPodacast()
                }
            Image(systemName: "pause.circle")
                .padding(.trailing, 10)
                .onTapGesture {
                    pausePodcast()
                }
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(Color(.lightGray))
    }

    func playPodacast() {
        guard let url = URL.init(string: rssItem?.enclosure?.attributes?.url ?? "") else { return }
        let playerItem = AVPlayerItem.init(url: url)
        audioPlayer = AVPlayer.init(playerItem: playerItem)
        audioPlayer?.volume = 1.0
        audioPlayer?.play()
    }

    func pausePodcast() {
        audioPlayer?.pause()
    }
}

//struct PodcastPlayerBar_Previews: PreviewProvider {
//    static var previews: some View {
//        PodcastPlayerBar(namespace: <#T##Namespace.ID#>, audioPlayer: <#T##AVPlayer?#>, rssItem: <#T##RSSFeedItem?#>)
//    }
//}
