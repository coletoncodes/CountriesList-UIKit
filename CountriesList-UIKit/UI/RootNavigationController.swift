//
//  RootNavigationController.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/29/24.
//

import UIKit

/// The root navigation controller
class RootNavigationController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBar.isHidden = false
    }
}
