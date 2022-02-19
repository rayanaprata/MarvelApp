//
//  HomeViewControllerTests.swift
//  MarvelAppTests
//
//  Created by C94280a on 03/12/21.
//

import XCTest
@testable import MarvelApp

class HomeViewControllerTests: XCTestCase {
    
    private var sut: HomeViewController!
    
    override func setUp() {
        sut = HomeViewController()
    }
    
    func testWhenThereNoCharacters_CharacterListsShouldBeZero() {
        sut.loadView()

        XCTAssertEqual(sut.viewModel.carouselCharacters.count, 0)
        XCTAssertEqual(sut.viewModel.searchList.count, 0)
        XCTAssertEqual(sut.viewModel.listCharacters.count, 0)
    }
    
}
