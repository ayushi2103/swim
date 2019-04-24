import Foundation

public protocol Interpolator {
    associatedtype P: PixelType
    associatedtype T: BinaryFloatingPoint & DataType
    
    var edgeMode: EdgeMode<P, T> { get set }
    @inlinable func interpolate(x: T, y: T, in image: Image<P, T>) -> Pixel<P, T>
    @inlinable func interpolate(x: T, y: T, in image: Image<P, T>, into pixel: MutablePixelRef<P, T>)
}

extension Interpolator {
    @inlinable
    public func interpolate(x: T, y: T, in image: Image<P, T>) -> Pixel<P, T> {
        var pixel = Pixel<P, T>(value: 0)
        
        pixel.withUnsafeMutableBufferPointer {
            let ref = MutablePixelRef<P, T>(x: -1, y: -1, pointer: $0)
            interpolate(x: x, y: y, in: image, into: ref)
        }
        
        return pixel
    }
}

extension Interpolator {
    @inlinable
    func clampValue(x: Int, max: Int) -> Int? {
        guard x < 0 || x >= max else {
            // Already inside
            return x
        }
        
        switch edgeMode {
        case .constant:
            return nil
        case .edge:
            return clamp(x, min: 0, max: max-1)
        case .symmetric:
            var x = x
            while x < 0 || x >= max {
                if x < 0 {
                    x = -x - 1
                }
                if x >= max {
                    x = 2*max - x - 1
                }
            }
            return x
        case .reflect:
            var x = x
            while x < 0 || x >= max {
                if x < 0 {
                    x = -x
                }
                if x >= max {
                    x = 2*max - x - 2
                }
            }
            return x
        case .wrap:
            var x = x
            while x < 0 {
                x += max
            }
            while x >= max {
                x -= max
            }
            return x
        }
    }
    
    @inlinable
    func inImageCoord(x: Int, y: Int, width: Int, height: Int) -> (x: Int, y: Int)? {
        if let x = clampValue(x: x, max: width), let y = clampValue(x: y, max: height) {
            return (x, y)
        } else {
            return nil
        }
    }
}

public enum EdgeMode<P: PixelType, T: BinaryFloatingPoint&DataType> {
    case constant(pixel: Pixel<P, T>)
    case edge
    case symmetric
    case reflect
    case wrap
    
    public static func constant(value: T) -> EdgeMode<P, T> {
        return .constant(pixel: Pixel(value: value))
    }
}
