import UIKit

class SliderWindow: ResizingWindow {

    // MARK: - Constants

    fileprivate struct Constants {
        static let sliderMinimumTrackTintColor = UIColor(red: 0.37, green: 0.20, blue: 0.37, alpha: 1.0)
        static let sliderHeight = CGFloat(40)
        static let sliderWidth = CGFloat(40)
    }

    // MARK: - Properties

    var horizontalSlider: UISlider?
    var verticalSlider: UISlider?

    // MARK: - Enable

    override func enable() {
        setupSliders()
        listenToRotationNotification()
        setupDescriptionLabel()
    }

    // MARK: - Setup

    private func setupSliders() {

        self.horizontalSlider = createSlider()
        self.horizontalSlider.map(self.addSubview)
        self.addConstraintsForHorizontalSlider()

        self.verticalSlider = createSlider()
        self.verticalSlider.map(self.addSubview)

        self.verticalSlider?.translatesAutoresizingMaskIntoConstraints = true
        self.verticalSlider?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 0.5))
        self.verticalSlider?.frame = CGRect(x: 0,
                                            y: 0,
                                            width: Constants.sliderWidth,
                                            height: self.frame.height - 2*Constants.defaultMargin - Constants.sliderHeight)
        self.verticalSlider?.center = CGPoint(x: self.frame.width - Constants.defaultMargin - Constants.sliderWidth/2,
                                              y: (self.frame.height - Constants.sliderHeight - Constants.defaultMargin)/2)
    }

    private func createSlider() -> UISlider {
        let slider =  UISlider()

        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 1
        slider.backgroundColor = Constants.backgroundColor
        slider.minimumTrackTintColor = Constants.sliderMinimumTrackTintColor
        slider.alpha = 0

        slider.addTarget(self, action: #selector(sliderEditingChanged), for: .valueChanged)

        UIView.animate(withDuration: Constants.animationDuration, animations: {
            slider.alpha = 1
        })

        return slider
    }

    private func addConstraintsForHorizontalSlider() {
        guard let horizontalSlider = self.horizontalSlider else {
            return
        }
        horizontalSlider.addConstraint(NSLayoutConstraint(item: horizontalSlider,
                                                          attribute: .height,
                                                          relatedBy: .equal,
                                                          toItem: nil,
                                                          attribute: .notAnAttribute,
                                                          multiplier: 1,
                                                          constant: Constants.sliderHeight))
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: horizontalSlider,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: Constants.defaultMargin))
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: horizontalSlider,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: -Constants.defaultMargin))
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: horizontalSlider,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 2 * Constants.defaultMargin + Constants.sliderHeight))
    }

    func listenToRotationNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(SliderWindow.deviceOrientationDidChange(_:)),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
    }

    func setupDescriptionLabel() {

        guard let
            horizontalSlider = self.horizontalSlider,
            let verticalSlider = self.verticalSlider else {
                return
        }

        self.descriptionLabel = {

            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.alpha = 0

            self.addSubview(label)

            label.addConstraint(NSLayoutConstraint(item: label,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 0,
                                                   constant: 120))
            label.addConstraint(NSLayoutConstraint(item: label,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 0,
                                                   constant: 30))
            self.addConstraint(NSLayoutConstraint(item: label,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: horizontalSlider,
                                                  attribute: .top,
                                                  multiplier: 1,
                                                  constant: -4))
            self.addConstraint(NSLayoutConstraint(item: label,
                                                  attribute: .centerX,
                                                  relatedBy: .equal,
                                                  toItem: horizontalSlider,
                                                  attribute: .centerX,
                                                  multiplier: 1,
                                                  constant: 0))

            label.backgroundColor = Constants.backgroundColor
            label.textColor = UIColor.white
            label.textAlignment = .center

            UIView.animate(withDuration: Constants.animationDuration, animations:{ () -> Void in
                label.alpha = 1
            })

            return label
        }()
    }


    // MARK: - Orientation did change

    private var requestedSize: CGSize? {
        guard let horizontalValue = self.horizontalSlider?.value,
            let verticalValue = self.verticalSlider?.value else {
                return nil
        }

        return CGSize(width: CGFloat(horizontalValue) * frame.size.width, height: CGFloat(verticalValue) * frame.size.height)
    }

    @objc func deviceOrientationDidChange(_ notification: Notification) {
        guard let size = requestedSize else {
            return
        }
        DispatchQueue.main.async {
            self.windowDidRotate?(size)
            self.updateView()
        }
    }

    // MARK: - Slider did change

    @objc func sliderEditingChanged(_ sender: UISlider) {
        notifySliderValuesChanged()
        updateView()
    }

    private func notifySliderValuesChanged() {
        guard let size = requestedSize else {
            return
        }
        resizingValueDidChange?(size)
    }


    // MARK: - Update View

    override func updateView() {
        guard let size = requestedSize else {
            return
        }
        let width = String(Int(size.width))
        let height = String(Int(size.height))
        self.descriptionLabel?.text = width + "x" + height
    }


    // MARK: - Point Event Handler

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard
            let horizontalFrame = self.horizontalSlider?.frame,
            let verticalFrame = self.verticalSlider?.frame else {
                return false
        }
        return verticalFrame.contains(point) || horizontalFrame.contains(point)
    }
}
