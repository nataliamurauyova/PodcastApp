//
//  PodcastCell.swift
//  PodcastApp
//
//  Created by Nataliya Murauyova on 3/25/21.
//
import FeedKit
import SwiftUI

struct PodcastCell: View {
    @State var feedItem: RSSFeedItem?
    @StateObject var downloader = Downloader()
    @StateObject var storage: Saver = Saver()

    @State var downloadStarted = false

    var body: some View {
        VStack {
            HStack {
                Text(feedItem?.title ?? "")
                Spacer()
                Button(action: {
                    downloadStarted.toggle()
                    downloader.downloadCompletion = { location in
                        storage.saveItem(with: feedItem?.title ?? "", location: location)
                    }
                    downloader.download(from: feedItem?.enclosure?.attributes?.url ?? "")
                }) {
                    Image(systemName: "tray.and.arrow.down")
                }
            }

            if downloadStarted {
                ProgressView("Loading...", value: downloader.progress)
            }
            Spacer()
        }
    }
}

struct PodcastCell_Previews: PreviewProvider {
    static var previews: some View {
        PodcastCell()
    }
}
