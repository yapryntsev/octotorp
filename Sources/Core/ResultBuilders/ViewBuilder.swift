//
//  ViewBuilder.swift
//  Octotorp
//

import UIKit

@resultBuilder
public struct ViewBuilder {

    public typealias Expression = UIView
    public typealias Component = [UIView]
    public typealias FinalResult = [UIView]

    public static func buildBlock(_ components: Component...) -> Component {
        return components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: Expression) -> Component {
        return [expression]
    }

    public static func buildFinalResult(_ component: Component) -> FinalResult {
        return component
    }

    public static func buildArray(_ components: [Component]) -> Component {
        return components.flatMap { $0 }
    }

    public static func buildOptional(_ component: Component?) -> Component {
        return component ?? []
    }
}
