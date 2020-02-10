//
//  Operators.swift
//  GCPFilterBuilder
//
//  Created by Andy Saw on 2020/02/11.
//  Copyright © 2020 Andy Saw. All rights reserved.
//

import Foundation

public protocol Operator: CustomStringConvertible {}

public enum StringOperator: Operator {
    case equal
    case notEqual
    case greaterThan
    case greaterThanOrEqual
    case lessThan
    case lessThanOrEqual

    public var description: String {
        switch self {
        case .equal: return "="
        case .notEqual: return "!="
        case .greaterThan: return ">"
        case .greaterThanOrEqual: return ">="
        case .lessThan: return "<"
        case .lessThanOrEqual: return "<="
        }
    }
}

public enum NumericOperator: Operator {
    case containment // Equivalent to '=' for numeric types
    case equal // Should be avoided for double-valued fields
    case notEqual
    case greaterThan
    case greaterThanOrEqual
    case lessThan
    case lessThanOrEqual

    public var description: String {
       switch self {
       case .containment: return ":"
       case .equal: return "="
       case .notEqual: return "!="
       case .greaterThan: return ">"
       case .greaterThanOrEqual: return ">="
       case .lessThan: return "<"
       case .lessThanOrEqual: return "<="
       }
   }
}
