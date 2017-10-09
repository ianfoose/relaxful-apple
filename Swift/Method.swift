//  Method.swift
//  Relaxful
//
//  Created by Ian Foose on 7/15/17.
//  Copyright © 2017 Foose Industries. All rights reserved.

import Foundation

public enum Method {
    case get
    case post
    case put
    case patch
    case delete
    case head
    
    public var string:String {
        return String(describing: self)
    }
}
