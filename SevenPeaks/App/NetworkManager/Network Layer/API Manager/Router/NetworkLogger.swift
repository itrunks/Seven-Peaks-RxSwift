//
//  NetworkLogger.swift
//  SevenPeaks
//
//  Created by Raja on 27/11/21.
/*
 Except where otherwise noted in the source code (e.g. the files hash.c,
 list.c and the trio files, which are covered by a similar licence but
 with different Copyright notices) all the files are:
 
 Copyright (C) 2021 Raja Pitchai.  All Rights Reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is fur-
 nished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FIT-
 NESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
 RAJA PITCHAI BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CON-
 NECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 Except as contained in this notice, the name of Raja Pitchai shall not
 be used in advertising or otherwise to promote the sale, use or other deal-
 ings in this Software without prior written authorization from him.
 */

import Foundation

class NetworkLogger
{
    var methodStartTime = Date()
    static func log(request: URLRequest)
    {
        NetworkLogger().methodStartTime = Date()
        
        print("- - - - - - - START TIME : \(NetworkLogger().methodStartTime) - - - - - - -")
        
        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        
        var headers:String = ""
        
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
            headers += #"""
            --header "\#(key): \#(value)" \
            """#
        }
        
        var bodyString:String = ""
        
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
            bodyString += #" "\#(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")" "#
        }
        
        print(logOutput)
        
        let curl = #"""
            curl --location --request \#(method) "\#(urlAsString)" \ \#(headers)
            --data \#(bodyString)
            """#
        print(curl)
    }
    
    static func log(response: URLResponse?)
    {
        guard response != nil else { return }
        let methodFinish = Date().timeIntervalSince(NetworkLogger().methodStartTime)
        print("- - - - - - - START TIME : \(NetworkLogger().methodStartTime) - - - - - - -")
        
        print("- - - - - - - END TIME : \(methodFinish) - - - - - - -")
    }
}
