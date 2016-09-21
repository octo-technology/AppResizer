//
//  ModalViewController.swift
//  AppResizer
//
//  Created by Ahmed Mseddi on 31/10/2015.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    @IBAction func didTapOnDismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
