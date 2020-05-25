//
//  PhotoBrowserViewController.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/5/25.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

// 照片浏览器
class PhotoBrowserViewController: UIViewController {

    private var urls: [URL]
    private var currentIndexPath: IndexPath
    
    @objc private func closeButtonClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonClick() {
        print("保存照片")
    }
    
    // 懒加载控件
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
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
    
    
    override func loadView() {
//        super.loadView()
        let rect = UIScreen.main.bounds
        view = UIView(frame: rect)
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(urls)
        print(currentIndexPath)
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
            make.right.equalTo(view.snp.right).offset(-8)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        // 设置监听方法
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonClick), for: .touchUpInside)
    }
}
