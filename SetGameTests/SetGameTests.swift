//
//  SetGameTests.swift
//  SetGameTests
//
//  Created by Joe Mestrovich on 6/5/20.
//  Copyright © 2020 Mizmovac. All rights reserved.
//

import XCTest
@testable import SetGame

class SetGameTests: XCTestCase {
	var cardGame = SetGame()
	
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDeckBuild() throws {
		let card1 = cardGame.deck.first(where: { $0.color == .color1 && $0.count == .count1 && $0.fill == .fill1 && $0.shape == .shape1 })
		XCTAssertNotNil(card1)
		
		let card2 = cardGame.deck.first(where: { $0.color == .color3 && $0.count == .count3 && $0.fill == .fill3 && $0.shape == .shape3 })
		XCTAssertNotNil(card2)
    }
	
	func testSet() throws {
		// Winning set with a common element
		let cardSet1 = [
			Card(id: 0, shape: .shape1, count: .count1, color: .color1, fill: .fill1, inPlay: true),
			Card(id: 1, shape: .shape1, count: .count2, color: .color2, fill: .fill2, inPlay: true),
			Card(id: 2, shape: .shape1, count: .count3, color: .color3, fill: .fill3, inPlay: true)
		]
		
		// Winning set with all unique elements
		let cardSet2 = [
			Card(id: 0, shape: .shape1, count: .count1, color: .color1, fill: .fill1, inPlay: true),
			Card(id: 1, shape: .shape2, count: .count2, color: .color2, fill: .fill2, inPlay: true),
			Card(id: 2, shape: .shape3, count: .count3, color: .color3, fill: .fill3, inPlay: true)
		]
		
		// Losing set with one duplicated element
		let cardSet3 = [
			Card(id: 0, shape: .shape1, count: .count1, color: .color1, fill: .fill1, inPlay: true),
			Card(id: 1, shape: .shape2, count: .count2, color: .color1, fill: .fill2, inPlay: true),
			Card(id: 2, shape: .shape3, count: .count3, color: .color3, fill: .fill3, inPlay: true)
		]
		
		// Losing set with too few selected game cards
		let cardSet4 = [
			Card(id: 0, shape: .shape1, count: .count1, color: .color1, fill: .fill1, inPlay: true),
			Card(id: 1, shape: .shape2, count: .count2, color: .color1, fill: .fill2, inPlay: true)
		]
		
		let setCheck1 = cardGame.isValidSet(cardSet1)
		XCTAssertTrue(setCheck1)
		
		let setCheck2 = cardGame.isValidSet(cardSet2)
		XCTAssertTrue(setCheck2)
		
		let setCheck3 = cardGame.isValidSet(cardSet3)
		XCTAssertFalse(setCheck3)
		
		let setCheck4 = cardGame.isValidSet(cardSet4)
		XCTAssertFalse(setCheck4)
	}
	
	func testPlays() throws {
		var playFieldCount = cardGame.cardsInPlay.count
		let initialDeckCount = cardGame.deck.count
		XCTAssertEqual(playFieldCount, 0)
		
		cardGame.updatePlayField()
		XCTAssertEqual(cardGame.cardsInPlay.count, cardGame.playFieldCount)
		
		// Remove three cards from the play field and replace them with a
		// winning set.
		cardGame.unplayFieldCards([cardGame.cardsInPlay[0], cardGame.cardsInPlay[1], cardGame.cardsInPlay[2]])
		
		let card1 = cardGame.deck.firstIndex(where: { $0.color == .color1 && $0.count == .count1 && $0.fill == .fill1 && $0.shape == .shape1 })!
		cardGame.deck[card1].inPlay = true
		let card2 = cardGame.deck.firstIndex(where: { $0.color == .color2 && $0.count == .count2 && $0.fill == .fill2 && $0.shape == .shape2 })!
		cardGame.deck[card2].inPlay = true
		let card3 = cardGame.deck.firstIndex(where: { $0.color == .color3 && $0.count == .count3 && $0.fill == .fill3 && $0.shape == .shape3 })!
		cardGame.deck[card3].inPlay = true
		let playedCards = [cardGame.deck[card1], cardGame.deck[card2], cardGame.deck[card3]]
		playFieldCount = cardGame.cardsInPlay.count
		
		cardGame.playHand(playedCards)
		XCTAssertEqual(cardGame.deck.count, initialDeckCount - 3)
		XCTAssertEqual(cardGame.cardsInPlay.count, playFieldCount - 3)
		
		cardGame.updatePlayField()
		XCTAssertEqual(cardGame.cardsInPlay.count, cardGame.playFieldCount)
	}

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
