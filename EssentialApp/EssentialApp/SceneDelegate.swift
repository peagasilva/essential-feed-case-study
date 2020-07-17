//
//  Created by Raphael Silva on 12/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import UIKit
import CoreData
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let remoteURL = URL(string: "https://static1.squarespace.com/static/5891c5b8d1758ec68ef5dbc2/t/5db4155a4fbade21d17ecd28/1572083034355/essential_app_feed.json")!
        
        let remoteClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        
        let localStorageURL = NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("feed-store.sqlite")
        
        let localStore = try! CoreDataFeedStore(url: localStorageURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)
        
        window?.rootViewController = FeedUIComposer.feedComposed(withFeedLoader: FeedLoaderWithFallbackComposite(primary: remoteFeedLoader,
                                                                                                                 fallback: localFeedLoader),
                                                                 imageLoader: FeedImageDataLoaderWithFallbackComposite(primary: localImageLoader,
                                                                                                                       fallback: remoteImageLoader))
    }
}
