//
//  AnnouncementViewModelFactory.swift
//  Octotorp
//

import UIKit

protocol IAnnouncementViewModelFactory {
    func viewModel(for step: Route.Step) -> AnnouncementItemView.Model
}

final class AnnouncementViewModelFactory: IAnnouncementViewModelFactory {

    func viewModel(for step: Route.Step) -> AnnouncementItemView.Model {
        return .init(
            image: imageFor(step: step),
            instruction: step.instruction,
            distance: String(format: "%.0f", step.distance) + " м"
        )
    }

    // MARK: - Private

    private func imageFor(step: Route.Step) -> UIImage? {
        switch step.sign {
        case 2, 1:
            return UIImage(named: "ArrowRight")
        case -2, -1:
            return UIImage(named: "ArrowLeft")
        case 7, -7, 0:
            return UIImage(named: "ArrowTop")
        default:
            return nil
        }
    }
}
