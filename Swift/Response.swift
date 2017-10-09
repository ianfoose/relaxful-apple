//  Response.swift
//  Relaxful
//
//  Created by Ian Foose on 7/15/17.
//  Copyright © 2017 Foose Industries. All rights reserved.

import Foundation

public struct Response {
    // MARK: - Variables
    public var response:URLResponse?
    public var status = 200
    public var text:String?
    public var data:Data?
    public var headers:[AnyHashable : Any]?
    
    // MARK: - Functions
    
    /**
 
    */
    public func validate() -> Bool {
        if status >= 200 && status <= 304 || status == 409 {
            return true
        }
        return false
    }
    
    // function to check if response has any data
    private func checkResponse() -> Bool {
        if response != nil && data != nil {
            return true
        }
        return false
    }
    
    // function to parse json array
    internal func jsonArray() -> [[String:Any]]? {
        if checkResponse() {
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String:Any]]
                //jsonArray = json
                return json
            } catch {
                return nil
            }
        }
        return nil
    }
    
    internal func jsonObject() -> [String:Any]? {
        if checkResponse() {
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                //jsonObject = json
                return json
            } catch {
                return nil
            }
        }
        return nil
    }
}

public extension Response {
    // custom init
    public init(_ response:URLResponse?,data:Data?) {
        self.data = data
        self.response = response
        
        if response != nil {
            self.response = response
            
            if let httpResponse = response as? HTTPURLResponse {
                self.headers = httpResponse.allHeaderFields
                self.status = httpResponse.statusCode
            }
        }
        
        if data != nil {
            if let responseText = String(data: data!, encoding: .utf8) {
                self.text = responseText
            }
        }
    }
}
