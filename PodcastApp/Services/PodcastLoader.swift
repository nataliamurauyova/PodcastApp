//
//  PodcastLoader.swift
//  PodcastApp
//
//  Created by Nataliya Murauyova on 2/21/21.
//
import Combine
import Foundation
import FeedKit

class Loader: ObservableObject {
    let url = URL(string: "https://www.svoboda.org/podcast/?zoneId=896.rss")

    @Published var feedItems = [RSSFeedItem]()
    @Published var state = State.ready

    enum State {
        case ready
        case loading(Cancellable)
        case loaded
        case error(Error)
    }

    let urlSession = URLSession.shared

    func load() {
        let parser = FeedParser(URL: url!)
        let publisher = parser.parse().publisher

        self.state = .loading(publisher.sink { (completion) in
            switch completion {
            case .finished:
                break
            case let .failure(error):
                self.state = .error(error)
            }
        } receiveValue: { (feed) in
            self.state = .loaded
            self.feedItems = feed.rssFeed?.items ?? []
        })
    }

    func downloadPodcast(item: RSSFeedItem) {
//        urlSession.downloadTask(with: item.enclosure?.attributes?.url ?? URL(string: "")) { (urk, response
//            error
//        }
        urlSession.downloadTask(with: URL(string: item.enclosure?.attributes?.url ?? "")!) { (url, response, error) in
            
        }
    }

    func loadIfNeeded() {
        guard case .ready = self.state else { return }
        self.load()
    }
}

extension RSSFeedItem: Identifiable {
    public var id: String {
        return self.title ?? ""
    }
}
