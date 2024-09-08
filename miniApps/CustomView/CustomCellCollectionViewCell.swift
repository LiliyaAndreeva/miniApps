//
//  CustomCellCollectionViewCell.swift
//  miniApps
//
//  Created by Лилия Андреева on 08.09.2024.
//

import UIKit

class CustomCellCollectionViewCell: UICollectionViewCell {
	static let identifier = ConstantStrings.cellIdentifier
	private lazy var textLabel: UILabel = setupLabel()
	
	func configure(with model: Model) {
		textLabel.text = model.title
		setupUI()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = Sizes.cornerRadius
		clipsToBounds = true
	}
	
}
// MARK: - Settings view
private extension CustomCellCollectionViewCell {
	func setupUI() {
		self.backgroundColor = .systemPink
		addSubviews()
		setupLayout()
	}
}

// MARK: - Settings
private extension CustomCellCollectionViewCell {

	func addSubviews(){
		self.addSubview(textLabel)
	}

	func setupLabel() -> UILabel {
		let label = UILabel()
		label.textColor = .white
		let screenWidth = UIScreen.main.bounds.width
		let fontSize = screenWidth / Sizes.fontSize
		label.font = .systemFont(ofSize: fontSize)
		label.textAlignment = .center
		return label
	}
}

// MARK: - Setup layout
private extension CustomCellCollectionViewCell {
	func setupLayout() {
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])
	}
}
