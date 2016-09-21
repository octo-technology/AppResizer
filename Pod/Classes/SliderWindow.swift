import UIKit

class DeviceButton: UIButton {
    var device: iOSDevice?
}

class ResizingWindow: UIWindow {
    struct Constants {
        static let backgroundColor = UIColor(red: 0.56, green: 0.35, blue: 0.71, alpha: 1.0)
        static let defaultMargin = CGFloat(8)
        static let animationDuration = Double(0.3)
    }
    var windowDidRotate:((_ size: CGSize) -> Void)?
    var resizingValueDidChange:((_ size: CGSize) -> Void)?
    var descriptionLabel: UILabel!

    func enable() { }
    func updateView() { }
}

class DevicesListWindow: ResizingWindow {
    var stackView: UIStackView?

    struct Constants {
        static let stackViewHeight = CGFloat(30)
    }
    var devices: [iOSDevice] = {
        let allDevices = PlistFileLoader().readPropertyList().map {$0.flatMap { iOSDevice(dictionary: $0) } }
        return allDevices?.filter { $0.isDisplayableOnDeviceSize(size: UIScreen.main.bounds.size) } ?? [iOSDevice]()
    }()

    override func enable() {
        setupStackView()
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let stackViewFrame = stackView?.frame else {
            return false
        }
        return stackViewFrame.contains(point)
    }

    private func setupStackView() {
        self.stackView = createStackView()
    }

    private func createStackView() -> UIStackView {
        let buttons: [UIButton] = devices.map { createSizingButton(device: $0) }

        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)

        addConstraintsForStackView(stackView: stackView)

        stackView.backgroundColor = Constants.backgroundColor
        stackView.alpha = 0
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            stackView.alpha = 1
        })

        return stackView
    }

    private func createSizingButton(device: iOSDevice) -> UIButton {
        let button = DeviceButton(type: .system)
        button.setTitle(device.name, for: .normal)
        button.device = device
        button.addTarget(self, action: #selector(sizingButtonTapped), for: .touchUpInside)
        return button
    }

    @objc func sizingButtonTapped(sender: DeviceButton) {
        guard let device = sender.device else {
            return
        }
        let size = CGSize(width: device.width, height: device.height)
        resizingValueDidChange?(size)
    }

    private func addConstraintsForStackView(stackView: UIStackView) {
        stackView.addConstraint(NSLayoutConstraint(item: stackView,
                                                          attribute: .height,
                                                          relatedBy: .equal,
                                                          toItem: nil,
                                                          attribute: .notAnAttribute,
                                                          multiplier: 1,
                                                          constant: Constants.stackViewHeight))
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: stackView,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: Constants.defaultMargin))
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: stackView,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: -Constants.defaultMargin))
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: stackView,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 2 * Constants.defaultMargin))
    }
}

extension DevicesListWindow: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

class SliderWindow: ResizingWindow {

    // MARK: - Contants

    fileprivate struct Constants {
        static let sliderMinimumTrackTintColor = UIColor(red: 0.37, green: 0.20, blue: 0.37, alpha: 1.0)
        static let sliderHeight = CGFloat(40)
        static let sliderWidth = CGFloat(40)
    }

    // MARK: - Propeties

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
        guard let horizontalValue = self.horizontalSlider?.value as? CGFloat,
            let verticalValue = self.verticalSlider?.value as? CGFloat else {
                return nil
        }

        return CGSize(width: horizontalValue, height: verticalValue)
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
        let width = String(Int(size.width * frame.width))
        let height = String(Int(size.height * frame.height))
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
