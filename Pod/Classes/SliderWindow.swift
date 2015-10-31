
class SliderWindow: UIWindow {

    // MARK: - Contants
    
    private struct Constants {
        static let sliderBackgroundColor = UIColor(red:0.56, green:0.35, blue:0.71, alpha:1.0)
        static let sliderMinimumTrackTintColor = UIColor(red:0.37, green:0.20, blue:0.37, alpha:1.0)
        static let sliderHeight = CGFloat(50)
        static let defaultMargin = CGFloat(8)
        static let animationDuration = Double(0.3)
    }
    
    
    // MARK: - Propeties
    
    var slider: UISlider?
    var widthLabel: UILabel?
    
    var windowDidRotate:((sliderValue: Float) -> ())?
    var sliderValueDidChange:((sliderValue: Float) -> ())?
    
    
    // MARK: - Enable
    
    func enableSlider() {
        self.setupSlider()
        self.listenToRotationNotification()
        self.setupWidthLabel()
    }
    
    
    // MARK: - Setup
    
    func setupSlider() {
        
        self.slider =  {
            
            let slider =  UISlider()
            
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.value = 1
            slider.backgroundColor = Constants.sliderBackgroundColor
            slider.minimumTrackTintColor = Constants.sliderMinimumTrackTintColor
            slider.alpha = 0
            
            self.addSubview(slider)
            
            slider.addConstraint(NSLayoutConstraint(item: slider, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: Constants.sliderHeight))
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: slider, attribute: .Bottom, multiplier: 1, constant: Constants.defaultMargin))
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: slider, attribute: .Leading, multiplier: 1, constant: -Constants.defaultMargin))
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: slider, attribute: .Trailing, multiplier: 1, constant: Constants.defaultMargin))
            
            slider.addTarget(self, action: Selector("sliderEditingChanged:"), forControlEvents: .ValueChanged)
            
            UIView.animateWithDuration(Constants.animationDuration, animations:{ () -> Void in
                slider.alpha = 1
            })
            
            return slider
        }()
    }
    
    func listenToRotationNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func setupWidthLabel() {

        guard let slider = self.slider else {
            return
        }
        
        self.widthLabel = {
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.alpha = 0
            
            self.addSubview(label)
            
            label.addConstraint(NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: 100))
            label.addConstraint(NSLayoutConstraint(item: label, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: 30))
            self.addConstraint(NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: slider, attribute: .Top, multiplier: 1, constant: -4))
            self.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: slider, attribute: .CenterX, multiplier: 1, constant: 0))
            
            label.backgroundColor = Constants.sliderBackgroundColor
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            
            UIView.animateWithDuration(Constants.animationDuration, animations:{ () -> Void in
                label.alpha = 1
            })
            
            return label
        }()
    }
    
    
    // MARK: - Orientation did change
    
    @objc func deviceOrientationDidChange(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.windowDidRotate?(sliderValue: self.slider?.value ?? 1)
            self.updateLabel()
        }
    }
    
    
    // MARK: - Slider did change
    
    @objc func sliderEditingChanged(sender: UISlider) {
        self.sliderValueDidChange?(sliderValue: sender.value)
        self.updateLabel()
    }
    
    
    // MARK: - Update Label
    
    func updateLabel() {
        if let slider = self.slider {
            self.widthLabel?.text = String(Int(slider.value * Float(self.frame.width)))
        }
    }
    
    
    // MARK: - Point Event Handler
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if let slider = self.slider {
            return CGRectContainsPoint(slider.frame, point)
        }
        return false
    }
}
