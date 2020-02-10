import Foundation

@_functionBuilder
struct FilterBuilder<Field: RawRepresentable> where Field.RawValue == String {
    static func buildBlock(_ queries: FilterToken<Field>...) -> [FilterToken<Field>] {
        return queries
    }
}

indirect enum FilterToken<Field: RawRepresentable>: CustomStringConvertible where Field.RawValue == String {
    case root(FilterToken<Field>)
    case and([FilterToken<Field>], grouped: Bool)
    case or([FilterToken<Field>], grouped: Bool)
    case group([FilterToken<Field>])
    case expression(field: Field, operation: Operation, value: String)
    case specialExpression(Field, SpecialToken)

    var description: String {
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

        case .expression(let field, let operation, let value):
            return [field.rawValue, operation.description, value].joined()

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

enum SpecialToken {
    case empty
    case size
    case fullMatchRegex(String)
}

protocol Operation: CustomStringConvertible {}

enum StringOperation: Operation {
    case equal
    case notEqual
    case greaterThan
    case greaterThanOrEqual
    case lessThan
    case lessThanOrEqual

    var description: String {
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

enum NumericOperation: Operation {
    case containment // Equivalent to '=' for numeric types
    case equal // Should be avoided for double-valued fields
    case notEqual
    case greaterThan
    case greaterThanOrEqual
    case lessThan
    case lessThanOrEqual

    var description: String {
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

func MakeQuery<Field: RawRepresentable>(for fields: Field.Type, @FilterBuilder<Field> builder: () -> FilterToken<Field>) -> FilterToken<Field> where Field.RawValue == String {
    return .root(builder())
}

func And<Field: RawRepresentable>(grouped: Bool = true, @FilterBuilder<Field> builder: () -> [FilterToken<Field>]) -> FilterToken<Field> where Field.RawValue == String {
    return .and(builder(), grouped: grouped)
}

func Or<Field: RawRepresentable>(grouped: Bool = true, @FilterBuilder<Field> builder: () -> [FilterToken<Field>]) -> FilterToken<Field> where Field.RawValue == String {
    return .or(builder(), grouped: grouped)
}

func Group<Field: RawRepresentable>(@FilterBuilder<Field> builder: () -> [FilterToken<Field>]) -> FilterToken<Field> where Field.RawValue == String {
    return .group(builder())
}

func Expression<Field: RawRepresentable, Value: RawRepresentable>(_ field: Field, _ operation: NumericOperation = .equal, case: Value) -> FilterToken<Field> where Field.RawValue == String, Value.RawValue == Int {
    return .expression(field: field, operation: operation, value: "\(`case`.rawValue)")
}

func Expression<Field: RawRepresentable, Value: RawRepresentable>(_ field: Field, _ operation: StringOperation = .equal, case: Value) -> FilterToken<Field> where Field.RawValue == String, Value.RawValue == String {
    return .expression(field: field, operation: operation, value: "'\(`case`.rawValue)'")
}

func Expression<Field: RawRepresentable>(_ field: Field, _ operation: StringOperation = .equal, rawValue: Int) -> FilterToken<Field> where Field.RawValue == String {
    return .expression(field: field, operation: operation, value: "\(rawValue)")
}

func Expression<Field: RawRepresentable>(_ field: Field, _ operation: StringOperation = .equal, rawValue: String) -> FilterToken<Field> where Field.RawValue == String {
    return .expression(field: field, operation: operation, value: "'\(rawValue)'")
}

func Expression<Field: RawRepresentable>(_ field: Field, _ operation: StringOperation = .equal, boolean: Bool) -> FilterToken<Field> where Field.RawValue == String {
    return .expression(field: field, operation: operation, value: "\(boolean)")
}

func Expression<Field: RawRepresentable>(_ field: Field, _ specialToken: SpecialToken) -> FilterToken<Field> where Field.RawValue == String {
    return .specialExpression(field, specialToken)
}
