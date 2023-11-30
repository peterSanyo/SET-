//
//  GameLogicTests.swift
//  GameLogicTests
//
//  Created by Péter Sanyó on 30.11.23.
//

import XCTest
@testable import SET_

final class GameLogicTests: XCTestCase {
    
    var gameLogic: GameLogic!
    
    func testDeckInitialization() {
        // Arrange
        let overallCards = 81
        let displayedCardsCount = 12
        let expectedDeckCount = overallCards - displayedCardsCount
        
        // Act
        let gameLogic = GameLogic()
        
        //Arrange
        XCTAssertEqual(gameLogic.deckOfCards.count, expectedDeckCount, "Deck should be initialized with \(expectedDeckCount) cards.")
    }
}
