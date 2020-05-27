//
//  PhotoBrowserCellCollectionViewCell.swift
//  Weibo
//
//  Created by bughh on 2020/5/26.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

protocol PhotoBrowserCellDelegate: NSObjectProtocol {
    func photoBrowserCellDidTapImage()
}

class PhotoBrowserCell: UICollectionViewCell {

    weak var delegate: PhotoBrowserCellDelegate?
    
    lazy var scrollView: UIScrollView = UIScrollView()
    lazy var imageView: UIImageView = UIImageView()
    private lazy var placeHolder: ProgressImageView = ProgressImageView()
    
    // http://wx3.sinaimg.cn/thumbnail/006x0M7Agy1gf4ldi9jm8j31900u04qr.jpg 缩略图
    // https://open.weibo.com/wiki/2/statuses/home_timeline  文档地址
    var imageUrl: URL? {
        didSet {
            guard let url = imageUrl else {
                return
            }
            
            // 恢复 imageview, scrollview 的内容属性，保证上一张图片的缩放，不会影响下一张图片的显示
            resetScrollView()
            
            // 当大图网络加载较慢时，先从从磁盘加载缩略图，放置在中心
            let placeholderImage = SDImageCache.shared.imageFromDiskCache(forKey: url.absoluteString)
            
            setPlaceHolder(image: placeholderImage)
            
            // 异步加载大图
            /*
             几乎所有的第三方框架，进度回调都是异步的，原因：
                1、不是所有的程序都需要进度回调，如果放在主线程，会引起主线程卡顿
                2、进度回调的频率很高
                3、使用进度回调，要求界面上参与进度变化的 UI 不多，而且不会频繁更新
             */
            imageView.sd_setImage(with: bmiddleUrl(url: url), placeholderImage: nil, options: [SDWebImageOptions.retryFailed, SDWebImageOptions.refreshCached], context: nil, progress: { (current, total, _) in
//                print(Thread.current)
                // 更新进度
                DispatchQueue.main.async {
                    self.placeHolder.progess = CGFloat(current) / CGFloat(total)
                }

            }) { (image, _, _, _) in
                if image == nil {
                    SVProgressHUD.showInfo(withStatus: "您的网络不给力")
                    return
                }
                self.placeHolder.isHidden = true
                self.setPosition(image: image!)
            }
        }
    }
    
    /*
     手势识别是对 touch 的封装，UIScrollView 支持捏合手势，一般做过手势监听的控件，都会屏蔽掉 touch 事件,
     当点击照片查看器的照片时，下面的方法不起作用
     */
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("haha")
//    }
    
    private func resetScrollView() {
        // 重设 imageView 内容属性，scrollView 在处理缩放的时候，是通过调整代理方法返回的视图的 transform 来实现的
        imageView.transform = CGAffineTransform.identity
        
        // 重设 scrollview 内容属性
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize.zero
    }
    
    private func setPlaceHolder(image: UIImage?) {
        placeHolder.isHidden = false
        placeHolder.image = image
        placeHolder.sizeToFit()
        placeHolder.center = scrollView.center
    }
    
    private func setPosition(image:UIImage) {
        let size = self.displaySize(image: image)
        if size.height < scrollView.bounds.height {
            let y = (scrollView.bounds.height - size.height) * 0.5
            // 调整内容边距, 会调整控件的位置，但不会影响控件滚动
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
            // 调整 frame 的 x/y，一旦缩放，影响滚动范围
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        } else {
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            scrollView.contentSize = size
        }
    }
    
    // 返回根据 scrollview 的宽度等比例缩放后的图片尺寸
    private func displaySize(image: UIImage) -> CGSize {
        let w = scrollView.bounds.width
        let h = image.size.height * w / image.size.width
        
        return CGSize(width: w, height: h)
        
    }
    private func bmiddleUrl(url: URL) -> URL {
        var urlString = url.absoluteString
        urlString = urlString.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/")
        return URL(string: urlString)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 添加控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(placeHolder)
        
        // 定义布局
        var rect = bounds
        // 给图片与图片之间留出边距
        rect.size.width -= 20
        scrollView.frame = rect
//        scrollView.backgroundColor = .yellow
        
        // 设置 scrollview 的缩放
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        
        // 添加手势识别
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        // UIImageView 用户交互默认是关闭的
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
}

// MARK: - 响应点击手势
extension PhotoBrowserCell {
    @objc private func tapImage() {
        print("关闭图像")
        delegate?.photoBrowserCellDidTapImage()
    }
    
}
extension PhotoBrowserCell: UIScrollViewDelegate {
    // 返回被缩放的视图，scrollView 在处理缩放的时候，是通过调整代理方法返回的视图的 transform 来实现的
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // 该方法在缩放完成后执行一次
    // view: 被缩放的视图
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("缩放完成")
        
        var offSetY = (scrollView.bounds.height - view!.frame.height) * 0.5
        offSetY = offSetY < 0 ? 0 : offSetY
        
        var offSetX = (scrollView.bounds.width - view!.frame.width) * 0.5
        offSetX = offSetX < 0 ? 0 : offSetX
        scrollView.contentInset = UIEdgeInsets(top: offSetY, left: offSetX, bottom: 0, right: 0)
        
    }
    
    /*
     只要缩放就会被调用
     打印的 imageView.transform 中，
     a, d：代表缩放比例
     a, b, c, d 共同决定旋转
     tx，ty 设置位移
     */
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print(imageView.transform)
    }
}
