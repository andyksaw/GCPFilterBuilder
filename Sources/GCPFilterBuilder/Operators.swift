//
//  Operators.swift
//  GCPFilterBuilder
//
//  Created by Andy Saw on 2020/02/11.
//  Copyright © 2020 Andy Saw. All rights reserved.
//

import Foundation

public enum Operator {
    case contains
    case equal
    case notEqual
    case greaterThan
    case greaterThanOrEqual
    case lessThan
    case lessThanOrEqual
}

extension Operator: RawRepresentable {

    public var rawValue: String {
        switch self {
        case .contains: return ":"
        case .equal: return "="
        case .notEqual: return "!="
        case .greaterThan: return ">"
        case .greaterThanOrEqual: return ">="
        case .lessThan: return "<"
        case .lessThanOrEqual: return "<="
        }
    }

    public init?(rawValue: String) {
        switch rawValue {
        case ":": self = .contains
        case "=": self = .equal
        case "!=": self = .notEqual
        case ">": self = .greaterThan
        case ">=": self = .greaterThanOrEqual
        case "<": self = .lessThan
        case "<=": self = .lessThanOrEqual

        default: return nil
        }
    }
}

extension Operator: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        switch value {
        case ":": self = .contains
        case "=": self = .equal
        case "!=": self = .notEqual
        case ">": self = .greaterThan
        case ">=": self = .greaterThanOrEqual
        case "<": self = .lessThan
        case "<=": self = .lessThanOrEqual

        default: preconditionFailure("Invalid operator provided")
        }
    }
}
