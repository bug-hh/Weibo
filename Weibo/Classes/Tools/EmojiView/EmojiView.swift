//
//  EmojiView.swift
//  EmojiKeyboard
//
//  Created by 彭豪辉 on 2020/5/16.
//  Copyright © 2020 彭豪辉. All rights reserved.
//

import UIKit

private let EmojiCellID = "EmojiCellID"

class EmojiView: UIView {

    @objc func itemClicked(item: UIBarButtonItem) {
        let indexPath = NSIndexPath(item: 0, section: item.tag)
        emojiCollectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
    }
    
    init(callBack: @escaping (Emoticon) -> ()) {
        self.emojiCallBack = callBack
        var rect = UIScreen.main.bounds
        rect.size.height = 320
        super.init(frame: rect)
        backgroundColor = .red
        setupUI()
        
        // 当主线程中有其他任务需要执行时，将不会执行主队列中的任务，只有当其他任务执行完成后，才会调度主队列中的任务
        DispatchQueue.main.async {
            // 默认滚动到「默认表情包组」
            let indexPath = NSIndexPath(item: 0, section: 1)
            self.emojiCollectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    private lazy var emojiCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: EmojiLayout())
    private lazy var toolBar = UIToolbar()
    
    private lazy var packages = EmoticonManager.sharedManager.packages
    
    private var emojiCallBack: (Emoticon) -> ()
    
    private class EmojiLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
        override func prepare() {
            super.prepare()
//            let col: CGFloat = 6
//            let row: CGFloat = 4
//
//            let w = collectionView!.bounds.width / col
//            print("w = \(w)")
//            print("width = \(collectionView!.bounds.width)")
//            let margin = (collectionView!.bounds.height - row * w) * 0.5
//            itemSize = CGSize(width: w, height: w)
            // collection view section 中，内部行间距
            minimumLineSpacing = 0
            // collection view section 中，每个 item 之间的间隔
            minimumInteritemSpacing = 0
            // collection view section 之间的间距
//            sectionInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
            
            scrollDirection = .horizontal
            collectionView?.isPagingEnabled = true
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let col: CGFloat = 6
            
            let w = collectionView.bounds.width / col
            return CGSize(width: w, height: w)
            
        }
        
    }
}

// MARK: - 设置界面
private extension EmojiView {
    func setupUI() {
        addSubview(emojiCollectionView)
        addSubview(toolBar)
        
        
        // 自动布局
        toolBar.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(44)
        }
        
        emojiCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(toolBar.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        
        prepareToolbar()
        prepareCollectionView()
    }
    
    func prepareToolbar() {
        // 创建按钮
        var items = [UIBarButtonItem]()
        
        var index = 0
        for p in packages {
            items.append(UIBarButtonItem(title: p.group_name_cn, style: .plain, target: self, action: #selector(itemClicked(item:))))
            items.last?.tag = index
            index += 1
            
            // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        
        toolBar.items = items
        toolBar.tintColor = .darkGray
    }
    
    func prepareCollectionView() {
        emojiCollectionView.backgroundColor = .white
        emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCellID)
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
    }
    
}

// MARK: - UICollectionView 数据源方法
extension EmojiView: UICollectionViewDataSource {
    // 返回有多少组表情包
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
        
    }
    // 返回每组表情包的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCellID, for: indexPath) as! EmojiCell
        cell.emoticon = packages[indexPath.section].emoticons[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension EmojiView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let em = packages[indexPath.section].emoticons[indexPath.item]
        emojiCallBack(em)
        // 添加最近表情
        // 最近表情不参与排序
        if indexPath.section > 0 {
            EmoticonManager.sharedManager.addRecent(em: em)
        }
    }
    
}

// MARK: - 自定义 UICollectionViewCell
private class EmojiCell: UICollectionViewCell {
    lazy var emojiButton: UIButton = UIButton()
    
    var emoticon: Emoticon? {
        didSet {
            emojiButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath), for: .normal)
            // 设置删除按钮
            if emoticon!.isRemoved {
                emojiButton.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
            // 千万不要加上这个判空，如果加上了，由于 cell 的复用，可能导致 非 emoji 的 cell 显示不正常
//            if emoticon?.emoji != nil {}
            emojiButton.setTitle(emoticon?.emoji, for: .normal)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emojiButton)
        emojiButton.backgroundColor = .white
        emojiButton.setTitleColor(.black, for: .normal)
        emojiButton.frame = bounds.insetBy(dx: 4, dy: 4)
        // 因为 emoji 本质上是一个字符串，所以可以通过调整字体大小，调整 emoji 的大小
        emojiButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        // 需要在 UICollectionViewCell 层，拦截用户点击事件，所以需要关闭 UIButton 的 UI 交互
        emojiButton.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
