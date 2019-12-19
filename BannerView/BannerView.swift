//
//  CardView.swift
//  AssignmentApp
//
//  Created by Subhadeep Pal on 17/12/19.
//  Copyright © 2019 Subhadeep Pal. All rights reserved.
//

import UIKit

protocol BannerUpdateDelegate: class {
    func pageUpdated(page: Int)
}

protocol BannerUpdateDatasource: class {
    var numberOfImageViews: Int {get}
    func bannerViewUrl(atIndex index: Int) -> URL
}


@IBDesignable class BannerView: UIView, UIScrollViewDelegate {
    
    var contentView:UIView?
    @IBInspectable var nibName:String?
    
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    private var imageViews: [UIImageView] = []
    
    weak var delegate: BannerUpdateDelegate?
    weak var datasource: BannerUpdateDatasource? {
        didSet {
            self.setupBanners()
        }
    }
    
    lazy var width: CGFloat = {
        return self.frame.width
    }()
    
    var numberOfPages: Int {
        return imageViews.count
    }
    var currentPage: Int = 0 {
        didSet{
            delegate?.pageUpdated(page: currentPage)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
         xibSetup()
    }

    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
         view.autoresizingMask =
                    [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }

    func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
                    withOwner: self,
                    options: nil).first as? UIView
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    func reloadData() {
        self.setupBanners()
    }
    
    private func setupBanners() {
        guard let dataSource = datasource else {return}
        let count = dataSource.numberOfImageViews
        for index in 0..<count {
            if imageViews.count > index {
                ImageLoader().imageFromUrl(url: dataSource.bannerViewUrl(atIndex: index)) { (image) in
                    self.imageViews[index].image = image
                }
            } else {
                let imageView = buildImageView()
                contentStackView.addArrangedSubview(imageView)
                imageViews.append(imageView)
                ImageLoader().imageFromUrl(url: dataSource.bannerViewUrl(atIndex: index)) { (image) in
                    self.imageViews[index].image = image
                }
            }
        }
        if count < imageViews.count {
            var newImageViews = [UIImageView]()
            for i in 0..<count {
                newImageViews.append(imageViews[i])
            }
            self.imageViews = newImageViews
        }
    }
    
    private func buildImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.cornerRadius = 8.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: self.width)
        imageView.addConstraint(widthConstraint)
        return imageView
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let pageNumber = Int(floor(contentOffset / width))
        if self.currentPage != pageNumber {
            self.currentPage = pageNumber
        }
    }
    
    func scrollTo(page: Int) {
        guard page < (datasource?.numberOfImageViews ?? 0) else {
            assertionFailure("Page number is greater than number of images")
            return
        }
        self.scrollView.scrollRectToVisible(self.imageViews[page].frame, animated: true)
    }
}
