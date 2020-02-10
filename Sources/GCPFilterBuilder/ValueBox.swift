//
//  ValueBox.swift
//  GCPFilterBuilder
//
//  Created by Andy Saw on 2020/02/11.
//  Copyright © 2020 Andy Saw. All rights reserved.
//

import Foundation

public struct ValueBox: CustomStringConvertible, ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByBooleanLiteral {
    private let _box: WrappedValueBox

    public var description: String {
        return _box.toString
    }

    public init(stringLiteral value: String) {
        self._box = StringValueBox(_value: value)
    }

    public init(integerLiteral value: Int) {
        self._box = IntValueBox(_value: value)
    }

    public init(booleanLiteral value: Bool) {
        self._box = BoolValueBox(_value: value)
    }
}

protocol WrappedValueBox {
    var toString: String { get }
}

struct StringValueBox: WrappedValueBox {
    var _value: String

    var toString: String {
        return "'\(_value)'"
    }
}

struct IntValueBox: WrappedValueBox {
    var _value: Int

    var toString: String {
        return "\(_value)"
    }
}

struct BoolValueBox: WrappedValueBox {
    var _value: Bool

    var toString: String {
        return "\(_value)"
    }
}
