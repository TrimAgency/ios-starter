//
//  ObjectMapperTransformations.swift
//  StarterTemplate
//
//  Created by Dominique Miller on 8/23/19.
//  Copyright © 2019 Trim Agency. All rights reserved.
//

import Foundation
import ObjectMapper

open class StringToURLTransform: TransformType {
    public typealias Object = URL
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> URL? {
        return URL(string: value as! String)
    }
    
    open func transformToJSON(_ value: URL?) -> String? {
        return value?.absoluteString
    }
}

open class APIDateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        if (value != nil) {
            return dateFormatter.date(from: value as! String)
        } else {
            return nil
        }
    }
    
    open func transformToJSON(_ value: Date?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if (value != nil) {
            return dateFormatter.string(from: value!)
        } else {
            return nil
        }
    }
}

open class APIDateTimeTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if (value != nil) {
            return dateFormatter.date(from: value as! String)
        } else {
            return nil
        }
    }
    
    open func transformToJSON(_ value: Date?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if (value != nil) {
            return dateFormatter.string(from: value!)
        } else {
            return nil
        }
    }
}

