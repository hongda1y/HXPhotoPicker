//
//  HXPHPreviewSelectedViewCell.swift
//  HXPHPickerExample
//
//  Created by Slience on 2020/12/29.
//  Copyright © 2020 洪欣. All rights reserved.
//

import UIKit
import Photos

open class HXPHPreviewSelectedViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var selectedView: UIView = {
        let selectedView = UIView.init()
        selectedView.isHidden = true
        selectedView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        selectedView.addSubview(tickView)
        return selectedView
    }()
    
    lazy var tickView: HXAlbumTickView = {
        let tickView = HXAlbumTickView.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        return tickView
    }()
    
    open var tickColor: UIColor? {
        didSet {
            tickView.tickLayer.strokeColor = tickColor?.cgColor
        }
    }
    
    var requestID: PHImageRequestID?
    
    open var photoAsset: HXPHAsset? {
        didSet {
            reqeustAssetImage()
        }
    }
    /// 获取图片，重写此方法可以修改图片
    open func reqeustAssetImage() {
        weak var weakSelf = self
        requestID = photoAsset?.requestThumbnailImage(targetWidth: hx_width * 2, completion: { (image, asset, info) in
            if weakSelf?.photoAsset == asset {
                weakSelf?.imageView.image = image
            }
        })
    }
    
    open override var isSelected: Bool {
        didSet {
            selectedView.isHidden = !isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(selectedView)
    }
    
    func cancelRequest() {
        if requestID != nil {
            PHImageManager.default().cancelImageRequest(requestID!)
            requestID = nil
        }
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        selectedView.frame = bounds
        tickView.center = CGPoint(x: hx_width * 0.5, y: hx_height * 0.5)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}