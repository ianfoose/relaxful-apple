//  Relaxer
//  Relaxer
//
//  Created by Ian Foose on 9/1/16.
//  Copyright © 2016 Foose Industries. All rights reserved.

import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public class Relaxer: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    // MARK: - Variables
    internal var uploadDelegate:UploadDelegate?
    internal var uploadResponse:URLResponse?
    internal var uploadData:Data? = Data()
    
    public var task:URLSessionTask?
    
    // callback for NSURLSession SSL Handling
    typealias CallbackBlock = (_ result:String, _ error:String?) -> ()
    var callback: CallbackBlock = {
        (resultString, error) -> Void in
        
        if error == nil {
            print("NSURL HTTPS RESULT: \(resultString)")
        } else {
            print("NSURL HTTPS ERROR: \(error!)")
        }
    }
    
    /**
     Uploads data
     
     - parameters:
     - method APIMethod
     - url String
     - params Dictionary
     - headers Dictionary
     - fileKey String
     - fileName String
     - mime String
     - data Data
     - uploadDelegate UploadDelegate
     */
    public func upload(_ method:Method!, url:String!, params:[String:String]?, headers:[String:String]?, fileKey:String!, fileName:String!, mime:String!, data:Data!, uploadDelegate:UploadDelegate?) {
        self.uploadDelegate = uploadDelegate
        
        let boundaryConstant = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.string
        request.setValue("multipart/form-data;boundary=\(boundaryConstant)", forHTTPHeaderField: "Content-Type")
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        
        var body = Data()
        
        body.append("--\(boundaryConstant)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fileKey!)\"; filename=\"\(fileName!)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mime!)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundaryConstant)--\r\n".data(using: .utf8)!)
        
        if params != nil {
            for (key, value) in params! {
                body.append("--\(boundaryConstant)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".data(using: .utf8)!)
            }
        }
        
        if headers != nil {
            for header in headers! {
                request.addValue(header.0, forHTTPHeaderField: header.1)
            }
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        task = session.uploadTask(with: request, from: body)
        task!.resume()
    }
    
    /**
     API Request
     
     - parameters:
     - method APIMethod
     - url String
     - body Dictionary
     - headers Dictionary
     - completion success completion
     - errorBlock error completion
     */
    public func request(_ method:Method!, url:String!, body:[String:String]?, headers:[String:String]?, completion: @escaping (Response) -> Void, errorBlock: @escaping (Error?) -> Void) {
        session(method, url: url, body: body, headers: headers) { data,error,response in
            if error != nil {
                errorBlock(error)
            } else {
                completion(Response(response, data: data))
            }
        }
    }
    
    /**
     API Request conveinence
     
     - parameters:
     - url String
     - completion success completion
     - errorBlock error completion
     
     */
    public func request(_ url:String!, completion: @escaping (Response) -> Void, errorBlock: @escaping(Error?) -> Void) {
        session(.get, url: url, body: nil, headers: nil) { (data, error, response) in
            if error != nil {
                errorBlock(error)
            } else {
                completion(Response(response, data: data))
            }
        }
    }
    
    /**
     Creates and executes a URLSession and DataTask
     
     - paramters:
     - method APIMethod
     - url String
     - body Dictionary
     - headers Dictionary
     - completion success completion
     */
    private func session(_ method:Method!, url:String!, body:[String:String]?, headers:[String:String]?, completion: @escaping (_ data:Data?,_ error:Error?,_ response:URLResponse?) -> ()) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.string
        
        if body != nil {
            var bodyString:String!
            
            var i = 0
            
            for val in body! {
                i += 1
                var suffix = ""
                
                if i != body!.count - 1 {
                    suffix = "&"
                }
                
                let q = (val.key + "=" + val.value+suffix).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                bodyString.append(q!)
            }
            
            request.httpBody = bodyString.data(using: .utf8)
        }
        
        if headers != nil {
            for header in headers! {
                request.addValue(header.0, forHTTPHeaderField: header.1)
            }
        }
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        
        task = session.dataTask(with: request) { data,response,error in
            completion(data, error, response)
        }
        task!.resume()
    }
    
    #if os(macOS)
    
    /**
     Gets an image from a URL
     
     - parameters:
     - url String
     - completion success completion
     - errorBlock error completion
     */
    public func getImageFromURL(_ url:String!, completion: @escaping (NSImage?) -> Void, errorBlock: @escaping (Error?) -> Void) {
        request(url, completion: { (response) in
            if response.validate() {
                if response.data != nil {
                    completion(NSImage(data: response.data!))
                }
            }
            completion(nil)
        }) { (error) in
            errorBlock(error)
        }
    }
    
    #elseif !os(macOS)
    
    /**
     Gets an image from a URL
     
     - parameters:
     - url String
     - completion success completion
     - errorBlock error completion
     */
    public func getImageFromURL(_ url:String!, completion: @escaping (UIImage?) -> Void, errorBlock: @escaping (Error?) -> Void) {
        request(url, completion: { (response) in
            if response.validate() {
                if response.data != nil {
                    completion(UIImage(data: response.data!))
                }
            }
            completion(nil)
        }) { (error) in
            errorBlock(error)
        }
    }
    
    #endif
    
    // MARK: - NSURLSession Delegate
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request:   URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        
        let newRequest:URLRequest? = request
        completionHandler(newRequest)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        uploadResponse = response
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        uploadData?.append(data)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        uploadDelegate?.uploadFinished(Response(uploadResponse ,data:uploadData), error:error)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64,    totalBytesExpectedToSend: Int64) {
        uploadDelegate?.uploadProgress(bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
    }
}

// MARK: - Extension for NSMutableData

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        self.append(data!)
    }
}
