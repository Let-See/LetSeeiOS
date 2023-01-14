//
//  CategorisedMocks.swift
//  
//
//  Created by Farshad Jahanmanesh on 07/01/2023.
//

import Foundation
public struct CategorisedMocks: Hashable {
    /// Category of the mocks, can be general or a specific scenario
    public var category: LetSeeMock.Category

    /// List of mocks belonging to the category
    public var mocks: [LetSeeMock]
}

typealias RequestToMockMapper = ((_: URL, _ mocks: Dictionary<String, Set<LetSeeMock>>) -> CategorisedMocks?)
