//
//  AllPodcastsView.swift
//  PodcastApp
//
//  Created by Nataliya Murauyova on 2/21/21.
//
import FeedKit
import SwiftUI
import AVFoundation

struct AllPodcastsView: View {
    @ObservedObject var model: Loader = Loader()
    @State var selectedPodcast: RSSFeedItem!

    @Namespace private var nameSpace
    @State private var shouldShowDetails: Bool = false

    @State private var downloadStarted: Bool = false
    @State private var progress: Double = 0
    @State private var dataTask: URLSessionDataTask?
    @State private var observation: NSKeyValueObservation?

    @StateObject var downloader = Downloader()

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
                    PodcastCell(feedItem: item)
                        .onTapGesture {
                            self.selectedPodcast = item
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
        AllPodcastsView()
    }
}
