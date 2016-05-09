//
//  ApiModel.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class ApiModel: NSObject {
    
    let url:String
    
    init(url: String){
        self.url = url
    }
    
    func request(api api: String, method: String, data: String, token: String = "",
                     callback userFunction: (jsonData: NSDictionary?, statusCodeReturned: Int) -> Void){
        
        let headers = [
            "authorization": token, // TODO: move this into an if statement.
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        let postData = NSMutableData(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(self.url)\(api)")!,
                                          cachePolicy: .UseProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.HTTPMethod = method
        request.allHTTPHeaderFields = headers
        request.HTTPBody = postData
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let status = (response as! NSHTTPURLResponse).statusCode
                print(status)
                
                if let data = data, jsonString = NSString(data: data, encoding: NSUTF8StringEncoding){
                    print(jsonString)
                }
            }
        })
        
        dataTask.resume()
    }
}
