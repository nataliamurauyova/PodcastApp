//
//  PodcastDetails.swift
//  PodcastApp
//
//  Created by Nataliya Murauyova on 3/29/21.
//
import FeedKit
import SwiftUI

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


//struct PodcastDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        //PodcastDetails()
//    }
//}
