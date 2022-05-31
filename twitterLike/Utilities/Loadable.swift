//
//  Loadable.swift
//  twitterLike
//
//  Created by Антон Голубейков on 31.05.2022.
//


// Here we describe different states of App's object (e.g. Posts that are being loaded from network).
import Foundation

enum Loadable<Value> {
    case loading
    case error(Error)
    case loaded(Value)
    
    //That lets us access and modify enum's value. We pack loaded(Value) into separate computed property.
    var value: Value? {
        get {
            if case let .loaded(value) = self {
                return value
            }
            return nil
        }
        set {
            guard let newValue = newValue else { return }
            self = .loaded(newValue)
        }
    }
}

// RangeReplaceableCollection means that we can create Arrays, Sets with () (e.g. Value())
extension Loadable where Value: RangeReplaceableCollection {
    //If loaded array is empty, we can set 'empty' status automatically. 
    static var empty: Loadable<Value> { get { .loaded(Value()) } }
}
// The compiler is having trouble matching the empty case because the Loadable enumeration does not conform to Equatable. Here we fix it.
extension Loadable: Equatable where Value: Equatable {
    static func == (lhs: Loadable<Value>, rhs: Loadable<Value>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.error(error1), .error(error2)):
            return error1.localizedDescription == error2.localizedDescription
        case let (.loaded(value1), .loaded(value2)):
            return value1 == value2
        default:
            return false
        }
    }
}
