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
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: {
            (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if data == nil {
                logger.error("No data returned, error: \(error?.localizedDescription)")
                return
            }
            
            var error: NSError?
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
            
            if jsonResult != nil {
                logger.verbose("Asynchronous request completed, result: \(jsonResult)")
                NSNotificationCenter.defaultCenter().postNotificationName(notif, object: nil, userInfo: jsonResult)
            }
            else {
                logger.error("Error sending async request: \(error?.localizedDescription)")
            }
            
        })
    }
}