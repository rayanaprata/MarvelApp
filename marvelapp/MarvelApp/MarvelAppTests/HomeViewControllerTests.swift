//
//  HomeViewControllerTests.swift
//  MarvelAppTests
//
//  Created by C94280a on 03/12/21.
//

import Foundation
@testable import MarvelApp
import XCTest

class HomeViewControllerTests: XCTestCase {
    
    private var sut: HomeViewController!
    
    override func setUp() {
        sut = HomeViewController()
    }
    
    func testWhenThereNoCharacters_CharacterListsShouldBeZero() {
        sut.loadView()
        
        XCTAssertEqual(sut.carouselCharacters.count, 0)
        XCTAssertEqual(sut.searchList.count, 0)
        XCTAssertEqual(sut.listCharacters.count, 0)
    }
    
    func testGetCharacters() {
        let api = APISpy()
        let sut = HomeViewController(api: api)
        
        sut.requestAPI()
        
        XCTAssertTrue(api.executeCalled)
        XCTAssertEqual(api.inputRequest, api.setNewCharacters(0))
    }
    
    func testInitWillCallAPIOnce() {
        let api = APISpy()
        let sut = HomeViewController(api: api)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(api.apiCalls, 1)
    }
    
    func testGetListCharactersSuccessWithResults() {
        let expect = expectation(description: "Expect sucess")
        
        let api = API()
        let sut = HomeViewController(api: api)
        
        sut.api?.getListCharacters(urlString: api.setNewCharacters(0),
                                   method: .GET,
                                   success: { result in
            XCTAssertGreaterThan(result.data.results.count, 0)
            expect.fulfill()
        },
                                   failure: { error in })
        
        waitForExpectations(timeout: 10.0)
    }
    
    //    func testGetListCharactersSuccessWithFailure() {
    //        let expect = expectation(description: "Expect sucess")
    //
    //        let api = API()
    //        let sut = HomeViewController(api: api)
    //
    //        sut.api?.getListCharacters(urlString: api.setListCharacters(),
    //                                   method: .GET,
    //                                   success: { result in
    //        },
    //                                   failure: { error in
    //            XCTAssertEqual(error, APIError.notFound)
    //            expect.fulfill()
    //        })
    //
    //        waitForExpectations(timeout: 5.0)
    //   }
    
}
