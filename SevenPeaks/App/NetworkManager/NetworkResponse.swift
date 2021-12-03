//
//  NetworkResponse.swift
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

enum NetworkResponse:Error {
    case success
    case authenticationError
    case badRequest
    case notFound
    case outdated
    case requestFailed
    case noData
    case unableToDecode
    case networkFailed
    case commonError
    case noNotifications
    
    var detail:String {
        
        switch self {
        case .success:
            return "Success"
        case .authenticationError:
            return "You need to be authenticated first."
        case .badRequest:
            return  "Bad request"
        case .outdated:
            return "The url you requested is outdated."
        case .requestFailed:
            return "Network request failed."
        case .notFound:
            return "Not found"
        case .noData:
            return "Response returned with no data to decode."
        case .unableToDecode:
            return "We could not decode the response."
        case .networkFailed:
            return "Unable to connect to the internet"
        case .noNotifications:
            return "No Notifications"
        case .commonError:
            return self.localizedDescription
        }
        
    }
    
}

extension HTTPURLResponse
{
    func verifyResponse() -> ResponseCheck<String>
    {
        switch self.statusCode
        {
        case 200...299:
            return .success
        case 400:
            return .failure(NetworkResponse.badRequest.detail)
        case 404:
            return .failure(NetworkResponse.notFound.detail)
        case 401...500:
            return .failure(NetworkResponse.authenticationError.detail)
        case 501...599:
            return .failure(NetworkResponse.badRequest.detail)
        case 600:
            return .failure(NetworkResponse.outdated.detail)
        default:
            return .failure(NetworkResponse.commonError.detail)
        }
    }
}

enum ResponseCheck<String>
{
    case success
    case failure(String)
}

