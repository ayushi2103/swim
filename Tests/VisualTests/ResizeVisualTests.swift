import XCTest
import Swim

class ResizeVisualTests: XCTestCase {
    func testResize() {
        do {
            let image = Image<RGB, Float>(width: 4,
                                          height: 4,
                                          data: (0..<4*4*3).map { _ in Float.random(in: 0..<1) })
            
            let resizedNN = image.resize(width: 128, height: 128, method: .nearestNeighbor)
            let resizedBL = image.resize(width: 128, height: 128, method: .bilinear)
            let resizedBC = image.resize(width: 128, height: 128, method: .bicubic)
                .clipped(low: 0, high: 1)
            
            let concat = Image<RGB, Float>.concatH([resizedNN, resizedBL, resizedBC])
            
            let rgb256 = (concat * 255).typeConverted(to: UInt8.self)
            let nsImage = rgb256.nsImage()
            
            XCTAssertTrue(nsImage.isValid, "Break and check nsImage in debugger.")
        }
    }
}