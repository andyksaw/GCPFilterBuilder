//
//  ValueBox.swift
//  GCPFilterBuilder
//
//  Created by Andy Saw on 2020/02/11.
//  Copyright © 2020 Andy Saw. All rights reserved.
//

import Foundation

public struct ValueBox: CustomStringConvertible, ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByBooleanLiteral, ExpressibleByFloatLiteral {
    private let _box: WrappedValueBox

    public var description: String {
        return _box.toString
    }

    public init(stringLiteral value: String) {
        self._box = StringValueBox(value)
    }

    public init(integerLiteral value: Int) {
        self._box = IntValueBox(value)
    }

    public init(booleanLiteral value: Bool) {
        self._box = BoolValueBox(value)
    }

    public init(floatLiteral value: Float) {
        self._box = FloatValueBox(value)
    }
}

protocol WrappedValueBox {
    var toString: String { get }
}

extension ValueBox {

    struct StringValueBox: WrappedValueBox {
        var _value: String

        var toString: String {
            return "'\(_value)'"
        }

        init(_ value: String) {
            self._value = value
        }
    }

    struct IntValueBox: WrappedValueBox {
        var _value: Int

        var toString: String {
            return "\(_value)"
        }

        init(_ value: Int) {
            self._value = value
        }
    }

    struct BoolValueBox: WrappedValueBox {
        var _value: Bool

        var toString: String {
            return "\(_value)"
        }

        init(_ value: Bool) {
            self._value = value
        }
    }

    struct FloatValueBox: WrappedValueBox {
        var _value: Float

        var toString: String {
            return "\(_value)"
        }

        init(_ value: Float) {
            self._value = value
        }
    }

}
