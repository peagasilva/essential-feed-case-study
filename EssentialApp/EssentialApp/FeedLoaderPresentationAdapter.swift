//
//  Created by Raphael Silva on 28/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Combine
import EssentialFeed
import EssentialFeediOS

final class FeedLoaderPresentationAdapter: FeedTableViewControllerDelegate {
    private let feedLoader: () -> FeedLoader.Publisher

    private var cancellables = Set<AnyCancellable>()

    var presenter: FeedPresenter?
    
    init(
        feedLoader: @escaping () -> FeedLoader.Publisher
    ) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        feedLoader()
            .sink(receiveCompletion: { [weak self] in
                switch $0 {
                case .finished:
                    break

                case let .failure(error):
                    self?.presenter?.didFinishLoadingFeed(
                        with: error
                    )
                }
            }, receiveValue: { [weak self] in
                self?.presenter?.didFinishLoadingFeed(
                    with: $0
                )
            }).store(in: &cancellables)
    }
}
