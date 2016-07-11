import Darwin

class SliderWindow: UIWindow {

    // MARK: - Contants

    private struct Constants {
        static let sliderBackgroundColor = UIColor(red:0.56, green:0.35, blue:0.71, alpha:1.0)
        static let sliderMinimumTrackTintColor = UIColor(red:0.37, green:0.20, blue:0.37, alpha:1.0)
        static let sliderHeight = CGFloat(40)
        static let sliderWidth = CGFloat(40)
        static let defaultMargin = CGFloat(8)
        static let animationDuration = Double(0.3)
    }


    // MARK: - Propeties

    var horizontalSlider: UISlider!
    var verticalSlider: UISlider!
    var widthLabel: UILabel?

    var windowDidRotate:((horizontalSliderValue: Float, verticalSliderValue: Float) -> ())?
    var sliderValueDidChange:((horizontalSliderValue: Float, verticalSliderValue: Float) -> ())?


    // MARK: - Enable

    func enableSliders() {
        self.setupSliders()
        self.listenToRotationNotification()
        self.setupWidthLabel()
    }


    // MARK: - Setup

    func setupSliders() {

        self.horizontalSlider = createSlider()
        self.addSubview(self.horizontalSlider)
        self.addConstraintsForHorizontalSlider()

        self.verticalSlider = createSlider()
        self.addSubview(self.verticalSlider)

        self.verticalSlider.translatesAutoresizingMaskIntoConstraints = true
        self.verticalSlider.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5))
        self.verticalSlider.frame = CGRect(x: 0,
                                           y: 0,
                                           width: Constants.sliderWidth,
                                           height: self.frame.height - 2*Constants.defaultMargin - Constants.sliderHeight)
        self.verticalSlider.center = CGPoint(x: self.frame.width - Constants.defaultMargin - Constants.sliderWidth/2,
                                             y: (self.frame.height - Constants.sliderHeight - Constants.defaultMargin)/2)
    }

    func createSlider() -> UISlider {
        let slider =  UISlider()

        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 1
        slider.backgroundColor = Constants.sliderBackgroundColor
        slider.minimumTrackTintColor = Constants.sliderMinimumTrackTintColor
        slider.alpha = 0

        slider.addTarget(self, action: #selector(sliderEditingChanged), forControlEvents: .ValueChanged)

        UIView.animateWithDuration(Constants.animationDuration) {
            slider.alpha = 1
        }

        return slider
    }

    private func addConstraintsForHorizontalSlider() {
        self.horizontalSlider.addConstraint(NSLayoutConstraint(item: self.horizontalSlider, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: Constants.sliderHeight))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: self.horizontalSlider,
            attribute: .Bottom, multiplier: 1, constant: Constants.defaultMargin))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: self.horizontalSlider,
            attribute: .Leading, multiplier: 1, constant: -Constants.defaultMargin))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: self.horizontalSlider,
            attribute: .Trailing, multiplier: 1, constant: Constants.defaultMargin))
    }

    func listenToRotationNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    func setupWidthLabel() {

        guard let
            horizontalSlider = self.horizontalSlider,
            verticalSlider = self.verticalSlider else {
                return
        }

        self.widthLabel = {

            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.alpha = 0

            self.addSubview(label)

            label.addConstraint(NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: 100))
            label.addConstraint(NSLayoutConstraint(item: label, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: 30))
            self.addConstraint(NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: horizontalSlider, attribute: .Top, multiplier: 1, constant: -4))
            self.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: horizontalSlider, attribute: .CenterX, multiplier: 1, constant: 0))

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
            self.windowDidRotate?(horizontalSliderValue: self.horizontalSlider.value, verticalSliderValue: self.verticalSlider.value)
            self.updateLabel()
        }
    }

    // MARK: - Slider did change

    @objc func sliderEditingChanged(sender: UISlider) {
        self.notifySliderValuesChanged()
        self.updateLabel()
    }
    
    private func notifySliderValuesChanged() {
        self.sliderValueDidChange?(horizontalSliderValue: self.horizontalSlider.value, verticalSliderValue: self.verticalSlider.value)
    }
    
    
    // MARK: - Update Label
    
    func updateLabel() {
        self.widthLabel?.text = String(Int(self.horizontalSlider.value * Float(self.frame.width)))
    }
    
    
    // MARK: - Point Event Handler
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return CGRectContainsPoint(self.verticalSlider.frame, point) || CGRectContainsPoint(self.horizontalSlider.frame, point)
    }
}
