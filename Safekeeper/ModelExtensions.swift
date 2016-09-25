//
//  ModelExtensions.swift
//  Safekeeper
//
//  Created by Robin on 2016-08-14.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation

extension Timer {
	static var NEARABLE_RANGING_LIMIT: Double {
		return 5
	}
}

extension ESTNearableType {
	
	var string: String {
		switch self{
		case .bag: return "Bag"
		case .bed: return "Bed"
		case .bike: return "Bike"
		case .car: return "Car"
		case.chair: return "Chair"
		case .dog: return "Dog"
		case .door: return "Door"
		case .fridge: return "Fridge"
		case .generic: return "Generic"
		case .shoe: return "Shoe"
		case .unknown: return "Unknown"
		case .all: return "All"
		}
	}
}

extension ESTColor {
	
	var string: String {
		switch self {
		case .black: return "Black"
		case .blueberryPie: return "Blueberry Pie"
		case .candyFloss: return "Candy Floss"
		case .icyMarshmallow: return "Icy Marshmallow"
		case .lemonTart: return "Lemon Tart"
		case .liquoriceSwirl: return "Liquorice Swirl"
		case .mintCocktail: return "Mint Cocktail"
		case .sweetBeetroot: return "Sweet Beetroot"
		case .transparent: return "Transparent"
		case .unknown: return "Unknown"
		case .vanillaJello: return "Vanilla Jello"
		case .white: return "White"
		}
	}
}
