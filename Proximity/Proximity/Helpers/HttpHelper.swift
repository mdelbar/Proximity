//
//  HttpHelper.swift
//  Proximity
//
//  Created by Matthias Delbar on 24/09/14.
//  Copyright (c) 2014 Matthias Delbar. All rights reserved.
//

import Foundation

class HttpHelper {
    
    private class func composeUrl(serverPath path: String) -> NSURL {
        // Server URL is local laptop IP and python server post
        let serverUrl = NSURL(string:"http://192.168.2.212:5000")
        
        return NSURL(string: path, relativeToURL: serverUrl)
    }
    
    class func get(serverPath path: String, notification notif: String) {
        var request = NSMutableURLRequest()
        request.URL = self.composeUrl(serverPath: path)
        request.HTTPMethod = "GET"
        
        executeRequest(request: request, notification: notif)
    }
    
    class func post(serverPath path: String, data: NSDictionary, notification notif: String) {
        var request = NSMutableURLRequest()
        request.URL = self.composeUrl(serverPath: path)
        var e: NSError?
        let jsonData = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(0), error: &e)
        logger.verbose("DICT data: [\(data)]")
        request.HTTPBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        
        executeRequest(request: request, notification: notif)
    }
    
    class func put(serverPath path: String, data: NSDictionary, notification notif: String) {
        var request = NSMutableURLRequest()
        request.URL = self.composeUrl(serverPath: path)
        var e: NSError?
        let jsonData = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(0), error: &e)
        logger.verbose("DICT data: [\(data)]")
        request.HTTPBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "PUT"
        
        executeRequest(request: request, notification: notif)
    }
    
    
    
    private class func executeRequest(#request: NSMutableURLRequest, notification notif: String) {
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: {
            (response:NSURLResponse!, data: NSData!, responseError: NSError!) -> Void in
            
            if data == nil {
                logger.error("No data returned, error: \(responseError?.localizedDescription)")
                return
            }
            
            var error: NSError?
            let jsonResult: NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary
            
            if jsonResult != nil {
                logger.verbose("Asynchronous request completed, result: \(jsonResult!)")
                NSNotificationCenter.defaultCenter().postNotificationName(notif, object: nil, userInfo: jsonResult!)
            }
            else {
                logger.error("Error sending async request: \(error?.localizedDescription)")
            }
            
        })
    }
}