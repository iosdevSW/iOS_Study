//
//  User.swift
//  DIContainer_Example
//
//  Created by iOS신상우 on 10/23/24.
//

import Foundation

public struct User: Userable {
    public var name: String
    public var age: Int
    
    public init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
