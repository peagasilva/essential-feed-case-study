//
//  ListViewControllerSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by Raphael Silva on 07/03/2021.
//  Copyright © 2021 Raphael Silva. All rights reserved.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

class ListViewControllerSnapshotTests: XCTestCase {

    func test_emptyList() {
        let sut = makeSUT()

        sut.display(emptyList())

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_LIST-light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_LIST-dark")
    }

    func test_listWithErrorMessage() {
        let sut = makeSUT()

        sut.display(.error(message: "This is a\nmulti-line\nerror message"))

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LIST_WITH_ERROR_MESSAGE-light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LIST_WITH_ERROR_MESSAGE-dark")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSize: .extraExtraExtraLarge)), named: "LIST_WITH_ERROR_MESSAGE-light-extraExtraExtraLarge")
    }

    // MARK: - Helpers

    private func makeSUT() -> ListViewController {
        let controller = ListViewController()
        controller.tableView.separatorStyle = .none
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

    private func emptyList() -> [CellController] {
        []
    }
}
