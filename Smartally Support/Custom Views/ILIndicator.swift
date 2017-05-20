//
//  ILIndicator.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 20/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

class ILIndicator: UIView {
    
    var indicator: UIActivityIndicatorView!
    
    // Init.
    init() {
        super.init(frame: Constants.bounds)
        makeViews()
    }
    // Got no idea, something to do with saving the state of the view. Bleh:p who cares.
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    private func makeViews() {
        // Set background color of main view.
        backgroundColor = .black; layer.opacity = 0.3
        // Add a view to place indicator upon.
        let view = UIView(frame: CGRect(x: (Constants.width / 2.0) - 75.0, y: (Constants.height / 2.0) - 75.0,
                                         width: 150.0, height: 150.0))
        view.backgroundColor = .white
        view.radius(to: 4.0)
        addSubview(view)
        // Make and add indicator.
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    open func start(onView view: UIView) {
        view.addSubview(self)
    }
    
    open func stop() {
        removeFromSuperview()
    }
}
