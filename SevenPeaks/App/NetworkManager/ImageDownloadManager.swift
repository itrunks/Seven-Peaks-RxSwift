//
//  ImageDownloadManager.swift
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

typealias ImageClosure = (_ result: Result<UIImage>, _ url: String) -> Void


class ImageDownloadManager: NSObject {
    
    static let shared = ImageDownloadManager()
    private var operationQueue = OperationQueue()
    private var dictionaryBlocks = [UIImageView: (url:String, image:ImageClosure, imageDownload:ImageDownloadOperation)]()
    
    private override init() {
        operationQueue.maxConcurrentOperationCount = 100
    }
    
    func addOperation(url: String, imageView: UIImageView, completion: @escaping ImageClosure) {
        
        if let image = DataCache.shared.getImageFromCache(key: url)  {
            
            completion(.Success(image), url)
            if  let result = self.dictionaryBlocks.removeValue(forKey: imageView){
                result.imageDownload.cancel()
            }
            
        } else {
            
            if !checkOperationExists(with: url,completion: completion) {
                
                if let result = self.dictionaryBlocks.removeValue(forKey: imageView){
                    result.imageDownload.cancel()
                }
                
                let newOperation = ImageDownloadOperation(url: url) { (image,downloadedImageURL) in
                    
                    if let result = self.dictionaryBlocks[imageView] {
                        
                        if result.url == downloadedImageURL {
                            
                            if let image = image {
                                
                                DataCache.shared.saveImageToCache(key: downloadedImageURL, image: image)
                                result.image(.Success(image), downloadedImageURL)
                                
                                if let result = self.dictionaryBlocks.removeValue(forKey: imageView){
                                    result.imageDownload.cancel()
                                }
                                
                            } else {
                                result.image(.Failure(NetworkResponse.notFound), downloadedImageURL)
                            }
                            
                            _ = self.dictionaryBlocks.removeValue(forKey: imageView)
                        }
                    }
                }
                
                dictionaryBlocks[imageView] = (url, completion, newOperation)
                operationQueue.addOperation(newOperation)
            }
        }
    }
    
    func checkOperationExists(with url: String, completion: @escaping ImageClosure) -> Bool {
        
        if let arrayOperation = operationQueue.operations as? [ImageDownloadOperation] {
            let opeartions = arrayOperation.filter{$0.url == url}
            return opeartions.count > 0 ? true : false
        }
        
        return false
    }
}
