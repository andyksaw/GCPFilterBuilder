//
//  FilterToken.swift
//  GCPFilterBuilder
//
//  Created by Andy Saw on 2020/02/11.
//  Copyright © 2020 Andy Saw. All rights reserved.
//

import Foundation

public indirect enum FilterToken<Field: RawRepresentable>: CustomStringConvertible where Field.RawValue == String {
    case root(FilterToken<Field>)
    case and([FilterToken<Field>], grouped: Bool)
    case or([FilterToken<Field>], grouped: Bool)
    case group([FilterToken<Field>])
    case expression(field: Field, operator: Operator, value: ValueBox, inversed: Bool)
    case functionExpression(Field, FunctionExp, inversed: Bool)
    case propertyExpression(field: Field, property: FieldProperty, operator: Operator, value: ValueBox, inversed: Bool)

    public var description: String {
        switch self {
        case .root(.root):
            preconditionFailure("FilterQuery cannot contain a nested FilterQuery")

        case .root(let tokens):
            let string = tokens.description

            // Strip brackets around root query because they're unnecessary
            if string.first == "(" && string.last == ")" {
                return String(string.dropFirst().dropLast())
            }
            return string

        case .and(let tokens, let grouped):
            let string = tokens.map { $0.description }.joined(separator: " AND ")
            return grouped ? "(" + string + ")" : string

        case .or(let tokens, let grouped):
            let string = tokens.map { $0.description }.joined(separator: " OR ")
            return grouped ? "(" + string + ")" : string

        case .group(let tokens):
            return "(" + tokens.description + ")"

        case .expression(let field, let `operator`, let value, let inversed):
            let string = [field.rawValue, `operator`.rawValue, value.description].joined()
            return inversed ? "NOT " + string : string

        case .functionExpression(let field, let specialToken, let inversed):
            let string: String = {
                switch specialToken {
                case .empty:
                    return "\(field.rawValue).empty"
                case .fullMatchRegex(let pattern):
                    let escapedPattern = pattern.replacingOccurrences(of: "\\", with: "\\\\", options: .literal)
                    return "\(field.rawValue).regex.full_match('\(escapedPattern)')"
                case .startsWith(let literal):
                    return "\(field.rawValue).starts_with(\(literal.description))"
                case .endsWith(let literal):
                    return "\(field.rawValue).ends_with(\(literal.description))"
                }
            }()
            return inversed ? "NOT " + string : string

        case .propertyExpression(let field, let property, let `operator`, let value, let inversed):
            switch property {
            case .size:
                let string = [field.rawValue, ".size", `operator`.rawValue, value.description].joined()
                return inversed ? "NOT " + string : string
            }
        }
    }
}

public enum FunctionExp {
    case empty
    case fullMatchRegex(String)
    case startsWith(ValueBox)
    case endsWith(ValueBox)
}

public enum FieldProperty {
    case size
}
