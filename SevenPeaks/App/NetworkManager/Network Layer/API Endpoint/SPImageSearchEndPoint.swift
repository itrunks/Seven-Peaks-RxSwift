//
//  SPImageSearchEndPoint.swift
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

enum SPImageSearchEndPoint {
    case photoList(_ searchText: String, pageNo: Int)
    case carList
}

extension SPImageSearchEndPoint: RequestSchema
{
    
    var baseURL: String {
        let url =  EnvironmentManager.environmentBaseURL
        return url
    }
    
    var path: String {
        
        switch self{
        case .photoList(_, _):
                return "application/119267/article/get_articles_list"
        case .carList:
                return "application/119267/article/get_articles_list"
        }
  
    
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    var queryParam: String {
        switch self {
        case .photoList(let searchText, let pageNo):
              return "queryPath"
            
        case .carList:
            
            return ""
        }
    }
    
    var task: RequestTaskType {
        switch self {
        case .photoList(_, _):
            return .request
        case .carList:
            return .request
    }
    
}

}
