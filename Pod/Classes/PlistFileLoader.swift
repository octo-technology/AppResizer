import Foundation

extension Bundle {
    static var currentBundle: Bundle {
        let podBundle = Bundle(for: PlistFileLoader.self)

        guard
            let bundleURL = podBundle.url(forResource: "AppResizer", withExtension: "bundle"),
            let bundle = Bundle(url: bundleURL) else {
                return Bundle.main
        }
        return bundle
    }
}


class PlistFileLoader {

    func readPropertyList() -> [[String: Any]]? {
        do {
            var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
            guard
                let plistPath: String? = Bundle.currentBundle.path(forResource: "iOSDevices", ofType: "plist"),
                let plistXML = FileManager.default.contents(atPath: plistPath!),
                let plistData = try PropertyListSerialization.propertyList(from: plistXML,
                                                                           options: .mutableContainersAndLeaves,
                                                                           format: &propertyListFormat) as? [[String: Any]] else {
                                                                            return nil
            }
            return plistData
        } catch {
            return nil
        }
    }
}
