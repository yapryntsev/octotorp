//
//  RoutePickerAssembly.swift
//  Octotorp
//

import UIKit

final class RoutePickerAssembly {

    func assemble(
        direction: SearchResultItem,
        container: IRootWidgetContainer,
        output: @escaping (RoutePickerOutput) -> Void
    ) -> UIViewController {

        let presenter = presenter(output: output, container: container, direction: direction)
        let confirmView = bottomWidget(presenter: presenter)
        let pickerView = view(presenter: presenter)

        presenter.pickerView = pickerView
        presenter.confirmView = confirmView

        return pickerView
    }

    // MARK: - Private

    private func bottomWidget(presenter: IRouterPickerConfirmActionHandler) -> RouterPickerConfirmViewController {
        return RouterPickerConfirmViewController(actionHandler: presenter)
    }

    private func view(presenter: IRoutePickerPresenter) -> RoutePickerViewController {
        return RoutePickerViewController(presenter: presenter)
    }

    private func presenter(
        output: @escaping (RoutePickerOutput) -> Void,
        container: IRootWidgetContainer,
        direction: SearchResultItem
    ) -> RoutePickerPresenter {
        
        let viewModelFactory = RoutePickerViewModelFactory()
        let mapStateFactory = GlobalMapStateFactory()
        let routeService = RouteService()

        return RoutePickerPresenter(
            output: output,
            routeService: routeService,
            mapStateFactory: mapStateFactory,
            viewModelFactory: viewModelFactory,
            container: container,
            direction: direction
        )
    }
}
