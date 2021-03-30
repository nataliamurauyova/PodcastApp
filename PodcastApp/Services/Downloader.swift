//
//  Downloader.swift
//  PodcastApp
//
//  Created by Nataliya Murauyova on 3/29/21.
//
import FeedKit
import Foundation


class Downloader: NSObject, ObservableObject {
    @Published var progress = Float(0)
    @Published var item = RSSFeedItem()

    var downloadCompletion: ((URL) -> Void)?

    lazy var downloadSession: URLSession = {
      let configuration = URLSessionConfiguration.default

      return URLSession(configuration: configuration,
                        delegate: self,
                        delegateQueue: nil)
    }()

    func download(from url: String) {
        guard let url = URL(string: url) else { return }
        downloadSession.downloadTask(with: url).resume()
    }
}

extension Downloader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else {
          return
        }
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
        print(destinationUrl)

        do {
            try FileManager.default.moveItem(at: location, to: destinationUrl)
            print("File moved to documents folder")
            downloadCompletion?(destinationUrl)
        } catch {
            print(error)
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async { [weak self] in
            self?.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        }
    }
}
