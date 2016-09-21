import XCTest

@testable import AppResizer

class iOSDevicesTests: XCTestCase {

    func test_init_whenDictionaryDoesContainAllKeys_shouldReturnAnNonNilObject() {
        // Given
        let dictionary: [String: Any] = ["name": "iPhone6",
                                         "width": NSNumber(value: 375),
                                         "height": NSNumber(value: 667)]

        // When
        let device = iOSDevice(dictionary : dictionary)

        // Then
        XCTAssertEqual(device!.name, "iPhone6")
        XCTAssertEqual(device!.width, 375)
        XCTAssertEqual(device!.height, 667)
    }

    func test_init_whenDictionaryDoesNotContainName_shouldReturnNil() {
        // Given
        let dictionary: [String: Any] = ["width": NSNumber(value: 375),
                                         "height": NSNumber(value: 667)]

        // When
        let device = iOSDevice(dictionary : dictionary)

        // Then
        XCTAssertNil(device)
    }

    func test_init_whenDictionaryDoesNotContainWidth_shouldReturnNil() {
        // Given
        let dictionary: [String: Any] = ["name": "iPhone6",
                                         "height": NSNumber(value: 667)]

        // When
        let device = iOSDevice(dictionary : dictionary)

        // Then
        XCTAssertNil(device)
    }

    func test_init_whenDictionaryDoesNotContainHeight_shouldReturnNil() {
        // Given
        let dictionary: [String: Any] = ["name": "iPhone6",
                                         "height": NSNumber(value: 667)]

        // When
        let device = iOSDevice(dictionary : dictionary)

        // Then
        XCTAssertNil(device)
    }

    func test_isDisplayableOnDeviceSize_whenScreenHeightAndWidthAreGreaterThanDeviceHeightAndWidth_shouldReturnTrue() {
        // Given
        let screenSize = CGSize(width: 376, height: 668)
        let device = iOSDevice(dictionary: ["name": "iPhone6",
                                            "width": NSNumber(value: 375),
                                            "height": NSNumber(value: 667)])

        // When
        let isDisplayable = device?.isDisplayableOnDeviceSize(size: screenSize)

        // Then
        XCTAssertTrue(isDisplayable!)
    }

    func test_isDisplayableOnDeviceSize_whenScreenHeightAndWidthAreLowerThanDeviceHeightAndWidth_shouldReturnFalse() {
        // Given
        let screenSize = CGSize(width: 374, height: 666)
        let device = iOSDevice(dictionary: ["name": "iPhone6",
                                            "width": NSNumber(value: 375),
                                            "height": NSNumber(value: 667)])

        // When
        let isDisplayable = device?.isDisplayableOnDeviceSize(size: screenSize)

        // Then
        XCTAssertFalse(isDisplayable!)
    }

    func test_isDisplayableOnDeviceSize_whenScreenHeightIsLowerThanDeviceHeightAndScreenWidthIsHigherThanDeviceWidth_shouldReturnFalse() {
        // Given
        let screenSize = CGSize(width: 374, height: 668)
        let device = iOSDevice(dictionary: ["name": "iPhone6",
                                            "width": NSNumber(value: 375),
                                            "height": NSNumber(value: 667)])

        // When
        let isDisplayable = device?.isDisplayableOnDeviceSize(size: screenSize)

        // Then
        XCTAssertFalse(isDisplayable!)
    }

    func test_isDisplayableOnDeviceSize_whenScreenHeightIsHigherThanDeviceHeightAndScreenWidthIsLowerThanDeviceWidth_shouldReturnFalse() {
        // Given
        let screenSize = CGSize(width: 376, height: 666)
        let device = iOSDevice(dictionary: ["name": "iPhone6",
                                            "width": NSNumber(value: 375),
                                            "height": NSNumber(value: 667)])
        
        // When
        let isDisplayable = device?.isDisplayableOnDeviceSize(size: screenSize)
        
        // Then
        XCTAssertFalse(isDisplayable!)
    }
}
