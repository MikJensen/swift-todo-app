//
//  ApiModel.swift
//  swift-todo-app
//
//  Created by Jógvan Olsen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class ApiModel: NSObject {
    
    let url:String = "http://194.239.172.19"
    
    func request(api api: String, method: String, data: String, token: String = "",
                     completionHandler ch: (jsonData: NSDictionary?, statusCodeReturned: Int) -> Void){
        
        var headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        if(token != ""){
            headers["authorization"] = token
        }
        
        let postData = NSMutableData(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(self.url)\(api)")!,
                                          cachePolicy: .UseProtocolCachePolicy,
                                          timeoutInterval: 15.0)
        request.HTTPMethod = method
        request.allHTTPHeaderFields = headers
        request.HTTPBody = postData
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request){
            data, response, error in

            if (error != nil) {
                print("Couldn't connect to server: \(error)")
                ch(jsonData: nil, statusCodeReturned: -1)
            } else {
                let status = (response as! NSHTTPURLResponse).statusCode
                
                do{
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary {
                        ch(jsonData: json, statusCodeReturned: status)
                    }
                } catch let error as NSError {
                    // Should never happen!
                    print("error in catch: \(error.localizedDescription)")
                    ch(jsonData: nil, statusCodeReturned: -1)
                }
            }
        }
        
        dataTask.resume()
    }
}
