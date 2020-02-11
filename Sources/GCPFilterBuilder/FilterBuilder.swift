//
//  FilterBuilder.swift
//  GCPFilterBuilder
//
//  Created by Andy Saw on 2020/02/11.
//  Copyright © 2020 Andy Saw. All rights reserved.
//

import Foundation

@_functionBuilder
struct FilterBuilder<Field: RawRepresentable> where Field.RawValue == String {
    static func buildBlock(_ queries: FilterToken<Field>...) -> [FilterToken<Field>] {
        return queries
    }
}

// MARK: - Root Block

public func BuildQuery<Field: RawRepresentable>(for fields: Field.Type, @FilterBuilder<Field> builder: () -> FilterToken<Field>) -> String where Field.RawValue == String {
    return FilterToken.root(builder()).description
}

// MARK: - Blocks

public func And<Field: RawRepresentable>(grouped: Bool = true, @FilterBuilder<Field> builder: () -> [FilterToken<Field>]) -> FilterToken<Field> where Field.RawValue == String {
    return .and(builder(), grouped: grouped)
}

public func Or<Field: RawRepresentable>(grouped: Bool = true, @FilterBuilder<Field> builder: () -> [FilterToken<Field>]) -> FilterToken<Field> where Field.RawValue == String {
    return .or(builder(), grouped: grouped)
}

public func Group<Field: RawRepresentable>(@FilterBuilder<Field> builder: () -> [FilterToken<Field>]) -> FilterToken<Field> where Field.RawValue == String {
    return .group(builder())
}

// MARK: - Expressions

public func Field<Field: RawRepresentable, Value: RawRepresentable>(_ field: Field, _ operator: Operator = .equal, case: Value) -> FilterToken<Field> where Field.RawValue == String, Value.RawValue == Int {
    return .expression(field: field, operator: `operator`, value: ValueBox(integerLiteral: `case`.rawValue), inversed: false)
}

public func Field<Field: RawRepresentable, Value: RawRepresentable>(_ field: Field, _ operator: Operator = .equal, case: Value) -> FilterToken<Field> where Field.RawValue == String, Value.RawValue == String {
    return .expression(field: field, operator: `operator`, value: ValueBox(stringLiteral: `case`.rawValue), inversed: false)
}

public func Field<Field: RawRepresentable>(_ field: Field, _ operator: Operator = .equal, rawValue: ValueBox) -> FilterToken<Field> where Field.RawValue == String {
    return .expression(field: field, operator: `operator`, value: rawValue, inversed: false)
}

public func Field<Field: RawRepresentable>(_ field: Field, _ specialToken: FunctionExp) -> FilterToken<Field> where Field.RawValue == String {
    return .functionExpression(field, specialToken, inversed: false)
}

public func Field<Field: RawRepresentable>(_ field: Field, _ property: FieldProperty, _ operator: Operator = .equal, rawValue: ValueBox) -> FilterToken<Field> where Field.RawValue == String {
    return .propertyExpression(field: field, property: property, operator: `operator`, value: rawValue, inversed: false)
}

// MARK: - Inverted Expressions

public func Not<Field: RawRepresentable, Value: RawRepresentable>(_ field: Field, _ operator: Operator = .equal, case: Value) -> FilterToken<Field> where Field.RawValue == String, Value.RawValue == Int {
    return .expression(field: field, operator: `operator`, value: ValueBox(integerLiteral: `case`.rawValue), inversed: true)
}

public func Not<Field: RawRepresentable, Value: RawRepresentable>(_ field: Field, _ operator: Operator = .equal, case: Value) -> FilterToken<Field> where Field.RawValue == String, Value.RawValue == String {
    return .expression(field: field, operator: `operator`, value: ValueBox(stringLiteral: `case`.rawValue), inversed: true)
}

public func Not<Field: RawRepresentable>(_ field: Field, _ operator: Operator = .equal, rawValue: ValueBox) -> FilterToken<Field> where Field.RawValue == String {
    return .expression(field: field, operator: `operator`, value: rawValue, inversed: true)
}

public func Not<Field: RawRepresentable>(_ field: Field, _ specialToken: FunctionExp) -> FilterToken<Field> where Field.RawValue == String {
    return .functionExpression(field, specialToken, inversed: true)
}

public func Not<Field: RawRepresentable>(_ field: Field, _ property: FieldProperty, _ operator: Operator = .equal, rawValue: ValueBox) -> FilterToken<Field> where Field.RawValue == String {
    return .propertyExpression(field: field, property: property, operator: `operator`, value: rawValue, inversed: true)
}

// MARK: Date Expressions

//public func Expression<Field: RawRepresentable>(_ field: Field, operator: StringOperator = .equal, date: Date, formatter: (Date, TimeZone) -> String) -> FilterToken<Field> where Field.RawValue == String {
//     TODO
//}

//public func Expression<Field: RawRepresentable>(_ field: Field, operator: StringOperator = .equal, date: Date) -> FilterToken<Field> where Field.RawValue == String {
//     TODO
//}
