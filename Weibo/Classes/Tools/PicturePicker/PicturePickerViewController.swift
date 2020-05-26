//
//  PicturePickerViewController.swift
//  PicturePicker
//
//  Created by 彭豪辉 on 2020/5/21.
//  Copyright © 2020 彭豪辉. All rights reserved.
//

import UIKit

private let PicturePickerCellID = "Cell"

// 最大选择照片数量
private let PicturePickerMaxCount = 3

class PicturePickerViewController: UICollectionViewController {

    private var selectedIndex = 0
    
    lazy var pictures = [UIImage]()
    
    init() {
        super.init(collectionViewLayout: PicturePickerLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UICollectionViewController 中的 collectionView != view，这一点和 UITableView 不一样
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.collectionView.backgroundColor = .lightGray
        // Register cell classes
        self.collectionView!.register(PicturePickerCell.self, forCellWithReuseIdentifier: PicturePickerCellID)
        
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    private class PicturePickerLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            
            let count: CGFloat = 4
            let margin = UIScreen.main.scale * 4
            let w = (collectionView!.bounds.width - (count + 1) * margin) / count
            itemSize = CGSize(width: w, height: w)
            sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
            minimumInteritemSpacing = margin
            minimumLineSpacing = margin
        }
    }
    

}

// MARK: - UICollectionView 数据源方法
extension PicturePickerViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 保证末尾有一个加号按钮, 同时保证「选择的照片数量」达到上限后，不再允许用户添加
        return pictures.count + (pictures.count == PicturePickerMaxCount ? 0 : 1)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicturePickerCellID, for: indexPath) as! PicturePickerCell
    
        // Configure the cell
        cell.image = indexPath.item >= pictures.count ? nil : pictures[indexPath.item]
        cell.pictureCellDelegate = self
        
        return cell
    }
    
}

// 如果协议中的方法是私有的，那么实现协议方法的时候，函数也要声明为 fileprivate
// MARK: - 添加、删除照片代理方法
extension PicturePickerViewController: PicturePickerCellDelegate {
    fileprivate func picturePickerCellDidAdd(cell: PicturePickerCell) {
        print("添加照片")
        // 判断是否允许访问相册
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            print("无法访问照片库")
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        // 记录当前用户选择的照片索引
        selectedIndex = collectionView.indexPath(for: cell)?.item ?? 0
        present(picker, animated: true, completion: nil)
    }
    
    fileprivate func picturePickerCellDidRemove(cell: PicturePickerCell) {
        print("删除照片")
        let indexPath = collectionView.indexPath(for: cell)!
        if indexPath.item >= pictures.count {
            return
        }
        
        // 删除数据
        pictures.remove(at: indexPath.item)
        // 动画删除视图
        /*
         在现在的 iOS 中，没有出现，删除一张图片，崩溃的情况，以前的 iOS 中有
         重新调用数据源方法（内部要求 3 个 即：PicturePickerMaxCount = 3，删除一个 indexpath，如果数据源方法不返回 2，就会崩溃，
         解决办法可以是：使用 reloadData() 代替，
         reloadData 函数，单纯刷新数据，没有动画，同时不会检测具体的 item 数量
         */
        collectionView.deleteItems(at: [indexPath])
        
    }
    
}

// MARK: - 从系统相册选择图片的代理方法
extension PicturePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 一旦实现代理方法，必须自己 dismiss
    /*
     picker.allowsEditing = true, 适用于头像选择  UIImagePickerControllerEditedImage
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as! UIImage
        let scaleImage = image.scaleToWith(width: 600)
        
        if selectedIndex >= pictures.count {
            pictures.append(scaleImage)
        } else {
            pictures[selectedIndex] = scaleImage
        }
        collectionView.reloadData()
        // 释放控制器
        dismiss(animated: true, completion: nil)
        
    }
}


/*
 如果协议中包含 optional 的函数，协议需要使用 @objc 修饰
 */
@objc
private protocol PicturePickerCellDelegate {
    // 添加照片
    @objc optional func picturePickerCellDidAdd(cell: PicturePickerCell)
    @objc optional func picturePickerCellDidRemove(cell: PicturePickerCell)
    
}
private class PicturePickerCell: UICollectionViewCell {
    
    weak var pictureCellDelegate: PicturePickerCellDelegate?
    var image: UIImage? {
        didSet {
            addButton.setImage(image ?? UIImage(named: "compose_pic_add"), for: .normal)
            // 当没有照片显示时，隐藏「删除按钮」
            removeButton.isHidden = image == nil
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     // private 修饰类：内部的一切方法和属性都是私有的, 所以，如果要使「运行循环」能够找到下面两个监听方法，
     需要 加上 @objc 参数，同时这个参数也表明，这两个函数，会被 OC 调用
     */
    
    @objc func addPicture() {
        pictureCellDelegate?.picturePickerCellDidAdd?(cell: self)
    }
    
    @objc func removePicture() {
        pictureCellDelegate?.picturePickerCellDidRemove?(cell: self)
    }
    
    // 设置控件
    private func setupUI() {
        // 添加控件
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        // 设置布局
        addButton.frame = contentView.bounds
        
        removeButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.right.equalTo(contentView.snp.right)
        }
        
        // 设置监听方法
        addButton.addTarget(self, action: #selector(addPicture), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removePicture), for: .touchUpInside)
        
        // 设置图像填充模式，方式添加的图像变形
        addButton.imageView?.contentMode = .scaleAspectFill
    }
    
    // MARK: - 懒加载控件
    private lazy var addButton: UIButton = UIButton(imageName: "compose_pic_add", backgroundImageName: nil)
    private lazy var removeButton: UIButton = UIButton(imageName: "compose_photo_close", backgroundImageName: nil)
    
    
    
}
