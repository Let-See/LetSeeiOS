//
//  String+Extensions.swift
//  
//
//  Created by Farshad Macbook M1 Pro on 4/18/22.
//

import Foundation
extension String {
    static var empty: String {
        return ""
    }
}

extension Dictionary where Key == AnyHashable, Value == Any {
    var asKeyValue: [KeyValue<String, String>] {
        self.map({ (arg0) in
            return KeyValue(key: arg0.key as! String, value: (arg0.value as! String).replacingOccurrences(of: "\"",with: "'"))
        })
    }
}

extension Dictionary where Key == String, Value == String {
    var asKeyValue: [KeyValue<String, String>] {
        self.map({ (arg0) in
            return KeyValue(key: arg0.key, value: arg0.value)
        })
    }
}

