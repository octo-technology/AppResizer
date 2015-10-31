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

    @IBAction func didTapOnResizeMe(sender: UIButton) {
        guard let mainWindow = UIApplication.sharedApplication().delegate?.window ?? nil else {
            return
        }
        AppResizer.sharedInstance.enable(mainWindow)
        UIView.animateWithDuration(0.3, animations:{ () -> Void in
            sender.alpha = 0
        })
        
    }
}

