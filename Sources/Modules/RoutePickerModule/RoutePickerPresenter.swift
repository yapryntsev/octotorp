//
//  RoutePickerPresenter.swift
//  Octotorp
//

import UIKit
import CoreLocation

protocol IRoutePickerPresenter {
    func viewDidLoad()
    func userDidTapCloseButton()
    func userDidTapFromButtom()
    func userDidSelectType(index: Int)
}

enum RoutePickerOutput {
    case close
    case selected(Route)
    case changeDeparture
}

final class RoutePickerPresenter: NSObject {

    // MARK: - Output
    private var output: (RoutePickerOutput) -> Void

    // Properties
    private var userLocation: CLLocationCoordinate2D?

    // Dependencies
    private let routeService: IRouteService
    private let mapStateFactory: IGlobalMapStateFactory
    private let viewModelFactory: IRoutePickerViewModelFactory

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    private let direction: SearchResultItem
    private var selectedIndex = 0
    private var routes = [Route]()

    private weak var container: IRootWidgetContainer?

    var confirmView: RouterPickerConfirmViewController?
    weak var pickerView: IRoutePickerViewController?

    // MARK: - Initialization

    init(
        output: @escaping (RoutePickerOutput) -> Void,
        routeService: IRouteService,
        mapStateFactory: IGlobalMapStateFactory,
        viewModelFactory: IRoutePickerViewModelFactory,
        container: IRootWidgetContainer,
        direction: SearchResultItem
    ) {
        self.output = output
        self.direction = direction
        self.container = container
        self.routeService = routeService
        self.mapStateFactory = mapStateFactory
        self.viewModelFactory = viewModelFactory
    }

    // MARK: - Private

    private func getRoutes() {
        guard let start = userLocation else { return }

        routeService.route(start: start, end: direction.coodinate)
            .done { [self] routes in
                guard self.routes.isEmpty else { return }
                self.routes = routes
                configureView(with: routes)
            }
            .catch { [self] error in
                self.pickerView?.present(title: "Ошибочка", text: error.localizedDescription)
            }
    }

    private func configureView(with routes: [Route]) {
        let model = viewModelFactory.viewModel(for: direction, with:  routes)

        pickerView?.hideSkeleton()
        pickerView?.configure(with: model)
        container?.widgetDidChangeLayout()

        guard let confirmView = confirmView else { return }
        container?.set(widget: confirmView, as: .bottom, animated: true)
    }
}

// MARK: - IRoutePickerPresenter

extension RoutePickerPresenter: IRoutePickerPresenter {

    func viewDidLoad() {
        pickerView?.showSkeleton()

        let state = mapStateFactory.skeleton()
        container?.map.configure(with: state)

        locationManager.startUpdatingLocation()
    }

    func userDidTapCloseButton() {
        let state = mapStateFactory.explore()
        container?.map.configure(with: state)

        output(.close)
    }

    func userDidTapFromButtom() {
        output(.changeDeparture)
    }

    func userDidSelectType(index: Int) {
        selectedIndex = index

        let route = routes[selectedIndex]
        let state = mapStateFactory.review(route)

        container?.map.configure(with: state)
    }
}

// MARK: - IRouterPickerConfirmActionHandler

extension RoutePickerPresenter: IRouterPickerConfirmActionHandler {

    func userDidTapConfirmButton() {
        let route = routes[selectedIndex]
        output(.selected(route))
    }
}

// MARK: - CLLocationManagerDelegate

extension RoutePickerPresenter: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        manager.stopUpdatingLocation()
        userLocation = location.coordinate
        getRoutes()
    }
}
