import XCTest

class BasicPerformanceTests: XCTestCase {

}

#if canImport(Accelerate)

import Accelerate

extension BasicPerformanceTests {
    func testMultiplyImage() {
        var rgba = [Double](repeating: 1, count: 40000000)
        let scalar: Double = 0.99
        measure {
            for _ in 0..<10 {
                for i in 0..<rgba.count {
                    rgba[i] *= scalar
                }
            }
        }
    }
    
    func testMultiplyImage_accelerate() {
        var rgba = [Double](repeating: 1, count: 40000000)
        var scalar: Double = 0.99
        measure {
            for _ in 0..<10 {
                rgba.withUnsafeMutableBufferPointer {
                    let p = $0.baseAddress!
                    vDSP_vsmulD(p, 1, &scalar, p, 1, vDSP_Length($0.count))
                }
            }
        }
    }
    
    func testMultiplyPixel() {
        var rgba = [Double](repeating: 1, count: 4)
        let scalar: Double = 0.99
        measure {
            for _ in 0..<1000000 {
                for i in 0..<rgba.count {
                    rgba[i] *= scalar
                }
            }
        }
    }
    
    func testMultiplyPixel_accelerate() {
        var rgba = [Double](repeating: 1, count: 4)
        var scalar: Double = 0.99
        measure {
            for _ in 0..<1000000 {
                rgba.withUnsafeMutableBufferPointer {
                    let p = $0.baseAddress!
                    vDSP_vsmulD(p, 1, &scalar, p, 1, vDSP_Length($0.count))
                }
            }
        }
    }
    
    func testInterleave() {
        let cnt = 10000000
        let x = [Double](repeating: 0, count: cnt)
        let y = [Double](repeating: 1, count: cnt)
        var result = [Double](repeating: 0, count: 2*cnt)
        measure {
            for i in 0..<cnt {
                result[2*i+0] = x[i]
                result[2*i+1] = y[i]
            }
        }
    }
    
    func testInterleave_accelerate() {
        let cnt = 10000000
        let x = [Double](repeating: 0, count: cnt)
        let y = [Double](repeating: 1, count: cnt)
        var result = [Double](repeating: 0, count: 2*cnt)
        measure {
            result.withUnsafeMutableBufferPointer {
                var p = $0.baseAddress!
                x.withUnsafeBufferPointer {
                    let xp = $0.baseAddress!
                    
                    cblas_dcopy(Int32(cnt), xp, 1, p, 2)
                }
                p += 1
                y.withUnsafeBufferPointer {
                    let yp = $0.baseAddress!
                    
                    cblas_dcopy(Int32(cnt), yp, 1, p, 2)
                }
            }
        }
    }
}

#endif
