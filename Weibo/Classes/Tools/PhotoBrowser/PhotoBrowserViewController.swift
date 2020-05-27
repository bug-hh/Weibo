//
//  PhotoBrowserViewController.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/5/25.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import SVProgressHUD

let PhotoBrowserViewCellID = "PhotoBrowserViewCellID"

// 照片浏览器
class PhotoBrowserViewController: UIViewController {

    private var urls: [URL]
    private var currentIndexPath: IndexPath
    
    private class PhotoBrowserViewLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            itemSize = collectionView!.bounds.size
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .horizontal
            
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            
//            collectionView?.showsHorizontalScrollIndicator = false
            
        }
    }
    
    @objc private func closeButtonClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonClick() {
        print("保存照片")
        // 获取图片
        let cell = collectionView.visibleCells[0] as! PhotoBrowserCell
        let image = cell.imageView.image
        
        // 保存图片
        guard let img = image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(imageCompletionHandler(img:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
//    - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    @objc func imageCompletionHandler(img: UIImage, didFinishSavingWithError error: NSError?, contextInfo: Any) {
        let message = error != nil ? "保存失败" : "保存成功"
        SVProgressHUD.showInfo(withStatus: message)
        
        
    }
    
    // 懒加载控件
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserViewLayout())
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("关闭", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("保存", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        return button
    }()
    
    init(urls: [URL], indexPath: IndexPath) {
        self.urls = urls
        self.currentIndexPath = indexPath
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // loadView 与 xib，sb 等价，主要职责是创建视图层次结构，loadView 函数执行完毕，view 上的元素要创建完成
    // 如果 view == nil，系统会在调用 view 的 get 方法时，自动调用 loadView，创建 view
    override func loadView() {
//        super.loadView()
        var rect = UIScreen.main.bounds
        // 给图片与图片之间留出边距
        rect.size.width += 20
        view = UIView(frame: rect)
        setupUI()
    }
    
    /*
     视图加载完成之后，被调用，loadView 执行完毕后，执行
     主要做数据加载，或其他处理
     但是，目前市场上很多程序，没有实现 loadView，所有建立子控件的代码都在 viewDidLoad 中
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 让 collection view 滚动到指定的位置
        collectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
    }
}

// MARK: - 设置 UI
extension PhotoBrowserViewController {
    private func setupUI() {
        // 添加控件
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        // 设置布局
        collectionView.frame = view.bounds
        
        closeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-8)
            make.left.equalTo(view.snp.left).offset(8)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-8)
            make.right.equalTo(view.snp.right).offset(-28)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        // 设置监听方法
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonClick), for: .touchUpInside)
        
        // 准备 collectionView
        prepareCollectionView()
    }
    
    private func prepareCollectionView() {
        // 注册可重用 cell
        collectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: PhotoBrowserViewCellID)
        // 设置数据源
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoBrowserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserViewCellID, for: indexPath) as! PhotoBrowserCell
        cell.backgroundColor = .black
        cell.imageUrl = urls[indexPath.item]
        cell.delegate = self
        return cell
    }
}

// MARK: - PhotoBrowserCellDelegate
extension PhotoBrowserViewController: PhotoBrowserCellDelegate {
    func photoBrowserCellDidTapImage() {
        closeButtonClick()
    }
}
