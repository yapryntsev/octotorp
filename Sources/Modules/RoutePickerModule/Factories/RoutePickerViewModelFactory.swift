//
//  RoutePickerViewModelFactory.swift
//  Octotorp
//

import UIKit

protocol IRoutePickerViewModelFactory {
    func viewModel(
        for destination: SearchResultItem,
        with: [Route]
    ) -> RoutePickerViewController.Model
}

final class RoutePickerViewModelFactory: IRoutePickerViewModelFactory {

    // Dependencies
    private lazy var dateFormatter: DateComponentsFormatter = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru")
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar


        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .brief

        return formatter
    }()

    // MARK: - Public

    func viewModel(
        for destination: SearchResultItem,
        with routes: [Route]
    ) -> RoutePickerViewController.Model {

        return .init(
            descriptionModel: makeDescriptionModel(for: destination),
            carouselModel: makeCarouselModel(for: routes)
        )
    }

    // MARK: - Private

    private func makeDescriptionModel(for destination: SearchResultItem) -> RoutePickerDescriptionView.Model {
        // TODO: исправить
        return .init(
            from: "Куда: \(destination.name)",
            to: "Мое местоположение"
        )
    }

    private func makeCarouselModel(for routes: [Route]) -> [RoutePickerCarouselItemView.Model] {

        return routes.map { route in
            return .init(
                icon: makeIcon(for: route),
                text: makeTimeTravel(for: route)
            )
        }
    }

    private func makeIcon(for route: Route) -> UIImage? {
        switch route.transport {
        case .walking:
            return UIImage(named: "Walk")
        case .scooter:
            return UIImage(named: "KickScooter")
        case .bike:
            return UIImage(named: "Bike")
        }
    }

    private func makeTimeTravel(for route: Route) -> String {
        return dateFormatter.string(from: route.travelTime) ?? ""
    }
}
