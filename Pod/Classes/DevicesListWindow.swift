import UIKit

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

  override func shouldAnimate() -> Bool {
    return true
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
