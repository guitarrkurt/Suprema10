//
//  Internet.swift
//  Suprema Salsa
//
//  Created by miguel mexicano on 18/01/16.
//  Copyright © 2016 miguel mexicano. All rights reserved.
//

import UIKit

class Internet: NSObject {
    
    func InternetHer ()->Bool{
        var Status:Bool = false
        let url = NSURL(string: "http://www.google.com")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        do {
            try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            
            if let httpResponse = response as? NSHTTPURLResponse{
                if httpResponse.statusCode == 200{
                    Status=true
                }
            }
            
        } catch (let e) {
            print(e)
        }
        
        return Status
    }
    
    
    

}
