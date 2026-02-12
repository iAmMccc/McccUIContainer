//
//  File.swift
//  FluxKit
//
//  Created by Mccc on 2026/2/12.
//

import Foundation
import Foundation
public protocol FluxNamespaceWrappable {
    associatedtype WrapperType
    var flux: WrapperType { get }
    static var flux: WrapperType.Type { get }
}

public extension FluxNamespaceWrappable {
    var flux: FluxNamespaceWrapper<Self> {
        return FluxNamespaceWrapper(value: self)
    }

    static var flux: FluxNamespaceWrapper<Self>.Type {
        return FluxNamespaceWrapper.self
    }
}

public struct FluxNamespaceWrapper<T> {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}
