//
//  RootViewController.swift
//  miniApps
//
//  Created by Лилия Андреева on 08.09.2024.
//

import UIKit
import CurrentGeoPositionPackage
import WeatherForecastSPM
import TikTacToeSPM

enum ListState {
	case smallItems
	case middleitems
	case fullScreenItems
}


final class RootViewController: UIViewController {
	
	// MARK: - Private properties
	private var viewData: [Model] = []
	private var itemState: ListState = .smallItems
	private lazy var collectionView: UICollectionView = setupCollectionView()
	// MARK: - Dependencies
	private var currentCityViewController = ViewControllerPack()
	private var weatherForecasrViewController = WeaterForecastViewController()
	private var tictactoeViewController = TikTacToeViewController()

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.delegate = self
		collectionView.dataSource = self
		setupView()
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		collectionView.collectionViewLayout.invalidateLayout()
	}
}

// MARK: - Settings View
private extension RootViewController {
	func setupView(){
		view.backgroundColor = .white
		addSubView()
		setupLayout()
		createButton()
		generateCellItems()
	}
}

// MARK: - Settings
private extension RootViewController {

	func addSubView(){
		view.addSubview(collectionView)
	}

	func setupCollectionView() -> UICollectionView {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(
			CustomCellCollectionViewCell.self,
			forCellWithReuseIdentifier: CustomCellCollectionViewCell.identifier
		)
		collectionView.showsVerticalScrollIndicator = false
		return collectionView
	}

	func createButton() {
		let toggleButton = UIBarButtonItem(
			image: UIImage(systemName: ConstantStrings.imageName),
			style: .done,
			target: self,
			action: #selector(toggleState)
		)
		let resizedImage = toggleButton.image?.withConfiguration(
			UIImage.SymbolConfiguration(
				pointSize: Sizes.pointSize,
				weight: .regular
			)
		)
		toggleButton.image = resizedImage
		navigationItem.leftBarButtonItem = toggleButton
	}



	@objc func toggleState() {
		switch itemState {
		case .smallItems:
			itemState = .middleitems
		case .middleitems:
			itemState = .fullScreenItems
		case .fullScreenItems:
			itemState = .smallItems
		}
		collectionView.reloadData()
	}

	private func generateCellItems() {
		let uniqueItems = Model.fetchCell()

		while viewData.count < Sizes.itemsCount {
			let randomIndex = Int.random(in: Sizes.zero..<uniqueItems.count)
			viewData.append(uniqueItems[randomIndex])
		}
	}
}

// MARK: - Layout
extension RootViewController {
	func setupLayout() {
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}


extension RootViewController: UICollectionViewDelegate, UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewData.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: CustomCellCollectionViewCell.identifier,
			for: indexPath
		) as? CustomCellCollectionViewCell else { return UICollectionViewCell() }

		let selectedModel = viewData[indexPath.row]
		cell.configure(with: selectedModel)
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if itemState == .smallItems {
			if let cell = collectionView.cellForItem(at: indexPath) {
				cell.isUserInteractionEnabled = false
			}
			return
		}
		let selectedModel = viewData[indexPath.row]

		switch selectedModel.title {
		case ConstantStrings.VCTitle.currentCity:
			navigationController?.pushViewController(currentCityViewController, animated: true)
		case ConstantStrings.VCTitle.weatherForecast:
			navigationController?.pushViewController(weatherForecasrViewController, animated: true)
		case ConstantStrings.VCTitle.tiktactoe:
			navigationController?.pushViewController(tictactoeViewController, animated: true)
		default:
			break
		}
	}
}

extension RootViewController:  UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		switch itemState {
		case .smallItems:
			let height = eitherOfTheScreenHeight
			let width = view.frame.width
			return CGSize(width: width, height: height)
		case .middleitems:
			let height = halfOfTheScreenHeight
			let width = view.frame.width
			return CGSize(width: width, height: height)
		case .fullScreenItems:
			return CGSize(width: view.frame.width, height: view.frame.height)
		}
	}

	var eitherOfTheScreenHeight: Double {
		return view.frame.height / Sizes.dividers.dividerSmall
	}

	var halfOfTheScreenHeight: Double {
		return view.frame.height / Sizes.dividers.dividerMedium
	}
}


