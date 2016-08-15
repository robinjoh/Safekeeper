//
//  ModelExtensions.swift
//  Safekeeper
//
//  Created by Robin on 2016-08-14.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation

extension NSTimer {
	static var NEARABLE_RANGING_LIMIT: Double {
		return 5
	}
}

extension ESTNearableType {
	
	var string: String {
		switch self{
		case .Bag: return "Bag"
		case .Bed: return "Bed"
		case .Bike: return "Bike"
		case .Car: return "Car"
		case.Chair: return "Chair"
		case .Dog: return "Dog"
		case .Door: return "Door"
		case .Fridge: return "Fridge"
		case .Generic: return "Generic"
		case .Shoe: return "Shoe"
		case .Unknown: return "Unknown"
		case .All: return "All"
		}
	}
}

extension ESTColor {
	
	var string: String {
		switch self {
		case .Black: return "Black"
		case .BlueberryPie: return "Blueberry Pie"
		case .CandyFloss: return "Candy Floss"
		case .IcyMarshmallow: return "Icy Marshmallow"
		case .LemonTart: return "Lemon Tart"
		case .LiquoriceSwirl: return "Liquorice Swirl"
		case .MintCocktail: return "Mint Cocktail"
		case .SweetBeetroot: return "Sweet Beetroot"
		case .Transparent: return "Transparent"
		case .Unknown: return "Unknown"
		case .VanillaJello: return "Vanilla Jello"
		case .White: return "White"
		}
	}
}