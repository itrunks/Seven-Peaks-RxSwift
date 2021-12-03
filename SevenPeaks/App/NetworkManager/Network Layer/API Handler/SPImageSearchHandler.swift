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

class SPImageSearchHandler {
    
    static func getCarList( completion: @escaping (Result<([WelcomeContent]?)>) -> ())
    {
        Router<SPImageSearchEndPoint>().request(SPImageSearchEndPoint.carList) { result in
            
            switch result
            {
            case .Success((let data, let response)):
                
                if let response = response as? HTTPURLResponse
                {
                    let results = response.verifyResponse()
                    
                    switch results
                    {
                    case .success:
                        
                        guard let responseData = data
                            else
                        {
                            completion(.Failure(.noData))
                            return
                        }
                        
                        do
                        {
                            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            
                            print(jsonData)
                            
                            let apiResponse = try JSONDecoder().decode(Welcome.self, from: responseData)
                            
                            completion(.Success(apiResponse.content))
                        }
                        catch
                        {
                            print(error)
                            completion(.Failure(NetworkResponse.unableToDecode))
                        }
                        
                    case .failure(_):
                        
                        completion(.Failure(NetworkResponse.requestFailed))
                    }
                }
                break
        case .Failure( _):
                completion(.Failure(.commonError))
                break
        case .Error(_):
                completion(.Failure(.commonError))
                break
            }
        }
        
    }
   
    
}
