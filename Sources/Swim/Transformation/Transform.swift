
import Foundation

extension Image {
    public func flipLR() -> Image<P, T> {
        
        var newImage = Image<P, T>(width: width, height: height)
        
        _data.withUnsafeBufferPointer { src in
            newImage._data.withUnsafeMutableBufferPointer { dst in
                let dstTail = dst.baseAddress! + (width-1)*P.channels
                for y in 0..<height {
                    var src = src.baseAddress! + y*width*P.channels
                    var dst = dstTail + y*width*P.channels
                    for _ in 0..<width {
                        memcpy(dst, src, P.channels * MemoryLayout<T>.size)
                        src += P.channels
                        dst -= P.channels
                    }
                }
            }
        }
        
        return newImage
    }
    
    public func flipUD() -> Image<P, T> {
        
        var newImage = Image<P, T>(width: width, height: height)
        
        _data.withUnsafeBufferPointer { src in
            newImage._data.withUnsafeMutableBufferPointer { dst in
                var src = src.baseAddress!
                var dst = dst.baseAddress! + (height-1)*width*P.channels
                for _ in 0..<height {
                    memcpy(dst, src, width * P.channels * MemoryLayout<T>.size)
                    src += width*P.channels
                    dst -= width*P.channels
                }
            }
        }
        
        return newImage
    }
}

extension Image {
    func rot180() -> Image<P, T> {
        
        var newImage = Image<P, T>(width: width, height: height)
        
        _data.withUnsafeBufferPointer { src in
            newImage._data.withUnsafeMutableBufferPointer { dst in
                var src = src.baseAddress!
                var dst = dst.baseAddress! + ((height-1) * width + width-1) * P.channels
                for _ in 0..<pixelCount {
                    memcpy(dst, src, width * P.channels * MemoryLayout<T>.size)
                    src += P.channels
                    dst -= P.channels
                }
            }
        }
        
        return newImage
    }
}
