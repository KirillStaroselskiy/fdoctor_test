//
//  ViewController.swift
//  Test_Family_Doc
//
//  Created by  user on 09.03.2020.
//  Copyright © 2020  user. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    fileprivate var collectionViewCellIdentifier = "CollectionViewCell"

    private lazy var collectionView: UICollectionView =  {
        let flowLayout = ZoomAndSnapFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collection = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false

        return collection
    }()
    
    private lazy var nameLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .lightGray
        label.numberOfLines = 0

        return label
     }()
    
    private lazy var nextPageButton: UIButton =  {
        let button = UIButton()
        button.setTitle("Далее", for: .normal)
        button.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
     }()
    
    private lazy var refreshButton: UIButton =  {
       let button = UIButton()
        button.setImage(UIImage(named: "refresh"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        return button
    }()
    private var pageControl = UIPageControl(frame: .zero)

    
    private var viewModel = PillsViewModel()
    private var currentIndex = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel.pills.isEmpty {
            self.loadData(callBack: nil)
        } else {
            self.fillLabels(viewModel.pills[0])
        }
        
        self.view.backgroundColor = .white
        self.view.addSubview(refreshButton)
        self.view.addSubview(collectionView)
        self.view.addSubview(pageControl)
        self.view.addSubview(nameLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(nextPageButton)
        self.view.addSubview(refreshButton)
        
        refreshButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().inset(20)
            make.height.width.equalTo(40)

        }
                
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.refreshButton.snp.bottom).offset(20)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.5)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(self.collectionView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.pageControl.snp.bottom).offset(15)
            make.leading.equalTo(self.collectionView).offset(20)
            make.trailing.equalTo(self.collectionView).inset(20)

        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(self.nameLabel)

        }
        
        nextPageButton.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel).offset(60)
            make.trailing.equalTo(self.descriptionLabel)
            make.height.equalTo(25)
            make.width.equalTo(85)

        }
        
        refreshButton.addTarget(self, action: #selector(refreshButtonClicked), for: .touchUpInside)
        nextPageButton.addTarget(self, action: #selector(nextPageButtonClicked), for: .touchUpInside)
        setupPageControl()
        self.registerCollectionViewNibs()
    }
    
    private func registerCollectionViewNibs() {
        self.collectionView.register(UINib(nibName: collectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: collectionViewCellIdentifier)
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = viewModel.pills.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = UIColor.blue.withAlphaComponent(0.8)
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.8)
    }
    
    @objc func refreshButtonClicked() {
        refreshButton.rotate360Degrees()

        self.loadData(){
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: { [weak self] in
                self?.refreshButton.layer.removeAllAnimations()
            })
        }
    }

    @objc func nextPageButtonClicked() {

        guard var centerCellIndexPath: IndexPath  = collectionView.centerCellIndexPath else {
            return
        }
        if centerCellIndexPath.row < viewModel.pills.count - 1 {
            self.fadeOut()

            centerCellIndexPath.row += 1
            collectionView.scrollToItem(at: centerCellIndexPath, at: .centeredHorizontally, animated: true)
            
            self.pageControl.currentPage = centerCellIndexPath.row
            self.fillLabels(viewModel.pills[centerCellIndexPath.row])
        }
    }
    
   private func loadData(callBack: (() -> ())?) {
        viewModel.fetch(){
            self.collectionView.reloadData()
            self.fillLabels(self.viewModel.pills[0])
            self.setupPageControl()
            callBack?()
        }
    }
    
    private func fillLabels(_ pill: PillsModel){
        nameLabel.text = pill.name
        descriptionLabel.text = "\(pill.desription ?? ""). \(pill.dose ?? "")"
        self.fadeIn()
    }
    
    private func fadeOut(duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, animations: {
        self.nameLabel.alpha = 0.0
        self.descriptionLabel.alpha = 0.0
      })
    }
    
    private func fadeIn(duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, animations: {
        self.nameLabel.alpha = 1.0
        self.descriptionLabel.alpha = 1.0
      })
    }
    
    var x: CGFloat = 0.0
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! CollectionViewCell
        let pill = viewModel.pills[indexPath.row]
        if let img =  pill.img {
            cell.setImage(stringURL: img)
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let centerCellIndexPath: IndexPath  = collectionView.centerCellIndexPath else {
            return
        }
        self.fadeOut()
        self.pageControl.currentPage = centerCellIndexPath.row
        self.fillLabels(viewModel.pills[centerCellIndexPath.row])

    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height * 0.6)
     }
}


extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

