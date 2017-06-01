//
//  ImageScrollView.swift
//  Smartally Support
//
//  Created by Uzma Desai on 31/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

class ImageScrollView: UIScrollView {

    var imageView: UIImageView
    
    override init(frame: CGRect) {
        self.imageView = UIImageView()
       self.imageView.image = UIImage(named: "jobs_placeholder")

        super.init(frame: frame)
        
        contentSize = frame.size // Set content size.
        delegate = self          // Set delegate.
        
        createZoomableImageView()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // Create imageView.
    func createZoomableImageView() {
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        // set zoomScales.
        let widthScale = frame.size.width / imageView.bounds.width
        let heightScale = frame.size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        zoomScale = minScale
        minimumZoomScale = minScale
        maximumZoomScale = 3.0
    }

}

extension ImageScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
