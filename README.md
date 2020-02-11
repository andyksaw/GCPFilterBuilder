# GCPFilterBuilder

(WIP)

A lightweight DSL library to build query strings for use with APIs that follow [GCP's API guidelines](https://cloud.google.com/monitoring/api/v3/sorting-and-filtering). 

The library leverages the power of Swift 5 Function Builders to allow you to write your strings in a type-safe but declarative, expressive manner.

```swift
enum UserField: String {
    case displayName = "display_name"
    case description = "description"
    case isActive = "is_active"
}

let query = BuildQuery(for: UserField.self) {
    And {
        Or {
            Field(.displayName, .regexFullMatch("[a-zA-Z]{4}"))
            Field(.displayName, "=", "dummy_user")
        }
        Field(.isActive, true)
    }
}

print(query) 
```

Resulting in the following query:
```
(display_name.regex.full_match('[a-zA-Z]{4}') OR display_name='dummy_user') AND is_active=true
```

---

## Installation

Coming soon...

## Usage

### Field Definition

`BuildQuery` requires an enum type to be passed to it. The enum represents every field name that can be used in a query.

### Expressions

Expressions are simple field binary comparisons.

You can pass a rawValue for comparison:
```swift
Field(.fieldName, .equal, "string")
Field(.fieldName, .equal, 123)
Field(.fieldName, .equal, true)
```

You can pass a `RawRepresentable` (String|Int) enum case:
```swift
enum City: String {
    case tokyo
    case osaka
    case fukuoka
}

Field(.countryName, .equal, City.tokyo)
```

Omitting the operator will default to `.equal`
```swift
// Same as above
Field(.countryName, City.tokyo)
```

### Operators

All the expected operators are supported, including 'not equal' `!=` and 'containment' `:`

```swift
Field(.description, .contains, "swearing")
Field(.viewCount, .greaterThanOrEqual, 10)
```

Operators can be substituted with a String for greater readability at the cost of compiler type safety:
```swift
Field(.position, "=", "center")
Field(.energyLevel, "<", 50)
```

### Groups

You can manually specify a group of parenthesis:
```swift
Group {
    Field(.name, "John Smith")
}
// (name='John Smith')
```

Or you can force an `And` or `Or` to provide their own:
```swift
And(grouped: true) {
    ...
}

Or(grouped: true) {
    ...
}
```

By default, `grouped` is `true`. However, the root of a query will always have parenthesis stripped.

### Nested Blocks
`And` and `Or` can be nested infinitely and can hold an infinite number of expressions

```swift
And {
    Or {
        Or {
            ...
            ...
            ...
            ...
        }
        ...
    }
    ...
}
```

### Not

You can invert expressions:
```swift
Not(.weather, Weather.Sunny)

// NOT weather='sunny'

// Same thing as weather!='sunny'
```

Multiple NOT can be combined:
```swift
Or {
    Not(.adjective, "bad")
    Not(.adjective, "awful")
}

// (NOT adjective='bad' OR NOT adjective='awful')
```

### Function Expressions

Supports regex:
```swift
Field(.displayName, .regexFullMatch("Temp \\d{4}"))

// display_name=regex.full_match('Temp \\d{4}')
```

Empty string or list check:
```swift
Field(.displayName, .empty)
// display_name.empty
```

`starts_with` and `ends_with` support coming soon...

### Special Properties

Comparison of string length or list size:
```swift
Field(.displayName, .size, ">", 5)
// display_name.size > 5
```

## Todo
- [x] Support expressions for special properties
- [ ] Support full range of function expressions
- [ ] Support unified date expressions/formatting
- [ ] Solve namespace pollution problem
- [ ] Unit tests

- [ ] Future: DSL for Sort strings?