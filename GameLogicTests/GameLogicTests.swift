//
//  GameLogicTests.swift
//  GameLogicTests
//
//  Created by Péter Sanyó on 30.11.23.
//

@testable import SET_
import XCTest

@MainActor class GameLogicTests: XCTestCase {
    func testDeckInitialization() throws {
        // Arrange
        let expectedTotalOfCards = 81
        let expectedDisplayedCardsCount = 12
        let expectedDeckCount = expectedTotalOfCards - expectedDisplayedCardsCount
        
        // Act
        let gameLogic = GameLogic()
        
        // Assert
        XCTAssertEqual(gameLogic.deckOfCards.count + gameLogic.displayedCards.count, expectedTotalOfCards, "There should be a total of \(expectedTotalOfCards) cards involved in the game")
        XCTAssertEqual(gameLogic.deckOfCards.count, expectedDeckCount, "Deck should be initialized with \(expectedDeckCount) cards.")
        XCTAssertEqual(gameLogic.displayedCards.count, expectedDisplayedCardsCount, "There should be \(expectedDisplayedCardsCount) cards displayed")
    }
    
    func testDealAdditionalCards() throws {
        // Arrange
        var gameLogic = GameLogic()
        let initialDeckCount = gameLogic.deckOfCards.count
        let initialDisplayedCount = gameLogic.displayedCards.count

        // Act
        gameLogic.dealAdditionalCards()

        // Assert
        XCTAssertEqual(gameLogic.deckOfCards.count, initialDeckCount - 3, "Deck should decrease by 3 cards")
        XCTAssertEqual(gameLogic.displayedCards.count, initialDisplayedCount + 3, "Displayed cards should increase by 3")
    }

}
