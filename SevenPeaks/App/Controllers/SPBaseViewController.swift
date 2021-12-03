//
//  BaseViewController.swift
//  SevenPeaks
//
//  Created by Raja Pitchai on 03/12/21.
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
import Reachability
import RxReachability
import RxSwift
import RxCocoa


class SPBaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let reachability: Reachability! = try? Reachability()
    
    var delegate: networkDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "navBarColor")
        
        networkConnection()
        
    }
    
    //Network Setup
    
    private func networkConnection(){
        //declare this property where it won't go out of scope relative to your listener
        bindReachability()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? reachability?.startNotifier()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability?.stopNotifier()
    }
    
}

extension SPBaseViewController {
    
    func bindReachability() {
        
        reachability?.rx.reachabilityChanged
            .subscribe(onNext: { reachability in
                print("Reachability changed: \(reachability.connection)")
            })
            .disposed(by: disposeBag)
        
        reachability?.rx.status
            .subscribe(onNext: { status in
                print("Reachability status changed: \(status)")
            })
            .disposed(by: disposeBag)
        
        reachability?.rx.isReachable
            .subscribe(onNext: { isReachable in
                print("Is reachable: \(isReachable)")
            })
            .disposed(by: disposeBag)
        
        reachability?.rx.isConnected
            .subscribe(onNext: { [self] in
                print("Is connected")
                delegate?.isConnected()
                
            })
            .disposed(by: disposeBag)
        
        reachability?.rx.isDisconnected
            .subscribe(onNext: { [self] in
                print("Is disconnected")
                delegate?.isDisconnected()
                
            })
            .disposed(by: disposeBag)
    }
}
