import UIKit

class SliderWindow: UIWindow {

    // MARK: - Contants

    private struct Constants {
        static let sliderBackgroundColor = UIColor(red: 0.56, green: 0.35, blue: 0.71, alpha: 1.0)
        static let sliderMinimumTrackTintColor = UIColor(red: 0.37, green: 0.20, blue: 0.37, alpha: 1.0)
        static let sliderHeight = CGFloat(40)
        static let sliderWidth = CGFloat(40)
        static let defaultMargin = CGFloat(8)
        static let animationDuration = Double(0.3)
    }


    // MARK: - Propeties

    var horizontalSlider: UISlider?
    var verticalSlider: UISlider?
    var descriptionLabel: UILabel?

    var windowDidRotate:((horizontalSliderValue: Float, verticalSliderValue: Float) -> Void)?
    var sliderValueDidChange:((horizontalSliderValue: Float, verticalSliderValue: Float) -> Void)?


    // MARK: - Enable

    func enableSliders() {
        self.setupSliders()
        self.listenToRotationNotification()
        self.setupDescriptionLabel()
    }


    // MARK: - Setup

    func setupSliders() {

        self.horizontalSlider = createSlider()
        self.horizontalSlider.map(self.addSubview)
        self.addConstraintsForHorizontalSlider()

        self.verticalSlider = createSlider()
        self.verticalSlider.map(self.addSubview)

        self.verticalSlider?.translatesAutoresizingMaskIntoConstraints = true
        self.verticalSlider?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5))
        self.verticalSlider?.frame = CGRect(x: 0,
                                           y: 0,
                                           width: Constants.sliderWidth,
                                           height: self.frame.height - 2*Constants.defaultMargin - Constants.sliderHeight)
        self.verticalSlider?.center = CGPoint(x: self.frame.width - Constants.defaultMargin - Constants.sliderWidth/2,
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
        guard let horizontalSlider = self.horizontalSlider else {
            return
        }
        horizontalSlider.addConstraint(NSLayoutConstraint(item: horizontalSlider, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: Constants.sliderHeight))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: horizontalSlider,
            attribute: .Bottom, multiplier: 1, constant: Constants.defaultMargin))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: horizontalSlider,
            attribute: .Leading, multiplier: 1, constant: -Constants.defaultMargin))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: horizontalSlider,
            attribute: .Trailing, multiplier: 1, constant: 2 * Constants.defaultMargin + Constants.sliderHeight))
    }

    func listenToRotationNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SliderWindow.deviceOrientationDidChange(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    func setupDescriptionLabel() {

        guard let
            horizontalSlider = self.horizontalSlider,
            verticalSlider = self.verticalSlider else {
                return
        }

        self.descriptionLabel = {

            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.alpha = 0

            self.addSubview(label)

            label.addConstraint(NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: 120))
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
        guard let horizontalValue = self.horizontalSlider?.value,
            let verticalValue = self.verticalSlider?.value else {
                return
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.windowDidRotate?(horizontalSliderValue: horizontalValue, verticalSliderValue: verticalValue)
            self.updateLabel()
        }
    }

    // MARK: - Slider did change

    @objc func sliderEditingChanged(sender: UISlider) {
        self.notifySliderValuesChanged()
        self.updateLabel()
    }
    
    private func notifySliderValuesChanged() {
        guard let horizontalValue = self.horizontalSlider?.value,
            let verticalValue = self.verticalSlider?.value else {
                return
        }
        self.sliderValueDidChange?(horizontalSliderValue: horizontalValue,
                                   verticalSliderValue: verticalValue)
    }
    
    
    // MARK: - Update Label
    
    func updateLabel() {
        guard let horizontalValue = self.horizontalSlider?.value,
            let verticalValue = self.verticalSlider?.value else {
                return
        }
        let width = String(Int(horizontalValue * Float(self.frame.width)))
        let height = String(Int(verticalValue * Float(self.frame.height)))
        self.descriptionLabel?.text = width + "x" + height
    }
    
    
    // MARK: - Point Event Handler
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        guard let horizontalFrame = self.horizontalSlider?.frame,
            let verticalFrame = self.verticalSlider?.frame else {
                return true
        }
        return CGRectContainsPoint(verticalFrame, point) || CGRectContainsPoint(horizontalFrame, point)
    }
}
