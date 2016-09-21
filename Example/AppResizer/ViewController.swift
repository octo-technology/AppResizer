//
//  ViewController.swift
//  AppResizer
//
//  Created by Ahmed Mseddi on 10/31/2015.
//  Copyright (c) 2015 Ahmed Mseddi. All rights reserved.
//

import UIKit

import AppResizer


class ViewController: UIViewController {

    @IBAction func didTapOnResizeMe(_ sender: UIButton) {
        guard let window = UIApplication.shared.delegate?.window ?? nil else {
            return
        }
        AppResizer.sharedInstance.enable(mainWindow: window)
        UIView.animate(
            withDuration: 0.3,
            animations:{
                sender.alpha = 0
        })
        
    }
}
