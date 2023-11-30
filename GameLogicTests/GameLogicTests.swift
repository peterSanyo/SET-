//
//  GameLogicTests.swift
//  GameLogicTests
//
//  Created by Péter Sanyó on 30.11.23.
//
//  This file contains unit tests for the GameLogic struct in the SET_ app.
//  It aims to test various functionalities of the game's logic, ensuring the
//  correctness and reliability of the game mechanics.

@testable import SET_
import XCTest

@MainActor class GameLogicTests: XCTestCase {
    
    // Tests the initial state of the GameLogic to ensure that the cards are properly initialized.
    func testDeckInitialization() throws {
        let expectedTotalOfCards = 81
        let expectedDisplayedCardsCount = 12
        let expectedDeckCount = expectedTotalOfCards - expectedDisplayedCardsCount

        let gameLogic = GameLogic()

        XCTAssertEqual(gameLogic.deckOfCards.count + gameLogic.displayedCards.count, expectedTotalOfCards, "There should be a total of \(expectedTotalOfCards) cards involved in the game")
        XCTAssertEqual(gameLogic.deckOfCards.count, expectedDeckCount, "Deck should be initialized with \(expectedDeckCount) cards.")
        XCTAssertEqual(gameLogic.displayedCards.count, expectedDisplayedCardsCount, "There should be \(expectedDisplayedCardsCount) cards displayed")
    }

    // Tests the behavior of dealing additional cards. Verifies that the correct number of cards is moved from the deck to the displayed cards.
    func testDealAdditionalCards() throws {
        var gameLogic = GameLogic()
        let initialDeckCount = gameLogic.deckOfCards.count
        let initialDisplayedCount = gameLogic.displayedCards.count

        gameLogic.dealAdditionalCards()

        XCTAssertEqual(gameLogic.deckOfCards.count, initialDeckCount - 3, "Deck should decrease by 3 cards")
        XCTAssertEqual(gameLogic.displayedCards.count, initialDisplayedCount + 3, "Displayed cards should increase by 3")
    }

    // Tests the penalty mechanics in the ViewModel. Ensures that the score is correctly decreased when a valid set is available.
    func DealPenaltyMechanics() throws {
        var viewModel = SetGameViewModel()
        viewModel.gameLogic.setupTestScenarioWithValidSet() // Ensure this sets a valid set in displayedCards
        let initialScore = viewModel.gameLogic.score

        viewModel.dealMechanics()

        XCTAssertEqual(viewModel.gameLogic.score, initialScore - 3, "Score should decrease by 3 points when a set is available")
    }
}
