import Foundation

public struct BilinearInterpolator<T: BinaryFloatingPoint&DataType>: Interpolator {
    public var edgeMode: EdgeMode<T>
    
    public init(mode: EdgeMode<T> = .constant(0)) {
        self.edgeMode = mode
    }
    
    @inlinable
    public func interpolate<P>(x: T, y: T, in image: Image<P, T>) -> Pixel<P, T> {
        let x0 = floor(x)
        let x1 = x0 + 1
        let y0 = floor(y)
        let y1 = y0 + 1
        
        let x0x = x - x0
        let xx1 = x1 - x
        let y0y = y - y0
        let yy1 = y1 - y
        
        let lu = getPixel(x: Int(x0), y: Int(y0), in: image)
        let ru = getPixel(x: Int(x1), y: Int(y0), in: image)
        let ld = getPixel(x: Int(x0), y: Int(y1), in: image)
        let rd = getPixel(x: Int(x1), y: Int(y1), in: image)
        
        var top = xx1 * lu
        top += x0x * ru
        
        var bottom = xx1 * ld
        bottom += x0x * rd
        
        return top * yy1 + bottom * y0y
    }
}