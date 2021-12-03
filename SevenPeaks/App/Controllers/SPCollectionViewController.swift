//
//  SPCollectionViewController.swift
//  SevenPeaks
//
//  Created by Raja on 28/11/21.
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
import RxSwift
import RxCocoa


class SPCollectionViewController: SPBaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var searchBarController: UISearchController!
    private var numberOfColumns: CGFloat = SPConstants.defaultColumnCount
    private var viewModel = SPViewModel()
    private var isFirstTimeActive = false
   // private var footerView:CustomFooterView?
    private var isLoading:Bool = false
    
    public var carsList = PublishSubject<[WelcomeContent]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        //viewModelClosures()
        setupBindings()
        viewModel.fetchResults()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Bindings
    
    private func setupBindings() {
        
        // binding loading to vc
        
        // observing errors to show
        
        viewModel
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    self.showAlert(message: message)
                case .serverMessage(let message):
                    self.showAlert(message: message)
                }
            })
            .disposed(by: disposeBag)
        
        
        // binding albums to album container
        
        viewModel
            .cars
            .observe(on: MainScheduler.instance)
            .bind(to: self.carsList)
            .disposed(by: disposeBag)
        
        
        viewModel.cars.bind(to: collectionView.rx.items(cellIdentifier: "ImageCollectionViewCell", cellType: ImageCollectionViewCell.self)) {  (row,carList,cell) in

            let car = carList
            cell.carImage = ImageModel.init(withPhotos: car)
            cell.lbl_car_title.text = car.title
            cell.lbl_date_and_time.text = car.dateTime?.locale()
            cell.lbl_description.text = car.ingress
           
            }.disposed(by: disposeBag)
       
    }
    
 
    
    private func showAlert(title: String = "Error", message: String?) {
             self.showAlertPop(withTitle: title, message: message)
    }
}

//MARK:- Configure UI
extension SPCollectionViewController {
    
    fileprivate func configureUI() {
        // Do any additional setup after loading the view, typically from a nib.
        self.delegate = self
        collectionView
            .rx.delegate
            .setForwardToDelegate(self, retainDelegate: false)
        
        //collectionView.delegate = self
        //collectionView.register(nibName: ImageCollectionViewCell.self)
        
       // viewModel.loading
         //   .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: ImageCollectionViewCell.self))
    
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension SPCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width)/numberOfColumns, height: (collectionView.bounds.width)/numberOfColumns)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK:- Network Delegate
extension SPCollectionViewController: networkDelegate{
    
    func isConnected() {
        self.viewModel.fetchResults()
    }
    
    func isDisconnected() {
        self.showAlert(message: "no internet connection")
    }
}
