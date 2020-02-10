//
//  FilterBuilder.swift
//  GCPFilterBuilder
//
//  Created by Andy Saw on 2020/02/11.
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

// MARK: - Building Blocks

public func And<Field: RawRepresentable>(grouped: Bool = true, @FilterBuilder<Field> builder: () -> [FilterToken<Field>]) -> FilterToken<Field> where Field.RawValue == String {
    return .and(builder(), grouped: grouped)
}

public func Or<Field: RawRepresentable>(grouped: Bool = true, @FilterBuilder<Field> builder: () -> [FilterToken<Field>]) -> FilterToken<Field> where Field.RawValue == String {
    return .or(builder(), grouped: grouped)
}

public func Group<Field: RawRepresentable>(@FilterBuilder<Field> builder: () -> [FilterToken<Field>]) -> FilterToken<Field> where Field.RawValue == String {
    return .group(builder())
}

public func Expression<Field: RawRepresentable, Value: RawRepresentable>(_ field: Field, _ operator: NumericOperator = .equal, case: Value) -> FilterToken<Field> where Field.RawValue == String, Value.RawValue == Int {
    return .expression(field: field, operator: `operator`, value: "\(`case`.rawValue)")
}

public func Expression<Field: RawRepresentable, Value: RawRepresentable>(_ field: Field, _ operator: StringOperator = .equal, case: Value) -> FilterToken<Field> where Field.RawValue == String, Value.RawValue == String {
    return .expression(field: field, operator: `operator`, value: "'\(`case`.rawValue)'")
}

public func Expression<Field: RawRepresentable>(_ field: Field, _ operator: StringOperator = .equal, rawValue: Int) -> FilterToken<Field> where Field.RawValue == String {
    return .expression(field: field, operator: `operator`, value: "\(rawValue)")
}

public func Expression<Field: RawRepresentable>(_ field: Field, _ operator: StringOperator = .equal, rawValue: String) -> FilterToken<Field> where Field.RawValue == String {
    return .expression(field: field, operator: `operator`, value: "'\(rawValue)'")
}

public func Expression<Field: RawRepresentable>(_ field: Field, _ operator: StringOperator = .equal, boolean: Bool) -> FilterToken<Field> where Field.RawValue == String {
    return .expression(field: field, operator: `operator`, value: "\(boolean)")
}

public func Expression<Field: RawRepresentable>(_ field: Field, _ specialToken: SpecialToken) -> FilterToken<Field> where Field.RawValue == String {
    return .specialExpression(field, specialToken)
}
