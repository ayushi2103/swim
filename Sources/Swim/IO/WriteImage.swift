import Foundation
import CStbImage

// MAKR: WriteFormat

public enum WriteFormat {
    case bitmap, jpeg, png
}

// MARK: - Utility

@inlinable
func write<P: ImageFileFormat>(image: Image<P, UInt8>, url: URL, format: WriteFormat) throws {
    
    guard url.isFileURL else {
        throw ImageWriteError.failedToWrite
    }
    
    let path = url.path
    
    let width = Int32(image.width)
    let height = Int32(image.height)
    let bpp = Int32(P.channels)
    
    let code: Int32
    switch format {
    case .bitmap:
        guard !(image is HasAlpha) else {
            throw ImageWriteError.alphaNotSupported
        }
        code = image.data.withUnsafeBufferPointer {
            write_image_bmp(path, width, height, bpp, $0.baseAddress!)
        }
    case .jpeg:
        guard !(image is HasAlpha) else {
            throw ImageWriteError.alphaNotSupported
        }
        code = image.data.withUnsafeBufferPointer {
            write_image_jpg(path, width, height, bpp, $0.baseAddress!)
        }
    case .png:
        code = image.data.withUnsafeBufferPointer {
            write_image_png(path, width, height, bpp, $0.baseAddress!)
        }
    }
    
    guard code != 0 else {
        throw ImageWriteError.failedToWrite
    }
}

// MARK: - UInt8
extension Image where P: ImageFileFormat, T == UInt8 {
    /// Save image.
    @inlinable
    public func write(to url: URL, format: WriteFormat) throws {
        try Swim.write(image: self, url: url, format: format)
    }
}

// MARK: - Float
extension Image where P: ImageFileFormat, T == Float {
    /// Save image.
    /// Pixel values are clipped to [0, 1].
    @inlinable
    public func write(to url: URL, format: WriteFormat) throws {
        var i255 = self.clipped(low: 0, high: 1) * 255
        i255.round()
        let uint8 = Image<P, UInt8>(uncheckedCast: i255)
        try Swim.write(image: uint8, url: url, format: format)
    }
}


// MARK: - Double
extension Image where P: ImageFileFormat, T == Double {
    /// Save image.
    /// Pixel values are clipped to [0, 1].
    @inlinable
    public func write(to url: URL, format: WriteFormat) throws {
        var i255 = self.clipped(low: 0, high: 1) * 255
        i255.round()
        let uint8 = Image<P, UInt8>(uncheckedCast: i255)
        try Swim.write(image: uint8, url: url, format: format)
    }
}

// MARK: - Error type

public enum ImageWriteError: Error {
    case alphaNotSupported
    case failedToWrite
}
