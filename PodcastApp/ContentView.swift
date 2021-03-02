//
//  ContentView.swift
//  PodcastApp
//
//  Created by Nataliya Murauyova on 2/21/21.
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

struct PodcastDetails: View {
    let namespace: Namespace.ID
    @State var rssItem: RSSFeedItem

    var body: some View {
        VStack {
            Image(systemName: "star")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(40)
                .matchedGeometryEffect(id: "animation", in: namespace)

            HStack {
                VStack(alignment: .center) {
                    Text(rssItem.title ?? "Podcast name")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(rssItem.description ?? "Description")
                        .font(.title)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                }.padding()
                Spacer()
            }

            HStack {
                Image(systemName: "backward.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 30))

                Image(systemName: "play.fill")
                    .foregroundColor(.white)
                    .padding([.leading, .trailing], 75)
                    .font(.system(size: 50))

                Image(systemName: "forward.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.cyan))
    }
}



struct ContentView: View {
    @ObservedObject var model: Loader = Loader()
    @State var selectedPodcast: RSSFeedItem!

    @Namespace private var nameSpace
    @State private var shouldShowDetails: Bool = false

    @State private var downloadStarted: Bool = false
    @State private var progress: Double = 0
    @State private var dataTask: URLSessionDataTask?
    @State private var observation: NSKeyValueObservation?

    var body: some View {
        VStack {
            Spacer()
            if shouldShowDetails {
                PodcastDetails(namespace: nameSpace, rssItem: selectedPodcast)
                    .onTapGesture {
                        shouldShowDetails.toggle()
                    }
            } else {
                List(model.feedItems) { item in
                    VStack {
                        HStack {
                            Text(item.title ?? "")
                                .onTapGesture {
                                    self.selectedPodcast = item
                                }
                            Spacer()
                            Button(action: {
                              //downloadPodcast()
                            }) {
                                Image(systemName: "tray.and.arrow.down")
                            }
                        }
                        Spacer()

                        if downloadStarted {
                            ProgressView("Downloading...", value: progress, total: 100)
                        }
                    }

                }
                PodcastPlayerBar(namespace: nameSpace, rssItem: selectedPodcast)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            shouldShowDetails.toggle()
                        }
                    }
            }
        }
        .overlay(StatusOverlay(model: model))
        .onAppear(perform: {
            model.loadIfNeeded()
        })
    }

    private func downloadPodcast() {
        guard let url = URL(string: selectedPodcast.enclosure?.attributes?.url ?? "") else {
            return
        }
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
            observation?.invalidate()

            if let data = data {
                // save mp3 to file manager
            }
        })

        observation = dataTask?.progress.observe(\.fractionCompleted, changeHandler: { (downloadProgress, _) in
            DispatchQueue.main.async {
                progress = downloadProgress.fractionCompleted
            }
        })

        downloadStarted = true

        dataTask?.resume()
    }
}

struct StatusOverlay: View {

    @ObservedObject var model: Loader

    var body: some View {
        switch model.state {
        case .ready:
            return AnyView(EmptyView())
        case .loading:
            //return AnyView(ProgressView())
            return AnyView(EmptyView())
        case .loaded:
            return AnyView(EmptyView())
        case let .error(error):
            return AnyView(
                VStack(spacing: 10) {
                    Text(error.localizedDescription)
                        .frame(maxWidth: 300)
                    Button("Retry") {
                        self.model.loadIfNeeded()
                    }
                }
                .padding()
                .background(Color.red)
            )
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
