//
//  Router.swift
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
import UIKit

 typealias NetworkRouterCompletion = (Result<(Data?,URLResponse?)>) -> ()


protocol NetworkRouter: class
{
    associatedtype EndPoint: RequestSchema
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    
    func cancel()
}

class Router<EndPoint: RequestSchema>: NetworkRouter {

    private var task: URLSessionTask?
    {
        didSet
        {
            guard let task = task else { return }
            
            DispatchQueue.main.async {
                if task.state == .running
                {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
                else
                {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    {
       
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60
        sessionConfig.timeoutIntervalForResource = 60
        sessionConfig.waitsForConnectivity = true
        
        let session = URLSession(configuration: sessionConfig)
        
        do {
            let request = try self.buildRequest(from: route)
            
            // Log the response on the console
            //   AFNetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                NetworkLogger.log(response: response)
                
                if let err =  error{
                    completion(.Failure(err as! NetworkResponse))
                }
                
                let succ = (data, response)
                completion(.Success(succ))
            })
            
            self.task?.resume()
        }
        catch
        {
            completion(.Failure(error as! NetworkResponse))
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: URL(string:(route.baseURL + route.path + route.queryParam))!,
                                 cachePolicy: .returnCacheDataElseLoad,
                                 timeoutInterval: 30.0)
        print("===== \(request)")
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}
