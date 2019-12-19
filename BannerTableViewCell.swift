//
//  BannerTableViewCell.swift
//  AssignmentApp
//
//  Created by Subhadeep Pal on 19/12/19.
//  Copyright © 2019 Subhadeep Pal. All rights reserved.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bannerView: BannerView! {
        didSet {
            bannerView.datasource = self
            bannerView.delegate = self
        }
    }
    
    var imageUrls: [URL]? {
        didSet {
            pageControl.numberOfPages = imageUrls?.count ?? 0
            pageControl.currentPage = bannerView.currentPage
            bannerView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pageChanged(_ sender: Any) {
        bannerView.scrollTo(page: pageControl.currentPage)
    }
}

extension BannerTableViewCell: BannerUpdateDelegate, BannerUpdateDatasource {
    var numberOfImageViews: Int {
        return self.imageUrls?.count ?? 0
    }
    
    func bannerViewUrl(atIndex index: Int) -> URL {
        return self.imageUrls![index]
    }
    
    func pageUpdated(page: Int) {
        // update page control
        pageControl.currentPage = page
    }
}
