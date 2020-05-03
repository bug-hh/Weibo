//
//  NewFeatureViewController.swift
//  Weibo
//
//  Created by bughh on 2020/5/3.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import SnapKit

private let WBNewFeatureCellID = "WBNewFeatureCellID"
private let WBNewFeatureImageCount = 4

class NewFeatureViewController: UICollectionViewController {

    // 懒加载属性，必须要在控制器实例化之后才会被创建
//    private lazy var layout = UICollectionViewLayout()
    
    init() {
        // 这个地方不能定义 layout 为懒加载属性，这里的 layout 需要在「控制器实例化之前」就创建好
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
//        构造函数完成之后，内部属性才会被创建
        super.init(collectionViewLayout: layout)
        
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(NewFeatureCell.self, forCellWithReuseIdentifier: WBNewFeatureCellID)

        // Do any additional setup after loading the view.
    }

   
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return WBNewFeatureImageCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WBNewFeatureCellID, for: indexPath) as! NewFeatureCell
        // Configure the cell
        cell.imageIndex = indexPath.item
        
        return cell
    }
    
    // scroll view 停止滚动的代理方法
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if page != WBNewFeatureImageCount - 1 {
            return
        }
        // 如果滚动到最后一页，那么显示按钮动画
        let cell = collectionView.cellForItem(at: IndexPath(item: page, section: 0)) as! NewFeatureCell
        cell.showButtonAnimate()
    }

}


private class NewFeatureCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = UIImageView()
    private lazy var startButton: UIButton = UIButton(imageName: "guideStart", title: "", color: .white)
    
    var imageIndex: Int = 0 {
        didSet {
            imageView.image = UIImage(named: "guide\(imageIndex + 1)Background")
            startButton.isHidden = true
        }
    }
    // frame 的大小是 layout.itemSize 指定的
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func showButtonAnimate() {
        startButton.isHidden = false
        startButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        startButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 2.0,            // 动画时长
                       delay: 0,                     // 延迟时间
                       usingSpringWithDamping: 0.6,  // 弹力系数，0-1，越小越弹
                       initialSpringVelocity: 10,    // 模拟重力加速度
                       options: [],                  // 动画选项
                       animations: {
                        self.startButton.transform = CGAffineTransform.identity
        }) { (_) in
            self.startButton.isUserInteractionEnabled = true
        }
    }
    
    @objc func startButtonClicked() {
        print("立即体验")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification),
        object: nil) // 这个 object 和 AppDelegate 设置监听里的 object 不一样
    }
    
    private func setupUI() {
        addSubview(imageView)
        addSubview(startButton)
        imageView.frame = bounds
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).multipliedBy(0.7)
        }
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
