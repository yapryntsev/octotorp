//
//  Reusable.swift
//  Octotorp
//

import Foundation

public protocol ReuseIdentifirable {
    var reuseIdentifier: String { get }
}

public extension ReuseIdentifirable {

    var reuseIdentifier: String {
        return String(describing: self)
    }
}

public protocol Reusable: ReuseIdentifirable {
    func prepareForReuse()
}

public extension Reusable {
    func prepareForReuse() { }
}
