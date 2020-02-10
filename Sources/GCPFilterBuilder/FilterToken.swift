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
    case expression(field: Field, operator: Operator, value: String)
    case specialExpression(Field, SpecialToken)

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

        case .expression(let field, let `operator`, let value):
            return [field.rawValue, `operator`.description, value].joined()

        case .specialExpression(let field, let specialToken):
            switch specialToken {
            case .empty:
                return "\(field.rawValue).empty"
            case .size:
                return "\(field.rawValue).size"
            case .fullMatchRegex(let pattern):
                let escapedPattern = pattern.replacingOccurrences(of: "\\", with: "\\\\", options: .literal)
                return "\(field.rawValue).regex.full_match('\(escapedPattern)')"
            }

        }
    }
}

public enum SpecialToken {
    case empty
    case size
    case fullMatchRegex(String)
}
