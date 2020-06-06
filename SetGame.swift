//
//  SetGame.swift
//  SetGame
//
//  Created by Joe Mestrovich on 6/5/20.
//  Copyright © 2020 Mizmovac. All rights reserved.
//

import Foundation

enum GameShape: CaseIterable {
	case shape1, shape2, shape3
}

enum GameCount: CaseIterable {
	case count1, count2, count3
}

enum GameColor: CaseIterable {
	case color1, color2, color3
}

enum GameFill: CaseIterable {
	case fill1, fill2, fill3
}

struct Card: Identifiable {
	let id: Int
	let shape: GameShape
	let count: GameCount
	let color: GameColor
	let fill: GameFill
	var inPlay: Bool
}

struct SetGame {
	let playFieldCount = 12
	
	var deck = [Card]()
	var cardsInPlay: [Card] {
		get {
			deck.filter({ $0.inPlay })
		}
	}
	
	init() {
		deck = buildDeck().shuffled()
	}
	
	// A better buildDeck. I moved the shuffle into the initializer because it
	// doesn't really belong here. A buildDeck function is all about making a
	// fresh deck of cards and nothing else.
	private func buildDeck() -> [Card] {
		GameShape.allCases.flatMap { shape in
			GameCount.allCases.flatMap { count in
				GameColor.allCases.flatMap { color in
					GameFill.allCases.map { fill in
						(shape, count, color, fill)
					}
				}
			}
		}
		.enumerated().map { offset, element in
			Card(id: offset,
				 shape: element.0,
				 count: element.1,
				 color: element.2,
				 fill: element.3,
				 inPlay: false)
		}
	}
	
	// I will add some additional unit tests for this function so that I can
	// be extra confident that it is correctly identifying winning hands.
	// Game rules at:
	// https://en.wikipedia.org/wiki/Set_(card_game)
	//
	// This code feels sloppy to me, so I hope to refactor later. For now I
	// will focus on the view model and view work.
	
	func isValidSet(_ cards: [Card]) -> Bool {
		guard cards.count == 3 else { return false }
		guard cards.contains(where: { $0.inPlay }) else { return false }
		
		var sharedElementCount = 0
		// TODO: Refactor duplicated code
		let countCardShapes = Set(cards.map { $0.shape })
		print(countCardShapes)
		if countCardShapes.count == 1 { sharedElementCount += 1 }
		if countCardShapes.count == 2 { return false }
		
		let countCardCount = Set(cards.map { $0.count })
		if countCardCount.count == 1 { sharedElementCount += 1 }
		if countCardCount.count == 2 { return false }
		
		let countCardColor = Set(cards.map { $0.color })
		if countCardColor.count == 1 { sharedElementCount += 1 }
		if countCardColor.count == 2 { return false }
		
		let countCardFill = Set(cards.map { $0.fill })
		if countCardFill.count == 1 { sharedElementCount += 1 }
		if countCardFill.count == 2 { return false }
		
		return sharedElementCount < 2
	}
	
	mutating func playHand(_ cards: [Card]) {
		guard isValidSet(cards) else { return }
		
		removePlayedCards(cards)
	}
	
	mutating private func removePlayedCards(_ cards: [Card]) {
		cards.forEach { card in
			if let index = deck.firstIndex(where: { $0.id == card.id }) {
				deck.remove(at: index)
			}
		}
	}
	
	#if DEBUG
	mutating func unplayFieldCards(_ cards: [Card]) {
		cards.forEach { card in
			if let index = deck.firstIndex(where: { $0.id == card.id }) {
				deck[index].inPlay = false
			}
		}
	}
	#endif
	
	mutating func updatePlayField() {
		while cardsInPlay.count < playFieldCount && (deck.count - cardsInPlay.count > 0) {
			guard let newFieldCardIndex = deck.firstIndex(where: { !$0.inPlay }) else { return }
			
			deck[newFieldCardIndex].inPlay = true
		}
	}
	
}

	
