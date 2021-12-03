//
//  SPConstants.swift
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

class SPConstants: NSObject {

    static let defaultColumnCount: CGFloat = 1.0
}

enum Response
{
    case json
    case xml
    case soap
    
    var format:String {
        switch self {
        case .json:
            return "json"
        case .xml:
            return "xml"
        case .soap:
            return "soap"
        }
    }
}


enum DateType:String
{
    case `default` //=  "dd.MM.yyy HH:mm"
    case currentYear
    case otherYear
    case hr12
    case hr24
    
    func format(year:DateType = .default, timeFormat:DateType = .default) -> String {
        switch year {
        case .currentYear:
            if timeFormat == .hr12{
                return "dd MMMM, hh:mm a"
            }else{
                return "dd MMMM, hh:mm"
            }
        case .otherYear:
            if timeFormat == .hr12{
                return "dd MMMM yyyy, hh:mm a"
            }else{
                return "dd MMMM yyyy, hh:mm"
            }
        case .default:
            return "dd.MM.yyy HH:mm"
        case .hr12:
            return "dd MMMM, hh:mm a"
        case .hr24 :
            return "dd MMMM, HH:mm"
        }
    }
}

