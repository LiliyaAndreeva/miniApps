//
//  Model.swift
//  miniApps
//
//  Created by Лилия Андреева on 08.09.2024.
//

import Foundation
struct Model {
	let title: String

	static func fetchCell() -> [Model] {
		let cellItems = [
			Model(title: ConstantStrings.VCTitle.currentCity),
			Model(title: ConstantStrings.VCTitle.weatherForecast),
			Model(title: ConstantStrings.VCTitle.tiktactoe)
		]
		return cellItems
	}
}
