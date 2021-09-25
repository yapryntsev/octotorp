//
//  RouteAnnouncer.swift
//  Octotorp
//

import UIKit
import CoreLocation
import AVFoundation

protocol IRouteAnnouncer: IAnnouncementsProvider {
    func annonce(step: Route.Step)
    func updtaeAnnonce(with location: CLLocationCoordinate2D)
}

protocol IAnnouncementsProvider {
    func expanded()
    func collapsed()

    func numberOfAnnouncements() -> Int
    func announcement(at indexPath: IndexPath) -> AnnouncementItemView.Model
}

final class RouteAnnouncer: NSObject, IRouteAnnouncer {

    // Properties
    var shouldAnnonce: Bool = true
    var currentStepIndex = IndexPath(row: 0, section: 0)

    // Dependencies
    private var steps: [Route.Step]
    private let synthesizer = AVSpeechSynthesizer()
    private let viewModelFactory: IAnnouncementViewModelFactory

    weak var collectionView: UICollectionView?

    // MARK: - Initialization

    init(steps: [Route.Step], viewModelFactory: IAnnouncementViewModelFactory) {
        self.steps = steps
        self.viewModelFactory = viewModelFactory
    }

    // MARK: - IRouteAnnouncer

    func annonce(step: Route.Step) {
        guard let index = steps.firstIndex(of: step) else { return }
        currentStepIndex = IndexPath(row: index + 1, section: 0)

        collectionView?.scrollToItem(
            at: currentStepIndex,
            at: .top,
            animated: true)

        guard shouldAnnonce else { return }

        let utterance = AVSpeechUtterance(string: step.instruction)
        utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")

        synthesizer.speak(utterance)
    }

    func updtaeAnnonce(with location: CLLocationCoordinate2D) {
        let currentStep = steps[currentStepIndex.row]
        let distance = currentStep.end.distance(to: location)

        steps[currentStepIndex.row] = currentStep.mutate(with: distance)
        collectionView?.reloadItems(at: [currentStepIndex])
    }
}

// MARK: - IAnnouncementsProvider

extension RouteAnnouncer: IAnnouncementsProvider {

    func expanded() { }

    func collapsed() {
        collectionView?.scrollToItem(
            at: currentStepIndex,
            at: .top,
            animated: true)
    }

    func numberOfAnnouncements() -> Int {
        return steps.count
    }

    func announcement(at indexPath: IndexPath) -> AnnouncementItemView.Model {
        return viewModelFactory.viewModel(for: steps[indexPath.row])
    }
}
