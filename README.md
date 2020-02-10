# GCPFilterBuilder

(WIP)

A light-weight library to build filter/sort query strings for use with APIs that follow [GCP's API guidelines](https://cloud.google.com/monitoring/api/v3/sorting-and-filtering). 

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
            Expression(.displayName, .regexFullMatch("[a-zA-Z]{4}"))
            Expression(.displayName, "=", "dummy_user")
        }
        Expression(.isActive, true)
    }
}

print(query) 
```

Resulting in the following query:
```
(display_name.regex.full_match('[a-zA-Z]{4}') OR display_name='dummy_user') AND is_active=true
```