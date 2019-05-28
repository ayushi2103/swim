import Foundation

extension Color where T: AdditiveArithmetic {
    @inlinable
    public static func +=<C: ColorProtocol>(lhs: inout Color, rhs: C) where C.P == P, C.T == T {
        for i in 0..<P.channels {
            lhs[i] += rhs[i]
        }
    }
    
    @inlinable
    public static func +(lhs: Color, rhs: Color) -> Color {
        var new = lhs
        new += rhs
        return new
    }
    
    @inlinable
    public static func -=<C: ColorProtocol>(lhs: inout Color, rhs: C) where C.P == P, C.T == T {
        for i in 0..<P.channels {
            lhs[i] -= rhs[i]
        }
    }
    
    @inlinable
    public static func -(lhs: Color, rhs: Color) -> Color {
        var new = lhs
        new -= rhs
        return new
    }
}

extension Color where T: Numeric {
    @inlinable
    public static func *=<C: ColorProtocol>(lhs: inout Color, rhs: C) where C.P == P, C.T == T {
        for i in 0..<P.channels {
            lhs[i] *= rhs[i]
        }
    }
    
    @inlinable
    public static func *(lhs: Color, rhs: Color) -> Color {
        var new = lhs
        new *= rhs
        return new
    }
}

extension Color where T: BinaryInteger {
    @inlinable
    public static func /=<C: ColorProtocol>(lhs: inout Color, rhs: C) where C.P == P, C.T == T {
        for i in 0..<P.channels {
            lhs[i] /= rhs[i]
        }
    }
    
    @inlinable
    public static func /(lhs: Color, rhs: Color) -> Color {
        var new = lhs
        new /= rhs
        return new
    }
}

extension Color where T: BinaryFloatingPoint {
    @inlinable
    public static func /=<C: ColorProtocol>(lhs: inout Color, rhs: C) where C.P == P, C.T == T {
        for i in 0..<P.channels {
            lhs[i] /= rhs[i]
        }
    }
    
    @inlinable
    public static func /(lhs: Color, rhs: Color) -> Color {
        var new = lhs
        new /= rhs
        return new
    }
}