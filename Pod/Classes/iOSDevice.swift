import UIKit

struct iOSDevice {
    let name: String
    let width: CGFloat
    let height: CGFloat

    init?(dictionary: [String: Any]) {
        guard
            let name = dictionary["name"] as? String,
            let widthNumber = dictionary["width"] as? NSNumber,
            let heightNumber = dictionary["height"] as? NSNumber else {
                return nil
        }

        self.name = name
        self.height = CGFloat(heightNumber.floatValue)
        self.width = CGFloat(widthNumber.floatValue)
    }

    func isDisplayableOnDeviceSize(size: CGSize) -> Bool {
        return height <= size.height && width <= size.width
    }
}
