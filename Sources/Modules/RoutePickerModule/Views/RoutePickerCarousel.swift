//
//  RoutePickerCarouselView.swift
//  Octotorp
//

import UIKit
import SkeletonView

private extension CGFloat {
    static let contentHeigh = CGFloat(40)
}

protocol IRoutePickerCarouselActionHandler: AnyObject {
    func userDidSelectType(index: Int)
}

final class RoutePickerCarouselView: UIView {

    // UI
    private lazy var collectionView: UICollectionView = {
        let layoutProvider = RoutePickerCarouselLayoutFactory()
        let collection = UICollectionView(layoutProvider: layoutProvider)
        collection.alwaysBounceVertical = false
        collection.backgroundColor = .clear
        collection.clipsToBounds = false
        collection.dataSource = self
        collection.delegate = self

        collection.register(RoutePickerCarouselItemCell.self)

        return collection
    }()

    // Properties
    private var itemModels = [RoutePickerCarouselItemView.Model]()

    // Dependencies
    weak var actionHandler: IRoutePickerCarouselActionHandler?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setup() {
        addSubview(collectionView)
        collectionView.snp.edgesToSuperview()

        collectionView.snp.makeConstraints { make in
            make.height.equalTo(CGFloat.contentHeigh)
        }

        self.isSkeletonable = true
        collectionView.isSkeletonable = true
    }
}

// MARK: - Configurable

extension RoutePickerCarouselView: Configurable {

    func configure(with model: [RoutePickerCarouselItemView.Model]) {
        itemModels = model
        collectionView.reloadData()

        collectionView.selectItem(
            at: .init(item: 0, section: 0),
            animated: true, scrollPosition: []
        )
        collectionView(collectionView, didSelectItemAt: .init(item: 0, section: 0))
    }
}

// MARK: - SkeletonCollectionViewDataSource

extension RoutePickerCarouselView: SkeletonCollectionViewDataSource {

    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 3
    }

    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        cellIdentifierForItemAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {

        return String(describing: RoutePickerCarouselItemCell.self)
    }

    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        skeletonCellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell? {

        let cell: RoutePickerCarouselItemCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(with: .init(icon: nil, text: "skeleton"))

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return itemModels.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell: RoutePickerCarouselItemCell = collectionView.dequeueCell(for: indexPath)
        let model = itemModels[indexPath.row]

        cell.configure(with: model)
        cell.hideSkeleton()

        return cell
    }
}

extension RoutePickerCarouselView: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        actionHandler?.userDidSelectType(index: indexPath.row)
    }
}
