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

    public var description: String {
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
}
