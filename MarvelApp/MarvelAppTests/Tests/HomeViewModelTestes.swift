//
//  HomeViewModelTestes.swift
//  MarvelAppTests
//
//  Created by C94280a on 17/01/22.
//

import XCTest
@testable import MarvelApp

class HomeViewModelTestes: XCTestCase {
    
    private var sut: HomeViewModel!
    private let api = NetworkServiceSpy()
    private let apiError = NetworkErrorServiceMock()
    private let coreData = CoreDataMock()
    private let parse = ParseManager()
    
    override func setUp() {
        sut = HomeViewModel(networkService: api,
                            coreDataManager: coreData,
                            parseManager: parse)
    }
    
    override func tearDown() {
      sut = nil
      super.tearDown()
    }
    
    func testApiInitialized() {
        XCTAssertNotNil(sut.getCharacters())
        XCTAssertNotNil(sut.getCarouselCharacters())
        XCTAssertNotNil(sut.getSearchCharacters("Vision"))
    }
    
    func testApiCallGetCarouselCharactersOnce(){
        sut.getCarouselCharacters()
        XCTAssertEqual(api.apiCalls, 1)
    }
    
    func testApiCallGetListCharactersOnce(){
        sut.getCharacters()
        XCTAssertEqual(api.apiCalls, 1)
    }
    
    func testGetCharacters() {
        sut.getCharacters()
        XCTAssertTrue(api.executeCalled)
        XCTAssertEqual(api.inputRequest, api.setNewCharacters(0))
    }
    
    func testGetCarouselCharacters() {
        sut.getCarouselCharacters()
        XCTAssertTrue(api.executeCalled)
        XCTAssertEqual(api.inputRequest, api.setCarouselCharacter(0))
    }
    
    func testGetSearchCharacters() {
        sut.getSearchCharacters("Vision")
        XCTAssertTrue(api.executeCalled)
        XCTAssertEqual(api.inputRequest, api.searchCharacter("Vision"))
    }
    
    func testInitWillCallAPITwiceOneForCarouselAndOtherForCharactersList() {
        sut.loadData()
        XCTAssertEqual(api.apiCalls, 2)
    }
    
    func testCarouselCharactersSuccessRequestAPI(){
        let spy = HomeViewControllerSpy()
        sut.delegate = spy
        sut.getCarouselCharacters()

        XCTAssertEqual(spy.reloadCarouselCalls, 1)
        XCTAssertEqual(sut.carouselCharacters.count, 5)
    }
    
    func testGetListCharactersSuccessRequestAPI(){
        sut.isLoading = false
        let spy = HomeViewControllerSpy()
        sut.delegate = spy
        sut.getCharacters()

        XCTAssertEqual(spy.reloadCharactersListCalls, 1)
        XCTAssertEqual(sut.listCharacters.count, 20)
    }
    
    func testSearchCharactersRequestAPI() {
        let spy = HomeViewControllerSpy()
        sut.delegate = spy
        sut.getSearchCharacters("Abomination")

        XCTAssertTrue(sut.listCharacters.count > 0)
        XCTAssertEqual(sut.listCharacters.count, 2)
        XCTAssertEqual(sut.listCharacters[0].name, "Abomination (Emil Blonsky)")
        XCTAssertEqual(sut.listCharacters[1].name, "Abomination (Ultimate)")
    }
    
    func testFailureRequestAPI() {
        let sut = HomeViewModel(networkService: apiError,
                                coreDataManager: coreData,
                                parseManager: parse)
        sut.getCharacters()
        sut.getCarouselCharacters()

        XCTAssertEqual(sut.carouselCharacters.count, 0)
        XCTAssertEqual(sut.listCharacters.count, 0)
    }
    
    func testDataPersistence() {
        sut.getCharacters()
        
        XCTAssertTrue(coreData.haveSavedCharacters)
        XCTAssertTrue(coreData.haveSavedOffset)
    }
    
}
